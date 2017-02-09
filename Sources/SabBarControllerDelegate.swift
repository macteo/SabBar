// The MIT License (MIT)
//
// Copyright © 2016-2017 Matteo Gavagnin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

/**
 Implement this protocol to control sidebar appearance based on the current trait
 collection.
 */

@objc public protocol SabBarControllerDelegate {
    
    /**
     Whenever the `traitCollection` is changed the `SabBarController` asks its
     `sabBarDelegate` (if set) to specify the visibility of the sidebar. If the
     sidebar is visible, the tabBar will be hidden and vice versa.
     
     Default values are:
     
     ```swift
     if traitCollection.horizontalSizeClass == .Regular ||
     traitCollection.verticalSizeClass == .Compact {
     return true
     } else {
     return false
     }
     ```
     
     - parameter controller: the `SabBarController` that is performing the
     request.
     - parameter traitCollection: the current `UITraitCollection`.
     - returns: if the sidebar should be visible or not.
     */
    func shouldShowSidebar(_ controller: SabBarController, traitCollection: UITraitCollection) -> Bool
}
