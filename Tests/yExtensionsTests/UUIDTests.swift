/* *************************************************************************************************
 UUIDTests.swift
   © 2019,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions
import Foundation

let tests: [(uuidString: String, base32EncodedString: String, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt)] = [
  ("00000000-0000-0000-0000-000000000000", "AAAAAAAAAAAAAAAAAAAAAAAAAA", #fileID, #filePath, #line, #column),
  ("E38399E3-83BC-E382-B9EF-BC93EFBC9221", "4OBZTY4DXTRYFOPPXSJ67PESEE", #fileID, #filePath, #line, #column),
]

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct UUIDTests {
  @Test func base32() {
    for test in tests {
      let sourceLocation = SourceLocation(
        fileID: test.fileID.description,
        filePath: test.filePath.description,
        line: Int(test.line),
        column: Int(test.column)
      )
      #expect(
        UUID(uuidString:test.uuidString) == UUID(base32Encoded: test.base32EncodedString, version: .rfc4648),
        sourceLocation: sourceLocation
      )
    }
  }
}
#else
final class UUIDTests: XCTestCase {
  func test_base32() {
    for test in tests {
      XCTAssertEqual(UUID(uuidString:test.uuidString),
                     UUID(base32Encoded: test.base32EncodedString, version: .rfc4648),
                     file: test.filePath, line: test.line)
    }
  }
}
#endif
