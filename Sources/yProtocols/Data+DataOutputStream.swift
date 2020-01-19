/* *************************************************************************************************
 Data+DataOutputStream.swift
   © 2018-2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

extension DataProtocol {
  public func write<Target>(to target: inout Target) where Target: DataOutputStream {
    target.write(self)
  }
}

extension MutableDataProtocol {
  public mutating func write<D>(_ data: D) where D: DataProtocol {
    self.append(contentsOf: data)
  }
}

extension Data: DataOutputStream, DataOutputStreamable {}


