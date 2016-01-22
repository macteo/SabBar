// The MIT License (MIT)
//
// Copyright © 2016 Matteo Gavagnin
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
import SabBar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SabBarControllerDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if let sabBarController = window?.rootViewController as? SabBarController {
            sabBarController.sabBarDelegate = self
            
            sabBarController.hasNavigation = true
            
            sabBarController.separateHeader = true
            
            let size : CGFloat = 40.0
            let userView = UIImageView(frame: CGRect(x: 0, y: 0, width: size, height: size))
            userView.backgroundColor = UIColor.clearColor()
            userView.clipsToBounds = true
            
            let image = UIImage(named: "SabBar")
            userView.image = image
            
            userView.layer.cornerRadius = 8
            sabBarController.headerView = userView
        }
        
        return true
    }
    
    func shouldShowSidebar(controller: SabBarController, traitCollection: UITraitCollection) -> Bool {
        if traitCollection.horizontalSizeClass == .Regular || traitCollection.verticalSizeClass == .Compact {
            return true
        } else {
            return false
        }
    }
}

