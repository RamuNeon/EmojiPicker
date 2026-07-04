//
//  EmojiCategory.swift
//  EmojiPicker
//
//  Created by RamuNeon on 2026/07/04.
//

import Foundation

public struct EmojiCategory: Codable, Hashable, Identifiable, Sendable {
    public let type: EmojiCategoryType
    public var emojis: [Emoji]

    public var id: EmojiCategoryType {
        type
    }

    public var title: String {
        type.title
    }

    public init(type: EmojiCategoryType, emojis: [Emoji]) {
        self.type = type
        self.emojis = emojis
    }
}

public enum EmojiCategoryType: Int, Codable, CaseIterable, Identifiable, Sendable {
    case frequentlyUsed = 0
    case people = 1
    case nature = 2
    case foodAndDrink = 3
    case activity = 4
    case travelAndPlaces = 5
    case objects = 6
    case symbols = 7
    case flags = 8

    public var id: Int {
        rawValue
    }

    public static var bundledTypes: [EmojiCategoryType] {
        [.people, .nature, .foodAndDrink, .activity, .travelAndPlaces, .objects, .symbols, .flags]
    }

    var resourceName: String? {
        switch self {
        case .frequentlyUsed:
            return nil
        case .people:
            return "emotionsAndPeople"
        case .nature:
            return "animalsAndNature"
        case .foodAndDrink:
            return "foodAndDrinks"
        case .activity:
            return "activities"
        case .travelAndPlaces:
            return "travellingAndPlaces"
        case .objects:
            return "items"
        case .symbols:
            return "symbols"
        case .flags:
            return "flags"
        }
    }

    public var title: String {
        switch self {
        case .frequentlyUsed:
            return "Frequently Used"
        case .people:
            return "Smileys & People"
        case .nature:
            return "Animals & Nature"
        case .foodAndDrink:
            return "Food & Drink"
        case .activity:
            return "Activity"
        case .travelAndPlaces:
            return "Travel & Places"
        case .objects:
            return "Objects"
        case .symbols:
            return "Symbols"
        case .flags:
            return "Flags"
        }
    }

    var systemImageName: String {
        switch self {
        case .frequentlyUsed:
            return "clock"
        case .people:
            return "face.smiling"
        case .nature:
            return "leaf"
        case .foodAndDrink:
            return "fork.knife"
        case .activity:
            return "soccerball"
        case .travelAndPlaces:
            return "car"
        case .objects:
            return "lightbulb"
        case .symbols:
            return "number"
        case .flags:
            return "flag"
        }
    }
}
