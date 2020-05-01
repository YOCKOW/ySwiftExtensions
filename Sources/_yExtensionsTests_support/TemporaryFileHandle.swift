/* *************************************************************************************************
 TemporaryFileHandle.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

private var _fileHandles: [(url: URL, fileHandle: FileHandle)] = []

private func _closeAllFileHandles() {
  for (url, fh) in _fileHandles {
    do {
      if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
        try fh.close()
      } else {
        fh.closeFile()
      }
      try FileManager.default.removeItem(at: url)
    } catch {
      
    }
  }
}
private var _registered: Bool = false
private func _register(url: URL, fileHandle: FileHandle) {
  if !_registered {
    atexit(_closeAllFileHandles)
    _registered = true
  }
  _fileHandles.append((url: url, fileHandle: fileHandle))
}

public func _temporaryFileHandle(contents: Data? = nil) throws -> FileHandle {
  func _tmp() -> URL {
    if #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
      return FileManager.default.temporaryDirectory
    } else {
      return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    }
  }
  
  let url = _tmp().appendingPathComponent(UUID().uuidString)
  FileManager.default.createFile(atPath: url.path, contents: contents)
  let fh = try FileHandle(forUpdating: url)
  _register(url: url, fileHandle: fh)
  return fh
}
