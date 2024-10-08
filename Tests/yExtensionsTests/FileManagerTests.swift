/* *************************************************************************************************
 FileManagerTests.swift
   © 2020,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@testable import yExtensions
import XCTest

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct FileManagerTests {
  @Test func sr12737() throws {
    let baseDirURL = URL.temporaryDirectory.appendingPathComponent("ySwiftExtensionsFileManagerTests",
                                                                   isDirectory: true)

    let nn = 50
    let components: [String] = (0..<nn).reduce(into: []) { result, _ in
      result.append(String(UUID().base32EncodedString().prefix(7)))
    }
    DispatchQueue.concurrentPerform(iterations: nn) {
      let dirURL = baseDirURL.appendingPathComponent(components[0..<(nn - $0)].joined(separator: "/"))
      do {
        Thread.sleep(forTimeInterval: Double((0..<100).randomElement()!) * 0.001)
        try FileManager.default.createDirectoryWithIntermediateDirectories(at: dirURL)
      } catch {
        Issue.record("Error (Job #\($0)): \(error.localizedDescription)")
      }
    }

    try FileManager.default.removeItem(at: baseDirURL)
  }
}
#else
final class FileManagerTests: XCTestCase {
  func test_sr12737() throws {
    let baseDirURL = URL.temporaryDirectory.appendingPathComponent("ySwiftExtensionsFileManagerTests",
                                                                   isDirectory: true)
    
    let nn = 50
    let components: [String] = (0..<nn).reduce(into: []) { result, _ in
      result.append(String(UUID().base32EncodedString().prefix(7)))
    }
    DispatchQueue.concurrentPerform(iterations: nn) {
      let dirURL = baseDirURL.appendingPathComponent(components[0..<(nn - $0)].joined(separator: "/"))
      do {
        Thread.sleep(forTimeInterval: Double((0..<100).randomElement()!) * 0.001)
        try FileManager.default.createDirectoryWithIntermediateDirectories(at: dirURL)
      } catch {
        XCTFail("Error (Job #\($0)): \(error.localizedDescription)")
      }
    }
    
    try FileManager.default.removeItem(at: baseDirURL)
  }
}
#endif
