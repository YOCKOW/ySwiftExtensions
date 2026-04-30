/* *************************************************************************************************
 StringComparisonTests.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@testable import yExtensions
import Testing

@Suite struct StringComparisonTests {
  @Test func test_asciiCaseInsensitivelyEqual() {
    #expect("ABCDefgh".isASCIICaseInsensitivelyEqual(to: "aBcDeFgH"))
    #expect("ABCDefgh".isASCIICaseInsensitivelyEqual(to: "AbCdEfGh"))
    
    #expect(!"ABCDefgh".isASCIICaseInsensitivelyEqual(to: "IJKLmnop"))
    #expect(!"ABCDefgh".isASCIICaseInsensitivelyEqual(to: "aBcDeFgHi"))
    #expect(!"ABCDefgh".isASCIICaseInsensitivelyEqual(to: "AbCdEfG"))
  }
}
