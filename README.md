# SabBar

Drop-in `UITabBarController` subclass that shows a sidebar with tabs based on trait collections.

[![License MIT](https://img.shields.io/cocoapods/l/SabBar.svg)](https://raw.githubusercontent.com/macteo/SabBar/master/LICENSE) [![Version](https://img.shields.io/cocoapods/v/SabBar.svg)](https://cocoapods.org/?q=SabBar) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![travis-ci](https://travis-ci.org/macteo/SabBar.svg?branch=master)](https://travis-ci.org/macteo/SabBar)
[![codecov.io](https://codecov.io/github/macteo/SabBar/coverage.svg?branch=master)](https://codecov.io/github/macteo/SabBar?branch=master) ![Swift 3](https://img.shields.io/badge/language-Swift%203-EB7943.svg) ![iOS 8+](https://img.shields.io/badge/iOS-8+-EB7943.svg)

![split-view](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/split-view.gif)

## Description

**SabBar** aims to let you easily choose to show a sidebar with the same functionality of a `UITabBar` inside of your application, based on trait collections. To do so we've created a `UITabBarController` subclass called `SabBarController` that does most of the work. 
We've also added few options to customize the appearance of those sidebar (width, tab height, top navigation bar, header view, ecc).

 ![iPhone-landscape](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/iPhone-landscape.png)

## Features

- [x] Ready to use, just swap a class.
- [x] iPad and iPhone compatible.
- [x] Single drop-in file.
- [x] Customize sidebar appearance based on trait collections.
- [x] No dependancies.
- [x] Tests.
- [x] Supports accessibility.
- [x] Optional header view.
- [x] Work well with and without navigation bars.
- [x] Automatically grabs customizations from the `UITabBar`.
- [x] Full documentation.
- [ ] Support top, bottom and centered sidebar cells.
- [ ] Support sidebar translucency.

## Requirements

- iOS 8.0+
- Xcode 8.0+

## Documentation

[Online documentation](http://cocoadocs.org/docsets/SabBar) is available curtesy of CocoaDocs. You can also navigate it offline downloading the source code and looking inside the *docs* folder.

## Usage

Import *SabBar* module into your Swift class

```swift
import SabBar
```

or if you are writing in Objective-C

```objc
#import <SabBar/SabBar-Swift.h>
```

> Keep in mind the you have to let the project generate the Bridging Header otherwise the integration may fail.

Just replace any `UITabBarController` instance with a `SabBarController` one directly on Storyboards or programmatically.

![custom-class](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/custom-class.jpg)

🎉

### Sample project

In the *Sample* folder you can find a sample project with few lines of code in the `AppDelegate` class for a jumpstart.

> Unfortunately you cannot create a subclass written on Objective-C of a Swift class, so you *can* use **SabBar** in an Objective-C project, but if you need to subclass the `SubBarController` you are forced to do it in Swift.

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build Marklight.

To integrate **SabBar** into your Xcode project using CocoaPods, specify it in your `Podfile`:

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

Add the *SabBar* Xcode project to your own. Then add the `SabBar` framework to the embedded binaries of your app's target.

### Manually as source file

Just drag & drop the *SabBar.swift* source file from the *Sources* folder in your Xcode project.

## Issues and bugs

Feel free to open an [issue](https://github.com/macteo/SabBar/issues) reporting a problem or requesting a new feature.

## Acknowledgements

* Matteo Gavagnin – [@macteo](https://twitter.com/macteo)
* [Dimension S.r.l.](http://dimension.it)

## License

SabBar is released under the MIT license. See [LICENSE](https://raw.githubusercontent.com/macteo/SabBar/master/LICENSE) for details.
