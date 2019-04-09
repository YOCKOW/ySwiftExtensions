/* *************************************************************************************************
 FileHandleTests.swift
   © 2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions

final class FileHandleTests: XCTestCase {
  func test_warn() {
    let path = NSTemporaryDirectory() + UUID().uuidString
    _ = FileManager.default.createFile(atPath:path, contents:nil, attributes:nil)
    let originalStandardError = FileHandle._changeableStandardError
    let tmpFile = FileHandle(forUpdatingAtPath:path)!
    FileHandle._changeableStandardError = tmpFile
    
    warn("A", "B", "C", separator:",", terminator:"\n")
    
    FileHandle._changeableStandardError = originalStandardError
      
    tmpFile.seek(toFileOffset:0)
    let data = tmpFile.availableData
    tmpFile.closeFile()
      
    try! FileManager.default.removeItem(atPath:path)
      
    let warning = String(data:data, encoding:.utf8)!
      
    XCTAssertEqual(warning, "A,B,C\n")
  }
}





