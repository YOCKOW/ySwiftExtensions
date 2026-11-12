/* *************************************************************************************************
 SingleElementSequence.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

/// A sequence which has only one element.
public struct SingleElementSequence<Element>: Sequence {
  public typealias Element = Element

  public let element: Element

  @inlinable
  public init(_ element: Element) {
    self.element = element
  }

  public struct Iterator: IteratorProtocol {
    private let _element: Element
    private var _alreadyIterated: Bool

    fileprivate init(_ element: Element) {
      self._element = element
      self._alreadyIterated = false
    }

    public mutating func next() -> Element? {
      if _alreadyIterated {
        return nil
      }
      _alreadyIterated = true
      return _element
    }
  }

  public func makeIterator() -> Iterator {
    return Iterator(self.element)
  }
}

extension SingleElementSequence: Sendable where Element: Sendable {}

extension SingleElementSequence.Iterator: Sendable where Element: Sendable {}
