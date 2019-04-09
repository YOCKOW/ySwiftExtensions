/* *************************************************************************************************
 FileHandle+TextOutputStream.swift
   © 2017-2019 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

extension FileHandle: TextOutputStream {
  /// Appends `string` using `encoding` to the stream.
  public func write(_ string:String, using encoding:String.Encoding) {
    self.write(string.data(using:encoding)!)
  }
  
  /// Write `string` using UTF-8 encoding to the receiver.
  public func write(_ string:String) {
    self.write(string, using:.utf8)
  }
}

extension FileHandle {
  internal static var _changeableStandardError: FileHandle = .standardError
}

/// Print objects to standard error
public func warn(_ items: Any..., separator: String = " ", terminator: String = "\n") {
  let string = items.map{ String(describing:$0) }.joined(separator:separator) + terminator
  
  // There's a bug related to "print" in Swift 5.0 on Linux.
  #if os(Linux) && compiler(>=5.0) && compiler(<5.1)
  string.utf8CString.withUnsafeBytes {
    _ = write(FileHandle._changeableStandardError.fileDescriptor, $0.baseAddress, $0.count - 1)
  }
  #else
  print(string, separator:"", terminator:"", to:&FileHandle._changeableStandardError)
  #endif
}

