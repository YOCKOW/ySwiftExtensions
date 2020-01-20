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
  public mutating func readToEnd() throws -> Data? {
    return try self.read(upToCount: Int.max)
  }
}
