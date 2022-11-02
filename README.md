<p align="center">
    <img src="https://raw.githubusercontent.com/SerhiyButz/Themer/master/Logo.png" width="500" max-width="50%" alt="Wrap" />
</p>

<p align="center">
    <a href="https://github.com/SerhiyButz/Themer">Themer</a>
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Swift-4.2-orange" alt="Swift" />
    <img src="https://img.shields.io/badge/platform-macOS%20|%20iOS-orange.svg" alt="Platform" />
    <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-orange" alt="SPM" />
    <img src="https://github.com/SerhiyButz/Themer/workflows/Swift/badge.svg" alt="CI" />
    <a href="https://codecov.io/gh/SerhiyButz/Themer">
      <img src="https://codecov.io/gh/SerhiyButz/Themer/branch/master/graph/badge.svg" />
    </a>
    <a href="https://github.com/SerhiyButz/Themer/blob/master/LICENSE">
        <img src="https://img.shields.io/badge/licence-MIT-orange" alt="License" />
    </a>
</p>
Themer is a lightweight theme manager for iOS which provides theming for the whole app and allows toggling the current theme, all at once. It was developed by striving for the highest flexibility and cleanness of theming code and to provide a universal solution suitable even for pre-iOS 13 devices.

## Table of Contents

- [Features & Benefits](#features--benefits)
- [How](#how)
- [Get started](#get-started)
- [Installation](#installation)
  - [Swift Package as dependendcy in Xcode 11+](#swift-package-as-dependency-in-xcode-11)
  - [Manually](#manually)
- [License](#license)

## Features & Benefits

- [x] A flexible and extensible theming facility to the entire app
- [x] A clean theming code
- [x] A clear boundary between the look and the logic
- [x] Compatibility with pre-iOS 13 devices

## How

By integrating **Themer** into your app and configuring. Here're the steps: 
1. Instantiate the theme manager singleton, an instance of the `Themer` class.
2. Configure it with your app themes.
3. For each themable visual element, add a theme-handling method(s) and register it with **Themer**.
4. Whenever needed, toggle the current theme using **Themer**'s `theme` property.

## Get started

1. First, declare a model for your theme settings, which will represent a collection of the available theme attributes in your app, like in the example below.

    ```swift
    import Themer
    ...
    struct MyThemeSettings: ThemeModelProtocol {
        let appBgColor: UIColor
        let textColor: UIColor
    }
    ```

1. Define your themes (theme settings instances).

    ```swift
    extension MyThemeSettings {
        static let lightTheme = MyThemeSettings(
            appBgColor: .white,
            textColor: .black
        )
        static let darkTheme = MyThemeSettings(
            appBgColor: .gray,
            textColor: .white
        )
    }
    ```

    Here, the extension serves for better code organizing.

1. Declare your app's theme enum, which is the key in configuring and using the theme manager.

    ```swift
    import Themer
    ...
    enum MyTheme: ThemeProtocol {
        case light
        case dark
        var settings: MyThemeSettings {
            switch self {
            case .light: return MyThemeSettings.lightTheme
            case .dark: return MyThemeSettings.darkTheme
            }
        }
    }
    ```

    Here, the enum's cases behave like “tags” to refer to the available themes. The computed property `settings` maps the enum's cases to their respective theme instances.

1. To integrate the theme manager, in your app define the theme manager's singleton, as shown below.

    ```swift
    import Themer
    ...
    extension Themer where Theme == MyTheme {
        private static var instance: Themer?
        static var shared: Themer {
            if instance == nil {
                instance = Themer(defaultTheme: .light)
            }
            return instance!
        }
    }
    ```

    Notice how the theme manager is configured with the enum `MyTheme`  (via the `Theme` generic parameter constraining with the `where` clause) , defined in step 3.

1. Define theme-handling method(s) for each themable visual element, like below for a hypothetical `ThemableViewController`, like in the example below.

    ```swift
    extension ThemableViewController {
        /// Handles Themer's theme toggle notifications.
        ///
        /// - Parameter theme: The new theme.
        private func handleTheme(_ theme: MyTheme) {
            view.backgroundColor = theme.settings.appBgColor
            ...
        }
    }
    ```

    The `handleTheme(_:)` method is where you put all theme configuring code for `ThemableViewController`. The theme-handler methods can be named arbitrarily. Specific theme attributes can be reached by referring to the `settings` property, which provides access to them.

1. Now, by using **Themer**'s method `register(target:action:)` register `ThemableViewController`'s theme-handling method(s), like in the example below.

    ```swift
    import Themer
    ...
    class ThemableViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            // Subscribe to theme notifications.
            Themer.shared.register(target: self,
                                   action: ThemableViewController.handleTheme)
        }
    }
    ```

    Note: you should register theme-handling method(s) in the point where their targets (i.e., the visual elements) are ready for *immediate* theming, as the initial theme applying (with the default theme) is performed at that very moment!

1. Whenever you need to toggle the current theme, you just write, as shown below.

    ```swift
    import Themer
    ...
    Themer.shared.theme = .dark
    ```

## Installation

### Swift Package as dependency in Xcode 11+

1. Go to "File" -> "Swift Packages" -> "Add Package Dependency"
2. Paste Themer repository URL into the search field:

`https://github.com/SerhiyButz/Themer.git`

3. Click "Next"

4. Ensure that the "Rules" field is set to something like this: "Version: Up To Next Major: 1.1.0"

5. Click "Next" to finish

For more info, check out [here](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

### Manually

Simply Copy and Paste `Source/Themer` files in your Xcode Project.

## License

This project is licensed under the MIT license.
