/* *************************************************************************************************
 NonEmptyTests.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@testable import yExtensions
import Testing

@Suite struct NonEmptyTests {
  @Test func test_nonEmptyArray() {
    var nonEmptyArray = NonEmpty<Array<Int>>(0, 1, 2, 3)
    #expect(!nonEmptyArray.isEmpty)
    #expect(nonEmptyArray.count == 4)
    #expect(nonEmptyArray.first == 0)
    #expect(nonEmptyArray.last == 3)

    nonEmptyArray.append(4)
    #expect(nonEmptyArray.last == 4)

    nonEmptyArray.insert(contentsOf: [-3, -2, -1], at: 0)
    #expect(nonEmptyArray.count == 8)
    #expect(nonEmptyArray.elementsEqual([-3, -2, -1, 0, 1, 2, 3, 4]))
  }
}
