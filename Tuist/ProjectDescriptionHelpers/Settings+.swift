//
//  Settings+.swift
//  ProjectDescriptionHelpers
//
//  Created by 조용인 on 12/13/25.
//

import Foundation
import ProjectDescription

extension Settings {
    public static let release = Self.settings(
        base: [
            "OTHER_LDFLAGS": ["-ObjC"],
            "DEVELOPMENT_TEAM": "6NXQDZ68FD",
            "CODE_SIGN_STYLE": "Manual",
            "PROVISIONING_PROFILE_SPECIFIER": "match Development com.pida.me.ios",
            "CODE_SIGN_IDENTITY": "Apple Development: yongin cho (B2J2829PJ5)",
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon"
        ],
        configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
        ]
    )

    public static let dev = Self.settings(
        base: [
            "OTHER_LDFLAGS": ["-ObjC"],
            "DEVELOPMENT_TEAM": "6NXQDZ68FD",
            "CODE_SIGN_STYLE": "Manual",
            "PROVISIONING_PROFILE_SPECIFIER": "match Development com.pida.me.ios-dev",
            "CODE_SIGN_IDENTITY": "Apple Development: yongin cho (B2J2829PJ5)",
            "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon_dev"
        ],
        configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
        ]
    )
    
    public static let `default` = Self.settings(
        base: [
            "OTHER_LDFLAGS": ["-ObjC"]
        ],
        configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("Config/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("Config/Release.xcconfig")),
        ])
}

extension Project.Options.TextSettings {
    public static let `default` = Self.textSettings(
        indentWidth: 2,
        tabWidth: 2,
        wrapsLines: true
    )
}

extension Project.Options {
    public static let `default` = Self.options(
        //    automaticSchemesOptions: .disabled,
        defaultKnownRegions: ["ko"],
        developmentRegion: "ko",
        textSettings: .default
    )
}
