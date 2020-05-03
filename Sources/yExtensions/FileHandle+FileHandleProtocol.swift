/* *************************************************************************************************
 FileHandle+FileHandleProtocol.swift
   © 2017-2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation
import yProtocols

@available(swift 5.0)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension FileHandle: FileHandleProtocol {
  public func write(string: String, using encoding: String.Encoding, allowLossyConversion: Bool) throws {
    enum _Error: Error { case dataConversionFailed }
    guard let data = string.data(using: encoding, allowLossyConversion: allowLossyConversion) else {
      throw _Error.dataConversionFailed
    }
    try self.write(contentsOf: data)
  }
}

// Workaround for https://bugs.swift.org/browse/SR-11922
#if !canImport(ObjectiveC) && swift(<5.3)
extension FileHandle {
  public func truncate(atOffset offset: UInt64) throws {
    try self.truncate(toOffset: offset)
  }
}
#endif

private func _warn<Target>(items: [Any], separator: String, terminator: String, to output: inout Target) where Target: TextOutputStream {
  // There's a bug related to "print" in Swift 5.0 on Linux.
  #if os(Linux) && compiler(>=5.0) && compiler(<5.1)
  let string = items.map{ String(describing: $0) }.joined(separator: separator) + terminator
  output.write(string)
  #else
  let numberOfItems = items.count
  switch numberOfItems {
  case 0:
    print("", separator: separator, terminator: terminator, to: &output)
  case 1:
    print(items[0], separator: separator, terminator: terminator, to: &output)
  default:
    for ii in 0..<(numberOfItems - 1) {
      print(items[ii], separator, separator:"", terminator:"", to: &output)
    }
    print(items.last!, separator:"", terminator: terminator, to: &output)
  }
  #endif
}

/// Writes the textual representations of the given items into the given output stream.
///
/// You are supposed to use `warn(_:separator:terminator:)` instead of this.
/// This function is for the purpose of debug.
public func warn<Target>(_ items: Any..., separator: String = " ", terminator: String = "\n", to output: inout Target) where Target: TextOutputStream {
  _warn(items: items, separator: separator, terminator: terminator, to: &output)
}


/// Print objects to standard error
public func warn(_ items: Any..., separator: String = " ", terminator: String = "\n") {
  var stderr = AnyFileHandle.standardError
  _warn(items: items, separator: separator, terminator: terminator, to: &stderr)
}


