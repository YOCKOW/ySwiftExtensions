/* *************************************************************************************************
 _test_support.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

internal func _temporaryFileHandle(contents: Data? = nil) throws -> FileHandle {
  func _tmp() -> URL {
    if #available(macOS 10.12, *) {
      return FileManager.default.temporaryDirectory
    } else {
      return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    }
  }
  
  let url = _tmp().appendingPathComponent(UUID().uuidString)
  FileManager.default.createFile(atPath: url.path, contents: contents)
  return try FileHandle(forUpdating: url)
}
