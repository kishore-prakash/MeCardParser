//  MeCardParsing.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

import Foundation

/// Parses a raw MeCard string into the domain model ``MeCard``.
///
/// Consumers should depend on this protocol rather than the concrete
/// ``MeCardParser`` so that alternative implementations and test doubles can be
/// substituted freely.
public protocol MeCardParsing {
    /// Parses `raw` into a ``MeCard``.
    ///
    /// - Parameter raw: The full MeCard string, including the `MECARD:` prefix.
    /// - Returns: `.success` with the parsed card, or `.failure` describing why
    ///   the input could not be parsed.
    func parse(_ raw: String) -> Result<MeCard, MeCardParsingError>
}
