//
//  EmojiAvailability.swift
//  EmojiPicker
//
//  Created by Miyin on 2026/07/04.
//

import Foundation
import UIKit

public enum EmojiAvailability {
    public static func maxEmojiVersion(forSystemVersion systemVersion: String = UIDevice.current.systemVersion) -> Double {
        let version = (systemVersion as NSString).doubleValue

        switch version {
        case 12.1..<13.2:
            return 11.0
        case 13.2..<14.2:
            return 12.0
        case 14.2..<14.5:
            return 13.0
        case 14.5..<15.4:
            return 13.1
        case 15.4..<16.4:
            return 14.0
        case 16.4...:
            return 15.0
        default:
            return 5.0
        }
    }
}
