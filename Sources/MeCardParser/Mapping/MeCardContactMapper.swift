//  MeCardContactMapper.swift
//  MeCardParser
//
//  Created by Kishore Prakash on 31/07/20.
//  Copyright © 2020 Kishore Prakash. All rights reserved.
//
//  Licensed under the MIT License. See LICENSE for details.

#if canImport(Contacts)
import Contacts

/// The default ``MeCardContactMapping`` implementation.
public struct MeCardContactMapper: MeCardContactMapping {

    public init() {}

    public func contact(from meCard: MeCard) -> CNContact {
        let contact = CNMutableContact()

        if let name = meCard.name {
            contact.familyName = name.familyName ?? ""
            contact.givenName = name.givenName ?? ""
        }

        if let phonetic = meCard.phoneticName {
            contact.phoneticFamilyName = phonetic.familyName ?? ""
            contact.phoneticGivenName = phonetic.givenName ?? ""
        }

        if !meCard.phoneNumbers.isEmpty {
            contact.phoneNumbers = meCard.phoneNumbers.map { phone in
                CNLabeledValue(
                    label: Self.label(for: phone.kind),
                    value: CNPhoneNumber(stringValue: phone.value)
                )
            }
        }

        if !meCard.emailAddresses.isEmpty {
            contact.emailAddresses = meCard.emailAddresses.map {
                CNLabeledValue(label: CNLabelHome, value: $0 as NSString)
            }
        }

        if !meCard.urls.isEmpty {
            contact.urlAddresses = meCard.urls.map {
                CNLabeledValue(label: CNLabelHome, value: $0 as NSString)
            }
        }

        if !meCard.addresses.isEmpty {
            contact.postalAddresses = meCard.addresses.map {
                CNLabeledValue(label: CNLabelHome, value: Self.postalAddress(from: $0))
            }
        }

        if let birthday = meCard.birthday {
            contact.birthday = birthday
        }

        if let nickname = meCard.nickname {
            contact.nickname = nickname
        }

        if let note = meCard.note {
            // `CNMutableContact.note` requires the com.apple.developer.contacts.notes
            // entitlement to persist, but assigning it is always safe.
            contact.note = note
        }

        return contact
    }

    private static func label(for kind: MeCardPhoneNumber.Kind) -> String {
        switch kind {
        case .voice: return CNLabelHome
        case .videophone: return CNLabelOther
        }
    }

    private static func postalAddress(from address: MeCardAddress) -> CNPostalAddress {
        let postal = CNMutablePostalAddress()
        postal.street = address.street ?? ""
        postal.city = address.city ?? ""
        if let region = address.region {
            postal.subAdministrativeArea = region
        }
        postal.postalCode = address.postalCode ?? ""
        postal.country = address.country ?? ""
        return postal
    }
}
#endif
