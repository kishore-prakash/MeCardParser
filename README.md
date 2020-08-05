# MeCardParser

[![CI](https://github.com/kishore-prakash/MeCardParser/actions/workflows/ci.yml/badge.svg)](https://github.com/kishore-prakash/MeCardParser/actions/workflows/ci.yml)
[![SwiftPM](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg?style=flat)](https://swift.org/package-manager/)

A clean, testable Swift library that turns [MeCard](https://en.wikipedia.org/wiki/MeCard_(QR_code)) QR-code strings into a framework-agnostic model and, on Apple platforms, into `CNContact` objects.

## Architecture

The library is organized into small, independently testable layers following clean-architecture principles. Every layer depends only on abstractions (protocols), so any piece can be tested or replaced in isolation.

```
Raw string ──▶ MeCardTokenizer ──▶ [MeCardField] ──▶ MeCardParser ──▶ MeCard ──▶ MeCardContactMapper ──▶ CNContact
              (MeCardTokenizing)                     (MeCardParsing)  (domain)   (MeCardContactMapping)
```

| Layer | Type(s) | Responsibility |
|-------|---------|----------------|
| **Domain** | `MeCard`, `MeCardName`, `MeCardAddress`, `MeCardPhoneNumber`, `MeCardParsingError` | Pure value types. No dependency on `Contacts`. |
| **Parsing** | `MeCardTokenizing` / `MeCardTokenizer`, `MeCardParsing` / `MeCardParser` | Split the payload into fields, then interpret them into a `MeCard`. Fully unit-testable without any Apple framework. |
| **Mapping** | `MeCardContactMapping` / `MeCardContactMapper` | Translate a `MeCard` into a `CNContact`. Isolated behind `#if canImport(Contacts)`. |
| **Facade** | `MeCardContactBuilder` | Convenience that wires parser + mapper together with injectable dependencies. |

## Installation

MeCardParser is distributed exclusively through the **Swift Package Manager**.

Add the package in Xcode (**File ▸ Add Packages…**) using the repository URL, or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/kishore-prakash/MeCardParser.git", from: "2.0.0")
]
```

## Usage

### One-shot: string ▶ `CNContact`

```swift
import MeCardParser

let qr = "MECARD:N:Doe,John;TEL:555-555-5555;EMAIL:email@example.com;URL:https://www.example.com;"

switch MeCardContactBuilder().makeContact(from: qr) {
case .success(let contact):
    // use the CNContact
    break
case .failure(let error):
    print("Not a valid MeCard: \(error.localizedDescription)")
}
```

Prefer an optional? Use `contact(from:)`:

```swift
guard let contact = MeCardContactBuilder().contact(from: qr) else { return }
```

### Parsing only (no `Contacts` dependency)

When you just need the structured data — or you're on a platform without `Contacts` — use the parser directly:

```swift
let result = MeCardParser().parse(qr)
if case .success(let meCard) = result {
    print(meCard.name?.givenName ?? "")
    print(meCard.phoneNumbers.map(\.value))
}
```

### Testing / customization

Every collaborator is injectable, so you can swap in test doubles or alternative implementations:

```swift
let builder = MeCardContactBuilder(
    parser: MeCardParser(tokenizer: MyCustomTokenizer()),
    mapper: MeCardContactMapper()
)
```

## Migrating from 1.x

`Parser.parserMeCard(data:)` still works but is deprecated. Replace it with `MeCardContactBuilder`:

```swift
// Before
let contact = Parser.parserMeCard(data: qr)

// After
let contact = MeCardContactBuilder().contact(from: qr)
```

## Example

An example iOS app lives in the `Example` directory. It consumes the library
through a local Swift Package reference, so you can simply clone the repo and
open `Example/MeCardParser.xcodeproj` in Xcode — no dependency manager required.

## Running the tests

```bash
swift test
```

## Author

Kishore Prakash, kishore.balasa@gmail.com

## License

MeCardParser is available under the MIT license. See the LICENSE file for more info.
