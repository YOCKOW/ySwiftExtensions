/* *************************************************************************************************
 DataTests.swift
   © 2018-2019,2021,2024-2025 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation
import Testing
import XCTest
@testable import yExtensions

private let data = Data([
  0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,
  0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F,
])
private let subdata = data[0x04..<0x0C]

@Suite struct DataTests {
  @Test func base32() {
    let tests: [Base32Version: (String, String, String, Int, Int)] = [
      .rfc4648: ("AQCQMBYIBEFAW", #fileID, #filePath, #line, #column),
      .crockford: ("0G2GC1R81450P", #fileID, #filePath, #line, #column),
    ]

    for (version, testValue) in tests {
      let sourceLocation = SourceLocation(fileID: testValue.1, filePath: testValue.2, line: testValue.3, column: testValue.4)
      #expect(
        subdata.base32EncodedString(using: version) == testValue.0,
        "Encoding",
        sourceLocation: sourceLocation
      )
      #expect(
        subdata == Data(base32Encoded: testValue.0, version: version),
        "Decoding",
        sourceLocation: sourceLocation
      )
    }
  }

  @Test func base64_SF_GHI1535() {
    // Confirm that we can work around https://github.com/swiftlang/swift-foundation/issues/1535
    for length in 1992..<1997 {
      let data: any DataProtocol = Data(repeating: 0xFF, count: length)
      let encoded = data.base64EncodedData(options: .lineLength76Characters)
      #expect(encoded.last != 0x00)
    }
  }

  @Test func protocolTest() throws {
    let source = Data([0,1,2,3])
    var target = Data()

    try source.write(to: &target)
    #expect(source == target)
  }

  @Test func quotedPrintable() {
    func assertQP(
      _ string: String,
      quotedPrintableString: String,
      encodingOptions: Data.QuotedPrintableEncodingOptions = .default,
      fileID: StaticString = #fileID,
      filePath: StaticString = #filePath,
      line: UInt = #line,
      column: UInt = #column
    ) {
      let sourceLocation = SourceLocation(
        fileID: String(describing: fileID),
        filePath: String(describing: filePath),
        line: Int(line),
        column: Int(column)
      )
      #expect(
        Data(string.utf8).quotedPrintableEncodedString(options: encodingOptions) == quotedPrintableString,
        "Failed to encode: \(string)",
        sourceLocation: sourceLocation
      )
      #expect(
        Data(quotedPrintableEncoded: quotedPrintableString).flatMap({ String(data: $0, encoding: .utf8) }) == string,
        "Failed to decode: \(quotedPrintableString)",
        sourceLocation: sourceLocation
      )
    }

    let CRLF = "\u{0D}\u{0A}"
    assertQP(
      "J'interdis aux marchands de vanter trop leur marchandises. Car ils se font vite pédagogues et t'enseignent comme but ce qui n'est par essence qu'un moyen, et te trompant ainsi sur la route à suivre les voilà bientôt qui te dégradent, car si leur musique est vulgaire ils te fabriquent pour te la vendre une âme vulgaire.",
      quotedPrintableString: """
      J'interdis aux marchands de vanter trop leur marchandises. Car ils se font =\(CRLF)\
      vite p=C3=A9dagogues et t'enseignent comme but ce qui n'est par essence qu'=\(CRLF)\
      un moyen, et te trompant ainsi sur la route =C3=A0 suivre les voil=C3=A0 bi=\(CRLF)\
      ent=C3=B4t qui te d=C3=A9gradent, car si leur musique est vulgaire ils te f=\(CRLF)\
      abriquent pour te la vendre une =C3=A2me vulgaire.
      """
    )

    // Check whether or not https://github.com/YOCKOW/ySwiftExtensions/issues/43 is fixed.
    assertQP(
      "!あいうえおかきくけこ",
      quotedPrintableString: """
      !=E3=81=82=E3=81=84=E3=81=86=E3=81=88=E3=81=8A=E3=81=8B=E3=81=8D=E3=81=8F=\(CRLF)\
      =E3=81=91=E3=81=93
      """
    )

    // Check whether or not https://github.com/YOCKOW/ySwiftExtensions/issues/45 is fixed.
    assertQP(
      """
      !あいうえおかきくけこ
      さしすせそたちつてと?
      """,
      quotedPrintableString: """
      !=E3=81=82=E3=81=84=E3=81=86=E3=81=88=E3=81=8A=E3=81=8B=E3=81=8D=E3=81=8F=\(CRLF)\
      =E3=81=91=E3=81=93=0A=E3=81=95=E3=81=97=E3=81=99=E3=81=9B=E3=81=9D=E3=81=9F=\(CRLF)\
      =E3=81=A1=E3=81=A4=E3=81=A6=E3=81=A8?
      """,
      encodingOptions: .regardAsBinary
    )
  }

  @Test func relativeIndex() {
    #expect(subdata[subdata.startIndex] == subdata[relativeIndex: 0])
    #expect(subdata == subdata[relativeBounds: 0...7])
    #expect(subdata == subdata[relativeBounds: 0..<8])
    #expect(subdata == subdata[relativeBounds: 0...])
    #expect(subdata == subdata[relativeBounds: (-1)<..7])
    #expect(subdata == subdata[relativeBounds: (-1)<..<8])
    #expect(subdata == subdata[relativeBounds: (-1)<..])
    #expect(subdata == subdata[relativeBounds: ...7])
    #expect(subdata == subdata[relativeBounds: ..<8])
  }

  @Test func view() {
    let uint8View = data.uint8View
    #expect(uint8View[uint8View.index(after:uint8View.startIndex)] == 0x01)

    guard let uint16BEView = data.uint16BigEndianView else { XCTFail("Must not be nil."); return }
    #expect(uint16BEView[uint16BEView.index(uint16BEView.startIndex, offsetBy:3)] == 0x0607)

    guard let uint16LEView = data.uint16LittleEndianView else { XCTFail("Must not be nil."); return }
    #expect(uint16LEView[uint16LEView.index(uint16LEView.startIndex, offsetBy:7)] == 0x0F0E)

    guard let uint32BEView = data.uint32BigEndianView else { XCTFail("Must not be nil."); return }
    #expect(uint32BEView[uint32BEView.index(uint32BEView.startIndex, offsetBy:1)] == 0x04050607)

    guard let uint32LEView = data.uint32LittleEndianView else { XCTFail("Must not be nil."); return }
    #expect(uint32LEView[uint32LEView.index(uint32LEView.startIndex, offsetBy:2)] == 0x0B0A0908)

    guard let subUInt16LEView = subdata.uint16LittleEndianView else { XCTFail("Must not be nil."); return }
    #expect(subUInt16LEView[subUInt16LEView.startIndex] == 0x0504)
  }
}
