//  MeCardAddress.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

import Foundation

/// A structured postal address.
///
/// The MeCard `ADR` field is a comma-separated list whose leading components
/// form the street and whose trailing components map onto city / region /
/// postal code / country.
public struct MeCardAddress: Equatable {

    public var street: String?
    public var city: String?
    public var region: String?
    public var postalCode: String?
    public var country: String?

    public init(
        street: String? = nil,
        city: String? = nil,
        region: String? = nil,
        postalCode: String? = nil,
        country: String? = nil
    ) {
        self.street = street
        self.city = city
        self.region = region
        self.postalCode = postalCode
        self.country = country
    }
}
