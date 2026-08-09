/* *************************************************************************************************
 StringEncodings+IANACharacterSetName.swift
   © 2018,2023,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import CoreFoundation
import Foundation

extension String.Encoding {
  /// Initialize with `CFString.Encoding`
  public init(_ cfStringEncoding:CFString.Encoding) {
    self.init(rawValue:CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(cfStringEncoding.rawValue)))
  }
  
  /// Get IANA Character Set Name
  @available(*, deprecated, renamed: "ianaCharsetName")
  public var ianaCharacterSetName: String? {
    return self.ianaCharsetName
  }
  
  /// Initialize with IANA Character Set Name
  @available(*, deprecated, renamed: "init(ianaCharsetName:)")
  public init?(ianaCharacterSetName charsetName:String) {
    self.init(ianaCharsetName: charsetName)
  }
}

extension String.Encoding {
  /// The name of this encoding that is compatible with the one of the IANA registry "charset".
  ///
  /// - Note: This property returns the same value with [`ianaName`](https://developer.apple.com/documentation/swift/string/encoding/iananame) if available.
  public var ianaCharsetName: String? {
    #if swift(>=6.3)
    if #available(macOS 26.4, iOS 26.4, tvOS 26.4, visionOS 26.4, watchOS 26.4, *) {
      return self.ianaName
    }
    #endif
    guard let cfCharSetName = CFString.Encoding(self).ianaCharacterSetName else {
      return nil
    }
    return String(cfCharSetName)
  }

  /// Creates an instance from the name of the IANA registry "charset".
  ///
  /// - Note: This initializer creates the same instance with [`init(ianaName:)`](https://developer.apple.com/documentation/swift/string/encoding/init(iananame:)) if available.
  public init?<S>(ianaCharsetName charsetName: S) where S: StringProtocol {
    #if swift(>=6.3)
    if #available(macOS 26.4, iOS 26.4, tvOS 26.4, visionOS 26.4, watchOS 26.4, *) {
      self.init(ianaName: String(charsetName))
      return
    }
    #endif
    let cfStringEncoding = CFString.Encoding(ianaCharacterSetName: charsetName.coreFoundationString)
    if cfStringEncoding == .invalidIdentifier { return nil }
    self.init(cfStringEncoding)
  }
}
