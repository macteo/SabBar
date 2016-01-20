# SabBar

Drop-in `UITabBarController` subclass that support lateral tabs based on size classes.

[![License MIT](https://img.shields.io/cocoapods/l/SabBar.svg)](https://raw.githubusercontent.com/macteo/SabBar/master/LICENSE) [![Version](https://img.shields.io/cocoapods/v/SabBar.svg)](https://cocoapods.org/?q=SabBar) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![travis-ci](https://travis-ci.org/macteo/SabBar.svg?branch=master)](https://travis-ci.org/macteo/SabBar)
[![codecov.io](https://codecov.io/github/macteo/SabBar/coverage.svg?branch=master)](https://codecov.io/github/macteo/SabBar?branch=master)

## Description

## Features

- [x] Fix iPhone 6 Landscape navigation bar height.
- [x] Standalone project.
- [ ] Readme.
- [ ] Medium Article.
- [ ] Screenshots.
- [ ] Documentation.
- [x] CocoaPods.
- [x] Carthage.
- [x] Swift package manager.
- [x] Tests.
- [x] Single drop-in class.
- [x] Accessibility.
- [x] Bar background tint.
- [x] Blending layer (table view).
- [x] Remove xib.
- [x] Refactor code.
- [x] License.
- [x] Changelog.
- [x] Add header button.
- [x] Control on which size classes show which bar.
- [ ] Support top, bottom and centered sidebar cells.
- [x] Support different selected image.
- [ ] Continuous integration with travis.
- [ ] Code Coverage.
- [ ] Push on github.
- [x] Design icon.
- [ ] Tab Bar images.
- [x] User icon for the header.
- [ ] Record Gif.

## Requirements

- iOS 8.0+
- Xcode 7.1+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build Marklight.

To integrate SabBar into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!
target "YourTargetName" do
    pod 'SabBar'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install [Carthage](https://github.com/Carthage/Carthage) with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Marklight into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```ogdl
github "macteo/SabBar"
```

Run `carthage update --platform iOS` to build the framework and drag the built `SabBar.framework` into your Xcode project.

### Manually as a Framework

Add the *SabBar* Xcode project to your own. Then add the `SabBar` framework as desired to the embedded binaries of your app's target.

### Manually as source file

Just drag & drop the *SabBar.swift* source file from the *Sources* folder in your Xcode project.

## Usage

In this repository you can find a sample project with few lines of code in the `ViewController` class for a jumpstart.

*Sample code is written in Swift but Objective-C should be supported too, if you find an incompatibility please open an issue.*

### Integration

## Acknowledgements

* Matteo Gavagnin – [@macteo](https://twitter.com/macteo)
* [Dimension S.r.l.](http://dimension.it)

## License

SabBar is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/macteo/SabBar/master/LICENSE) for details.
