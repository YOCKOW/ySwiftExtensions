/* *************************************************************************************************
 FileHandleProtocol.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

/// A type for objects like `FileHandle`.
///
/// Notes:
/// - You can't make subclasses `FileHandle` correctly on Darwin due to [SR-11926](https://bugs.swift.org/browse/SR-11926).
/// - `FileHandle` itself does not conform to `FileHandleProtocol` in this module,
///   because this protocol requires new APIs.
public protocol FileHandleProtocol {
  mutating func close() throws
  func offset() throws -> UInt64
  mutating func readToEnd() throws -> Data?
  mutating func read(upToCount count: Int) throws -> Data?
  @discardableResult mutating func seekToEnd() throws -> UInt64
  mutating func seek(toOffset offset: UInt64) throws
  mutating func synchronize() throws
  mutating func truncate(atOffset offset: UInt64) throws
  mutating func write<T: DataProtocol>(contentsOf data: T) throws
}

extension FileHandleProtocol {
  public var availableData: Data {
    mutating get {
      do { return try self.readToEnd() ?? Data() } catch { return Data() }
    }
  }
  
  /// Read data until the given `byte` appears.
  public mutating func read(toByte byte: UInt8, upToCount count: Int = Int.max) throws -> Data {
    var result = Data()
    for _ in 0..<count {
      guard let byteData = try self.read(upToCount: 1) else { break }
      if byteData.isEmpty { break }
      result.append(byteData)
      if byteData[0] == byte { return result }
    }
    return result
  }
  
  public mutating func readToEnd() throws -> Data? {
    return try self.read(upToCount: Int.max)
  }
}


// MARK: Legacy APIs

private func _getData(_ body: () throws -> Data?) -> Data {
  // "try?" causes double-optional value in Swift <5.0
  do {
    guard let data = try body() else { return Data() }
    return data
  } catch {
    return Data()
  }
}

extension FileHandleProtocol {
  @available(*, deprecated, renamed: "close()")
  public mutating func closeFile() {
    try? self.close()
  }
  
  @available(*, deprecated, renamed: "offset()")
  public var offsetInFile: UInt64 {
    return try! self.offset()
  }
  
  @available(*, deprecated, renamed: "read(upToCount:)")
  public mutating func readData(ofLength length: Int) -> Data {
    return _getData { try self.read(upToCount: length) }
    
  }
  
  @available(*, deprecated, renamed: "readToEnd()")
  public mutating func readDataToEndOfFile() -> Data {
    return _getData { try self.readToEnd() }
  }
  
  @available(*, deprecated, renamed: "seek(toOffset:)")
  public mutating func seek(toFileOffset offset: UInt64) {
    try! self.seek(toOffset: offset)
  }
  
  @available(*, deprecated, renamed: "seekToEnd()")
  @discardableResult public mutating func seekToEndOfFile() -> UInt64 {
    return try! self.seekToEnd()
  }
  
  @available(*, deprecated, renamed: "synchronize()")
  public mutating func synchronizeFile() {
    try! self.synchronize()
  }
  
  @available(*, deprecated, renamed: "truncate(atOffset:)")
  public mutating func truncateFile(atOffset offset: UInt64) {
    try! self.truncate(atOffset: offset)
  }
  
  @available(*, deprecated, renamed: "write(contentsOf:)")
  public mutating func write(_ data: Data) {
    try! self.write(contentsOf: data)
  }
}
