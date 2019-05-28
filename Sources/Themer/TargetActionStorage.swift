//
//  TargetActionStorage.swift
//  Themer
//
//  Created by Serge Bouts on 5/28/19
//  Copyright © Serge Bouts 2019
//  MIT license, see LICENSE file for details
//

import Foundation

fileprivate var associatedKey = "ThemerTargetActionStorage"

// The object-associated storage, which is attached to the targets (themable visual
// elements) and stores the relevant target's registered *target-actions*
// (theme handlers).
final class TargetActionStorage<Theme: ThemeProtocol> {
    private var targetActions: [AnyTargetActionWrapper<Theme>] = []

    static func setup(for target: Any) -> TargetActionStorage {
        let storage = TargetActionStorage()
        objc_setAssociatedObject(
            target,
            &associatedKey,
            storage,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        return storage
    }

    static func get(for target: Any) -> TargetActionStorage? {
        return objc_getAssociatedObject(target, &associatedKey).map { $0 as! TargetActionStorage }
    }

    func register<Target: AnyObject>(target: Target, action: @escaping (Target) -> (Theme) -> (), initialTheme: Theme) {
        let ta = AnyTargetActionWrapper(target: target, action: action)
        targetActions.append(ta)
        ta.applyTheme(initialTheme)
    }

    func applyTheme(_ theme: Theme) {
        targetActions.forEach {
            $0.applyTheme(theme)
        }
    }
}
