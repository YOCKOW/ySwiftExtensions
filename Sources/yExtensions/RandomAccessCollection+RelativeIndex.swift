/* *************************************************************************************************
 RandomAccessCollection+RelativeIndex.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@_exported import Ranges

extension RandomAccessCollection {
  @inlinable
  public func index(forRelativeIndex relativeIndex: Int) -> Self.Index {
    return self.index(self.startIndex, offsetBy: relativeIndex)
  }

  fileprivate func _absoluteRange<R>(forRelativeBounds relativeBounds: R) -> Range<Self.Index> where R: GeneralizedRange, R.Bound == Int {
    guard let bounds = relativeBounds.bounds else {
      return startIndex..<startIndex
    }
    let lower: Self.Index = ({
      switch $0 {
      case .unbounded:
        return startIndex
      case .included(let relativeLower):
        return index(forRelativeIndex: relativeLower)
      case .excluded(let relativeLower):
        precondition(relativeLower < Int.max, "Can't express the lower bound.")
        return index(forRelativeIndex: relativeLower + 1)
      }
    })(bounds.lower)

    switch bounds.upper {
    case .unbounded:
      return lower..<endIndex
    case .included(let relativeUpper):
      precondition(relativeUpper < Int.max, "Can't express the upper bound.")
      return lower..<index(forRelativeIndex: relativeUpper + 1)
    case .excluded(let relativeUpper):
      return lower..<index(forRelativeIndex: relativeUpper)
    }
  }
  
  /// Returns the distance from `startIndex` to `absoluteIndex`.
  @inlinable
  public func relativeIndex(for absoluteIndex: Self.Index) -> Int {
    return self.distance(from: self.startIndex, to: absoluteIndex)
  }
  
  @inlinable
  func relativeIndex(_ absoluteIndex: Self.Index, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
    return self.index(absoluteIndex, offsetBy: distance, limitedBy: self.index(forRelativeIndex: limit)).map {
      return self.relativeIndex(for: $0)
    }
  }
  
  @inlinable
  func relativeIndex(_ absoluteIndex: Self.Index, offsetBy distance: Int) -> Int {
    return self.relativeIndex(for: self.index(absoluteIndex, offsetBy: distance))
  }
  
  @inlinable
  public var relativeStartIndex: Int {
    return 0
  }
  
  @inlinable
  public var relativeEndIndex: Int {
    return self.relativeIndex(for: self.endIndex)
  }
  
  @inlinable
  public func relativeIndex(after ii: Int) -> Int {
    return ii + 1
  }
  
  @inlinable
  public func relativeIndex(before ii: Int) -> Int {
    return ii - 1
  }
  
  @inlinable
  public func formRelativeIndex(after ii: inout Int) {
    ii += 1
  }
  
  @inlinable
  public func formRelativeIndex(before ii: inout Int) {
    ii -= 1
  }
  
  @inlinable
  public subscript(relativeIndex relativeIndex: Int) -> Self.Element {
    return self[self.index(forRelativeIndex: relativeIndex)]
  }

  public subscript<R>(relativeBounds relativeBounds: R) -> Self.SubSequence where R: GeneralizedRange, R.Bound == Int {
    return self[_absoluteRange(forRelativeBounds: relativeBounds)]
  }
}

extension RandomAccessCollection where Self: RangeReplaceableCollection {
  @inlinable
  public mutating func insert<S>(contentsOf newElements: S,
                                 atRelativeIndex relativeIndex: Int) where S: Collection, Self.Element == S.Element {
    self.insert(contentsOf: newElements, at: self.index(forRelativeIndex: relativeIndex))
  }
  
  @inlinable
  @discardableResult
  public mutating func remove(atRelativeIndex relativeIndex: Int) -> Self.Element {
    return self.remove(at: self.index(forRelativeIndex: relativeIndex))
  }

  public mutating func removeSubrange<R>(ofRelativeBounds relativeBounds: R) where R: GeneralizedRange, R.Bound == Int {
    self.removeSubrange(_absoluteRange(forRelativeBounds: relativeBounds))
  }

  public mutating func replaceSubrange<R, C>(
    ofRelativeBounds relativeBounds: R,
    with newElements: C
  ) where R: GeneralizedRange, R.Bound == Int, C: Collection, Self.Element == C.Element {
    self.replaceSubrange(_absoluteRange(forRelativeBounds: relativeBounds), with: newElements)
  }
}

extension RandomAccessCollection where Self: MutableCollection {
  @inlinable
  public subscript(relativeIndex relativeIndex: Int) -> Self.Element {
    get {
      return self[self.index(forRelativeIndex: relativeIndex)]
    }
    set {
      self[self.index(forRelativeIndex: relativeIndex)] = newValue
    }
  }

  public subscript<R>(relativeBounds relativeBounds: R) -> Self.SubSequence where R: GeneralizedRange, R.Bound == Int {
    get {
      return self[_absoluteRange(forRelativeBounds: relativeBounds)]
    }
    set {
      self[_absoluteRange(forRelativeBounds: relativeBounds)] = newValue
    }
  }
}
