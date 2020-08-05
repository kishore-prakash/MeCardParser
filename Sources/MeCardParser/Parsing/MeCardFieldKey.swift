//  MeCardFieldKey.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

import Foundation

/// The set of MeCard field keys understood by the parser.
///
/// Modeling the keys as an enum keeps the parser's `switch` exhaustive and
/// documents exactly which fields are supported.
enum MeCardFieldKey: String {
    case name = "N"
    case sound = "SOUND"
    case telephone = "TEL"
    case videophone = "TEL-AV"
    case email = "EMAIL"
    case note = "NOTE"
    case birthday = "BDAY"
    case address = "ADR"
    case url = "URL"
    case nickname = "NICKNAME"
}
