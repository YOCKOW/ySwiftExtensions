/* *************************************************************************************************
 AnyFileHandle.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation
import yProtocols

/// A type-erasure for `FileHandleProtocol` or `FileHandle`.
@available(swift 5.0)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public final class AnyFileHandle: FileHandleProtocol {
  private class _Box {
    private func _mustBeOverridden(function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> Never {
      fatalError("\(function) must be overridden.", file: file, line: line)
    }
    
    fileprivate func close() throws { _mustBeOverridden() }
    fileprivate var objectIdentifier: ObjectIdentifier { _mustBeOverridden() }
    fileprivate func offset() throws -> UInt64 { _mustBeOverridden() }
    fileprivate func readToEnd() throws -> Data? { _mustBeOverridden() }
    fileprivate func read(upToCount count: Int) throws -> Data? { _mustBeOverridden() }
    fileprivate func seekToEnd() throws -> UInt64 { _mustBeOverridden() }
    fileprivate func seek(toOffset offset: UInt64) throws { _mustBeOverridden() }
    fileprivate func synchronize() throws { _mustBeOverridden() }
    fileprivate func truncate(atOffset offset: UInt64) throws { _mustBeOverridden() }
    fileprivate func write<T: DataProtocol>(contentsOf data: T) throws { _mustBeOverridden() }
    fileprivate func write(string: String, using encoding: String.Encoding, allowLossyConversion: Bool) throws { _mustBeOverridden() }
  }
  
  private class _SomeType<T>: _Box where T: FileHandleProtocol {
    private var _base: T
    fileprivate init(_ base: T) { self._base = base }
    
    fileprivate override func close() throws {
      try self._base.close()
    }
    
    fileprivate override var objectIdentifier: ObjectIdentifier {
      return ObjectIdentifier(self._base)
    }
    
    fileprivate override func offset() throws -> UInt64 {
      return try self._base.offset()
    }
    
    fileprivate override func readToEnd() throws -> Data? {
      return try self._base.readToEnd()
    }
    
    fileprivate override func read(upToCount count: Int) throws -> Data? {
      return try self._base.read(upToCount: count)
    }
    
    fileprivate override func seekToEnd() throws -> UInt64 {
      return try self._base.seekToEnd()
    }
    
    fileprivate override func seek(toOffset offset: UInt64) throws {
      try self._base.seek(toOffset: offset)
    }
    
    fileprivate override func synchronize() throws {
      try self._base.synchronize()
    }
    
    fileprivate override func truncate(atOffset offset: UInt64) throws {
      try self._base.truncate(atOffset: offset)
    }
    
    fileprivate override func write<T: DataProtocol>(contentsOf data: T) throws {
      try self._base.write(contentsOf: data)
    }
    
    fileprivate override func write(string: String, using encoding: String.Encoding, allowLossyConversion: Bool) throws {
      try self._base.write(string: string, using: encoding, allowLossyConversion: allowLossyConversion)
    }
  }
  
  
  private let _box: _Box
  
  public init<T>(_ fileHandle: T) where T: FileHandleProtocol {
    if case let anyFileHandle as AnyFileHandle = fileHandle {
      self._box = anyFileHandle._box
    } else {
      self._box = _SomeType<T>(fileHandle)
    }
  }
  
  public var availableData: Data {
    do { return try self._box.readToEnd() ?? Data() } catch { return Data() }
  }
  
  public func close() throws {
    return try self._box.close()
  }
  
  /// Returns an instance of `ObjectIdentifier` that is of the packed file handle.
  public var objectIdentifier: ObjectIdentifier {
    return self._box.objectIdentifier
  }
  
  public func offset() throws -> UInt64 {
    return try self._box.offset()
  }
  
  public func read(upToCount count: Int) throws -> Data? {
    return try self._box.read(upToCount: count)
  }
  
  public func seekToEnd() throws -> UInt64 {
    return try self._box.seekToEnd()
  }
  
  public func seek(toOffset offset: UInt64) throws {
    try self._box.seek(toOffset: offset)
  }
  
  public func synchronize() throws {
    try self._box.synchronize()
  }
  
  public func truncate(atOffset offset: UInt64) throws {
    try self._box.truncate(atOffset: offset)
  }
  
  public func write<T>(contentsOf data: T) throws where T : DataProtocol {
    try self._box.write(contentsOf: data)
  }
  
  public func write(string: String, using encoding: String.Encoding, allowLossyConversion: Bool) throws {
    try self._box.write(string: string, using: encoding, allowLossyConversion: allowLossyConversion)
  }
}


extension AnyFileHandle {
  /// The file handle associated with the standard error file.
  @available(swift 5.0)
  @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
  public static let standardError = AnyFileHandle(FileHandle.standardError)
  
  /// The file handle associated with the standard input file.
  @available(swift 5.0)
  @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
  public static let standardInput = AnyFileHandle(FileHandle.standardInput)
  
  /// The file handle associated with the standard output file.
  @available(swift 5.0)
  @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
  public static let standardOutput = AnyFileHandle(FileHandle.standardOutput)
}
