/* *************************************************************************************************
 StringWidthTests.swift
   © 2020,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct StringWidthTests {
  @Test func width() {
    #expect("ABCDE".estimatedWidth == 5)
    #expect("あいうえお".estimatedWidth == 10)
    #expect("1⃝".estimatedWidth == 2)
    #expect("あ⃝⃝".estimatedWidth == 2)
    #expect("が".estimatedWidth == 2)
  }
}
#else
final class StringWidthTests: XCTestCase {
  func test_width() {
    XCTAssertEqual("ABCDE".estimatedWidth, 5)
    XCTAssertEqual("あいうえお".estimatedWidth, 10)
    XCTAssertEqual("1⃝".estimatedWidth, 2)
    XCTAssertEqual("あ⃝⃝".estimatedWidth, 2)
    XCTAssertEqual("が".estimatedWidth, 2)
  }
}
#endif
