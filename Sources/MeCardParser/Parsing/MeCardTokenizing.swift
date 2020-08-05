//  MeCardTokenizing.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

import Foundation

/// Splits a raw MeCard payload (the text after the `MECARD:` prefix) into its
/// individual ``MeCardField`` entries.
///
/// This is a seam in the architecture: `MeCardParser` depends on the protocol,
/// not the concrete implementation, so tokenizing can be tested in isolation
/// and swapped out (e.g. for a stricter, spec-compliant tokenizer) without
/// touching the field-interpretation logic.
public protocol MeCardTokenizing {
    /// - Parameter payload: The MeCard body, i.e. everything after `MECARD:`.
    /// - Returns: The recognized `KEY:value` fields, in order of appearance.
    func tokenize(_ payload: String) -> [MeCardField]
}

/// The default tokenizer.
///
/// Fields are separated by `;`. Within a field, the key and value are separated
/// by the *first* `:` only — so a value such as `https://example.com` keeps its
/// scheme colon intact, which the original implementation had to special-case.
public struct MeCardTokenizer: MeCardTokenizing {

    public init() {}

    public func tokenize(_ payload: String) -> [MeCardField] {
        payload
            .split(separator: ";", omittingEmptySubsequences: true)
            .compactMap { Self.field(from: $0) }
    }

    private static func field(from segment: Substring) -> MeCardField? {
        guard let separatorIndex = segment.firstIndex(of: ":") else {
            return nil
        }

        let key = segment[..<separatorIndex]
            .trimmingCharacters(in: .whitespaces)
            .uppercased()
        guard !key.isEmpty else { return nil }

        let valueStart = segment.index(after: separatorIndex)
        let value = segment[valueStart...].trimmingCharacters(in: .whitespaces)

        return MeCardField(key: key, value: value)
    }
}
