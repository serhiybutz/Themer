//
//  ThemerTests.swift
//
//
//  Created by Serhiy Butz.
//

import XCTest
@testable import Themer

final class ThemerTests: XCTestCase {

    typealias SUT = Themer<Theme>
    var sut: SUT!

    override func setUp() {
        sut = Themer<Theme>(defaultTheme: .light)
    }

    override func tearDown() {
        sut = nil
        ConcreteThemeable.handledCount = 0
    }

    func text_registerDoesntRetain() {
        // Given

        var foo = ConcreteThemeable()

        // When

        sut.register(target: foo, action: ConcreteThemeable.themeHandler)

        // Then

        XCTAssertTrue(isKnownUniquelyReferenced(&foo))
    }

    func test_singleTarget() {
        // Given

        let foo = ConcreteThemeable()
        XCTAssertEqual(ConcreteThemeable.handledCount, 0)
        XCTAssertNil(foo.backgroundColor)

        // (1)

        //  - When

        sut.register(target: foo, action: ConcreteThemeable.themeHandler)

        //  - Then

        XCTAssertEqual(ConcreteThemeable.handledCount, 1)
        XCTAssertNotNil(foo.backgroundColor)
        XCTAssertEqual(foo.backgroundColor, Theme.light.settings.appBgColor)

        // (2) Toggle to the dark theme

        //  - When

        sut.theme = .dark

        //  - Then

        XCTAssertEqual(ConcreteThemeable.handledCount, 2)
        XCTAssertEqual(foo.backgroundColor, Theme.dark.settings.appBgColor)

        // (3) Toggle back to the light theme

        //  - When

        sut.theme = .light

        //  - Then

        XCTAssertEqual(ConcreteThemeable.handledCount, 3)
        XCTAssertEqual(foo.backgroundColor, Theme.light.settings.appBgColor)
    }

    func test_twoTargets() {
        // Given

        // (1) Create first themable

        //  - When

        let foo1 = ConcreteThemeable()

        //  - Then

        XCTAssertEqual(ConcreteThemeable.handledCount, 0)
        XCTAssertNil(foo1.backgroundColor)

        // (2)

        //  - When

        sut.register(target: foo1, action: ConcreteThemeable.themeHandler)

        //  - Then

        XCTAssertEqual(ConcreteThemeable.handledCount, 1)
        XCTAssertNotNil(foo1.backgroundColor)
        XCTAssertEqual(foo1.backgroundColor, Theme.light.settings.appBgColor)

        // (3) Create second themable

        //  - When

        let foo2 = ConcreteThemeable()

        //  - Then

        XCTAssertNil(foo2.backgroundColor)

        // (4)

        //  - When

        sut.register(target: foo2, action: ConcreteThemeable.themeHandler)

        //  - Then

        XCTAssertEqual(ConcreteThemeable.handledCount, 2)
        XCTAssertNotNil(foo2.backgroundColor)
        XCTAssertEqual(foo2.backgroundColor, Theme.light.settings.appBgColor)

        // (5) Toggle to the dark theme

        //  - When

        sut.theme = .dark

        //  - Then

        XCTAssertEqual(ConcreteThemeable.handledCount, 4)
        XCTAssertEqual(foo1.backgroundColor, Theme.dark.settings.appBgColor)
        XCTAssertEqual(foo2.backgroundColor, Theme.dark.settings.appBgColor)

        // (6) Toggle back to the light theme

        //  - When

        sut.theme = .light

        //  - Then

        XCTAssertEqual(ConcreteThemeable.handledCount, 6)
        XCTAssertEqual(foo1.backgroundColor, Theme.light.settings.appBgColor)
        XCTAssertEqual(foo2.backgroundColor, Theme.light.settings.appBgColor)
    }

    func test_targetsAutounregisterUponDeallocation() {
        // Given

        var foo1: ConcreteThemeable? = ConcreteThemeable()
        sut.register(target: foo1!, action: ConcreteThemeable.themeHandler)

        var foo2: ConcreteThemeable? = ConcreteThemeable()
        sut.register(target: foo2!, action: ConcreteThemeable.themeHandler)

        XCTAssertEqual(ConcreteThemeable.handledCount, 2)

        // (1) Toggle to the dark theme

        //  - When

        sut.theme = .dark

        //  - Then

        XCTAssertEqual(ConcreteThemeable.handledCount, 4)

        // (2) Deallocate the first themable

        //  - When

        foo1 = nil

        sut.theme = .light

        //  - Then

        XCTAssertEqual(ConcreteThemeable.handledCount, 5)

        // (3) Deallocate the second themable

        //  - When

        foo2 = nil

        sut.theme = .dark

        //  - Then
        
        XCTAssertEqual(ConcreteThemeable.handledCount, 5)
    }
}
