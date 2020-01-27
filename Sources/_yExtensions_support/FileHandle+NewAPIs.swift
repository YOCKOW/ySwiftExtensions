/* *************************************************************************************************
 FileHandle+NewAPIs.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

// FileHandle's new APIs to be used in any version...

extension FileHandle {
  public func _close() throws {
    #if !canImport(ObjectiveC)
      #if swift(>=5.0)
        try self.close()
      #else
        self.closeFile()
      #endif
    #else
    if #available(macOS 10.15, *) {
      try self.close()
    } else {
      self.closeFile()
    }
    #endif
  }
  
  public func _offset() throws -> UInt64 {
    #if !canImport(ObjectiveC)
      #if swift(>=5.0)
        return try self.offset()
      #else
        return self.offsetInFile
      #endif
    #else
//    if #available(macOS 10.16, *) {
//      return try self.offset()
//    } else {
      return self.offsetInFile
//    }
    #endif
  }
  
  public func _readToEnd() throws -> Data? {
    return try self._read(upToCount: Int.max)
  }
  
  public func _read(upToCount count: Int) throws -> Data? {
    func __read(upToCount count: Int) throws -> Data? {
      #if !canImport(ObjectiveC)
        #if swift(>=5.0)
          return try self.read(upToCount: count)
        #else
          return self.readData(ofLength: count)
        #endif
      #else
//      if #available(macOS 10.16, *) {
//        return try? self.read(upToCount: count)
//      } else {
        return self.readData(ofLength: count)
//      }
      #endif
    }
    return try __read(upToCount: count).flatMap { $0.count == 0 ? nil : $0 }
  }
  
  public func _seekToEnd()throws -> UInt64 {
    #if !canImport(ObjectiveC)
      #if swift(>=5.0)
        return try self.seekToEnd()
      #else
        return self.seekToEndOfFile()
      #endif
    #else
//    if #available(macOS 10.16, *) {
//      try self.seekToEnd()
//    } else {
    return self.seekToEndOfFile()
//    }
    #endif
  }
  
  public func _seek(toOffset offset: UInt64) throws {
    #if !canImport(ObjectiveC)
      #if swift(>=5.0)
        try self.seek(toOffset: offset)
      #else
        self.seek(toFileOffset: offset)
      #endif
    #else
    if #available(macOS 10.15, *) {
      try self.seek(toOffset: offset)
    } else {
      self.seek(toFileOffset: offset)
    }
    #endif
  }
  
  public func _synchronize() throws {
    #if !canImport(ObjectiveC)
      #if swift(>=5.0)
        try self.synchronize()
      #else
        self.synchronizeFile()
      #endif
    #else
    if #available(macOS 10.15, *) {
      try self.synchronize()
    } else {
      self.synchronizeFile()
    }
    #endif
  }
  
  public func _truncate(atOffset offset: UInt64) throws {
    #if !canImport(ObjectiveC)
      // https://bugs.swift.org/browse/SR-11922
      #if swift(>=5.3)
        try self.truncate(atOffset: offset)
      #elseif swift(>=5.0)
        try self.truncate(toOffset: offset)
      #else
        self.truncateFile(atOffset: offset)
      #endif
    #else
    if #available(macOS 10.15, *) {
      try self.truncate(atOffset: offset)
    } else {
      self.truncateFile(atOffset: offset)
    }
    #endif
  }
  
  public func _write<D>(contentsOf data: D) throws where D: DataProtocol {
    #if !canImport(ObjectiveC)
      #if swift(>=5.0)
        try self.write(contentsOf: data)
      #else
        self.write(Data(data))
      #endif
    #else
//    if #available(macOS 10.16, *) {
//      try? self.write(contentsOf: data)
//    } else {
      self.write(Data(data))
//    }
    #endif
  }
}
