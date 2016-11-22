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

import XCTest
@testable import SabBar

class SabBarTests: XCTestCase, SabBarControllerDelegate {
    let sabBarController = SabBarController()
    
    override func setUp() {
        super.setUp()
        sabBarController.view.frame = CGRect(x: 0, y: 0, width: 600, height: 600)
        sabBarController.viewWillAppear(true)
        sabBarController.viewDidAppear(true)
        sabBarController.sabBarDelegate = self
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testHeader() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        sabBarController.hasNavigation = true
        sabBarController.headerView = header
        XCTAssert(sabBarController.navigationBar.subviews[1] == header)
    }
    
    func testToolbarTintColor() {
        let tint = UIColor.red
        sabBarController.tabBar.barTintColor = tint
        sabBarController.buildSidebarView()
        XCTAssert(sabBarController.toolbar.barTintColor == tint)
    }
    
    func testOneTab() {
        let genericController = UIViewController()
        genericController.title = "Test Controller"
        sabBarController.viewControllers = [genericController]
        sabBarController.buildSidebarView()
        sabBarController.tabTable.reloadData()
        XCTAssert(sabBarController.tabBar.items?.count == 1)
        XCTAssert(sabBarController.tabTable.numberOfRows(inSection: 0) == 1)
        
        let indexPath = IndexPath(row: 0, section: 0)
        _ = sabBarController.tableView(sabBarController.tabTable, cellForRowAt: indexPath)
        if let cell = sabBarController.tabTable.cellForRow(at: indexPath) as? SabBarCell {
            XCTAssert(cell.tabLabel.text == genericController.title)
        }
        
        XCTAssert(sabBarController.selectedIndex == 0)
    }
    
    func testTwoTabs() {
        let genericController = UIViewController()
        let genericControllerTwo = UIViewController()
        sabBarController.viewControllers = [genericController, genericControllerTwo]
        sabBarController.tabTable.reloadData()
        XCTAssert(sabBarController.tabBar.items?.count == 2)
        XCTAssert(sabBarController.tabTable.numberOfRows(inSection: 0) == 2)
    }
    
    func testChangeTab() {
        let genericController = UIViewController()
        let genericControllerTwo = UIViewController()
        sabBarController.viewControllers = [genericController, genericControllerTwo]
        sabBarController.tabTable.reloadData()
        
        let selectedTab = sabBarController.tabBar.items![1]
        
        sabBarController.selectedIndex = 1
        sabBarController.tabBar(sabBarController.tabBar, didSelect: selectedTab)
        
        XCTAssert(sabBarController.tabBar.selectedItem! == sabBarController.tabBar.items![1])
        
        let indexPath = IndexPath(row: 1, section: 0)
        
        _ = sabBarController.tableView(sabBarController.tabTable, cellForRowAt: indexPath)
        if let cell = sabBarController.tabTable.cellForRow(at: indexPath) as? SabBarCell {
            XCTAssert(cell.isSelected == true)
        }
    }
    
    func testImageTint() {
        let tint = UIColor.red
        sabBarController.imageTint = tint
        
        let genericController = UIViewController()
        sabBarController.viewControllers = [genericController]
        sabBarController.buildSidebarView()
        sabBarController.tabTable.reloadData()
        
        let indexPath = IndexPath(row: 0, section: 0)
        _ = sabBarController.tableView(sabBarController.tabTable, cellForRowAt: indexPath)
        if let cell = sabBarController.tabTable.cellForRow(at: indexPath) as? SabBarCell {
            XCTAssert(cell.tintColor == tint)
        }
    }
    
    func shouldShowSidebar(_ controller: SabBarController, traitCollection: UITraitCollection) -> Bool {
        return true
    }
}
