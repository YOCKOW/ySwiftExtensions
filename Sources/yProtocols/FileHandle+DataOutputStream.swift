/* *************************************************************************************************
 FileHandle+DataOutputStream.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation
import yNewAPI

// `func write(contentsOf:)` is available in macOS>=10.15
// extension FileHandle: DataOutputStream {}

private let _SIZE_TO_READ = 1024
extension FileHandle: DataOutputStreamable {
  public func write<Target>(to target: inout Target) throws where Target : DataOutputStream {
    let originalOffset = try self.newAPI.offset()
    
    while true {
      // "try?" causes double-optional value in Swift <5.0
      var nilableData: Data? = nil
      do { nilableData = try self.newAPI.read(upToCount: _SIZE_TO_READ) } catch {}
      guard let data = nilableData else { break }
      try target.write(contentsOf: data)
    }
    try self.newAPI.seek(toOffset: originalOffset)
  }
}
