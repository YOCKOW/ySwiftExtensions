/* *************************************************************************************************
 BidirectionalCollection+Trimming.swift
   © 2023 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import UnicodeSupplement

extension BidirectionalCollection {
  /// Returns a new collection of the same type by removing prefix and suffix.
  public func trimming(where predicate: (Element) throws -> Bool) rethrows -> SubSequence {
    guard let fisrtIndex = try self.firstIndex(where: { try !predicate($0) }),
          let lastIndex = try self.lastIndex(where: { try !predicate($0) }) else {
      return self[startIndex..<startIndex]
    }
    return self[fisrtIndex...lastIndex]
  }
}

extension StringProtocol {
  public func trimmingCharacters(where predicate: (Character) throws -> Bool) rethrows -> SubSequence {
    return try self.trimming(where: predicate)
  }

  /// Returns a new string by removing specified `Unicode.Scalar`s.
  /// As a result, some `Character`s in the string may be degenerates.
  public func trimmingUnicodeScalars(where predicate: (Unicode.Scalar) throws -> Bool) rethrows -> String {
    return try String(String.UnicodeScalarView(self.unicodeScalars.trimming(where: predicate)))
  }

  public func trimmingUnicodeScalars(where keypath: KeyPath<Unicode.Scalar.LatestProperties, Bool>) -> String {
    return trimmingUnicodeScalars(where: { $0.latestProperties[keyPath: keypath] })
  }
}
