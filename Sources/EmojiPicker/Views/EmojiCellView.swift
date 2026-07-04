//
//  EmojiCellView.swift
//  EmojiPicker
//
//  Created by RamuNeon on 2026/07/04.
//

import SwiftUI

struct EmojiCellView: View {
    let emoji: Emoji
    let emojiString: String
    let hasSelectedSkinTone: Bool
    let onSelect: () -> Void
    let onPreviewChanged: (EmojiOverlayState?) -> Void
    let onSkinToneRequest: (EmojiOverlayState) -> Void

    @State private var frame: CGRect = .zero
    @State private var isPressed = false

    var body: some View {
        Text(emojiString)
            .font(.system(size: 29))
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isPressed ? Color(.tertiarySystemFill) : .clear)
            )
            .contentShape(Rectangle())
            .background(frameReader)
            .onPreferenceChange(EmojiCellFramePreferenceKey.self) { frames in
                frame = frames[emoji.id] ?? frame
            }
            .onTapGesture {
                if emoji.isSkinToneSupport && !hasSelectedSkinTone {
                    onSkinToneRequest(overlayState)
                } else {
                    onSelect()
                }
            }
            .onLongPressGesture(
                minimumDuration: 0.18,
                maximumDistance: 24,
                pressing: handlePressingChanged,
                perform: handleLongPress
            )
            .accessibilityLabel(Text(emoji.searchKey))
            .accessibilityAddTraits(.isButton)
    }

    private var frameReader: some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: EmojiCellFramePreferenceKey.self,
                value: [emoji.id: proxy.frame(in: .named(EmojiPickerCoordinateSpace.name))]
            )
        }
    }

    private var overlayState: EmojiOverlayState {
        EmojiOverlayState(emoji: emoji, frame: frame)
    }

    private func handlePressingChanged(_ pressing: Bool) {
        isPressed = pressing

        guard !emoji.isSkinToneSupport else { return }
        onPreviewChanged(pressing ? overlayState : nil)
    }

    private func handleLongPress() {
        if emoji.isSkinToneSupport {
            onSkinToneRequest(overlayState)
        } else {
            onSelect()
        }
    }
}
