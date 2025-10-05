/* *************************************************************************************************
 DataProtocol+Base64BugWorkaround.swift
   © 2025 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

extension UInt8 {
  @usableFromInline
  var _isAvailableForBase64: Bool {
    switch self {
    case 0x2B, 0x2F, 0x30...0x39, 0x3D, 0x41...0x5A, 0x61...0x7A:
      return true
    default:
      return false
    }
  }
}

extension DataProtocol {
  /// Returns a Base-64 encoded `Data`
  /// with working around [a bug](https://github.com/swiftlang/swift-foundation/issues/1535).
  ///
  /// - parameter options: The options to use for the encoding. Default value is `[]`.
  /// - returns: The Base-64 encoded data.
  @inlinable
  public func base64EncodedData(options: Data.Base64EncodingOptions = []) -> Data {
    let data = (self as? Data) ?? Data(self)
    let encoderMethod = Data.base64EncodedData(options:)
    #if canImport(Darwin) || swift(>=6.3)
    return encoderMethod(data)(options)
    #else
    return encoderMethod(data)(options).trimming(where: { !$0._isAvailableForBase64 })
    #endif
  }

  /// Returns a Base-64 encoded string.
  /// with working around [a bug](https://github.com/swiftlang/swift-foundation/issues/1535).
  ///
  /// - parameter options: The options to use for the encoding. Default value is `[]`.
  /// - returns: The Base-64 encoded string.
  @inlinable
  public func base64EncodedString(options: Data.Base64EncodingOptions = []) -> String {
    return String(data: self.base64EncodedData(options: options), encoding: .utf8)!
  }
}
