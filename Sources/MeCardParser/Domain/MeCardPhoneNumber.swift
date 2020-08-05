//  MeCardPhoneNumber.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

import Foundation

/// A phone number together with the kind of line it represents.
public struct MeCardPhoneNumber: Equatable {

    /// The kind of telephone line, derived from the MeCard field key.
    public enum Kind: Equatable {
        /// A standard voice line (`TEL`).
        case voice
        /// A videophone line (`TEL-AV`).
        case videophone
    }

    public var value: String
    public var kind: Kind

    public init(value: String, kind: Kind = .voice) {
        self.value = value
        self.kind = kind
    }
}
