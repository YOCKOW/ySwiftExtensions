/* *************************************************************************************************
 StringEncodingTests.swift
   © 2018,2024,2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@testable import yExtensions
import Testing

@Suite struct StringEncodingTests {
  @Test(
    arguments: [
      (.ascii, "US-ASCII"),
      (.iso2022JP, "ISO-2022-JP"),
      (.japaneseEUC, "EUC-JP"),
      (.utf8, "UTF-8"),
    ] as [(String.Encoding, String)]
  ) func test_IANACharSetName(_ pair: (encoding: String.Encoding, string: String)) throws {
    #expect(try #require(pair.encoding.ianaCharsetName).isASCIICaseInsensitivelyEqual(to: pair.string))
    #expect(try pair.encoding == #require(String.Encoding(ianaCharsetName: pair.string)))
  }
}
