//  MeCardContactMapperTests.swift
//  MeCardParserTests

#if canImport(Contacts)
import XCTest
import Contacts
@testable import MeCardParser

final class MeCardContactMapperTests: XCTestCase {

    private let sut = MeCardContactMapper()

    func testMapsName() {
        let contact = sut.contact(from: MeCard(name: MeCardName(familyName: "Doe", givenName: "John")))
        XCTAssertEqual(contact.familyName, "Doe")
        XCTAssertEqual(contact.givenName, "John")
    }

    func testMapsPhoneticName() {
        let contact = sut.contact(from: MeCard(phoneticName: MeCardName(familyName: "Doe", givenName: "John")))
        XCTAssertEqual(contact.phoneticFamilyName, "Doe")
        XCTAssertEqual(contact.phoneticGivenName, "John")
    }

    func testMapsPhoneNumbersWithLabels() {
        let contact = sut.contact(from: MeCard(phoneNumbers: [
            MeCardPhoneNumber(value: "111", kind: .voice),
            MeCardPhoneNumber(value: "222", kind: .videophone)
        ]))
        XCTAssertEqual(contact.phoneNumbers.count, 2)
        XCTAssertEqual(contact.phoneNumbers[0].label, CNLabelHome)
        XCTAssertEqual(contact.phoneNumbers[0].value.stringValue, "111")
        XCTAssertEqual(contact.phoneNumbers[1].label, CNLabelOther)
        XCTAssertEqual(contact.phoneNumbers[1].value.stringValue, "222")
    }

    func testMapsEmailsAndUrls() {
        let contact = sut.contact(from: MeCard(
            emailAddresses: ["a@x.com", "b@x.com"],
            urls: ["https://x.com"]
        ))
        XCTAssertEqual(contact.emailAddresses.map { $0.value as String }, ["a@x.com", "b@x.com"])
        XCTAssertEqual(contact.urlAddresses.map { $0.value as String }, ["https://x.com"])
    }

    func testMapsPostalAddress() {
        let contact = sut.contact(from: MeCard(addresses: [
            MeCardAddress(street: "1 Main St", city: "Springfield", postalCode: "12345", country: "USA")
        ]))
        let postal = contact.postalAddresses.first?.value
        XCTAssertEqual(postal?.street, "1 Main St")
        XCTAssertEqual(postal?.city, "Springfield")
        XCTAssertEqual(postal?.postalCode, "12345")
        XCTAssertEqual(postal?.country, "USA")
    }

    func testMapsBirthday() {
        var components = DateComponents()
        components.year = 2010
        components.month = 8
        components.day = 11
        let contact = sut.contact(from: MeCard(birthday: components))
        XCTAssertEqual(contact.birthday?.year, 2010)
        XCTAssertEqual(contact.birthday?.month, 8)
        XCTAssertEqual(contact.birthday?.day, 11)
    }

    func testMapsNickname() {
        let contact = sut.contact(from: MeCard(nickname: "JD"))
        XCTAssertEqual(contact.nickname, "JD")
    }

    func testEmptyCardMapsToEmptyContact() {
        let contact = sut.contact(from: MeCard())
        XCTAssertEqual(contact.givenName, "")
        XCTAssertTrue(contact.phoneNumbers.isEmpty)
        XCTAssertTrue(contact.emailAddresses.isEmpty)
        XCTAssertTrue(contact.postalAddresses.isEmpty)
    }
}
#endif
