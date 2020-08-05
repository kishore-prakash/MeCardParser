//  MeCardTokenizerTests.swift
//  MeCardParserTests

import XCTest
@testable import MeCardParser

final class MeCardTokenizerTests: XCTestCase {

    private let sut = MeCardTokenizer()

    func testTokenizesSimpleFields() {
        let fields = sut.tokenize("N:Doe,John;TEL:12345")
        XCTAssertEqual(fields, [
            MeCardField(key: "N", value: "Doe,John"),
            MeCardField(key: "TEL", value: "12345")
        ])
    }

    func testUpperCasesAndTrimsKeys() {
        let fields = sut.tokenize(" tel :12345")
        XCTAssertEqual(fields, [MeCardField(key: "TEL", value: "12345")])
    }

    func testKeepsColonsInValue() {
        // The scheme colon in a URL must survive: split on the first colon only.
        let fields = sut.tokenize("URL:https://www.example.com")
        XCTAssertEqual(fields, [MeCardField(key: "URL", value: "https://www.example.com")])
    }

    func testIgnoresEmptySegmentsIncludingTrailingSemicolons() {
        let fields = sut.tokenize("N:Doe;;TEL:12345;;")
        XCTAssertEqual(fields, [
            MeCardField(key: "N", value: "Doe"),
            MeCardField(key: "TEL", value: "12345")
        ])
    }

    func testSkipsSegmentsWithoutColon() {
        let fields = sut.tokenize("garbage;TEL:12345")
        XCTAssertEqual(fields, [MeCardField(key: "TEL", value: "12345")])
    }

    func testSkipsSegmentsWithEmptyKey() {
        let fields = sut.tokenize(":value;TEL:12345")
        XCTAssertEqual(fields, [MeCardField(key: "TEL", value: "12345")])
    }

    func testAllowsEmptyValue() {
        let fields = sut.tokenize("NOTE:;TEL:12345")
        XCTAssertEqual(fields, [
            MeCardField(key: "NOTE", value: ""),
            MeCardField(key: "TEL", value: "12345")
        ])
    }

    func testEmptyPayloadProducesNoFields() {
        XCTAssertTrue(sut.tokenize("").isEmpty)
    }
}
