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
  func test_dataOutputStream() throws {
    let data = Data([0,1,2,3])
    let source = try _temporaryFileHandle(contents: data)
    var target = AnyFileHandle(try _temporaryFileHandle())
    
    try source.write(to: &target)
    try target.seek(toOffset: 0)
    XCTAssertEqual(data, target.availableData)
  }
  
  func test_fileHandleProtocol() throws {
    let fh = try _temporaryFileHandle()
    let capsule = AnyFileHandle(fh)
    
    try capsule.seek(toOffset: 0)
    try capsule.write(contentsOf: Data([0,1,2,3]))
    XCTAssertEqual(try capsule.offset(), 4)
    try capsule.seek(toOffset: 0)
    let data = try capsule.readToEnd()
    XCTAssertEqual(data, Data([0,1,2,3]))
    
    try capsule.seek(toOffset: 1)
    let to2 = try capsule.read(toByte: 2)
    XCTAssertEqual(to2, Data([1,2]))
  }
  
  func test_readToByte() throws {
    let fh = try _temporaryFileHandle(contents: Data([0,1,2,3]))
    try fh.seek(toOffset: 1)
    XCTAssertEqual(try fh.read(toByte: 2), Data([1,2]))
  }
  
  func test_warn() throws {
    var tmpFile = try _temporaryFileHandle()
    warn("A", "B", "C", separator:",", terminator:"\n", to: &tmpFile)
      
    try tmpFile.seek(toOffset: 0)
    let warning = String(data: tmpFile.availableData, encoding: .utf8)!
    XCTAssertEqual(warning, "A,B,C\n")
  }
}





