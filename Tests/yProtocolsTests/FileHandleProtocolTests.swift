/* *************************************************************************************************
 FileHandleProtocolTests.swift
  © 2020 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
************************************************************************************************ */

import XCTest
@testable import yProtocols
import Foundation

final class FileHandleProtocolTests: XCTestCase {
  func test_fileHandle() throws {
    let fh = try _temporaryFileHandle()
    var capsule = AnyFileHandle(fh)
    
    try capsule.seek(toOffset: 0)
    try capsule.write(contentsOf: Data([0,1,2,3]))
    XCTAssertEqual(try capsule.offset(), 4)
    try capsule.seek(toOffset: 0)
    let data = try capsule.readToEnd()
    XCTAssertEqual(data, Data([0,1,2,3]))
  }
}
