//  MeCardContactBuilder.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

#if canImport(Contacts)
import Contacts

/// A convenience facade that parses a MeCard string and maps the result to a
/// `CNContact` in one call.
///
/// It wires together a ``MeCardParsing`` and a ``MeCardContactMapping``; both
/// dependencies are injectable so the composition can be tested and customized.
public struct MeCardContactBuilder {

    private let parser: MeCardParsing
    private let mapper: MeCardContactMapping

    public init(
        parser: MeCardParsing = MeCardParser(),
        mapper: MeCardContactMapping = MeCardContactMapper()
    ) {
        self.parser = parser
        self.mapper = mapper
    }

    /// Parses `raw` and maps it to a `CNContact`.
    ///
    /// - Returns: The mapped contact, or `nil` if `raw` is not a valid MeCard.
    public func contact(from raw: String) -> CNContact? {
        guard case .success(let meCard) = parser.parse(raw) else {
            return nil
        }
        return mapper.contact(from: meCard)
    }

    /// Parses `raw` and maps it to a `CNContact`, surfacing parsing errors.
    ///
    /// - Returns: `.success` with the mapped contact, or `.failure` describing
    ///   why the string could not be parsed.
    public func makeContact(from raw: String) -> Result<CNContact, MeCardParsingError> {
        parser.parse(raw).map(mapper.contact(from:))
    }
}
#endif
