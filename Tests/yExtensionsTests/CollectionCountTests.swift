/* *************************************************************************************************
 CollectionCountTests.swift
   © 2020,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation
import XCTest
@testable import yExtensions

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct CollectionCountTests {
  @Test func string() {
    let emptyString = ""
    #expect(emptyString.compareCount(with: -1) == .orderedDescending)
    #expect(emptyString.compareCount(with: 0) == .orderedSame)
    #expect(emptyString.compareCount(with: 1) == .orderedAscending)

    let yockowString = "YOCKOW"
    #expect(yockowString.compareCount(with: 3) == .orderedDescending)
    #expect(yockowString.compareCount(with: 6) == .orderedSame)
    #expect(yockowString.compareCount(with: 9) == .orderedAscending)
  }

  @Test func array() {
    let emptyArray = Array<Int>()
    #expect(emptyArray.compareCount(with: -1) == .orderedDescending)
    #expect(emptyArray.compareCount(with: 0) == .orderedSame)
    #expect(emptyArray.compareCount(with: 1) == .orderedAscending)

    let array = [0, 1, 2, 3, 4, 5]
    #expect(array.compareCount(with: 3) == .orderedDescending)
    #expect(array.compareCount(with: 6) == .orderedSame)
    #expect(array.compareCount(with: 9) == .orderedAscending)
  }
}
#else
final class CollectionCountTests: XCTestCase {
  func test_string() {
    let emptyString = ""
    XCTAssertEqual(emptyString.compareCount(with: -1), .orderedDescending)
    XCTAssertEqual(emptyString.compareCount(with: 0), .orderedSame)
    XCTAssertEqual(emptyString.compareCount(with: 1), .orderedAscending)

    let yockowString = "YOCKOW"
    XCTAssertEqual(yockowString.compareCount(with: 3), .orderedDescending)
    XCTAssertEqual(yockowString.compareCount(with: 6), .orderedSame)
    XCTAssertEqual(yockowString.compareCount(with: 9), .orderedAscending)
  }

  func test_array() {
    let emptyArray = Array<Int>()
    XCTAssertEqual(emptyArray.compareCount(with: -1), .orderedDescending)
    XCTAssertEqual(emptyArray.compareCount(with: 0), .orderedSame)
    XCTAssertEqual(emptyArray.compareCount(with: 1), .orderedAscending)

    let array = [0, 1, 2, 3, 4, 5]
    XCTAssertEqual(array.compareCount(with: 3), .orderedDescending)
    XCTAssertEqual(array.compareCount(with: 6), .orderedSame)
    XCTAssertEqual(array.compareCount(with: 9), .orderedAscending)
  }
}
#endif
