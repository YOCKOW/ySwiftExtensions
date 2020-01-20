/* *************************************************************************************************
 AnyFileHandle.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

/// A type-erasure for `FileHandleProtocol`.
public struct AnyFileHandle: FileHandleProtocol {
  private class _Box {
    private func _mustBeOverridden(function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> Never {
      fatalError("\(function) must be overridden.", file: file, line: line)
    }
    
    fileprivate func close() throws { _mustBeOverridden() }
    fileprivate func offset() throws -> UInt64 { _mustBeOverridden() }
    fileprivate func readToEnd() throws -> Data? { _mustBeOverridden() }
    fileprivate func read(upToCount count: Int) throws -> Data? { _mustBeOverridden() }
    fileprivate func seekToEnd() throws -> UInt64 { _mustBeOverridden() }
    fileprivate func seek(toOffset offset: UInt64) throws { _mustBeOverridden() }
    fileprivate func synchronize() throws { _mustBeOverridden() }
    fileprivate func truncate(atOffset offset: UInt64) throws { _mustBeOverridden() }
    fileprivate func write<T: DataProtocol>(contentsOf data: T) throws { _mustBeOverridden() }
  }
  
  private class _SomeFileHandle: _Box {
    private let _fileHandle: FileHandle
    fileprivate init(_ fileHandle: FileHandle) { self._fileHandle = fileHandle }
    
    fileprivate override func close() throws {
      try self._fileHandle._close()
    }
    
    fileprivate override func offset() throws -> UInt64 {
      return try self._fileHandle._offset()
    }
    
    fileprivate override func readToEnd() throws -> Data? {
      return try self._fileHandle._readToEnd()
    }
    
    fileprivate override func read(upToCount count: Int) throws -> Data? {
      return try self._fileHandle._read(upToCount: count)
    }
    
    fileprivate override func seekToEnd() throws -> UInt64 {
      return try self._fileHandle._seekToEnd()
    }
    
    fileprivate override func seek(toOffset offset: UInt64) throws {
      try self._fileHandle._seek(toOffset: offset)
    }
    
    fileprivate override func synchronize() throws {
      try self._fileHandle._synchronize()
    }
    
    fileprivate override func truncate(atOffset offset: UInt64) throws {
      try self._fileHandle._truncate(atOffset: offset)
    }
    
    fileprivate override func write<T: DataProtocol>(contentsOf data: T) throws {
      try self._fileHandle._write(contentsOf: data)
    }
  }
  
  private class _SomeType<T>: _Box where T: FileHandleProtocol {
    private let _base: T
    fileprivate init(_ base: T) { self._base = base }
    
    fileprivate override func close() throws {
      try self._base.close()
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
  }
  
  
  private let _box: _Box
  
  public init(_ fileHandle: FileHandle) {
    self._box = _SomeFileHandle(fileHandle)
  }
  
  public init<T>(_ fileHandle: T) where T: FileHandleProtocol {
    self._box = _SomeType<T>(fileHandle)
  }
  
  
  public func close() throws {
    return try self._box.close()
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
}