/* *************************************************************************************************
 StringEncodingTests.swift
   © 2018,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions

#if canImport(Testing)
import Testing
#endif

private func checkIANACharSetName(
  _ encoding: String.Encoding,
  _ expected: String,
  fileID: StaticString = #fileID,
  filePath: StaticString = #filePath,
  line: UInt = #line,
  column: UInt = #column
) {
  #if canImport(Testing)
  let sourceLocation = SourceLocation(
    fileID: fileID.description,
    filePath: filePath.description,
    line: Int(line),
    column: Int(column)
  )
  #expect(encoding.ianaCharacterSetName?.lowercased() == expected.lowercased(), sourceLocation: sourceLocation)
  #expect(encoding == String.Encoding(ianaCharacterSetName:expected), sourceLocation: sourceLocation)
  #else
  XCTAssertEqual(encoding.ianaCharacterSetName?.lowercased(), expected.lowercased(),
                 file: filePath, line: line)
  XCTAssertEqual(encoding, String.Encoding(ianaCharacterSetName:expected),
                 file: filePath, line: line)
  #endif
}

#if swift(>=6) && canImport(Testing)
@Suite struct StringEncodingTests {
  @Test func IANACharSetName() {
    checkIANACharSetName(.ascii, "US-ASCII")
    checkIANACharSetName(.iso2022JP, "ISO-2022-JP")
    checkIANACharSetName(.japaneseEUC, "EUC-JP")
    checkIANACharSetName(.utf8, "UTF-8")
  }
}
#else
final class StringEncodingTests: XCTestCase {
  func test_IANACharSetName() {
    checkIANACharSetName(.ascii, "US-ASCII")
    checkIANACharSetName(.iso2022JP, "ISO-2022-JP")
    checkIANACharSetName(.japaneseEUC, "EUC-JP")
    checkIANACharSetName(.utf8, "UTF-8")
  }
}
#endif
