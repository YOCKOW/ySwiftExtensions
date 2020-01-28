/* *************************************************************************************************
 FileHandleTests.swift
   © 2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions
import _yExtensions_support
import _yExtensionsTests_support

final class FileHandleTests: XCTestCase {
  func test_readToByte() throws {
    let fh = try _temporaryFileHandle(contents: Data([0,1,2,3]))
    try fh.newAPI.seek(toOffset: 1)
    XCTAssertEqual(try fh.read(toByte: 2), Data([1,2]))
  }
  
  func test_warn() throws {
    let originalStandardError = FileHandle._changeableStandardError
    let tmpFile = try _temporaryFileHandle()
    FileHandle._changeableStandardError = tmpFile
    
    warn("A", "B", "C", separator:",", terminator:"\n")
    
    FileHandle._changeableStandardError = originalStandardError
      
    try tmpFile.newAPI.seek(toOffset: 0)
    let warning = String(data: tmpFile.availableData, encoding: .utf8)!
    XCTAssertEqual(warning, "A,B,C\n")
  }
}





