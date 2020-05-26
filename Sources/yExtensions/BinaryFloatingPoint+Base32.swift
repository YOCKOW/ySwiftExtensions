/* *************************************************************************************************
 BinaryFloatingPoint+Base32.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

private func _swapIfNecessary<T>(_ bytes: inout T, byteOrder: ByteOrder) where T: RandomAccessCollection & MutableCollection, T.Element == UInt8, T.Index == Int {
  if byteOrder == .current || byteOrder == .unknown { return }
  for ii in 0..<(bytes.count / 2) {
    bytes.swapAt(ii, bytes.relativeEndIndex - ii - 1)
  }
}

extension BinaryFloatingPoint {
  /// Returns a Base-32 encoded data.
  public func base32EncodedData(using version: Base32Version = .rfc4648,
                                byteOrder: ByteOrder = .current,
                                padding: Bool = false) -> Data {
    var bytes = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: MemoryLayout<Self>.size)
    defer { bytes.deallocate() }
    
    precondition(withUnsafeBytes(of: self) { $0.copyBytes(to: bytes) } == MemoryLayout<Self>.size,
                 "Failed to copy bytes.")
    _swapIfNecessary(&bytes, byteOrder: byteOrder)
    
    return bytes.withUnsafeBytes { $0.base32EncodedData(using: version, padding: padding) }
  }
  
  /// Returns a Base-32 encoded string.
  public func base32EncodedString(using version: Base32Version = .rfc4648,
                                  byteOrder: ByteOrder = .current,
                                  padding: Bool = false) -> String {
    let data = self.base32EncodedData(using: version, byteOrder: byteOrder, padding: padding)
    return String(data: data, encoding: .utf8)!
  }
}

extension BinaryFloatingPoint {
  /// Initialize with a Base-32 encoded data.
  public init?<D>(base32Encoded data: D, version: Base32Version, byteOrder: ByteOrder) where D: DataProtocol {
    guard var decoded = Data(base32Encoded: data, version: version) else { return nil }
    
    let size = decoded.count
    guard size == MemoryLayout<Self>.size else { return nil }
    
    _swapIfNecessary(&decoded, byteOrder: byteOrder)
    
    let memory = UnsafeMutablePointer<Self>.allocate(capacity: 1)
    defer { memory.deallocate() }
    memory.withMemoryRebound(to: UInt8.self, capacity: size) {
      for ii in 0..<size { $0[ii] = decoded[ii] }
    }
    
    self.init(memory.pointee)
  }
  
  /// Initialize with a Base-32 encoded string.
  public init?(base32Encoded string: String, version: Base32Version, byteOrder: ByteOrder) {
    guard let data = string.data(using: .utf8) else { return nil }
    self.init(base32Encoded: data, version: version, byteOrder: byteOrder)
  }
}
