/* *************************************************************************************************
 FileManager+SR-12737.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

extension FileManager {
  /// Workaround for [SR-12737](https://bugs.swift.org/browse/SR-12737).
  /// Creates a directory with the given attributes at the specified URL,
  /// creating also intermediate directories.
  public func createDirectoryWithIntermediateDirectories(at url: URL,
                                                         attributes: [FileAttributeKey: Any]? = nil) throws {
    
    #if !canImport(ObjectiveC)
    func __createParentDirectory(of url: URL) throws {
      try self.createDirectoryWithIntermediateDirectories(
        at: url.standardizedFileURL.deletingLastPathComponent(), attributes: attributes
      )
    }
    
    if url.isExistingLocalDirectory {
      return
    } else {
      try __createParentDirectory(of: url)
    }
    #endif
    try self.createDirectory(at: url, withIntermediateDirectories: true, attributes: attributes)
  }
}
