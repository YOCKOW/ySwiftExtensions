/* *************************************************************************************************
 Data+LosslessDataConvertible.swift
   © 2020,2024 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import Foundation
@_exported import yProtocols

extension Foundation.Data: yProtocols.LosslessDataConvertible {
  public var dataRepresentation: Data {
    return self
  }

  public init<D>(contentsOf dataRepresentation: D) where D: DataProtocol {
    if case let data as Data = dataRepresentation {
      self = data
    } else {
      self.init(dataRepresentation)
    }
  }
}
