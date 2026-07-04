//
//  EmojiPickerTests.swift
//  EmojiPicker
//
//  Created by RamuNeon on 2026/07/04.
//

import XCTest
@testable import EmojiPicker

final class EmojiPickerTests: XCTestCase {
    private var suiteName: String!
    private var userDefaults: UserDefaults!
    private var storage: UserDefaultsEmojiStorage!

    override func setUp() {
        super.setUp()
        suiteName = "EmojiPickerTests.\(UUID().uuidString)"
        userDefaults = UserDefaults(suiteName: suiteName)
        userDefaults.removePersistentDomain(forName: suiteName)
        storage = UserDefaultsEmojiStorage(userDefaults: userDefaults, keyPrefix: suiteName)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: suiteName)
        storage = nil
        userDefaults = nil
        suiteName = nil
        super.tearDown()
    }

    func testBundleProviderDecodesAndFiltersJSONDefinitions() throws {
        let provider = BundleEmojiCatalogProvider()
        let categories = try provider.categories(maxEmojiVersion: 1.0)

        XCTAssertEqual(categories.count, EmojiCategoryType.bundledTypes.count)
        XCTAssertTrue(categories.allSatisfy { $0.type != .frequentlyUsed })
        XCTAssertTrue(categories.flatMap(\.emojis).allSatisfy { $0.version <= 1.0 })
        XCTAssertTrue(categories.contains { $0.type == .people && !$0.emojis.isEmpty })
    }

    func testSkinToneInsertionUsesEmojiModifierAfterFirstScalar() {
        let emoji = Emoji(
            emojiKeys: [128075],
            isSkinToneSupport: true,
            searchKey: "wavingHand",
            version: 0.6
        )

        XCTAssertEqual(emoji.string(for: .mediumDark), "👋🏾")
        XCTAssertEqual(emoji.string(for: EmojiSkinTone.none), "👋")
    }

    func testUserDefaultsPersistsSkinTone() {
        let emoji = Emoji(
            emojiKeys: [128075],
            isSkinToneSupport: true,
            searchKey: "wavingHand",
            version: 0.6
        )

        storage.setSkinTone(.dark, for: emoji)

        XCTAssertEqual(storage.skinTone(for: emoji), .dark)
    }

    func testFrequentlyUsedSortsByUsageCountThenMostRecent() {
        let first = Emoji(
            emojiKeys: [128512],
            isSkinToneSupport: false,
            searchKey: "grinningFace",
            version: 1
        )
        let second = Emoji(
            emojiKeys: [128515],
            isSkinToneSupport: false,
            searchKey: "grinningFaceWithBigEyes",
            version: 0.6
        )
        let third = Emoji(
            emojiKeys: [128516],
            isSkinToneSupport: false,
            searchKey: "grinningFaceWithSmilingEyes",
            version: 0.6
        )
        let category = EmojiCategory(type: .people, emojis: [first, second, third])

        storage.recordUsage(for: first, at: 10)
        storage.recordUsage(for: second, at: 12)
        storage.recordUsage(for: second, at: 14)
        storage.recordUsage(for: third, at: 20)

        let result = storage.frequentlyUsedEmojis(from: [category], limit: 3)

        XCTAssertEqual(result.map(\.searchKey), [
            "grinningFaceWithBigEyes",
            "grinningFaceWithSmilingEyes",
            "grinningFace"
        ])
    }

    func testAvailabilityMappingMatchesSupportedIOSRanges() {
        XCTAssertEqual(EmojiAvailability.maxEmojiVersion(forSystemVersion: "16.4"), 15.0)
        XCTAssertEqual(EmojiAvailability.maxEmojiVersion(forSystemVersion: "15.4"), 14.0)
        XCTAssertEqual(EmojiAvailability.maxEmojiVersion(forSystemVersion: "14.5"), 13.1)
        XCTAssertEqual(EmojiAvailability.maxEmojiVersion(forSystemVersion: "13.2"), 12.0)
    }
}
