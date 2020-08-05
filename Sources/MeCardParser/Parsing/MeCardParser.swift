//  MeCardParser.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

import Foundation

/// The default ``MeCardParsing`` implementation.
///
/// It is deliberately framework-free: the output is a pure ``MeCard`` value,
/// which an adapter such as `MeCardContactMapper` can then translate into a
/// `CNContact`. This separation is what makes the parsing logic fully
/// unit-testable without the `Contacts` framework.
public struct MeCardParser: MeCardParsing {

    /// The prefix that identifies a MeCard payload (matched case-insensitively).
    public static let prefix = "MECARD:"

    private let tokenizer: MeCardTokenizing

    /// - Parameter tokenizer: The tokenizer used to split the payload into
    ///   fields. Injectable for testing; defaults to ``MeCardTokenizer``.
    public init(tokenizer: MeCardTokenizing = MeCardTokenizer()) {
        self.tokenizer = tokenizer
    }

    public func parse(_ raw: String) -> Result<MeCard, MeCardParsingError> {
        guard let payload = Self.strippingPrefix(from: raw) else {
            return .failure(.missingPrefix)
        }

        let fields = tokenizer.tokenize(payload)
        guard !fields.isEmpty else {
            return .failure(.emptyPayload)
        }

        var card = MeCard()
        for field in fields {
            apply(field, to: &card)
        }

        guard !card.isEmpty else {
            return .failure(.emptyPayload)
        }
        return .success(card)
    }

    // MARK: - Prefix handling

    private static func strippingPrefix(from raw: String) -> String? {
        guard raw.count >= prefix.count,
              raw.prefix(prefix.count).uppercased() == prefix else {
            return nil
        }
        return String(raw.dropFirst(prefix.count))
    }

    // MARK: - Field interpretation

    private func apply(_ field: MeCardField, to card: inout MeCard) {
        guard !field.value.isEmpty, let key = MeCardFieldKey(rawValue: field.key) else {
            return
        }

        switch key {
        case .name:
            card.name = Self.parseName(field.value)
        case .sound:
            card.phoneticName = Self.parseName(field.value)
        case .telephone:
            card.phoneNumbers.append(MeCardPhoneNumber(value: field.value, kind: .voice))
        case .videophone:
            card.phoneNumbers.append(MeCardPhoneNumber(value: field.value, kind: .videophone))
        case .email:
            card.emailAddresses.append(field.value)
        case .url:
            card.urls.append(field.value)
        case .address:
            card.addresses.append(Self.parseAddress(field.value))
        case .birthday:
            if let birthday = Self.parseBirthday(field.value) {
                card.birthday = birthday
            }
        case .nickname:
            card.nickname = field.value
        case .note:
            card.note = field.value
        }
    }

    /// Parses a `family,given` name. A single component is treated as the
    /// given name.
    static func parseName(_ value: String) -> MeCardName {
        let components = value
            .split(separator: ",", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespaces) }

        switch components.count {
        case 0:
            return MeCardName()
        case 1:
            return MeCardName(familyName: nil, givenName: nonEmpty(components[0]))
        default:
            return MeCardName(
                familyName: nonEmpty(components[0]),
                givenName: nonEmpty(components[1])
            )
        }
    }

    /// Parses a comma-separated `ADR` value. Following the original layout, the
    /// first three components are joined into the street; the remainder map onto
    /// city, region, postal code and country.
    static func parseAddress(_ value: String) -> MeCardAddress {
        let components = value
            .split(separator: ",", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespaces) }

        var address = MeCardAddress()
        var streetParts: [String] = []

        for (index, component) in components.enumerated() {
            switch index {
            case 0, 1, 2:
                if !component.isEmpty { streetParts.append(component) }
            case 3:
                address.city = nonEmpty(component)
            case 4:
                address.region = nonEmpty(component)
            case 5:
                address.postalCode = nonEmpty(component)
            case 6:
                address.country = nonEmpty(component)
            default:
                break
            }
        }

        address.street = streetParts.isEmpty ? nil : streetParts.joined(separator: ", ")
        return address
    }

    /// Parses a `yyyyMMdd` birthday into year/month/day components.
    static func parseBirthday(_ value: String) -> DateComponents? {
        guard value.count == 8 else { return nil }

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyyMMdd"

        guard let date = formatter.date(from: value) else { return nil }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar.dateComponents([.year, .month, .day], from: date)
    }

    private static func nonEmpty(_ string: String) -> String? {
        string.isEmpty ? nil : string
    }
}
