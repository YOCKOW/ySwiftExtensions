/* *************************************************************************************************
 RandomAccessCollection+RelativeIndex.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
extension RandomAccessCollection {
  @inlinable
  public func index(forRelativeIndex relativeIndex: Int) -> Self.Index {
    return self.index(self.startIndex, offsetBy: relativeIndex)
  }
  
  @inlinable
  internal func _range(forRelativeBounds relativeBounds: Range<Int>) -> Range<Self.Index> {
    return self.index(forRelativeIndex: relativeBounds.lowerBound)..<self.index(forRelativeIndex: relativeBounds.upperBound)
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
  
  @inlinable
  public subscript(relativeBounds relativeBounds: Range<Int>) -> Self.SubSequence {
    return self[_range(forRelativeBounds: relativeBounds)]
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
  
  @inlinable
  public mutating func removeSubrange(ofRelativeBounds relativeBounds: Range<Int>) {
    self.removeSubrange(_range(forRelativeBounds: relativeBounds))
  }
  
  @inlinable
  public mutating func replaceSubrange<C>(ofRelativeBounds relativeBounds: Range<Int>,
                                          with newElements: C) where C: Collection, Self.Element == C.Element {
    self.replaceSubrange(_range(forRelativeBounds: relativeBounds), with: newElements)
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
  
  @inlinable
  public subscript(relativeBounds relativeBounds: Range<Int>) -> Self.SubSequence {
    get {
      return self[_range(forRelativeBounds: relativeBounds)]
    }
    set {
      self[_range(forRelativeBounds: relativeBounds)] = newValue
    }
  }
}
