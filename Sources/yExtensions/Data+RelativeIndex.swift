/* *************************************************************************************************
 Data+RelativeIndex.swift
   © 2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

extension Data {
  /// Represetnts the distance from `startIndex`.
  @available(*, deprecated, message: "Use computed properties defined in the extension of `RandomAccessCollection` instead.")
  public struct RelativeIndex: Comparable {
    private var _distance: Data.Index
    
    public init(_ distance:Int) {
      precondition(distance >= 0, "The value of distance must be positive or zero.")
      self._distance = distance
    }
    
    fileprivate func actualIndex(for data:Data) -> Data.Index {
      return data.startIndex + self._distance
    }
    
    fileprivate static func +(lhs:RelativeIndex, rhs:Int) -> RelativeIndex {
      return RelativeIndex(lhs._distance + rhs)
    }
    
    public static func <(lhs:RelativeIndex, rhs:RelativeIndex) -> Bool {
      return lhs._distance < rhs._distance
    }
  }
  
  @available(*, deprecated, message: "Use computed properties defined in the extension of `RandomAccessCollection` instead.")
  public var relativeStartIndex: RelativeIndex {
    return RelativeIndex(0)
  }
  
  @available(*, deprecated, message: "Use computed properties defined in the extension of `RandomAccessCollection` instead.")
  public var relativeEndIndex: RelativeIndex {
    return RelativeIndex(self.endIndex - self.startIndex)
  }
  
  @available(*, deprecated, message: "Use computed properties defined in the extension of `RandomAccessCollection` instead.")
  public func relativeIndex(_ relativeIndex:RelativeIndex, offsetBy distance:Int) -> RelativeIndex {
    return relativeIndex + distance
  }
  
  @available(*, deprecated, message: "Use computed properties defined in the extension of `RandomAccessCollection` instead.")
  public func relativeIndex(after index:RelativeIndex) -> RelativeIndex {
    return self.relativeIndex(index, offsetBy:1)
  }
  
  @available(*, deprecated, message: "Use computed properties defined in the extension of `RandomAccessCollection` instead.")
  public func relativeIndex(before index:RelativeIndex) -> RelativeIndex {
    return self.relativeIndex(index, offsetBy:-1)
  }
  
  @available(*, deprecated, message: "Use computed properties defined in the extension of `RandomAccessCollection` instead.")
  public subscript(_ relativeIndex:RelativeIndex) -> UInt8 {
    get {
      return self[relativeIndex.actualIndex(for:self)]
    }
    set {
      self[relativeIndex.actualIndex(for:self)] = newValue
    }
  }
  
  @available(*, deprecated, message: "Use computed properties defined in the extension of `RandomAccessCollection` instead.")
  public subscript(_ relativeBounds:Range<RelativeIndex>) -> Data {
    get {
      let lower = relativeBounds.lowerBound.actualIndex(for:self)
      let upper = relativeBounds.upperBound.actualIndex(for:self)
      return self[lower..<upper]
    }
    set {
      let lower = relativeBounds.lowerBound.actualIndex(for:self)
      let upper = relativeBounds.upperBound.actualIndex(for:self)
      self[lower..<upper] = newValue
    }
  }
}
