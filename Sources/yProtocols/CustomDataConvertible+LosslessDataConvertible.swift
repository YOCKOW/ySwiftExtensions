/* *************************************************************************************************
 CustomDataConvertible+LosslessDataConvertible.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

/// A type with a customized data representation.
public protocol CustomDataConvertible {
  /// A data representation of this instance.
  var dataRepresentation: Data { get }
}

/// A type that can be represented as a data in a lossless, unambiguous way.
public protocol LosslessDataConvertible: CustomDataConvertible {
  /// Instantiates an instance of the conforming type from a data representation.
  init?<D>(contentsOf dataRepresentation: D) where D: DataProtocol
}
