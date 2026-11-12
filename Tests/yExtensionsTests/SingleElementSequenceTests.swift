/* *************************************************************************************************
 SingleElementSequenceTests.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@testable import yExtensions
import Testing

@Suite struct SingleElementSequenceTests {
  @Test func test_iterator() {
    let sequence = SingleElementSequence<Int>(0)
    var iterator = sequence.makeIterator()
    #expect(iterator.next() == 0)
    #expect(iterator.next().isNil)
  }

  @Test func test_conversion() {
    let sequence = SingleElementSequence<Int>(0)
    let array = Array<Int>(sequence)
    #expect(array.count == 1)
    #expect(array.first == 0)
  }
}
