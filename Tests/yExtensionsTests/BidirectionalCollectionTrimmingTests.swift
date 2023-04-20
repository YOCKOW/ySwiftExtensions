/* *************************************************************************************************
 BidirectionalCollectionTrimmingTests.swift
   © 2023 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation
import XCTest
@testable import yExtensions

final class KeyPathTests: XCTestCase {
  func test_asPredicate() {
    struct S: ExpressibleByBooleanLiteral, Equatable {
      typealias BooleanLiteralType = Bool
      let value: Bool
      var isTrue: Bool { value }
      var isFalse: Bool { !value }
      init(booleanLiteral value: Bool) { self.value = value }
    }

    let array: [S] = [true, false, false, true, false, true, true, true]
    XCTAssertEqual(array.filter(\.isTrue || \.isFalse), array)
    XCTAssertTrue(array.filter(\.isTrue && \.isFalse).isEmpty)
    XCTAssertEqual(array.trimming(where: \.isTrue && \.isTrue), [false, false, true, false])
    XCTAssertEqual(array.trimming(where: \.isFalse || \.isFalse), array[...])
  }
}
