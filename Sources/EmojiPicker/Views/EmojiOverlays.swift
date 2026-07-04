//
//  EmojiOverlays.swift
//  EmojiPicker
//
//  Created by RamuNeon on 2026/07/04.
//

import SwiftUI

struct EmojiPreviewOverlay: View {
    let emojiString: String
    let sourceFrame: CGRect
    let containerSize: CGSize

    var body: some View {
        VStack(spacing: 0) {
            Text(emojiString)
                .font(.system(size: 34))
                .frame(width: 56, height: 56)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            Triangle()
                .fill(Color(.secondarySystemBackground))
                .frame(width: 18, height: 9)
                .rotationEffect(.degrees(180))
        }
        .shadow(color: .black.opacity(0.18), radius: 12, y: 6)
        .position(x: clampedX(width: 56), y: max(40, sourceFrame.minY - 34))
        .allowsHitTesting(false)
    }

    private func clampedX(width: CGFloat) -> CGFloat {
        min(max(sourceFrame.midX, width / 2 + 8), containerSize.width - width / 2 - 8)
    }
}

struct EmojiSkinTonePickerOverlay: View {
    let emoji: Emoji
    let selectedTone: EmojiSkinTone?
    let sourceFrame: CGRect
    let containerSize: CGSize
    let selectedTint: Color
    let onSelect: (EmojiSkinTone) -> Void

    var body: some View {
        HStack(spacing: 4) {
            ForEach(EmojiSkinTone.allCases) { tone in
                Button {
                    onSelect(tone)
                } label: {
                    Text(emoji.string(for: tone))
                        .font(.system(size: 29))
                        .frame(width: itemSize, height: itemSize)
                        .background(
                            RoundedRectangle(cornerRadius: 7, style: .continuous)
                                .fill(selectedTone == tone ? selectedTint : .clear)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("Skin tone \(tone.rawValue)"))

                if tone == .none {
                    Divider()
                        .frame(height: itemSize - 8)
                        .padding(.horizontal, 8)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15, style: .continuous))
        .overlay(alignment: .bottom) {
            Triangle()
                .fill(Color(.secondarySystemBackground))
                .frame(width: 18, height: 9)
                .rotationEffect(.degrees(180))
                .offset(y: 8)
        }
        .shadow(color: .black.opacity(0.18), radius: 14, y: 7)
        .position(x: clampedX(width: overlayWidth), y: max(42, sourceFrame.minY - 34))
    }

    private var itemSize: CGFloat {
        max(34, min(42, sourceFrame.width))
    }

    private var overlayWidth: CGFloat {
        min(containerSize.width - 16, itemSize * 6 + 76)
    }

    private func clampedX(width: CGFloat) -> CGFloat {
        min(max(sourceFrame.midX, width / 2 + 8), containerSize.width - width / 2 - 8)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
