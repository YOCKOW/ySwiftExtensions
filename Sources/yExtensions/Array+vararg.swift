/* *************************************************************************************************
 Array+vararg.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

extension Array {
  /// The array is passed to the given function as a variable-length argument.
  ///
  /// - Note:
  ///    This function internally calls `unsafeBitcast`.
  ///    It may not work in the future Swift release.
  @inlinable
  public func pass<T>(to varargFunction: @escaping (Element...) -> T) -> T {
    let convertedFunction = unsafeBitCast(varargFunction, to: ((Self) -> T).self)
    return convertedFunction(self)
  }
}
