/* *************************************************************************************************
DataOutputStreamTests.swift
  © 2020 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
************************************************************************************************ */

import XCTest
@testable import yProtocols
import Foundation

final class DataOutputStreamTests: XCTestCase {
  func test_data() {
    let source = Data([0,1,2,3])
    var target = Data()
    
    source.write(to: &target)
    XCTAssertEqual(source, target)
  }
  
  func test_fileHandle() throws {
    func _temporaryFileHandle(contents: Data? = nil) throws -> FileHandle {
      func _tmp() -> URL {
        if #available(macOS 10.12, *) {
          return FileManager.default.temporaryDirectory
        } else {
          return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        }
      }
      
      let url = _tmp().appendingPathComponent(UUID().uuidString)
      FileManager.default.createFile(atPath: url.path, contents: contents)
      return try FileHandle(forUpdating: url)
    }
    
    let data = Data([0,1,2,3])
    let source = try _temporaryFileHandle(contents: data)
    var target = try _temporaryFileHandle()
    
    source.write(to: &target)
    if #available(macOS 10.15, *) {
      #if canImport(ObjectiveC) || swift(>=5.0)
      try target.seek(toOffset: 0)
      #else
      target.seek(toFileOffset: 0)
      #endif
    } else {
      target.seek(toFileOffset: 0)
    }
    XCTAssertEqual(data, target.availableData)
  }
}
