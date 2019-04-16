/* *************************************************************************************************
 UUIDTests.swift
   © 2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions
import Foundation

final class UUIDTests: XCTestCase {
  func test_base32() {
    let tests: [(uuidString:String, base32EncodedString:String, file:StaticString, line:UInt)] = [
      ("00000000-0000-0000-0000-000000000000", "AAAAAAAAAAAAAAAAAAAAAAAAAA", #file, #line),
      ("E38399E3-83BC-E382-B9EF-BC93EFBC9221", "4OBZTY4DXTRYFOPPXSJ67PESEE", #file, #line),
    ]
    
    for test in tests {
      XCTAssertEqual(UUID(uuidString:test.uuidString),
                     UUID(base32Encoded:test.base32EncodedString, using:.rfc4648),
                     file:test.file, line:test.line)
    }
  }
}




