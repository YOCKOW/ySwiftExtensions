/* *************************************************************************************************
 StringCFStringTests.swift
   © 2018,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct StringCFStringTests {
  @Test func conversion() {
    let ascii_string = "A"
    #expect(ascii_string == String(ascii_string.coreFoundationString))

    let japanese = "日本語"
    #expect(japanese == String(japanese.coreFoundationString))
  }
}
#else
final class StringCFStringTests: XCTestCase {
  func test_conversion() {
    let ascii_string = "A"
    XCTAssertEqual(ascii_string, String(ascii_string.coreFoundationString))
    
    let japanese = "日本語"
    XCTAssertEqual(japanese, String(japanese.coreFoundationString))
  }
}
#endif
