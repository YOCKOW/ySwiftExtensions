/* *************************************************************************************************
DataOutputStreamTests.swift
  © 2020 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
************************************************************************************************ */

import XCTest
@testable import yProtocols
import Foundation
import _yExtensionsTests_support

final class DataOutputStreamTests: XCTestCase {
  func test_data() throws {
    let source = Data([0,1,2,3])
    var target = Data()
    
    try source.write(to: &target)
    XCTAssertEqual(source, target)
  }
  
  func test_fileHandle() throws {
    let data = Data([0,1,2,3])
    let source = try _temporaryFileHandle(contents: data)
    var target = AnyFileHandle(try _temporaryFileHandle())
    
    try source.write(to: &target)
    try target.seek(toOffset: 0)
    XCTAssertEqual(data, target.availableData)
  }
}
