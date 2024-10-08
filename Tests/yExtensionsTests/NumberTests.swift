/* *************************************************************************************************
 NumberTests.swift
   © 2020,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct NumberTests {
  @Test func base32_float() {
    let float: Float = -118.625
    let expectedBitPattern: UInt32 = 0b11000010111011010100000000000000
    #expect(
      float.base32EncodedData(using: .rfc4648, byteOrder: .bigEndian, padding: false)
      == expectedBitPattern.base32EncodedData(using: .rfc4648, byteOrder: .bigEndian, padding: false)
    )
    #expect(
      Float(
        base32Encoded: expectedBitPattern.base32EncodedData(
          using: .triacontakaidecimal,
          byteOrder: .littleEndian,
          padding: false
        ),
        version: .triacontakaidecimal,
        byteOrder: .littleEndian
      ) == float
    )
  }

  @Test func base32_integer() {
    let int32: Int32 = 0x12345678
    #expect(
      int32.base32EncodedString(using: .rfc4648, byteOrder: .bigEndian, padding: false) == "CI2FM6A"
    )
    #expect(
      int32.base32EncodedString(using: .rfc4648, byteOrder: .littleEndian, padding: false) == "PBLDIEQ"
    )
    #expect(Int32(base32Encoded: "CI2FM6A", version: .rfc4648, byteOrder: .bigEndian) == int32)
    #expect(Int32(base32Encoded: "PBLDIEQ", version: .rfc4648, byteOrder: .littleEndian) == int32)
  }
}
#else
final class NumberTests: XCTestCase {
  func test_base32_float() {
    let float: Float = -118.625
    let expectedBitPattern: UInt32 = 0b11000010111011010100000000000000
    XCTAssertEqual(float.base32EncodedData(using: .rfc4648, byteOrder: .bigEndian, padding: false),
                   expectedBitPattern.base32EncodedData(using: .rfc4648, byteOrder: .bigEndian, padding: false))
    XCTAssertEqual(
      Float(base32Encoded: expectedBitPattern.base32EncodedData(using: .triacontakaidecimal,
                                                                byteOrder: .littleEndian,
                                                                padding: false),
            version: .triacontakaidecimal, byteOrder: .littleEndian),
      float
    )
  }
  
  func test_base32_integer() {
    let int32: Int32 = 0x12345678
    XCTAssertEqual(int32.base32EncodedString(using: .rfc4648, byteOrder: .bigEndian, padding: false),
                   "CI2FM6A")
    XCTAssertEqual(int32.base32EncodedString(using: .rfc4648, byteOrder: .littleEndian, padding: false),
                   "PBLDIEQ")
    XCTAssertEqual(Int32(base32Encoded: "CI2FM6A", version: .rfc4648, byteOrder: .bigEndian),
                   int32)
    XCTAssertEqual(Int32(base32Encoded: "PBLDIEQ", version: .rfc4648, byteOrder: .littleEndian),
                   int32)
  }
}
#endif
