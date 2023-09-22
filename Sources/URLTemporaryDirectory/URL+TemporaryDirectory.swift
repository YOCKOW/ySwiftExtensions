/* *************************************************************************************************
 URL+TemporaryDirectory.swift
   © 2020,2023 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

extension URL {
  /// URL for the temporary directory.
  /// On Darwin, it is for the current user.
  public static var temporaryDirectory: URL {
    #if swift(>=4.1) || canImport(ObjectiveC)
    if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
      return FileManager.default.temporaryDirectory
    }
    #endif
    return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
  }
}
