/* *************************************************************************************************
 StringWidthTests.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions

final class StringWidthTests: XCTestCase {
  func test_width() {
    XCTAssertEqual("ABCDE".estimatedWidth, 5)
    XCTAssertEqual("あいうえお".estimatedWidth, 10)
    XCTAssertEqual("1⃝".estimatedWidth, 2)
    XCTAssertEqual("あ⃝⃝".estimatedWidth, 2)
    XCTAssertEqual("が".estimatedWidth, 2)
  }
}





