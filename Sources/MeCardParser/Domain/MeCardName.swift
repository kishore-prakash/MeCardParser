//  MeCardName.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

import Foundation

/// A structured personal name.
///
/// In the MeCard format a name is encoded as `family,given`. Either component
/// may be absent, so both are optional.
public struct MeCardName: Equatable {

    public var familyName: String?
    public var givenName: String?

    public init(familyName: String? = nil, givenName: String? = nil) {
        self.familyName = familyName
        self.givenName = givenName
    }
}
