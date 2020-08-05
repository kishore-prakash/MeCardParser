//  MeCardContactMapping.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

#if canImport(Contacts)
import Contacts

/// Maps the framework-agnostic ``MeCard`` domain model onto a `CNContact`.
///
/// Keeping this behind a protocol lets UI code depend on an abstraction and
/// lets tests verify the mapping in isolation from parsing.
public protocol MeCardContactMapping {
    func contact(from meCard: MeCard) -> CNContact
}
#endif
