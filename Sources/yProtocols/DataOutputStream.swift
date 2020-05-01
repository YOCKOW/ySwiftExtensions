/* *************************************************************************************************
 DataOutputStream.swift
   © 2018-2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

/// Similar with `TextOutputStream`.
/// An instance of `Data` is given to the stream.
@available(swift 5.0)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public protocol DataOutputStream {
  /// Appends the given data to the stream.
  @available(*, deprecated, renamed: "write(contentsOf:)")
  mutating func write<D>(_ data: D) where D: DataProtocol
  
  mutating func write<D>(contentsOf data: D) throws where D: DataProtocol
}

@available(swift 5.0)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension DataOutputStream {
  public mutating func write<D>(_ data: D) where D: DataProtocol {
    try! self.write(contentsOf: data)
  }
}

/// Similar with `TextOutputStreamable`.
@available(swift 5.0)
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public protocol DataOutputStreamable {
  /// Writes a data representation of this instance into the given output stream.
  func write<Target>(to target: inout Target) throws where Target: DataOutputStream
}
