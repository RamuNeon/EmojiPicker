//
//  EmojiCatalogProvider.swift
//  EmojiPicker
//
//  Created by RamuNeon on 2026/07/04.
//

import Foundation

public protocol EmojiCatalogProvider: Sendable {
    func categories(maxEmojiVersion: Double) throws -> [EmojiCategory]
}

public enum EmojiCatalogError: Error, LocalizedError, Sendable {
    case missingResource(String)

    public var errorDescription: String? {
        switch self {
        case .missingResource(let name):
            return "Missing emoji definition resource: \(name).json"
        }
    }
}

public struct BundleEmojiCatalogProvider: EmojiCatalogProvider {
    private let bundle: Bundle
    private let decoder: JSONDecoder

    public init() {
        self.bundle = .module
        self.decoder = JSONDecoder()
    }

    init(bundle: Bundle, decoder: JSONDecoder = JSONDecoder()) {
        self.bundle = bundle
        self.decoder = decoder
    }

    public func categories(maxEmojiVersion: Double) throws -> [EmojiCategory] {
        try EmojiCategoryType.bundledTypes.map { type in
            guard let resourceName = type.resourceName,
                  let url = resourceURL(named: resourceName)
            else {
                throw EmojiCatalogError.missingResource(type.resourceName ?? type.title)
            }

            let data = try Data(contentsOf: url)
            var category = try decoder.decode(EmojiCategory.self, from: data)
            category.emojis.removeAll { $0.version > maxEmojiVersion }
            return EmojiCategory(type: type, emojis: category.emojis)
        }
    }

    private func resourceURL(named resourceName: String) -> URL? {
        bundle.url(
            forResource: resourceName,
            withExtension: "json",
            subdirectory: "EmojiDefinitions"
        ) ?? bundle.url(forResource: resourceName, withExtension: "json")
    }
}
