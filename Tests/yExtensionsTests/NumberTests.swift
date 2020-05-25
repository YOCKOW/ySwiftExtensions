/* *************************************************************************************************
 NumberTests.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions

final class NumberTests: XCTestCase {
  func test_base32() {
    let int32: Int32 = 0x12345678
    XCTAssertEqual(int32.base32EncodedString(using: .rfc4648, byteOrder: .bigEndian, padding: false),
                   "CI2FM6A")
    XCTAssertEqual(int32.base32EncodedString(using: .rfc4648, byteOrder: .littleEndian, padding: false),
                   "PBLDIEQ")
  }
}
