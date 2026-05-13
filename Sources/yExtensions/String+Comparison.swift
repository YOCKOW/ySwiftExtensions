/* *************************************************************************************************
 String+Comparison.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
extension String {
  /// Returns Boolean value that indecates whether the receiver has substring
  /// that matches `string` from `start`.
  public func matches(_ string:String, from start:String.Index? = nil) -> Bool {
    if self.isEmpty { return false }
    if string.isEmpty { return true }
    
    var si = start ?? self.startIndex
    var ci = string.startIndex
    
    while true {
      guard self[si] == string[ci] else { return false }
      si = self.index(after:si)
      ci = string.index(after:ci)
      
      switch (si, ci) {
      case (_, string.endIndex): return true
      case (self.endIndex, _): return false
      default: continue
      }
    }
  }
}

private extension UTF8.CodeUnit {
  func _isASCIICaseInsensitivelyEqual(to other: UTF8.CodeUnit) -> Bool {
    if self == other {
      return true
    }
    if 0x41 <= self && self <= 0x5A {
      return self + 0x20 == other
    }
    if 0x61 <= self && self <= 0x7A {
      return self - 0x20 == other
    }
    return false
  }
}

extension StringProtocol {
  /// Returns the Boolean value whether or not `self` is an
  /// [ASCII case-insensitive match](https://infra.spec.whatwg.org/#ascii-case-insensitive) for
  /// `otherUTF8`.
  public func isASCIICaseInsensitivelyEqual<UTF8>(to otherUTF8: UTF8) -> Bool
  where UTF8: Sequence, UTF8.Element == Unicode.UTF8.CodeUnit {
    var myIterator = self.utf8.makeIterator()
    var otherIterator = otherUTF8.makeIterator()

    while let myByte = myIterator.next() {
      guard let otherByte = otherIterator.next() else {
        return false
      }
      guard myByte._isASCIICaseInsensitivelyEqual(to: otherByte) else {
        return false
      }
    }
    return otherIterator.next().isNil
  }

  /// Returns the Boolean value whether or not `self` is an
  /// [ASCII case-insensitive match](https://infra.spec.whatwg.org/#ascii-case-insensitive) for
  /// `other`.
  @inlinable
  public func isASCIICaseInsensitivelyEqual<S>(to other: S) -> Bool where S: StringProtocol {
    return self.isASCIICaseInsensitivelyEqual(to: other.utf8)
  }
}
