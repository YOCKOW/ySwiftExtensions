/* *************************************************************************************************
 OptionalTests.swift
   © 2026 YOCKOW.
     Licensed under MIT License.
     See "LICENSE.txt" for more information.
 ************************************************************************************************ */

import yExtensions
import Testing

@Suite struct OptionalTests {
  @Test func test_isNil() {
    #expect(Int("hoge").isNil)
    #expect(!Int("1").isNil)
  }
}
