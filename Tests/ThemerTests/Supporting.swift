//
//  Supporting.swift
//
//
//  Created by Serhiy Butz.
//

import XCTest
@testable import Themer

final class EmptyThemeTarget {
    struct ThemeSettings: ThemeModelProtocol {}
    enum Theme: ThemeProtocol {
        var settings: ThemeSettings {
            return ThemeSettings()
        }
    }
    func themeHandler(_ theme: Theme) {}
}

final class SingleThemeTarget {
    struct ThemeSettings: ThemeModelProtocol {}
    enum Theme: ThemeProtocol {
        case `default`
        var settings: ThemeSettings {
            switch self {
            case .default: return ThemeSettings()
            }
        }
    }
    var isHandlerCalled: Bool = false
    func themeHandler(_ theme: Theme) {
        isHandlerCalled = true
    }
}

struct ThemeSettings: ThemeModelProtocol {
    let appBgColor: String
    
    static let lightTheme = ThemeSettings(
        appBgColor: "white"
    )

    static let darkTheme = ThemeSettings(
        appBgColor: "darkGray"
    )
}

enum Theme: ThemeProtocol {
    case light
    case dark
    var settings: ThemeSettings {
        switch self {
        case .light: return ThemeSettings.lightTheme
        case .dark: return ThemeSettings.darkTheme
        }
    }
}

final class ConcreteThemeable {
    var backgroundColor: String?
    static var handledCount: Int = 0
    func themeHandler(_ theme: Theme) {
        backgroundColor = theme.settings.appBgColor
        ConcreteThemeable.handledCount += 1
    }
}
