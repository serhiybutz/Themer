//
//  TargetAction.swift
//  Themer
//
//  Created by Serhiy Butz on 5/28/19
//  Copyright © Serhiy Butz 2019
//  MIT license, see LICENSE file for details
//

// A generic protocol to be adopted by type-erased `AnyTargetActionWrapper`s.
protocol TargetAction {
    associatedtype Theme: ThemeProtocol
    func applyTheme(_ theme: Theme)
}
