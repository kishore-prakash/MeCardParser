// swift-tools-version:5.5
//  Package.swift
//  MeCardParser

import PackageDescription

let package = Package(
    name: "MeCardParser",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_11),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "MeCardParser",
            targets: ["MeCardParser"]
        )
    ],
    targets: [
        .target(
            name: "MeCardParser",
            path: "Sources/MeCardParser"
        ),
        .testTarget(
            name: "MeCardParserTests",
            dependencies: ["MeCardParser"],
            path: "Tests/MeCardParserTests"
        )
    ]
)
