import XCTest

import yExtensionsTests
import yProtocolsTests

var tests = [XCTestCaseEntry]()
tests += yExtensionsTests.__allTests()
tests += yProtocolsTests.__allTests()

XCTMain(tests)
