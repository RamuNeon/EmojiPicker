//
//  EmojiPickerConfiguration.swift
//  EmojiPicker
//
//  Created by Miyin on 2026/07/04.
//

import SwiftUI
import UIKit

public struct EmojiPickerConfiguration: Sendable {
    public var width: CGFloat
    public var height: CGFloat
    public var columnCount: Int
    public var selectedCategoryTintColor: Color
    public var dismissAfterSelection: Bool
    public var feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    public var showEmptyCategories: Bool
    public var maxFrequentlyUsedCount: Int
    public var arrowEdge: Edge

    public init(
        width: CGFloat = 340,
        height: CGFloat = 380,
        columnCount: Int = 8,
        selectedCategoryTintColor: Color = .blue,
        dismissAfterSelection: Bool = true,
        feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle? = .light,
        showEmptyCategories: Bool = false,
        maxFrequentlyUsedCount: Int = 30,
        arrowEdge: Edge = .top
    ) {
        self.width = width
        self.height = height
        self.columnCount = columnCount
        self.selectedCategoryTintColor = selectedCategoryTintColor
        self.dismissAfterSelection = dismissAfterSelection
        self.feedbackStyle = feedbackStyle
        self.showEmptyCategories = showEmptyCategories
        self.maxFrequentlyUsedCount = maxFrequentlyUsedCount
        self.arrowEdge = arrowEdge
    }
}
