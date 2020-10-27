/* *************************************************************************************************
 Data+DataOutputStream.swift
   © 2018-2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation
@_exported import yProtocols

extension DataProtocol {
  @available(swift 5.0)
  @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
  public func write<Target>(to target: inout Target) throws where Target: DataOutputStream {
    try target.write(contentsOf: self)
  }
}

extension MutableDataProtocol {
  @available(swift 5.0)
  @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
  public mutating func write<D>(contentsOf data: D) throws where D: DataProtocol {
    self.append(contentsOf: data)
  }
}

extension Data: DataOutputStream, DataOutputStreamable {}


