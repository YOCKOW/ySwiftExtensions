/* *************************************************************************************************
 FileHandleTests.swift
   © 2019,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import XCTest
@testable import yExtensions

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct FileHandleTests {
  @Test func dataOutputStream() throws {
    let data = Data([0,1,2,3])
    try _withTemporaryFileHandle(contents: data) { (source) in
      try _withTemporaryFileHandle { (targetFH) in
        var target = AnyFileHandle(targetFH)
        try source.write(to: &target)
        try target.seek(toOffset: 0)
        #expect(data == target.availableData)
      }
    }
  }

  @Test func fileHandleProtocol() throws {
    try _withTemporaryFileHandle { (fh) in
      let capsule = AnyFileHandle(fh)

      try capsule.seek(toOffset: 0)
      try capsule.write(contentsOf: Data([0,1,2,3]))
      #expect(try capsule.offset() == 4)
      try capsule.seek(toOffset: 0)
      let data = try capsule.readToEnd()
      #expect(data == Data([0,1,2,3]))

      try capsule.seek(toOffset: 1)
      let to2 = try capsule.read(toByte: 2)
      #expect(to2 == Data([1,2]))
    }
  }

  @Test func objectIdentifier() throws {
    try _withTemporaryFileHandle { (fh) in
      #expect(ObjectIdentifier(fh) == AnyFileHandle(fh).objectIdentifier)
    }
  }

  @Test func readToByte() throws {
    try _withTemporaryFileHandle(contents: Data([0,1,2,3])) { (fh) in
      try fh.seek(toOffset: 1)
      #expect(try fh.read(toByte: 2) == Data([1,2]))
    }
  }

  @Test func warnTest() throws {
    try _withTemporaryFileHandle { (fh) in
      var tmpFile = fh
      warn("A", "B", "C", separator:",", terminator:"\n", to: &tmpFile)

      try tmpFile.seek(toOffset: 0)
      let warning = try #require(String(data: tmpFile.availableData, encoding: .utf8))
      #expect(warning == "A,B,C\n")
    }
  }
}
#else
@available(swift 5.0)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
final class FileHandleTests: XCTestCase {
  func test_dataOutputStream() throws {
    let data = Data([0,1,2,3])
    try _withTemporaryFileHandle(contents: data) { (source) in
      try _withTemporaryFileHandle { (targetFH) in
        var target = AnyFileHandle(targetFH)
        try source.write(to: &target)
        try target.seek(toOffset: 0)
        XCTAssertEqual(data, target.availableData)
      }
    }
  }
  
  func test_fileHandleProtocol() throws {
    try _withTemporaryFileHandle { (fh) in
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
  
  func test_objectIdentifier() throws {
    try _withTemporaryFileHandle { (fh) in
      XCTAssertEqual(ObjectIdentifier(fh), AnyFileHandle(fh).objectIdentifier)
    }
  }
  
  func test_readToByte() throws {
    try _withTemporaryFileHandle(contents: Data([0,1,2,3])) { (fh) in
      try fh.seek(toOffset: 1)
      XCTAssertEqual(try fh.read(toByte: 2), Data([1,2]))
    }
  }
  
  func test_warn() throws {
    try _withTemporaryFileHandle { (fh) in
      var tmpFile = fh
      warn("A", "B", "C", separator:",", terminator:"\n", to: &tmpFile)

      try tmpFile.seek(toOffset: 0)
      let warning = String(data: tmpFile.availableData, encoding: .utf8)!
      XCTAssertEqual(warning, "A,B,C\n")
    }
  }
}
#endif
