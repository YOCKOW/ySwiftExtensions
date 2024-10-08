/* *************************************************************************************************
 SequentialInputStreamTests.swift
   © 2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation
import XCTest
@testable import yExtensions

private func __randomBytes(_ nn: Int) -> Data {
  return (0..<nn).reduce(into: Data()) { (data: inout Data, _) in
    data.append(.random(in: .min ... .max))
  }
}

private func __data(from file: FileHandle) throws -> Data {
  try file.seek(toOffset: 0)
  return try file.readToEnd() ?? Data()
}

#if swift(>=6) && canImport(Testing)
import Testing

@Suite struct SequentialInputStreamTests {
  @Test func test_streamReading() throws {
    let streamSource0_data = __randomBytes(.random(in: 128...256))
    try _withTemporaryFileURLAndHandle(contents: __randomBytes(.random(in: 1024...2048))) { (streamSource1_url, streamSource1_file) in
      let streamSource2_data = __randomBytes(.random(in: 256...512))
      try _withTemporaryFileURLAndHandle(contents: __randomBytes(.random(in: 1024...2048))) { (streamSource3_url, streamSource3_file) in

        let seqInputStream = SequentialInputStream([
          InputStream(data: streamSource0_data),
          try XCTUnwrap(InputStream(url: streamSource1_url)),
          InputStream(data: streamSource2_data),
          try XCTUnwrap(InputStream(url: streamSource3_url)),
        ])

        seqInputStream.open()
        XCTAssertNotEqual(seqInputStream.streamStatus, .error)
        XCTAssertNil(seqInputStream.streamError)

        var fetchedData = Data()
        while seqInputStream.hasBytesAvailable {
          let size = 101
          let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
          defer { buffer.deallocate() }

          let count = seqInputStream.read(buffer, maxLength: size)
          guard count > 0 else { break }
          fetchedData.append(buffer, count: count)
        }

        let data0Count = streamSource0_data.count
        XCTAssertEqual(fetchedData[relativeBounds: 0..<data0Count], streamSource0_data)
        fetchedData = fetchedData.dropFirst(data0Count)

        let data1 = try __data(from: streamSource1_file)
        XCTAssertEqual(fetchedData[relativeBounds: 0..<data1.count], data1)
        fetchedData = fetchedData.dropFirst(data1.count)

        let data2Count = streamSource2_data.count
        XCTAssertEqual(fetchedData[relativeBounds: 0..<data2Count], streamSource2_data)
        fetchedData = fetchedData.dropFirst(data2Count)

        let data3 = try __data(from: streamSource3_file)
        XCTAssertEqual(fetchedData[relativeBounds: 0..<data3.count], data3)
      }
    }

  }
}
#else
final class SequentialInputStreamTests: XCTestCase {
  func test_streamReading() throws {
    let streamSource0_data = __randomBytes(.random(in: 128...256))
    try _withTemporaryFileURLAndHandle(contents: __randomBytes(.random(in: 1024...2048))) { (streamSource1_url, streamSource1_file) in
      let streamSource2_data = __randomBytes(.random(in: 256...512))
      try _withTemporaryFileURLAndHandle(contents: __randomBytes(.random(in: 1024...2048))) { (streamSource3_url, streamSource3_file) in

        let seqInputStream = SequentialInputStream([
          InputStream(data: streamSource0_data),
          try XCTUnwrap(InputStream(url: streamSource1_url)),
          InputStream(data: streamSource2_data),
          try XCTUnwrap(InputStream(url: streamSource3_url)),
        ])

        seqInputStream.open()
        XCTAssertNotEqual(seqInputStream.streamStatus, .error)
        XCTAssertNil(seqInputStream.streamError)

        var fetchedData = Data()
        while seqInputStream.hasBytesAvailable {
          let size = 101
          let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
          defer { buffer.deallocate() }

          let count = seqInputStream.read(buffer, maxLength: size)
          guard count > 0 else { break }
          fetchedData.append(buffer, count: count)
        }

        let data0Count = streamSource0_data.count
        XCTAssertEqual(fetchedData[relativeBounds: 0..<data0Count], streamSource0_data)
        fetchedData = fetchedData.dropFirst(data0Count)

        let data1 = try __data(from: streamSource1_file)
        XCTAssertEqual(fetchedData[relativeBounds: 0..<data1.count], data1)
        fetchedData = fetchedData.dropFirst(data1.count)

        let data2Count = streamSource2_data.count
        XCTAssertEqual(fetchedData[relativeBounds: 0..<data2Count], streamSource2_data)
        fetchedData = fetchedData.dropFirst(data2Count)

        let data3 = try __data(from: streamSource3_file)
        XCTAssertEqual(fetchedData[relativeBounds: 0..<data3.count], data3)
      }
    }

  }
}
#endif
