/* *************************************************************************************************
 StringProtocol+Count.swift
   © 2020 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import Foundation

extension StringProtocol {
  /// Compare the number of characters of `self` with `target`.
  ///
  /// - Returns:
  ///   `.orderedAscending` if the number of characters of `self` is less than `target`,
  ///   `.orderedDescending` if the number of characters of `self` is greater than `target`, or
  ///   `.orderedSame` if the number of characters of `self` is equal to `target`.
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
