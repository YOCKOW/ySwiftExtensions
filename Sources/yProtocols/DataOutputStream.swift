/* *************************************************************************************************
 DataOutputStream.swift
   © 2018-2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

/// Similar with `TextOutputStream`.
/// An instance of `Data` is given to the stream.
public protocol DataOutputStream {
  /// Appends the given data to the stream.
  @available(*, deprecated, renamed: "write(contentsOf:)")
  mutating func write<D>(_ data: D) where D: DataProtocol
  
  /// Appends the given data to the stream.
  mutating func write<D>(contentsOf data: D) throws where D: DataProtocol
}



/// Similar with `TextOutputStreamable`.
public protocol DataOutputStreamable {
  /// Writes a data representation of this instance into the given output stream.
  func write<Target>(to target: inout Target) throws where Target: DataOutputStream
}

extension DataOutputStream {
  public mutating func write<D>(_ data: D) where D: DataProtocol {
    try! self.write(contentsOf: data)
  }
}

extension DataOutputStreamable where Self: DataProtocol {
  public func write<Target>(to target: inout Target) throws where Target: DataOutputStream {
    try target.write(contentsOf: self)
  }
}
