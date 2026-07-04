//
//  Emoji.swift
//  EmojiPicker
//
//  Created by Miyin on 2026/07/04.
//

import Foundation

public struct Emoji: Codable, Hashable, Identifiable, Sendable {
    public let emojiKeys: [Int]
    public let isSkinToneSupport: Bool
    public let searchKey: String
    public let version: Double

    private let baseString: String?

    public var id: String {
        "\(searchKey)-" + emojiKeys.map(String.init).joined(separator: "-")
    }

    public var string: String {
        string(for: nil)
    }

    public init(
        emojiKeys: [Int],
        isSkinToneSupport: Bool,
        searchKey: String,
        version: Double
    ) {
        self.emojiKeys = emojiKeys
        self.isSkinToneSupport = isSkinToneSupport
        self.searchKey = searchKey
        self.version = version
        self.baseString = nil
    }

    public func string(for skinTone: EmojiSkinTone?) -> String {
        guard isSkinToneSupport, let skinKey = skinTone?.skinKey else {
            return baseString ?? emojiKeys.emojiString
        }

        var keys = emojiKeys
        keys.insert(skinKey, at: min(1, keys.count))
        return keys.emojiString
    }

    enum CodingKeys: String, CodingKey {
        case baseString = "string"
        case isSkinToneSupport
        case searchKey
        case emojiKeys
        case version
    }
}

public enum EmojiSkinTone: Int, Codable, CaseIterable, Identifiable, Sendable {
    case none = 1
    case light = 2
    case mediumLight = 3
    case medium = 4
    case mediumDark = 5
    case dark = 6

    public var id: Int {
        rawValue
    }

    public var skinKey: Int? {
        switch self {
        case .none:
            return nil
        case .light:
            return 0x1F3FB
        case .mediumLight:
            return 0x1F3FC
        case .medium:
            return 0x1F3FD
        case .mediumDark:
            return 0x1F3FE
        case .dark:
            return 0x1F3FF
        }
    }
}

extension Array where Element == Int {
    var emojiString: String {
        String(String.UnicodeScalarView(compactMap(UnicodeScalar.init)))
    }
}
