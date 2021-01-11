/* *************************************************************************************************
 Collection+Count.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

extension Collection {
  /// Compare the number of elements of `self` with `target`.
  ///
  /// - Returns:
  ///   `.orderedAscending` if the number of elements of `self` is less than `target`,
  ///   `.orderedDescending` if the number of elements of `self` is greater than `target`, or
  ///   `.orderedSame` if the number of elements of `self` is equal to `target`.
  ///
  /// - Complexity: O(*n*) where *n* is the smaller of `self.count` and `target`.
  public func compareCount(with target: Int) -> ComparisonResult {
    if target < 0 {
      return .orderedDescending
    }

    var countNow = 0
    for _  in self {
      countNow += 1
      if countNow > target {
        return .orderedDescending
      }
    }
    assert(countNow <= target)
    return countNow == target ? .orderedSame : .orderedAscending
  }
}

extension RandomAccessCollection {
  /// Compare the number of elements of `self` with `target`.
  ///
  /// - Returns:
  ///   `.orderedAscending` if the number of elements of `self` is less than `target`,
  ///   `.orderedDescending` if the number of elements of `self` is greater than `target`, or
  ///   `.orderedSame` if the number of elements of `self` is equal to `target`.
  ///
  /// - Complexity: O(*1*)
  public func compareCount(with target: Int) -> ComparisonResult {
    let count = self.count
    return count == target ? .orderedSame : count < target ? .orderedAscending : .orderedDescending
  }
}
