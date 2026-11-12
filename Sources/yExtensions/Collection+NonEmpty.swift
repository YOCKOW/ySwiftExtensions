/* *************************************************************************************************
 Collection+NonEmpty.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

public struct NonEmpty<Collection> where Collection: Swift.Collection {
  private var _collection: Collection

  fileprivate init(_nonEmptyCollection collection: Collection) {
    assert(!collection.isEmpty)
    self._collection = collection
  }

  @inlinable
  public var isEmpty: Bool {
    return false
  }

  public init?(_ collection: Collection) {
    if collection.isEmpty {
      return nil
    }
    self.init(_nonEmptyCollection: collection)
  }

  public func map<T, E>(_ transform: (Collection.Element) throws(E) -> T) throws(E) -> NonEmpty<Array<T>> {
    return NonEmpty<Array<T>>(_nonEmptyCollection: try self._collection.map(transform))
  }

  public func flatMap<SegmentOfResult>(
    _ transform: (Collection.Element) throws -> NonEmpty<SegmentOfResult>
  ) rethrows -> NonEmpty<Array<SegmentOfResult.Element>> where SegmentOfResult: Swift.Collection {
    return NonEmpty<Array<SegmentOfResult.Element>>(
      _nonEmptyCollection: try self._collection.flatMap(transform)
    )
  }
}

extension NonEmpty: Sendable where Collection: Sendable {}

extension NonEmpty: Equatable where Collection: Equatable {}

extension NonEmpty: Hashable where Collection: Hashable {}

extension NonEmpty: Sequence {
  public typealias Element = Collection.Element

  public typealias Iterator = Collection.Iterator

  public func makeIterator() -> Collection.Iterator {
    return self._collection.makeIterator()
  }
}

extension NonEmpty: Swift.Collection {
  public typealias Index = Collection.Index

  public var startIndex: Collection.Index {
    return self._collection.startIndex
  }

  public var endIndex: Collection.Index {
    return self._collection.endIndex
  }

  public func index(after i: Index) -> Index {
    return self._collection.index(after: i)
  }

  public subscript(position: Index) -> Element {
    _read {
      yield self._collection[position]
    }
  }

  public var first: Element {
    return _collection[_collection.startIndex]
  }
}

extension NonEmpty: BidirectionalCollection where Collection: BidirectionalCollection {
  public func index(before i: Index) -> Index {
    return self._collection.index(before: i)
  }

  public var last: Element {
    return _collection[_collection.index(before: _collection.endIndex)]
  }
}

extension NonEmpty: RandomAccessCollection where Collection: RandomAccessCollection {}

extension NonEmpty: MutableCollection where Collection: MutableCollection {
  public subscript(position: Index) -> Element {
    _read {
      yield self._collection[position]
    }
    _modify {
      yield &self._collection[position]
    }
  }
}

extension NonEmpty where Collection: RangeReplaceableCollection {
  public init(_ firstElement: Element, _ remaining: Element...) {
    var collection = Collection()
    collection.append(firstElement)
    collection.append(contentsOf: remaining)
    self.init(_nonEmptyCollection: collection)
  }

  public mutating func append(_ newElement: Element) {
    self._collection.append(newElement)
  }

  public mutating func append<S>(contentsOf newElements: S) where S: Sequence, S.Element == Element {
    self._collection.append(contentsOf: newElements)
  }

  public mutating func insert(_ newElement: Self.Element, at i: Self.Index) {
    self._collection.insert(newElement, at: i)
  }

  public mutating func insert<S>(contentsOf newElements: S, at i: Self.Index)
  where S: Swift.Collection, Self.Element == S.Element {
    self._collection.insert(contentsOf: newElements, at: i)
  }
}

extension NonEmpty: CustomStringConvertible where Collection: CustomStringConvertible {
  public var description: String {
    return self._collection.description
  }
}

extension NonEmpty: CustomDebugStringConvertible where Collection: CustomDebugStringConvertible {
  public var debugDescription: String {
    return self._collection.debugDescription
  }
}
