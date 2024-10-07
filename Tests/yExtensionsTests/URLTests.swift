/* *************************************************************************************************
 URLTests.swift
   © 2020,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions
import Foundation

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct URLTests {
  @Test func localFiles() {
    #expect(!URL.temporaryDirectory.isExistingLocalFile)
    #expect(URL.temporaryDirectory.isExistingLocalDirectory)
  }
}
#else
final class URLTests: XCTestCase {
  func test_localFiles() {
    XCTAssertFalse(URL.temporaryDirectory.isExistingLocalFile)
    XCTAssertTrue(URL.temporaryDirectory.isExistingLocalDirectory)
  }
}
#endif
