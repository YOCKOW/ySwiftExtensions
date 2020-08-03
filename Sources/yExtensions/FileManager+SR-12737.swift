/* *************************************************************************************************
 FileManager+SR-12737.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

private let _directoryCreationQue = DispatchQueue(
  label: "jp.YOCKOW.ySwiftExtensions.FileManager.directoryCreation",
  qos: .background
)

extension FileManager {
  /// Workaround for [SR-12737](https://bugs.swift.org/browse/SR-12737).
  /// Creates a directory with the given attributes at the specified URL,
  /// creating also intermediate directories.
  public func createDirectoryWithIntermediateDirectories(at url: URL,
                                                         attributes: [FileAttributeKey: Any]? = nil) throws {
    func __create(at url: URL) throws {
      #if !canImport(ObjectiveC) && compiler(<5.3)
      if url.isExistingLocalDirectory {
        return
      }
      let parent = url.standardizedFileURL.deletingLastPathComponent()
      if !parent.isExistingLocalDirectory {
        try __create(at: parent)
      }
      #endif
      try self.createDirectory(at: url, withIntermediateDirectories: true, attributes: attributes)
    }
    
    try _directoryCreationQue.sync {
      try __create(at: url)
    }
  }
}
