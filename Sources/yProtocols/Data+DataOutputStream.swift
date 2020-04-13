/* *************************************************************************************************
 Data+DataOutputStream.swift
   © 2018-2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation

extension MutableDataProtocol {
  public mutating func write<D>(contentsOf data: D) throws where D: DataProtocol {
    self.append(contentsOf: data)
  }
}

extension Data: DataOutputStream, DataOutputStreamable {}


