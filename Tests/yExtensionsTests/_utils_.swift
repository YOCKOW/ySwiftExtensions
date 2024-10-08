/* *************************************************************************************************
 _utils_.swift
   © 2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation
import yExtensions

enum _TemporaryFileError: Error {
  case cannotCreateFile
}

func _withTemporaryFileURLAndHandle<T>(
  contents: Data? = nil,
  _ work: (URL, FileHandle) throws -> T
) throws -> T {
  let url = URL.temporaryDirectory.appendingPathComponent(UUID().uuidString)
  guard FileManager.default.createFile(atPath: url.path, contents: contents) else {
    throw _TemporaryFileError.cannotCreateFile
  }
  defer {
    try? FileManager.default.removeItem(at: url)
  }
  let fh = try FileHandle(forUpdating: url)
  defer {
    try? fh.close()
  }
  return try work(url, fh)
}

func _withTemporaryFileHandle<T>(
  contents: Data? = nil,
  _ work: (FileHandle) throws -> T
) throws -> T {
  return try _withTemporaryFileURLAndHandle(contents: contents) { (_, fh) throws -> T in
    return try work(fh)
  }
}
