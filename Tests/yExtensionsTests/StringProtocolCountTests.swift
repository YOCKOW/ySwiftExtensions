/* *************************************************************************************************
 StringProtocolCountTests.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation
import XCTest
@testable import yExtensions

final class StringProtocolCountTests: XCTestCase {
  func test_countComparison() {
    let emptyString = ""
    XCTAssertEqual(emptyString.compareCount(with: -1), .orderedDescending)
    XCTAssertEqual(emptyString.compareCount(with: 0), .orderedSame)
    XCTAssertEqual(emptyString.compareCount(with: 1), .orderedAscending)

    let yockowString = "YOCKOW"
    XCTAssertEqual(yockowString.compareCount(with: 3), .orderedDescending)
    XCTAssertEqual(yockowString.compareCount(with: 6), .orderedSame)
    XCTAssertEqual(yockowString.compareCount(with: 9), .orderedAscending)
  }
}
