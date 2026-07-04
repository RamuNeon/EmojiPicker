# EmojiPicker

[简体中文](README.zh-CN.md)

EmojiPicker is a native SwiftUI emoji picker for iOS 16+. It recreates a macOS-style popover emoji picker while keeping the public API small and easy to integrate into SwiftUI apps.

The picker UI is implemented in SwiftUI instead of wrapping the original UIKit picker through `UIViewControllerRepresentable`. Emoji definition resources are derived from [MCEmojiPicker](https://github.com/izyumkin/MCEmojiPicker) and packaged as Swift Package resources.

## Features

- Native SwiftUI `EmojiPickerView`.
- Popover presentation through `View.emojiPicker(isPresented:selectedEmoji:configuration:)`.
- Category-grouped emoji grid with 8 columns by default.
- Sticky section headers.
- Bottom category bar with tap-to-jump and scroll-synced selection.
- Long-press emoji preview.
- Skin tone picker with persisted skin tone preference.
- Frequently used emoji tracking and sorting.
- Emoji availability filtering based on the current iOS version.
- Configurable size, columns, selected category color, haptics, dismiss behavior, and popover arrow edge.

## Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 15+
- Swift Package Manager

## Installation

### Xcode

1. Open your iOS project in Xcode.
2. Choose `File > Add Package Dependencies...`.
3. Enter the repository URL:

```text
https://github.com/RamuNeon/EmojiPicker
```

4. Select the dependency rule you want to use.
5. Add `EmojiPicker` to your app target.

### Package.swift

If your app or library is also a Swift Package, add EmojiPicker to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/RamuNeon/EmojiPicker", from: "1.0.0")
]
```

Then add the product to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "EmojiPicker", package: "EmojiPicker")
        ]
    )
]
```

If no release tag is available yet, use the `main` branch temporarily:

```swift
.package(url: "https://github.com/RamuNeon/EmojiPicker", branch: "main")
```

## Quick Start

The most common integration is to attach the picker to a button. Tapping the button presents the picker, and choosing an emoji updates the bound value.

```swift
import SwiftUI
import EmojiPicker

struct ContentView: View {
    @State private var isPickerPresented = false
    @State private var selectedEmoji = "😀"

    var body: some View {
        Button {
            isPickerPresented = true
        } label: {
            Text(selectedEmoji)
                .font(.largeTitle)
                .frame(width: 56, height: 56)
        }
        .emojiPicker(
            isPresented: $isPickerPresented,
            selectedEmoji: $selectedEmoji
        )
    }
}
```

## Customization

Use `EmojiPickerConfiguration` to customize presentation and interaction behavior:

```swift
.emojiPicker(
    isPresented: $isPickerPresented,
    selectedEmoji: $selectedEmoji,
    configuration: EmojiPickerConfiguration(
        width: 360,
        height: 420,
        columnCount: 8,
        selectedCategoryTintColor: .purple,
        dismissAfterSelection: true,
        feedbackStyle: .light,
        showEmptyCategories: false,
        maxFrequentlyUsedCount: 30,
        arrowEdge: .top
    )
)
```

### Configuration Options

| Option | Default | Description |
| --- | --- | --- |
| `width` | `340` | Popover content width. |
| `height` | `380` | Popover content height. |
| `columnCount` | `8` | Number of emoji grid columns. |
| `selectedCategoryTintColor` | `.blue` | Selected color in the bottom category bar. |
| `dismissAfterSelection` | `true` | Whether the picker closes after selecting an emoji. |
| `feedbackStyle` | `.light` | Haptic feedback style. Pass `nil` to disable haptics. |
| `showEmptyCategories` | `false` | Whether empty categories should be shown. |
| `maxFrequentlyUsedCount` | `30` | Maximum number of emoji in the frequently used category. |
| `arrowEdge` | `.top` | SwiftUI popover arrow edge. |

## Inline Picker

If you do not need popover presentation, embed `EmojiPickerView` directly in a sheet, panel, or custom container:

```swift
struct InlineEmojiPicker: View {
    @State private var selectedEmoji = "😀"

    var body: some View {
        EmojiPickerView(selectedEmoji: $selectedEmoji)
            .frame(width: 340, height: 380)
    }
}
```

`EmojiPickerView` also accepts an `isPresented` binding so selection can dismiss the surrounding container:

```swift
EmojiPickerView(
    selectedEmoji: $selectedEmoji,
    isPresented: $isPickerPresented,
    configuration: EmojiPickerConfiguration(dismissAfterSelection: true)
)
```

## Data and Persistence

EmojiPicker includes two data-layer components:

- `BundleEmojiCatalogProvider`: loads emoji JSON resources from the Swift Package bundle and filters emoji by the current iOS-supported emoji version.
- `UserDefaultsEmojiStorage`: persists skin tone preferences and frequently used emoji history.

You do not need to create these manually for the default setup. If you need an isolated storage namespace, initialize `EmojiPickerView` directly and inject custom storage:

```swift
EmojiPickerView(
    selectedEmoji: $selectedEmoji,
    storage: UserDefaultsEmojiStorage(
        userDefaults: .standard,
        keyPrefix: "com.example.myapp.emojiPicker"
    )
)
```

## Notes

- SwiftUI popover behavior on compact-width devices is controlled by the system. On iOS 16.4+, EmojiPicker uses `.presentationCompactAdaptation(.popover)` to keep popover-style presentation.
- EmojiPicker does not currently include emoji search UI.
- Complex multi-person skin tone emoji sequences follow the source data and are not additionally decomposed by this package.

## License and Credits

EmojiPicker is distributed under the MIT License.

Emoji JSON definition resources are derived from [izyumkin/MCEmojiPicker](https://github.com/izyumkin/MCEmojiPicker), which is also distributed under the MIT License:

Copyright (c) 2022 Ivan Izyumkin

See [NOTICE.md](NOTICE.md) for the full third-party notice.
