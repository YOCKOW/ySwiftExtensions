/* *************************************************************************************************
 FileHandle+NewAPIs.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

// FileHandle's new APIs to be used in any version...

extension FileHandle {
  open class NewAPI {
    private var _fileHandle: FileHandle
    fileprivate init(_ fileHandle: FileHandle) {
      self._fileHandle = fileHandle
    }
    
    open func close() throws {
      #if !canImport(ObjectiveC)
        #if swift(>=5.0)
          try self._fileHandle.close()
        #else
          self._fileHandle.closeFile()
        #endif
      #else
      if #available(macOS 10.15, *) {
        try self._fileHandle.close()
      } else {
        self._fileHandle.closeFile()
      }
      #endif
    }
  
    open func offset() throws -> UInt64 {
      #if !canImport(ObjectiveC)
        #if swift(>=5.0)
          return try self._fileHandle.offset()
        #else
          return self._fileHandle.offsetInFile
        #endif
      #else
  //    if #available(macOS 10.16, *) {
  //      return try self.offset()
  //    } else {
        return self._fileHandle.offsetInFile
  //    }
      #endif
    }
    
    open func readToEnd() throws -> Data? {
      return try self.read(upToCount: Int.max)
    }
    
    open func read(upToCount count: Int) throws -> Data? {
      func _read(upToCount count: Int) throws -> Data? {
        #if !canImport(ObjectiveC)
          #if swift(>=5.0)
            return try self._fileHandle.read(upToCount: count)
          #else
            return self._fileHandle.readData(ofLength: count)
          #endif
        #else
  //      if #available(macOS 10.16, *) {
  //        return try? self.read(upToCount: count)
  //      } else {
          return self._fileHandle.readData(ofLength: count)
  //      }
        #endif
      }
      return try _read(upToCount: count).flatMap { $0.count == 0 ? nil : $0 }
    }
    
    open func seekToEnd()throws -> UInt64 {
      #if !canImport(ObjectiveC)
        #if swift(>=5.0)
          return try self._fileHandle.seekToEnd()
        #else
          return self._fileHandle.seekToEndOfFile()
        #endif
      #else
  //    if #available(macOS 10.16, *) {
  //      try self.seekToEnd()
  //    } else {
        return self._fileHandle.seekToEndOfFile()
  //    }
      #endif
    }
    
    open func seek(toOffset offset: UInt64) throws {
      #if !canImport(ObjectiveC)
        #if swift(>=5.0)
          try self._fileHandle.seek(toOffset: offset)
        #else
          self._fileHandle.seek(toFileOffset: offset)
        #endif
      #else
      if #available(macOS 10.15, *) {
        try self._fileHandle.seek(toOffset: offset)
      } else {
        self._fileHandle.seek(toFileOffset: offset)
      }
      #endif
    }
    
    open func synchronize() throws {
      #if !canImport(ObjectiveC)
        #if swift(>=5.0)
          try self._fileHandle.synchronize()
        #else
          self._fileHandle.synchronizeFile()
        #endif
      #else
      if #available(macOS 10.15, *) {
        try self._fileHandle.synchronize()
      } else {
        self._fileHandle.synchronizeFile()
      }
      #endif
    }
    
    open func truncate(atOffset offset: UInt64) throws {
      #if !canImport(ObjectiveC)
        // https://bugs.swift.org/browse/SR-11922
        #if swift(>=5.3)
          try self._fileHandle.truncate(atOffset: offset)
        #elseif swift(>=5.0)
          try self._fileHandle.truncate(toOffset: offset)
        #else
          self._fileHandle.truncateFile(atOffset: offset)
        #endif
      #else
      if #available(macOS 10.15, *) {
        try self._fileHandle.truncate(atOffset: offset)
      } else {
        self._fileHandle.truncateFile(atOffset: offset)
      }
      #endif
    }
    
    open func write<D>(contentsOf data: D) throws where D: DataProtocol {
      #if !canImport(ObjectiveC)
        #if swift(>=5.0)
          try self._fileHandle.write(contentsOf: data)
        #else
          self._fileHandle.write(Data(data))
        #endif
      #else
  //    if #available(macOS 10.16, *) {
  //      try? self.write(contentsOf: data)
  //    } else {
        self._fileHandle.write(Data(data))
  //    }
      #endif
    }
  }
  
  public var newAPI: NewAPI { return NewAPI(self) }
}
