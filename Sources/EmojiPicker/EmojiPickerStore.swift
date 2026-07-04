//
//  EmojiPickerStore.swift
//  EmojiPicker
//
//  Created by Miyin on 2026/07/04.
//

import Combine
import Foundation

@MainActor
final class EmojiPickerStore: ObservableObject {
    @Published private(set) var categories: [EmojiCategory] = []
    @Published private(set) var loadError: Error?
    @Published var selectedCategory: EmojiCategoryType = .people

    private let catalogProvider: any EmojiCatalogProvider
    private let storage: any EmojiStorage
    private let configuration: EmojiPickerConfiguration
    private var baseCategories: [EmojiCategory] = []

    init(
        catalogProvider: any EmojiCatalogProvider,
        storage: any EmojiStorage,
        configuration: EmojiPickerConfiguration
    ) {
        self.catalogProvider = catalogProvider
        self.storage = storage
        self.configuration = configuration
        reload()
    }

    func reload() {
        do {
            baseCategories = try catalogProvider.categories(
                maxEmojiVersion: EmojiAvailability.maxEmojiVersion()
            )
            categories = composedCategories()
            selectedCategory = categories.first?.type ?? .people
            loadError = nil
        } catch {
            categories = []
            loadError = error
        }
    }

    func emojiString(for emoji: Emoji) -> String {
        emoji.string(for: storage.skinTone(for: emoji))
    }

    func hasSelectedSkinTone(for emoji: Emoji) -> Bool {
        storage.skinTone(for: emoji) != nil
    }

    func select(_ emoji: Emoji) -> String {
        storage.recordUsage(for: emoji, at: Date().timeIntervalSince1970)
        categories = composedCategories()
        return emojiString(for: emoji)
    }

    func setSkinTone(_ skinTone: EmojiSkinTone, for emoji: Emoji) -> String {
        storage.setSkinTone(skinTone, for: emoji)
        categories = composedCategories()
        return emoji.string(for: skinTone)
    }

    private func composedCategories() -> [EmojiCategory] {
        let frequentlyUsed = EmojiCategory(
            type: .frequentlyUsed,
            emojis: storage.frequentlyUsedEmojis(
                from: baseCategories,
                limit: configuration.maxFrequentlyUsedCount
            )
        )

        return ([frequentlyUsed] + baseCategories).filter {
            configuration.showEmptyCategories || !$0.emojis.isEmpty
        }
    }
}
