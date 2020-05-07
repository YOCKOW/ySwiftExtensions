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
/// - You can't make subclasses `FileHandle` correctly on Darwin
///   due to [SR-11926](https://bugs.swift.org/browse/SR-11926).
@available(swift 5.0)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public protocol FileHandleProtocol: class,
                                    DataOutputStream,
                                    DataOutputStreamable,
                                    TextOutputStream {
  func close() throws
  func offset() throws -> UInt64
  func readToEnd() throws -> Data?
  func read(upToCount count: Int) throws -> Data?
  @discardableResult func seekToEnd() throws -> UInt64
  func seek(toOffset offset: UInt64) throws
  func synchronize() throws
  func truncate(atOffset offset: UInt64) throws
  func write<T: DataProtocol>(contentsOf data: T) throws
  
  /// Write the data containing a representation of the String encoded using a given encoding.
  /// See also `String.data(string:using:allowLossyConversion:)` for the details about parameters.
  func write(string: String, using encoding: String.Encoding, allowLossyConversion: Bool) throws
}

public enum FileHandleProtocolError: Error {
  case dataConversionFailure
}

@available(swift 5.0)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileHandleProtocol {
  public var availableData: Data {
    get {
      do { return try self.readToEnd() ?? Data() } catch { return Data() }
    }
  }
  
  /// Read data until the given `byte` appears.
  public func read(toByte byte: UInt8, upToCount count: Int = Int.max) throws -> Data? {
    var result = Data()
    for _ in 0..<count {
      guard let byteData = try self.read(upToCount: 1) else { break }
      if byteData.isEmpty { break }
      result.append(byteData)
      if byteData.first == byte { return result }
    }
    return result.isEmpty ? nil : result
  }
  
  public func readToEnd() throws -> Data? {
    return try self.read(upToCount: Int.max)
  }
  
  public func write<Target>(to target: inout Target) throws where Target: DataOutputStream {
    let _SIZE_TO_READ = 1024
    
    let originalOffset = try self.offset()
    while true {
      var nilableData: Data? = nil
      do { nilableData = try self.read(upToCount: _SIZE_TO_READ) } catch {}
      guard let data = nilableData, !data.isEmpty else { break }
      try target.write(contentsOf: data)
    }
    try self.seek(toOffset: originalOffset)
  }
  
  public func write(string: String, using encoding: String.Encoding, allowLossyConversion: Bool) throws {
    guard let data = string.data(using: encoding, allowLossyConversion: allowLossyConversion) else {
      throw FileHandleProtocolError.dataConversionFailure
    }
    try self.write(contentsOf: data)
  }
  
  public func write(_ string: String) {
    try! self.write(string: string, using: .utf8, allowLossyConversion: false)
  }
}

