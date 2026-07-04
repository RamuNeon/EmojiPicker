//
//  EmojiCategoryBarView.swift
//  EmojiPicker
//
//  Created by Miyin on 2026/07/04.
//

import SwiftUI

struct EmojiCategoryBarView: View {
    let categories: [EmojiCategory]
    let selectedCategory: EmojiCategoryType
    let selectedTint: Color
    let height: CGFloat
    let onSelect: (EmojiCategoryType) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0) {
                ForEach(categories) { category in
                    Button {
                        onSelect(category.type)
                    } label: {
                        Image(systemName: category.type.systemImageName)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(
                                selectedCategory == category.type ? selectedTint : Color.secondary
                            )
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(Text(category.title))
                }
            }
            .padding(.horizontal, 16)
            .frame(height: height)
            .background(.regularMaterial)
        }
    }
}
