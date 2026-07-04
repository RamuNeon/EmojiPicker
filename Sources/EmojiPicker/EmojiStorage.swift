//
//  EmojiStorage.swift
//  EmojiPicker
//
//  Created by Miyin on 2026/07/04.
//

import Foundation

public protocol EmojiStorage: AnyObject {
    func skinTone(for emoji: Emoji) -> EmojiSkinTone?
    func setSkinTone(_ skinTone: EmojiSkinTone?, for emoji: Emoji)
    func usage(for emoji: Emoji) -> [TimeInterval]
    func recordUsage(for emoji: Emoji, at timestamp: TimeInterval)
    func frequentlyUsedEmojis(from categories: [EmojiCategory], limit: Int) -> [Emoji]
}

public final class UserDefaultsEmojiStorage: EmojiStorage {
    private let userDefaults: UserDefaults
    private let keyPrefix: String

    public init(
        userDefaults: UserDefaults = .standard,
        keyPrefix: String = "com.miyin.EmojiPicker"
    ) {
        self.userDefaults = userDefaults
        self.keyPrefix = keyPrefix
    }

    public func skinTone(for emoji: Emoji) -> EmojiSkinTone? {
        guard let rawValue = userDefaults.object(forKey: skinToneKey(for: emoji)) as? Int else {
            return nil
        }
        return EmojiSkinTone(rawValue: rawValue)
    }

    public func setSkinTone(_ skinTone: EmojiSkinTone?, for emoji: Emoji) {
        guard let skinTone else {
            userDefaults.removeObject(forKey: skinToneKey(for: emoji))
            return
        }
        userDefaults.set(skinTone.rawValue, forKey: skinToneKey(for: emoji))
    }

    public func usage(for emoji: Emoji) -> [TimeInterval] {
        userDefaults.array(forKey: usageKey(for: emoji)) as? [TimeInterval] ?? []
    }

    public func recordUsage(for emoji: Emoji, at timestamp: TimeInterval = Date().timeIntervalSince1970) {
        userDefaults.set([timestamp] + usage(for: emoji), forKey: usageKey(for: emoji))
    }

    public func frequentlyUsedEmojis(from categories: [EmojiCategory], limit: Int) -> [Emoji] {
        Array(
            categories
                .flatMap(\.emojis)
                .filter { !usage(for: $0).isEmpty }
                .sorted { lhs, rhs in
                    let lhsUsage = usage(for: lhs)
                    let rhsUsage = usage(for: rhs)

                    guard lhsUsage.count == rhsUsage.count else {
                        return lhsUsage.count > rhsUsage.count
                    }
                    return (lhsUsage.first ?? 0) > (rhsUsage.first ?? 0)
                }
                .prefix(limit)
        )
    }

    private func skinToneKey(for emoji: Emoji) -> String {
        "\(keyPrefix).skinTone.\(emoji.storageIdentifier)"
    }

    private func usageKey(for emoji: Emoji) -> String {
        "\(keyPrefix).usage.\(emoji.storageIdentifier)"
    }
}

private extension Emoji {
    var storageIdentifier: String {
        emojiKeys.map(String.init).joined(separator: "-")
    }
}
