/* *************************************************************************************************
 FileHandle+ReadData.swift
   © 2017-2018 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation
import yNewAPI

extension FileHandle {
  /// Read data until the given `byte` appears.
  public func read(toByte byte: UInt8, upToCount count: Int = Int.max) throws -> Data? {
    var result = Data()
    for _ in 0..<count {
      guard let byteData = try self.newAPI.read(upToCount: 1) else { break }
      if byteData.isEmpty { break }
      result.append(byteData)
      if byteData[0] == byte { return result }
    }
    return result.isEmpty ? nil : result
  }
  
  /// Read data until the given `byte` appears.
  @available(*, deprecated, renamed: "read(toByte:upToCount:)")
  public func readData(toByte byte:UInt8, maximumLength:Int = Int.max) -> Data {
    do {
      let result = try self.read(toByte: byte, upToCount: maximumLength)
      return result == nil ? Data() : result!
    } catch {
      return Data()
    }
  }
}


