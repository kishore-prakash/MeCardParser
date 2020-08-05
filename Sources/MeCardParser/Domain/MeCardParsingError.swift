//  MeCardParsingError.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

import Foundation

/// Errors that can be produced while parsing a MeCard payload.
public enum MeCardParsingError: Error, Equatable {

    /// The input did not begin with the case-insensitive `MECARD:` prefix.
    case missingPrefix

    /// The input contained the prefix but no recognizable field data.
    case emptyPayload
}

extension MeCardParsingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .missingPrefix:
            return "The data is not a MeCard: it does not start with the \"MECARD:\" prefix."
        case .emptyPayload:
            return "The MeCard payload did not contain any recognizable fields."
        }
    }
}
