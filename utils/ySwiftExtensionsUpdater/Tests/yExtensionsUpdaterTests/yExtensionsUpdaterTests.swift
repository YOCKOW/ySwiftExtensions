/* *************************************************************************************************
 yExtensionsUpdater.swift
  © 2020 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
 ************************************************************************************************ */


import XCTest
@testable import yExtensionsUpdater

final class yExtensionsUpdaterTests: XCTestCase {
  func test_output() throws {
    let delegate = yExtensionsUpdaterDelegate()
    let data =  try delegate.convert(delegate.sourceURLs.map({ try delegate.prepare(sourceURL: $0) }))
    let string = String(data: data, encoding: .utf8)!
    let lines = string.split { $0.isNewline }
    
    XCTAssertTrue(lines.contains("  public static let macRoman = CFString.Encoding(rawValue: 0x0)"))
  }
}
