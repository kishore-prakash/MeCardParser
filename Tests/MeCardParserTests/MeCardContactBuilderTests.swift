//  MeCardContactBuilderTests.swift
//  MeCardParserTests

#if canImport(Contacts)
import XCTest
import Contacts
@testable import MeCardParser

final class MeCardContactBuilderTests: XCTestCase {

    func testBuildsContactFromValidString() {
        let contact = MeCardContactBuilder().contact(from: "MECARD:N:Doe,John;TEL:12345;")
        XCTAssertEqual(contact?.familyName, "Doe")
        XCTAssertEqual(contact?.givenName, "John")
        XCTAssertEqual(contact?.phoneNumbers.first?.value.stringValue, "12345")
    }

    func testReturnsNilForInvalidString() {
        XCTAssertNil(MeCardContactBuilder().contact(from: "not a mecard"))
    }

    func testMakeContactSurfacesError() {
        let result = MeCardContactBuilder().makeContact(from: "not a mecard")
        XCTAssertEqual(result.mapError { $0 }.error, .missingPrefix)
    }

    func testInjectedDependenciesAreUsed() {
        // A stub parser proves the builder depends on the abstraction, not the
        // concrete parser.
        let stub = StubParser(result: .success(MeCard(nickname: "stubbed")))
        let contact = MeCardContactBuilder(parser: stub).contact(from: "anything")
        XCTAssertEqual(contact?.nickname, "stubbed")
    }

    // MARK: - Legacy facade

    func testLegacyParserStillWorks() {
        let contact = Parser.parserMeCard(data: "MECARD:N:Doe,John;")
        XCTAssertEqual(contact?.familyName, "Doe")
    }
}

// MARK: - Test doubles

private struct StubParser: MeCardParsing {
    let result: Result<MeCard, MeCardParsingError>
    func parse(_ raw: String) -> Result<MeCard, MeCardParsingError> { result }
}

private extension Result {
    var error: Failure? {
        if case .failure(let error) = self { return error }
        return nil
    }
}
#endif
