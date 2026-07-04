//
//  EmojiPickerPopover.swift
//  EmojiPicker
//
//  Created by RamuNeon on 2026/07/04.
//

import SwiftUI

public extension View {
    func emojiPicker(
        isPresented: Binding<Bool>,
        selectedEmoji: Binding<String>,
        configuration: EmojiPickerConfiguration = EmojiPickerConfiguration()
    ) -> some View {
        modifier(
            EmojiPickerPopoverModifier(
                isPresented: isPresented,
                selectedEmoji: selectedEmoji,
                configuration: configuration
            )
        )
    }
}

private struct EmojiPickerPopoverModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var selectedEmoji: String

    let configuration: EmojiPickerConfiguration

    func body(content: Content) -> some View {
        content.popover(
            isPresented: $isPresented,
            attachmentAnchor: .rect(.bounds),
            arrowEdge: configuration.arrowEdge
        ) {
            popoverContent
        }
    }

    @ViewBuilder
    private var popoverContent: some View {
        let picker = EmojiPickerView(
            selectedEmoji: $selectedEmoji,
            isPresented: $isPresented,
            configuration: configuration
        )
        .frame(width: configuration.width, height: configuration.height)

        if #available(iOS 16.4, *) {
            picker.presentationCompactAdaptation(.popover)
        } else {
            picker
        }
    }
}
