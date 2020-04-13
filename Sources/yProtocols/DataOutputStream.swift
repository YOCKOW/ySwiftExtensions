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
  mutating func write<D>(_ data: D) where D: DataProtocol
}

/// Similar with `TextOutputStreamable`.
public protocol DataOutputStreamable {
  /// Writes a data representation of this instance into the given output stream.
  func write<Target>(to target: inout Target) where Target: DataOutputStream
}
