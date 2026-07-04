// swift-tools-version: 5.9
//
//  Package.swift
//  EmojiPicker
//
//  Created by RamuNeon on 2026/07/04.
//

import PackageDescription

let package = Package(
    name: "EmojiPicker",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "EmojiPicker",
            targets: ["EmojiPicker"]
        )
    ],
    targets: [
        .target(
            name: "EmojiPicker",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "EmojiPickerTests",
            dependencies: ["EmojiPicker"]
        )
    ]
)
