/* *************************************************************************************************
 URL+LocalFiles.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

extension URL {
  /// URL for the temporary directory.
  /// On Darwin, it is for the current user.
  @available(macOS, obsoleted: 13.0, message: "Use vendor extension.")
  @available(iOS, obsoleted: 16.0, message: "Use vendor extension.")
  @available(tvOS, obsoleted: 16.0, message: "Use vendor extension.")
  @available(watchOS, obsoleted: 9.0, message: "Use vendor extension.")
  public static var temporaryDirectory: URL {
    #if swift(>=4.1) || canImport(ObjectiveC)
    if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
      return FileManager.default.temporaryDirectory
    }
    #endif
    return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
  }
}

extension FileManager {
  /// Returns whether file exists at `url` and is directory.
  /// Returns `nil` if `url` is not a file URL.
  fileprivate func _fileExists(at url: URL) -> (exists: Bool, isDirectory: Bool)? {
    guard url.isFileURL else { return nil }
    
    var isDir: ObjCBool = false
    guard self.fileExists(atPath: url.path, isDirectory: &isDir) else {
      return (false, false)
    }
    
    #if swift(>=4.1) || !os(Linux)
    return (true, isDir.boolValue)
    #else
    return (true, Bool(isDir))
    #endif
  }
}


extension URL {
  /// Returns `true` if the file that the receiver represents exists and is a directory.
  public var isExistingLocalDirectory: Bool {
    guard let result = FileManager.default._fileExists(at: self) else { return false }
    return result.exists && result.isDirectory
  }
  
  /// Returns `true` if the file that the receiver represents exists and is not a directory.
  public var isExistingLocalFile: Bool {
    guard let result = FileManager.default._fileExists(at: self) else { return false }
    return result.exists && !result.isDirectory
  }
}

