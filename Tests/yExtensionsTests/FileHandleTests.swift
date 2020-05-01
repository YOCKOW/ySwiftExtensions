/* *************************************************************************************************
 FileHandleTests.swift
   © 2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
import _yExtensionsTests_support
@testable import yExtensions
@testable import yProtocols

@available(swift 5.0)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
final class FileHandleTests: XCTestCase {
  func test_readToByte() throws {
    let fh = try _temporaryFileHandle(contents: Data([0,1,2,3]))
    try fh.seek(toOffset: 1)
    XCTAssertEqual(try fh.read(toByte: 2), Data([1,2]))
  }
  
  func test_warn() throws {
    let originalStandardError = FileHandle._changeableStandardError
    let tmpFile = try _temporaryFileHandle()
    FileHandle._changeableStandardError = tmpFile
    
    warn("A", "B", "C", separator:",", terminator:"\n")
    
    FileHandle._changeableStandardError = originalStandardError
      
    try tmpFile.seek(toOffset: 0)
    let warning = String(data: tmpFile.availableData, encoding: .utf8)!
    XCTAssertEqual(warning, "A,B,C\n")
  }
}





