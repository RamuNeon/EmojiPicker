# EmojiPicker

EmojiPicker 是一个 iOS 16+ 的 SwiftUI 原生 emoji 选择器。它复刻了 macOS 风格的弹出式 emoji picker 体验，同时保持公开 API 简洁，适合直接集成到 SwiftUI 应用中。

这个库的界面主体由 SwiftUI 实现，不依赖 `UIViewControllerRepresentable` 承载上游 UIKit picker。Emoji 定义资源来自 [MCEmojiPicker](https://github.com/izyumkin/MCEmojiPicker)，并在本库中以 Swift Package 资源形式打包。

## Features

- SwiftUI 原生 `EmojiPickerView`。
- 通过 `View.emojiPicker(isPresented:selectedEmoji:configuration:)` 以 popover 形式展示。
- 按类别分组的 8 列 emoji 网格。
- Sticky section header。
- 底部分类栏，支持点击跳转和滚动时自动高亮当前分类。
- 长按 emoji 预览。
- 支持肤色选择，并通过 `UserDefaults` 记住选择。
- 支持常用 emoji 记录和排序。
- 根据当前 iOS 版本过滤不可用的 emoji 定义。
- 支持自定义尺寸、列数、选中颜色、触觉反馈、选择后是否关闭等配置。

## Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 15+
- Swift Package Manager

## Installation

### Xcode

1. 打开你的 iOS 项目。
2. 选择 `File > Add Package Dependencies...`。
3. 输入仓库地址：

```text
https://github.com/RamuNeon/EmojiPicker
```

4. 选择需要的版本规则。
5. 将 `EmojiPicker` 添加到你的 app target。

### Package.swift

如果你的项目本身也是 Swift Package，可以在 `Package.swift` 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/RamuNeon/EmojiPicker", from: "1.0.0")
]
```

然后在 target 中添加产品依赖：

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

当前如果还没有发布 tag，也可以先使用分支依赖：

```swift
.package(url: "https://github.com/RamuNeon/EmojiPicker", branch: "main")
```

## Quick Start

最常见的用法是把 picker 绑定到一个按钮上。点击按钮后以 popover 形式展示，选择 emoji 后自动更新绑定值。

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

通过 `EmojiPickerConfiguration` 调整 picker 的展示和交互行为：

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
| `width` | `340` | popover 内容宽度。 |
| `height` | `380` | popover 内容高度。 |
| `columnCount` | `8` | emoji 网格列数。 |
| `selectedCategoryTintColor` | `.blue` | 底部分类栏选中颜色。 |
| `dismissAfterSelection` | `true` | 选择 emoji 后是否自动关闭 picker。 |
| `feedbackStyle` | `.light` | 触觉反馈样式；传入 `nil` 可关闭反馈。 |
| `showEmptyCategories` | `false` | 是否展示空分类。 |
| `maxFrequentlyUsedCount` | `30` | 常用 emoji 分类最多展示数量。 |
| `arrowEdge` | `.top` | SwiftUI popover 箭头方向。 |

## Inline Picker

如果不需要 popover，也可以直接把 `EmojiPickerView` 嵌入你的界面，例如放在 sheet、panel 或自定义容器中：

```swift
struct InlineEmojiPicker: View {
    @State private var selectedEmoji = "😀"

    var body: some View {
        EmojiPickerView(selectedEmoji: $selectedEmoji)
            .frame(width: 340, height: 380)
    }
}
```

`EmojiPickerView` 也支持传入 `isPresented` binding，用于在选择后控制外部容器关闭：

```swift
EmojiPickerView(
    selectedEmoji: $selectedEmoji,
    isPresented: $isPickerPresented,
    configuration: EmojiPickerConfiguration(dismissAfterSelection: true)
)
```

## Data and Persistence

EmojiPicker 内置两层数据能力：

- `BundleEmojiCatalogProvider`：从 Swift Package 资源中读取 emoji JSON，并根据当前 iOS 支持的 emoji 版本过滤。
- `UserDefaultsEmojiStorage`：保存肤色偏好和常用 emoji 使用记录。

默认情况下，你不需要手动创建这些对象。如果需要隔离存储空间或用于测试，可以直接初始化 `EmojiPickerView` 并注入自定义 storage：

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

- SwiftUI 的 popover 在紧凑宽度设备上的行为受系统控制；iOS 16.4+ 会使用 `.presentationCompactAdaptation(.popover)` 保持 popover 风格。
- 本库当前不提供 emoji 搜索 UI。
- 多人组合肤色等复杂 emoji 序列遵循源数据能力，不额外拆解组合序列。

## License and Credits

EmojiPicker 使用 MIT License。

Emoji JSON 定义资源来自 [izyumkin/MCEmojiPicker](https://github.com/izyumkin/MCEmojiPicker)，原项目同样使用 MIT License：

Copyright (c) 2022 Ivan Izyumkin

完整第三方授权说明见 [NOTICE.md](NOTICE.md)。
