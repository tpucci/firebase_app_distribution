// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Copyright 2024, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import Foundation
import PackageDescription

enum ConfigurationError: Error {
  case fileNotFound(String)
  case parsingError(String)
  case invalidFormat(String)
}

let packageDirectory = String(URL(string: #file)!.deletingLastPathComponent().absoluteString
  .dropLast())

func loadFirebaseSDKVersion() throws -> String {
  let firebaseCoreScriptPath = NSString.path(withComponents: [
    packageDirectory,
    "..",
    "generated_firebase_sdk_version.txt",
  ])
  do {
    return try String(contentsOfFile: firebaseCoreScriptPath, encoding: .utf8)
      .trimmingCharacters(in: .whitespacesAndNewlines)
  } catch {
    throw ConfigurationError
      .fileNotFound("Error loading or parsing generated_firebase_sdk_version.txt: \(error)")
  }
}

func loadPubspecVersion() throws -> String {
  let pubspecPath = NSString.path(withComponents: [
    packageDirectory,
    "..",
    "..",
    "pubspec.yaml",
  ])
  do {
    let yamlString = try String(contentsOfFile: pubspecPath, encoding: .utf8)
    let lines = yamlString.split(separator: "\n")

    guard let packageVersionLine = lines.first(where: { $0.starts(with: "version:") }) else {
      throw ConfigurationError.invalidFormat("No package version line found in pubspec.yaml")
    }
    var packageVersion = packageVersionLine.split(separator: ":")[1]
      .trimmingCharacters(in: .whitespaces)
      .replacingOccurrences(of: "+", with: "-")
    packageVersion = packageVersion.replacingOccurrences(of: "^", with: "")
    return packageVersion
  } catch {
    throw ConfigurationError.fileNotFound("Error loading or parsing pubspec.yaml: \(error)")
  }
}

let library_version: String
let firebase_sdk_version_string: String

do {
  library_version = try loadPubspecVersion()
  firebase_sdk_version_string = try loadFirebaseSDKVersion()
} catch {
  fatalError("Failed to load configuration: \(error)")
}

guard let firebase_sdk_version = Version(firebase_sdk_version_string) else {
  fatalError("Invalid Firebase SDK version: \(firebase_sdk_version_string)")
}

let package = Package(
  name: "firebase_app_distribution_ios",
  platforms: [
    .iOS("15.0"),
  ],
  products: [
    .library(name: "firebase-app-distribution-ios", targets: ["firebase_app_distribution_ios"]),
  ],
  dependencies: [
    .package(url: "https://github.com/firebase/firebase-ios-sdk", from: firebase_sdk_version),
  ],
  targets: [
    .target(
      name: "firebase_app_distribution_ios",
      dependencies: [
        .product(name: "FirebaseAppDistribution-Beta", package: "firebase-ios-sdk"),
      ],
      resources: [
        // TODO: If your plugin requires a privacy manifest
        // (e.g. if it uses any required reason APIs), update the PrivacyInfo.xcprivacy file
        // to describe your plugin's privacy impact, and then uncomment this line.
        // For more information, see:
        // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
        // .process("PrivacyInfo.xcprivacy"),
      ],
      cSettings: [
        .headerSearchPath("include"),
        .define("LIBRARY_VERSION", to: "\"\(library_version)\""),
        .define("LIBRARY_NAME", to: "\"flutter-fire-fad\""),
      ]
    ),
  ]
)
