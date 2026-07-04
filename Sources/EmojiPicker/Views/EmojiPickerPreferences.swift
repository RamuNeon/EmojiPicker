//
//  EmojiPickerPreferences.swift
//  EmojiPicker
//
//  Created by Miyin on 2026/07/04.
//

import SwiftUI

enum EmojiPickerCoordinateSpace {
    static let name = "EmojiPickerCoordinateSpace"
}

struct EmojiCellFramePreferenceKey: PreferenceKey {
    static var defaultValue: [String: CGRect] = [:]

    static func reduce(value: inout [String: CGRect], nextValue: () -> [String: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
    }
}

struct EmojiCategoryOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: [EmojiCategoryType: CGFloat] = [:]

    static func reduce(value: inout [EmojiCategoryType: CGFloat], nextValue: () -> [EmojiCategoryType: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { _, new in new })
    }
}

struct EmojiOverlayState: Identifiable, Equatable {
    let emoji: Emoji
    let frame: CGRect

    var id: String {
        emoji.id
    }
}

extension EmojiCategoryType {
    var scrollID: String {
        "emoji-category-\(rawValue)"
    }
}
