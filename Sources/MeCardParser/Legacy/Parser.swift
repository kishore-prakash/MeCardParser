//  Parser.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

#if canImport(Contacts)
import Contacts
import Foundation

/// Backwards-compatible entry point preserved from MeCardParser 1.x.
///
/// New code should prefer composing ``MeCardParser`` with ``MeCardContactMapper``
/// (or use ``MeCardContactBuilder``), which separates parsing from Contacts
/// mapping and is far easier to test.
public enum Parser {

    /// Parses a MeCard string and maps it to a `CNContact`.
    ///
    /// - Parameter data: The full MeCard string, including the `MECARD:` prefix.
    /// - Returns: A `CNContact`, or `nil` if the string is not a valid MeCard.
    @available(*, deprecated, message: "Use MeCardContactBuilder or compose MeCardParser with MeCardContactMapper.")
    public static func parserMeCard(data: String) -> CNContact? {
        MeCardContactBuilder().contact(from: data)
    }
}
#endif
