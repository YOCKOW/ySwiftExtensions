/* *************************************************************************************************
 FileManagerTests.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

@testable import yExtensions
import XCTest

final class FileManagerTests: XCTestCase {
  func test_sr12737() throws {
    let manager = FileManager.default
    
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
        try manager.createDirectoryWithIntermediateDirectories(at: dirURL)
      } catch {
        XCTFail("Error (Job #\($0)): \(error.localizedDescription)")
      }
    }
    
    try manager.removeItem(at: baseDirURL)
  }
}
