/* *************************************************************************************************
 String+LosslessDataConvertible.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation
@_exported import yProtocols

extension Swift.String: yProtocols.LosslessDataConvertible {
  public var dataRepresentation: Data {
    return Data(self.utf8)
  }

  public init?<D>(contentsOf dataRepresentation: D) where D: DataProtocol {
    self.init(data: Data(dataRepresentation), encoding: .utf8)
  }
}
