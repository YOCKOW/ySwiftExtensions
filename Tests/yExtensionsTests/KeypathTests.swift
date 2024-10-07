/* *************************************************************************************************
 KeypathTests.swift
   © 2023-2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation
import XCTest
@testable import yExtensions

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct KeyPathTests {
  @Test func asPredicate() {
    struct S: ExpressibleByBooleanLiteral, Equatable {
      typealias BooleanLiteralType = Bool
      let value: Bool
      var isTrue: Bool { value }
      var isFalse: Bool { !value }
      init(booleanLiteral value: Bool) { self.value = value }
    }

    let array: [S] = [true, false, false, true, false, true, true, true]
    #expect(array.filter(\.isTrue || \.isFalse) == array)
    #expect(array.filter(\.isTrue && \.isFalse).isEmpty)
    #expect(array.trimming(where: \.isTrue && \.isTrue) == [false, false, true, false])
    #expect(array.trimming(where: \.isFalse || \.isFalse) == array[...])
  }
}
#else
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
#endif
