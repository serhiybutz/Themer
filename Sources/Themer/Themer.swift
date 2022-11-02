//
//  Themer.swift
//  Themer
//
//  Created by Serhiy Butz on 5/28/19
//  Copyright © Serhiy Butz 2019
//  MIT license, see LICENSE file for details
//

import Foundation

/// A theme manager.
///
/// This class encapsulates a registry of theme handlers, which are in the form
/// of *target-actions*. It:
/// * allows the visual elements (themables) to register their theme handlers
/// * maintains the available themes
/// * observes the current theme property and in the event of its change
///   executes the targets' registered theme handlers
public final class Themer<Theme: ThemeProtocol> {
    // MARK: - Types

    typealias TargetActionStorageType = TargetActionStorage<Theme>

    // MARK: - Properties

    // The targets' associated storages of theme handlers.
    private var targetActionStorages = NSHashTable<TargetActionStorageType>
        .weakObjects()

    private let lock = NSLock()

    // The current theme's underlying storage.
    private var _theme: Theme

    /// The current theme.
    public var theme: Theme {
        get { _theme }
        set {
            guard _theme != newValue else { return; }

            lock.lock()
            defer { lock.unlock() }

            _theme = newValue

            apply()
        }
    }

    // MARK: - Initialization

    /// Creates a theme manager.
    ///
    /// - Parameter defaultTheme: The default theme.
    public init(defaultTheme: Theme) {
        self._theme = defaultTheme
    }

    /// Registers a theme handler which is in the form of *target-action*.
    ///
    /// - Parameters:
    ///   - target: The target object.
    ///   - action: The action method.
    ///
    /// - Warning: It also initially executes the registered action!
    public func register<Target: AnyObject>(
        target: Target,
        action: @escaping (Target) -> (Theme) -> ()
    ) {
        lock.lock()
        defer { lock.unlock() }

        var storage: TargetActionStorageType
        if let s = TargetActionStorageType.get(for: target) {
            storage = s
        } else {
            storage = TargetActionStorageType.setup(for: target)
            targetActionStorages.add(storage)
        }

        storage.register(target: target, action: action, initialTheme: theme)
    }
}

// MARK: - Helpers
extension Themer {
    // Embodies the notification mechanism, i.e., it iterates through all the
    // targets' associated storages and performs execution of their registered
    // theme handlers in the order of their registration (on per-target basis).
    private func apply() {
        targetActionStorages.allObjects.forEach {
            $0.applyTheme(theme)
        }
    }
}
