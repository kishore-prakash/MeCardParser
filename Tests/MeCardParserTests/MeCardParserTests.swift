//  MeCardParserTests.swift
//  MeCardParserTests

import XCTest
@testable import MeCardParser

final class MeCardParserTests: XCTestCase {

    private let sut = MeCardParser()

    // MARK: - Prefix / error handling

    func testRejectsInputWithoutPrefix() {
        XCTAssertEqual(sut.parse("N:Doe,John;"), .failure(.missingPrefix))
    }

    func testPrefixIsCaseInsensitive() {
        XCTAssertNoThrow(try sut.parse("mecard:N:Doe,John;").get())
        XCTAssertNoThrow(try sut.parse("MeCard:N:Doe,John;").get())
    }

    func testRejectsPrefixOnlyPayload() {
        XCTAssertEqual(sut.parse("MECARD:"), .failure(.emptyPayload))
    }

    func testRejectsPayloadWithNoRecognizedFields() {
        XCTAssertEqual(sut.parse("MECARD:FOO:bar;BAZ:qux;"), .failure(.emptyPayload))
    }

    // MARK: - Names

    func testParsesFamilyAndGivenName() throws {
        let card = try sut.parse("MECARD:N:Doe,John;").get()
        XCTAssertEqual(card.name, MeCardName(familyName: "Doe", givenName: "John"))
    }

    func testParsesSingleComponentNameAsGivenName() throws {
        let card = try sut.parse("MECARD:N:Madonna;").get()
        XCTAssertEqual(card.name, MeCardName(familyName: nil, givenName: "Madonna"))
    }

    func testParsesPhoneticName() throws {
        let card = try sut.parse("MECARD:SOUND:Doe,John;").get()
        XCTAssertEqual(card.phoneticName, MeCardName(familyName: "Doe", givenName: "John"))
    }

    // MARK: - Phone numbers

    func testCollectsMultiplePhoneNumbersInOrderWithKinds() throws {
        let card = try sut.parse("MECARD:TEL:111;TEL-AV:222;TEL:333;").get()
        XCTAssertEqual(card.phoneNumbers, [
            MeCardPhoneNumber(value: "111", kind: .voice),
            MeCardPhoneNumber(value: "222", kind: .videophone),
            MeCardPhoneNumber(value: "333", kind: .voice)
        ])
    }

    // MARK: - Emails and URLs

    func testCollectsMultipleEmailsAndUrls() throws {
        let card = try sut.parse(
            "MECARD:EMAIL:a@x.com;EMAIL:b@x.com;URL:https://x.com;"
        ).get()
        XCTAssertEqual(card.emailAddresses, ["a@x.com", "b@x.com"])
        XCTAssertEqual(card.urls, ["https://x.com"])
    }

    // MARK: - Address

    func testParsesAddressComponents() throws {
        let raw = "MECARD:ADR:No. 56/1094,8th Main,Vijayanagar,Bangalore,Karnataka,560040,India;"
        let card = try sut.parse(raw).get()
        XCTAssertEqual(card.addresses, [
            MeCardAddress(
                street: "No. 56/1094, 8th Main, Vijayanagar",
                city: "Bangalore",
                region: "Karnataka",
                postalCode: "560040",
                country: "India"
            )
        ])
    }

    func testParsesPartialAddress() throws {
        let card = try sut.parse("MECARD:ADR:1 Main St,,,Springfield;").get()
        XCTAssertEqual(card.addresses, [
            MeCardAddress(street: "1 Main St", city: "Springfield")
        ])
    }

    // MARK: - Birthday

    func testParsesValidBirthday() throws {
        let card = try sut.parse("MECARD:BDAY:20100811;").get()
        XCTAssertEqual(card.birthday?.year, 2010)
        XCTAssertEqual(card.birthday?.month, 8)
        XCTAssertEqual(card.birthday?.day, 11)
    }

    func testIgnoresMalformedBirthday() throws {
        let card = try sut.parse("MECARD:BDAY:2010;NICKNAME:Nick;").get()
        XCTAssertNil(card.birthday)
    }

    func testIgnoresNonDateBirthday() throws {
        let card = try sut.parse("MECARD:BDAY:notadate;NICKNAME:Nick;").get()
        XCTAssertNil(card.birthday)
    }

    // MARK: - Nickname / note

    func testParsesNicknameAndNote() throws {
        let card = try sut.parse("MECARD:NICKNAME:JD;NOTE:Met at WWDC;").get()
        XCTAssertEqual(card.nickname, "JD")
        XCTAssertEqual(card.note, "Met at WWDC")
    }

    // MARK: - Full payload

    func testParsesFullRepresentativePayload() throws {
        let raw = "MECARD:N:Doe,John;SOUND:Doe,John;TEL:555-555-5555;EMAIL:email@example.com;" +
            "NOTE:Contoso;BDAY:20100811;ADR:No. 56/1094,8th Main,Vijayanagar;" +
            "URL:https://www.example.com;NICKNAME:Nickname;"
        let card = try sut.parse(raw).get()

        XCTAssertEqual(card.name, MeCardName(familyName: "Doe", givenName: "John"))
        XCTAssertEqual(card.phoneticName, MeCardName(familyName: "Doe", givenName: "John"))
        XCTAssertEqual(card.phoneNumbers, [MeCardPhoneNumber(value: "555-555-5555")])
        XCTAssertEqual(card.emailAddresses, ["email@example.com"])
        XCTAssertEqual(card.note, "Contoso")
        XCTAssertEqual(card.urls, ["https://www.example.com"])
        XCTAssertEqual(card.nickname, "Nickname")
        XCTAssertEqual(card.addresses.first?.street, "No. 56/1094, 8th Main, Vijayanagar")
        XCTAssertEqual(card.birthday?.year, 2010)
    }
}
