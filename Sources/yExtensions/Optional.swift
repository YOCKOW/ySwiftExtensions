/* *************************************************************************************************
 Optional.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

extension Optional {
  /// Returns the Boolean value that indicates whether the instance is `none` or not.
  @inlinable
  public var isNil: Bool {
    switch self {
    case .none:
      return true
    default:
      return false
    }
  }
}
