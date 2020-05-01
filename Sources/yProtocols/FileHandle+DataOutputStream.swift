/* *************************************************************************************************
 FileHandle+DataOutputStream.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

@available(swift 5.0)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileHandle: FileHandleProtocol {}

// Workaround for https://bugs.swift.org/browse/SR-11922
#if !canImport(ObjectiveC) && swift(<5.3)
extension FileHandle {
  public func truncate(atOffset offset: UInt64) throws {
    try self.truncate(toOffset: offset)
  }
}
#endif
