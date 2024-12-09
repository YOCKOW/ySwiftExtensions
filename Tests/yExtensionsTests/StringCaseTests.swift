/* *************************************************************************************************
 StringCaseTests.swift
   © 2019,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct StringCaseTests {
  @Test func camelCase() {
    #expect("SMTPServer".lowerCamelCase == "smtpServer")
    #expect("hypertext-transfer-protocol".upperCamelCase == "HypertextTransferProtocol")
    #expect("CCC10".lowerCamelCase == "ccc10")
    #expect("CCC10".upperCamelCase == "CCC10")
    #expect("ABC-1-2-3".lowerCamelCase == "abc1_2_3")
    #expect("ABC-DEF-ghi".upperCamelCase == "ABC_DEFGhi")
  }

  @Test func snakeCase() {
    #expect("these are my favourite things.".snakeCase == "these_are_my_favourite_things")
  }
}
#else
final class StringCaseTests: XCTestCase {
  func test_camelCase() {
    XCTAssertEqual("SMTPServer".lowerCamelCase, "smtpServer")
    XCTAssertEqual("hypertext-transfer-protocol".upperCamelCase, "HypertextTransferProtocol")
    XCTAssertEqual("CCC10".lowerCamelCase, "ccc10")
    XCTAssertEqual("CCC10".upperCamelCase, "CCC10")
  }
  
  func test_snakeCase() {
    XCTAssertEqual("these are my favourite things.".snakeCase,
                   "these_are_my_favourite_things")
  }
}
#endif
