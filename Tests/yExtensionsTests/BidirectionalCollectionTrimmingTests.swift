/* *************************************************************************************************
 BidirectionalCollectionTrimmingTests.swift
   © 2023 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation
import XCTest
@testable import yExtensions

final class BidirectionalCollectionTrimmingTests: XCTestCase {
  func test_array() {
    let array = [0, 1, 2, 3, 4, 5, 4, 3, 2, 1]
    XCTAssertEqual(array.trimming(where: { $0 < 3 }), [3, 4, 5, 4, 3])
  }

  func test_stringTrimmingCharacters() {
    let string = "ABCabcABC"
    XCTAssertEqual(string.trimmingCharacters(where: { $0.isUppercase }), "abc")
  }

  func test_stringTrimmingUnicodeScalars() {
    let string = "\n\nsome line\n\n"
    XCTAssertEqual(string.trimmingUnicodeScalars(where: \.isNewline), "some line")
  }
}
