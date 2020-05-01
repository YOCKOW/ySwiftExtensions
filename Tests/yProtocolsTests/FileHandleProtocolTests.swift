/* *************************************************************************************************
 FileHandleProtocolTests.swift
  © 2020 YOCKOW.
    Licensed under MIT License.
    See "LICENSE.txt" for more information.
************************************************************************************************ */

import XCTest
@testable import yProtocols
import Foundation
import _yExtensionsTests_support

@available(swift 5.0)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
final class FileHandleProtocolTests: XCTestCase {
  func test_fileHandle() throws {
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
}
