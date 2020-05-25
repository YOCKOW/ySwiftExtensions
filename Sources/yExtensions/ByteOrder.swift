/* *************************************************************************************************
 ByteOrder.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */
 
import CoreFoundation

/// Represents "endianness".
public enum ByteOrder {
  case unknown
  case littleEndian
  case bigEndian
  
  public init(_ byteOrder: __CFByteOrder) {
    switch byteOrder {
    case CFByteOrderUnknown:
      self = .unknown
    case CFByteOrderLittleEndian:
      self = .littleEndian
    case CFByteOrderBigEndian:
      self = .bigEndian
    default:
      fatalError("Unsupported Byte Order.")
    }
  }
  
  public init(_ byteOrder: CFByteOrder) {
    self.init(__CFByteOrder(rawValue: UInt32(byteOrder)))
  }
  
  public static let current = ByteOrder(CFByteOrderGetCurrent())
}
