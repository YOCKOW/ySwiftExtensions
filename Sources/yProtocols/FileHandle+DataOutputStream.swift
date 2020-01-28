/* *************************************************************************************************
 FileHandle+DataOutputStream.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation
import _yExtensions_support

private let _SIZE_TO_READ = 1024
extension FileHandle: DataOutputStream, DataOutputStreamable {
  public func write<D>(_ data: D) where D: DataProtocol {
    try? self.newAPI.write(contentsOf: data)
  }
  
  public func write<Target>(to target: inout Target) where Target: DataOutputStream {
    let originalOffset = try? self.newAPI.offset()
    defer {
      if let offset = originalOffset {
        try? self.newAPI.seek(toOffset: offset)
      }
    }
    
    while true {
      // "try?" causes double-optional value in Swift <5.0
      var nilableData: Data? = nil
      do { nilableData = try self.newAPI.read(upToCount: _SIZE_TO_READ) } catch {}
      guard let data = nilableData else { break }
      target.write(data)
    }
  }
}
