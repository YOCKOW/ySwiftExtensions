/* *************************************************************************************************
 ConcatenatedSequenceTests.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@testable import yExtensions
import Testing

@Suite struct ConcatenatedSequenceTests {
  @Test func test_concatenated() {
    let seq0 = [0, 1]
    let seq1 = ConcatenatedSequence<Int>([2,3,4])
    let seq2 = [5, 6]

    let concatenated = ConcatenatedSequence<Int>(seq0, seq1, seq2)
    let converted = Array<Int>(concatenated)
    #expect(converted.count == 7)
    #expect(converted == [0, 1, 2, 3, 4, 5, 6])
  }
}
