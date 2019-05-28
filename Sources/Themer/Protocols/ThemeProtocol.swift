//
//  ThemeProtocol.swift
//  Themer
//
//  Created by Serge Bouts on 5/28/19
//  Copyright © Serge Bouts 2019
//  MIT license, see LICENSE file for details
//

/// Protocol to be adopted by the client app's theme enum.
///
/// The theme enum's cases are mapped to the available theme model
/// instances with the `settings` computed property.
public protocol ThemeProtocol: Equatable {
    associatedtype Model: ThemeModelProtocol
    var settings: Model { get }
}
