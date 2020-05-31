/* *************************************************************************************************
 UUID+Base32.swift
   © 2018-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

extension UUID {
  /// Returns a Base32 encoded data.
  public func base32EncodedData(using version: Base32Version = .rfc4648, padding: Bool = false) -> Data {
    return withUnsafeBytes(of: self.uuid) {
      return $0.base32EncodedData(using: version, padding: padding)
    }
  }
  
  /// Returns a Base32 encoded string.
  public func base32EncodedString(using version:Base32Version = .rfc4648, padding:Bool = false) -> String {
    return String(data: self.base32EncodedData(using: version, padding: padding), encoding: .utf8)!
  }
  
  /// Initialize with a Base32 encoded data.
  public init?(base32Encoded data: Data, version: Base32Version) {
    let size = MemoryLayout<uuid_t>.size
    guard let data = Data(base32Encoded: data, version: version), data.count == size else {
      return nil
    }
    
    let uuidPointer = UnsafeMutablePointer<uuid_t>.allocate(capacity: 1)
    defer { uuidPointer.deallocate() }
    uuidPointer.withMemoryRebound(to: UInt8.self, capacity: size) {
      for ii in 0..<size {
        $0[ii] = data[ii]
      }
    }
    self.init(uuid: uuidPointer.pointee)
  }
  
  /// Initialize with a Base32 encoded string.
  public init?(base32Encoded string: String, version: Base32Version) {
    guard let uuid = string.data(using: .utf8).flatMap({ UUID(base32Encoded: $0, version: version) }) else {
      return nil
    }
    self = uuid
  }
  
  @available(*, deprecated, renamed: "init(base32Encoded:version:)")
  public init?(base32Encoded string:String, using version:Base32Version) {
    self.init(base32Encoded: string, version: version)
  }
}
