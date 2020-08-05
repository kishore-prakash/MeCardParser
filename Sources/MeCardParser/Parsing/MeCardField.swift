//  MeCardField.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

import Foundation

/// A single `KEY:value` entry extracted from a MeCard payload.
///
/// This is the raw, untyped output of the ``MeCardTokenizing`` step; interpreting
/// the semantics of each key is the job of ``MeCardParsing``.
public struct MeCardField: Equatable {

    /// The upper-cased field key (e.g. `N`, `TEL`, `EMAIL`).
    public let key: String

    /// The raw value, with surrounding whitespace trimmed.
    public let value: String

    public init(key: String, value: String) {
        self.key = key
        self.value = value
    }
}
