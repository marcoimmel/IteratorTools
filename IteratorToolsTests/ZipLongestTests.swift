//
//  ZipLongestTests.swift
//  IteratorTools
//
//  Created by Michael Pangburn on 8/25/17.
//  Copyright © 2017 Michael Pangburn. All rights reserved.
//

import XCTest
@testable import IteratorTools


class ZipLongestTests: XCTestCase {

    func testZipLongestMatchingLength() {
        var zipped = zipLongest([1, 2, 3], ["a", "b", "c"], firstFillValue: 0, secondFillValue: "z")
        XCTAssert(zipped.next()! == (1, "a"))
        XCTAssert(zipped.next()! == (2, "b"))
        XCTAssert(zipped.next()! == (3, "c"))
        XCTAssert(zipped.next() == nil)
    }

    func testZipLongestFirstSequenceLonger() {
        var zipped = zipLongest([1, 2, 3, 4], ["a", "b"], firstFillValue: 0, secondFillValue: "z")
        XCTAssert(zipped.next()! == (1, "a"))
        XCTAssert(zipped.next()! == (2, "b"))
        XCTAssert(zipped.next()! == (3, "z"))
        XCTAssert(zipped.next()! == (4, "z"))
        XCTAssert(zipped.next() == nil)
    }

    func testZipLongestSecondSequenceLonger() {
        var zipped = zipLongest([1, 2], ["a", "b", "c", "d"], firstFillValue: 0, secondFillValue: "z")
        XCTAssert(zipped.next()! == (1, "a"))
        XCTAssert(zipped.next()! == (2, "b"))
        XCTAssert(zipped.next()! == (0, "c"))
        XCTAssert(zipped.next()! == (0, "d"))
        XCTAssert(zipped.next() == nil)
    }

    func testZipLongestEmpty() {
        var zipped = zipLongest([], [], firstFillValue: 0, secondFillValue: "a")
        XCTAssert(zipped.next() == nil)
    }
}
