/* *************************************************************************************************
 FixedWidthInteger+Base32.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

extension FixedWidthInteger {
  /// Returns a Base-32 encoded data.
  public func base32EncodedData(using version: Base32Version = .rfc4648,
                                byteOrder: ByteOrder = .current,
                                padding: Bool = false) -> Data {
    let int = ({ () -> Self in
      switch byteOrder {
      case .unknown:
        return self
      case .littleEndian:
        return self.littleEndian
      case .bigEndian:
        return self.bigEndian
      }
    })()
    
    return withUnsafeBytes(of: int) {
      return $0.base32EncodedData(using: version, padding: padding)
    }
  }
  
  /// Returns a Base-32 encoded string.
  public func base32EncodedString(using version: Base32Version = .rfc4648,
                                  byteOrder: ByteOrder = .current,
                                  padding: Bool = false) -> String {
    let data = self.base32EncodedData(using: version, byteOrder: byteOrder, padding: padding)
    return String(data: data, encoding: .utf8)!
  }
}

extension FixedWidthInteger {
  /// Initialize with a Base-32 encoded data.
  public init?<D>(base32Encoded data: D, version: Base32Version, byteOrder: ByteOrder) where D: DataProtocol {
    guard let decoded = Data(base32Encoded: data, version: version) else { return nil }
    
    let size = decoded.count
    guard size == MemoryLayout<Self>.size else { return nil }
    
    let memory = UnsafeMutablePointer<Self>.allocate(capacity: 1)
    defer { memory.deallocate() }
    memory.withMemoryRebound(to: UInt8.self, capacity: size) {
      for ii in 0..<size { $0[ii] = decoded[ii] }
    }
    
    switch byteOrder {
    case .unknown:
      self.init(memory.pointee)
    case .littleEndian:
      self.init(littleEndian: memory.pointee)
    case .bigEndian:
      self.init(bigEndian: memory.pointee)
    }
  }
  
  /// Initialize with a Base-32 encoded string.
  public init?<S>(base32Encoded string: S, version: Base32Version, byteOrder: ByteOrder) where S: StringProtocol {
    guard let data = string.data(using: .utf8) else { return nil }
    self.init(base32Encoded: data, version: version, byteOrder: byteOrder)
  }
}
