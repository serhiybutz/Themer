// swift-tools-version:5.1

//
//  Themer
//  Copyright (c) Serge Bouts 2019
//  MIT license, see LICENSE file for details
//

import PackageDescription

let package = Package(
    name: "Themer",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_14),
    ],
    products: [
        .library(
            name: "Themer",
            targets: ["Themer"]),
    ],
    targets: [
        .target(
            name: "Themer",
            dependencies: []),
        .testTarget(
            name: "ThemerTests",
            dependencies: ["Themer"]),
    ]
)
