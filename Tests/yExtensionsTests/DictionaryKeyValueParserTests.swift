/* *************************************************************************************************
 DictionaryKeyValueParserTests.swift
   © 2018,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct DictionaryKeyValueParserTests {
  @Test func parse() {
    let string = ##"A=B; C=D; "\"E\""="F""##
    let parsed = Dictionary<String,String>(parsing:string)

    #expect(parsed["A"] == "B")
    #expect(parsed["C"] == "D")
    #expect(parsed["\"E\""] == "F")
  }
}
#else
final class DictionaryKeyValueParserTests: XCTestCase {
  func test_parse() {
    let string = ##"A=B; C=D; "\"E\""="F""##
    let parsed = Dictionary<String,String>(parsing:string)
    
    XCTAssertEqual(parsed["A"], "B")
    XCTAssertEqual(parsed["C"], "D")
    XCTAssertEqual(parsed["\"E\""], "F")
  }
}
#endif
