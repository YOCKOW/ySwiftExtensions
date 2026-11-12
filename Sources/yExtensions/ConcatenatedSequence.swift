/* *************************************************************************************************
 ConcatenatedSequence.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

/// A sequence type that holds internally an array of sequences.
public struct ConcatenatedSequence<Element>: Sequence, Sendable where Element: Sendable {
  private var _sequences: Array<any Sequence<Element> & Sendable>

  public struct Iterator: IteratorProtocol {
    private var _currentElementIterator: (any IteratorProtocol<Element>)?

    /// The iterator of `_sequences`.
    private var _sequenceIterator: Array<any Sequence<Element> & Sendable>.Iterator

    fileprivate init(_ nestedSequecne: ConcatenatedSequence<Element>) {
      var sequenceIterator = nestedSequecne._sequences.makeIterator()
      self._currentElementIterator = sequenceIterator.next()?.makeIterator()
      self._sequenceIterator = sequenceIterator
    }

    public mutating func next() -> Element? {
      if let nextElement = self._currentElementIterator?.next() {
        return nextElement
      }
      guard let nextSequence = self._sequenceIterator.next() else {
        return nil
      }
      self._currentElementIterator = nextSequence.makeIterator()
      return self.next()
    }
  }

  public func makeIterator() -> Iterator {
    return Iterator(self)
  }

  /// Initializes the instance with a sequence of sequences.
  public init<S>(_ sequences: S) where S: Sequence, S: Sendable, S.Element == any Sequence<Element> & Sendable {
    if case let concatSequence as ConcatenatedSequence<Element> = sequences {
      self = concatSequence
    } else if case let array as Array<any Sequence<Element> & Sendable> = sequences {
      self._sequences = array
    } else {
      self._sequences = Array<any Sequence<Element> & Sendable>(sequences)
    }
  }

  public init<S>(_ sequences: S) where S: Sequence, S.Element: Sequence, S.Element: Sendable, S.Element.Element == Element {
    self._sequences = sequences.map({ $0 as any Sequence<Element> & Sendable })
  }

  #if hasFeature(SameElementRequirements)
  public init<each S>(_ aSequence: repeat each S)
  where repeat each S: Sequence, repeat each S: Sendable, repeat (each S).Element == Element {
    var sequences: Array<any Sequence<Element> & Sendable> = []
    repeat sequences.append(each aSequence)
    self._sequences = sequences
  }
  #endif

  public init(_ sequences: (any Sequence<Element> & Sendable)...) {
    self.init(sequences)
  }

  public mutating func append<S>(_ sequence: S) where S: Sequence, S: Sendable, S.Element == Element {
    self._sequences.append(sequence)
  }

  @inlinable
  public mutating func append(oneElement element: Element) {
    self.append(SingleElementSequence<Element>(element))
  }
}
