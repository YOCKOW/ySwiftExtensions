/* *************************************************************************************************
 URLTests.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions
import Foundation

final class URLTests: XCTestCase {
  func test_localFiles() {
    XCTAssertFalse(URL.temporaryDirectory.isExistingLocalFile)
    XCTAssertTrue(URL.temporaryDirectory.isExistingLocalDirectory)
  }
}





