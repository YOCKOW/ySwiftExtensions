/* *************************************************************************************************
 yExtensionsUpdater.swift
  © 2020,2026 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@testable import yExtensionsUpdater
import yCodeUpdater
import Testing

@Suite struct yExtensionsUpdaterTests {
  @Test func test_output() async throws {
    let delegate = yExtensionsUpdaterDelegate()
    var intermediates: [IntermediateDataContainer<yExtensionsUpdaterDelegate.Intermediate>] = []
    for url in delegate.sourceURLs {
      intermediates.append(try await delegate.prepare(sourceURL: url))
    }
    let data =  try await delegate.convert(intermediates)
    let string = String(data: data, encoding: .utf8)!
    let lines = string.split { $0.isNewline }
    
    #expect(lines.contains("  public static let macRoman = CFString.Encoding(rawValue: 0x0)"))
  }
}
