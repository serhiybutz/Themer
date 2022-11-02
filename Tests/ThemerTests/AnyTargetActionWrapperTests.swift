//
//  AnyTargetActionWrapperTests.swift
//
//
//  Created by Serhiy Butz.
//

import XCTest
@testable import Themer

final class AnyTargetActionWrapperTests: XCTestCase {
    var sut: AnyTargetActionWrapper<EmptyThemeTarget.Theme>!

    override func tearDown() {
        sut = nil
    }

    func test_isNotRetained() {
        // Given

        var target: EmptyThemeTarget? = EmptyThemeTarget()

        weak var weakTarget = target

        sut = AnyTargetActionWrapper(
            target: target!,  // doesn't retain the themable object
            action: EmptyThemeTarget.themeHandler)

        // When

        target = nil

        // Then

        XCTAssertNil(weakTarget)
    }

    func test_themeHandlerIsCalled() {
        // Given

        let target = SingleThemeTarget()  // retain the themable object

        let sut2 = AnyTargetActionWrapper(
            target: target,
            action: SingleThemeTarget.themeHandler)

        // When
        // Then

        XCTAssertFalse(target.isHandlerCalled)

        // When

        sut2.applyTheme(.default)

        // Then
        XCTAssertTrue(target.isHandlerCalled)
    }
}
