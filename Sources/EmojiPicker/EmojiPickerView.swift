//
//  EmojiPickerView.swift
//  EmojiPicker
//
//  Created by Miyin on 2026/07/04.
//

import SwiftUI
import UIKit

public struct EmojiPickerView: View {
    @Binding private var selectedEmoji: String
    @Binding private var isPresented: Bool

    private let configuration: EmojiPickerConfiguration

    @StateObject private var store: EmojiPickerStore
    @State private var previewState: EmojiOverlayState?
    @State private var skinToneState: EmojiOverlayState?

    public init(
        selectedEmoji: Binding<String>,
        isPresented: Binding<Bool> = .constant(true),
        configuration: EmojiPickerConfiguration = EmojiPickerConfiguration(),
        catalogProvider: any EmojiCatalogProvider = BundleEmojiCatalogProvider(),
        storage: any EmojiStorage = UserDefaultsEmojiStorage()
    ) {
        self._selectedEmoji = selectedEmoji
        self._isPresented = isPresented
        self.configuration = configuration
        self._store = StateObject(
            wrappedValue: EmojiPickerStore(
                catalogProvider: catalogProvider,
                storage: storage,
                configuration: configuration
            )
        )
    }

    public var body: some View {
        GeometryReader { proxy in
            ScrollViewReader { scrollProxy in
                ZStack(alignment: .bottom) {
                    content(barHeight: categoryBarHeight(for: proxy.size))
                    categoryBar(scrollProxy: scrollProxy, height: categoryBarHeight(for: proxy.size))
                    overlays(containerSize: proxy.size)
                }
                .coordinateSpace(name: EmojiPickerCoordinateSpace.name)
                .background(Color(.systemBackground))
            }
        }
    }

    private func content(barHeight: CGFloat) -> some View {
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(store.categories) { category in
                    Section {
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(category.emojis) { emoji in
                                EmojiCellView(
                                    emoji: emoji,
                                    emojiString: store.emojiString(for: emoji),
                                    hasSelectedSkinTone: store.hasSelectedSkinTone(for: emoji),
                                    onSelect: { select(emoji) },
                                    onPreviewChanged: { previewState = $0 },
                                    onSkinToneRequest: { state in
                                        feedback()
                                        previewState = nil
                                        skinToneState = state
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, category.type == store.categories.last?.type ? barHeight + 8 : 0)
                    } header: {
                        sectionHeader(for: category)
                    }
                }
            }
        }
        .scrollIndicators(.visible)
        .onPreferenceChange(EmojiCategoryOffsetPreferenceKey.self) { offsets in
            updateSelectedCategory(with: offsets)
        }
        .onTapGesture {
            previewState = nil
            skinToneState = nil
        }
    }

    private func sectionHeader(for category: EmojiCategory) -> some View {
        Text(category.title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 40)
            .padding(.horizontal, 16)
            .background(Color(.systemBackground))
            .id(category.type.scrollID)
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: EmojiCategoryOffsetPreferenceKey.self,
                        value: [
                            category.type: proxy.frame(
                                in: .named(EmojiPickerCoordinateSpace.name)
                            ).minY
                        ]
                    )
                }
            )
    }

    private func categoryBar(scrollProxy: ScrollViewProxy, height: CGFloat) -> some View {
        EmojiCategoryBarView(
            categories: store.categories,
            selectedCategory: store.selectedCategory,
            selectedTint: configuration.selectedCategoryTintColor,
            height: height
        ) { category in
            feedback()
            previewState = nil
            skinToneState = nil
            store.selectedCategory = category
            withAnimation(.easeInOut(duration: 0.18)) {
                scrollProxy.scrollTo(category.scrollID, anchor: .top)
            }
        }
    }

    @ViewBuilder
    private func overlays(containerSize: CGSize) -> some View {
        if let previewState {
            EmojiPreviewOverlay(
                emojiString: store.emojiString(for: previewState.emoji),
                sourceFrame: previewState.frame,
                containerSize: containerSize
            )
            .transition(.opacity.combined(with: .scale(scale: 0.92)))
        }

        if let skinToneState {
            EmojiSkinTonePickerOverlay(
                emoji: skinToneState.emoji,
                selectedTone: currentSkinTone(for: skinToneState.emoji),
                sourceFrame: skinToneState.frame,
                containerSize: containerSize,
                selectedTint: configuration.selectedCategoryTintColor
            ) { tone in
                feedback()
                selectedEmoji = store.setSkinTone(tone, for: skinToneState.emoji)
                selectedEmoji = store.select(skinToneState.emoji)
                self.skinToneState = nil
                if configuration.dismissAfterSelection {
                    isPresented = false
                }
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
        }
    }

    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(minimum: 28), spacing: 0, alignment: .center),
            count: max(configuration.columnCount, 1)
        )
    }

    private func categoryBarHeight(for size: CGSize) -> CGFloat {
        min(max(size.width * 0.13, 44), 56)
    }

    private func select(_ emoji: Emoji) {
        feedback()
        selectedEmoji = store.select(emoji)
        previewState = nil
        skinToneState = nil

        if configuration.dismissAfterSelection {
            isPresented = false
        }
    }

    private func currentSkinTone(for emoji: Emoji) -> EmojiSkinTone? {
        EmojiSkinTone.allCases.first { emoji.string(for: $0) == store.emojiString(for: emoji) }
    }

    private func feedback() {
        guard let feedbackStyle = configuration.feedbackStyle else { return }
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }

    private func updateSelectedCategory(with offsets: [EmojiCategoryType: CGFloat]) {
        let nearTop = offsets
            .filter { $0.value <= 42 }
            .max { $0.value < $1.value }?
            .key

        let nearest = offsets.min {
            abs($0.value - 40) < abs($1.value - 40)
        }?.key

        guard let category = nearTop ?? nearest,
              category != store.selectedCategory
        else { return }

        DispatchQueue.main.async {
            store.selectedCategory = category
        }
    }
}
