/* *************************************************************************************************
 KeyPath+Predicate.swift
   © 2023 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

extension KeyPath where Value == Bool {
  /// Performs a logical OR operation regarding both key-paths as Boolean values.
  public static func ||(lhs: KeyPath<Root, Bool>, rhs: KeyPath<Root, Bool>) -> (Root) -> Bool {
    return { $0[keyPath: lhs] || $0[keyPath: rhs] }
  }

  /// Performs a logical AND operation regarding both key-paths as Boolean values.
  public static func &&(lhs: KeyPath<Root, Bool>, rhs: KeyPath<Root, Bool>) -> (Root) -> Bool {
    return { $0[keyPath: lhs] && $0[keyPath: rhs] }
  }
}
