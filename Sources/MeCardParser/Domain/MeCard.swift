//  MeCard.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

import Foundation

/// A framework-agnostic representation of a parsed MeCard payload.
///
/// `MeCard` is a pure value type in the domain layer. It has no dependency on
/// `Contacts` (or any other Apple framework beyond `Foundation`), which keeps
/// parsing logic fully unit-testable and lets the same model feed different
/// output adapters (e.g. `MeCardContactMapper`).
public struct MeCard: Equatable {

    /// The primary name of the contact.
    public var name: MeCardName?

    /// The phonetic ("SOUND") name of the contact.
    public var phoneticName: MeCardName?

    /// Phone numbers in the order they appeared in the payload.
    public var phoneNumbers: [MeCardPhoneNumber]

    /// Email addresses in the order they appeared in the payload.
    public var emailAddresses: [String]

    /// URLs in the order they appeared in the payload.
    public var urls: [String]

    /// Postal addresses in the order they appeared in the payload.
    public var addresses: [MeCardAddress]

    /// The contact's date of birth, if present and well-formed.
    public var birthday: DateComponents?

    /// The contact's nickname.
    public var nickname: String?

    /// A free-form note.
    public var note: String?

    public init(
        name: MeCardName? = nil,
        phoneticName: MeCardName? = nil,
        phoneNumbers: [MeCardPhoneNumber] = [],
        emailAddresses: [String] = [],
        urls: [String] = [],
        addresses: [MeCardAddress] = [],
        birthday: DateComponents? = nil,
        nickname: String? = nil,
        note: String? = nil
    ) {
        self.name = name
        self.phoneticName = phoneticName
        self.phoneNumbers = phoneNumbers
        self.emailAddresses = emailAddresses
        self.urls = urls
        self.addresses = addresses
        self.birthday = birthday
        self.nickname = nickname
        self.note = note
    }

    /// `true` when no field carried any usable information.
    public var isEmpty: Bool {
        name == nil
            && phoneticName == nil
            && phoneNumbers.isEmpty
            && emailAddresses.isEmpty
            && urls.isEmpty
            && addresses.isEmpty
            && birthday == nil
            && nickname == nil
            && note == nil
    }
}
