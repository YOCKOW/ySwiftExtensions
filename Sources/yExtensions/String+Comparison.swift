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
  /// `other`.
  public func isASCIICaseInsensitivelyEqual(to other: String) -> Bool {
    let (myUTF8, otherUTF8) = (self.utf8, other.utf8)
    var (myIndex, otherIndex) = (myUTF8.startIndex, otherUTF8.startIndex)
    while myIndex < myUTF8.endIndex && otherIndex < otherUTF8.endIndex {
      guard myUTF8[myIndex]._isASCIICaseInsensitivelyEqual(to: otherUTF8[otherIndex]) else {
        return false
      }

      myUTF8.formIndex(after: &myIndex)
      otherUTF8.formIndex(after: &otherIndex)
    }
    return myIndex == myUTF8.endIndex && otherIndex == otherUTF8.endIndex
  }
}
