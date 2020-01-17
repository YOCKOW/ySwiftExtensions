/* *************************************************************************************************
 FileHandle+DataOutputStream.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

extension FileHandle {
  fileprivate func _offset() -> UInt64? {
    #if !canImport(ObjectiveC)
      #if swift(>=5.0)
        return try? self.offset()
      #else
        return self.offsetInFile
      #endif
    #else
//    if #available(macOS 10.16, *) {
//      return try? self.offset()
//    } else {
        return self.offsetInFile
//    }
    #endif
  }
  
  fileprivate func _read(upToCount count: Int) -> Data? {
    func __read(upToCount count: Int) -> Data? {
      #if !canImport(ObjectiveC)
        #if swift(>=5.0)
          return try? self.read(upToCount: count)
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
    return __read(upToCount: count).flatMap { $0.count == 0 ? nil : $0 }
  }
  
  fileprivate func _seek(toOffset offset: UInt64) {
    #if !canImport(ObjectiveC)
      #if swift(>=5.0)
        try? self.seek(toOffset: offset)
      #else
        self.seek(toFileOffset: offset)
      #endif
    #else
    if #available(macOS 10.15, *) {
      try? self.seek(toOffset: offset)
    } else {
      self.seek(toFileOffset: offset)
    }
    #endif
  }
  
  fileprivate func _write<D>(contentsOf data: D) where D: DataProtocol {
    #if !canImport(ObjectiveC)
      #if swift(>=5.0)
        try? self.write(contentsOf: data)
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


private let _SIZE_TO_READ = 1024
extension FileHandle: DataOutputStream, DataOutputStreamable {
  public func write<D>(_ data: D) where D: DataProtocol {
    self._write(contentsOf: data)
  }
  
  public func write<Target>(to target: inout Target) where Target: DataOutputStream {
    let originalOffset = self._offset()
    defer {
      if let offset = originalOffset {
        self._seek(toOffset: offset)
      }
    }
    
    while true {
      guard let data = self._read(upToCount: _SIZE_TO_READ) else { break }
      target.write(data)
    }
  }
}
