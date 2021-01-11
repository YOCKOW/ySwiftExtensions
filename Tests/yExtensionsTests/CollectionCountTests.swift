/* *************************************************************************************************
 CollectionCountTests.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation
import XCTest
@testable import yExtensions

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
