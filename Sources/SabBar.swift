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

/**
 `SabBarController` is a subclass of `UITabBarController` that adds the option
 to show a sidebar with tabs instead of the classic `UITabBar` based on trait 
 collections.
 
 ![iPhone-landscape](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/iPhone-landscape.png)
 
 In order to use it, just instantiate it instead of the standard 
 `UITabBarController` programmatically or within Storyboards.
 
 ![custom-class](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/custom-class.jpg)
 */
open class SabBarController: UITabBarController, UITableViewDataSource, UITableViewDelegate {

// MARK: Constants and properties
    
    internal var sidebar = UIView()
    internal let toolbar = UIToolbar()
    internal let tabTable = UITableView(frame: CGRect.zero, style: .plain)

    fileprivate var navigationBarHeight : CGFloat {
        return navigationBarHeight(self.traitCollection)
    }
    
    fileprivate func navigationBarHeight(_ traitCollection : UITraitCollection) -> CGFloat {
        if traitCollection.verticalSizeClass == .compact && traitCollection.horizontalSizeClass == .compact {
            return 32 // iPhone 6 and below in landscape
        } else {
            return 44 // iPhone 6 Plus and above
        }
    }
    
    fileprivate let statusBarHeight : CGFloat = 20
    fileprivate var sidebarWidthConstraint : NSLayoutConstraint?
    fileprivate var navigationBarWidthConstraint : NSLayoutConstraint?
    fileprivate var navigationBarHeightConstraint : NSLayoutConstraint?
    fileprivate var headerViewCenterConstraint : NSLayoutConstraint?
    
// MARK: User customizable properties
    
    /**
     Specify the sidebar width, default 80 points.
     
     ![sidebar-width](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/sidebar-width.png)
     */
    @IBInspectable open var sidebarWidth : CGFloat = 80.0

    /**
     Specify the height of each tab inside the sidebar, dafault 60 points.
     
     ![sidebar-width](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/tab-height.png)
     */
    @IBInspectable open var tabHeight : CGFloat = 60.0
    
    /**
     By default the sidebar starts directly from the top of the view, use this
     property to ad a `UINavigationBar` above it.
     
     ![sidebar-width](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/has-navigation.png)
     */
    @IBInspectable open var hasNavigation : Bool = false

    /**
     If you has enabled the `hasNavigation` property, you may want to add a
     hairline border right beside it to function as separator.
     
     ![sidebar-width](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/separate-header.png)
     */
    @IBInspectable open var separateHeader : Bool = false
    
    /**
     Access the navigation bar, if enabled, to set its tint and behavior.
     */
    open let navigationBar = UINavigationBar()
    
    /**
     Specify a background color behind the sidebar, this will affect its color 
     if translucent. Default color is white.
     */
    @IBInspectable open var backgroundColor : UIColor = UIColor.white {
        didSet {
            self.view.backgroundColor = backgroundColor
        }
    }
    
    /**
     Choose a tint for the tabBar and the sidebar.
     */
    @IBInspectable open var imageTint : UIColor? {
        didSet {
            tabBar.tintColor = imageTint
        }
    }
    
    /**
     If you enabled the `hasNavigation` property, you can add a `UIView`, or one
     of its subclasses like `UIButton`. This will be automatically centered 
     above the sidebar. Keep in mind that If you exceed 32 points for its height
     it will overlap the navigation bar on devices smaller that the iPhone 6+ 
     in landscape.
     
     ![sidebar-width](https://raw.githubusercontent.com/macteo/SabBar/master/Assets/Readme/header-view.png)
     */
    @IBOutlet open var headerView : UIView? {
        willSet {
            if let headerView = headerView {
                headerView.removeFromSuperview()
            }
        }
        didSet {
            if hasNavigation == true {
                if let headerView = headerView {
                    navigationBar.addSubview(headerView)
                    headerView.translatesAutoresizingMaskIntoConstraints = false
                    centerHeaderView(navigationBarHeight)
                }
            } else if headerView != nil {
                print("hasNavigation on SabBarController must be enabled to display the headerView")
            }
        }
    }
    
    /**
     You can register a class that conforms to the `SabBarControllerDelegate`
     protocol in order to manage if you want to show or hide the sidebar, based
     on trait collections.
     */
    @IBOutlet open var sabBarDelegate : SabBarControllerDelegate?

// MARK: Sidebar visibility
    
    /**
     Toggle the Sidebar visibility programmatically.
    
     Sidebar and tabBar are mutually exclusive.
     
     - parameter visible: if the sidebar should be visibile or not.
     */
    open func toggleSidebar(visible: Bool) {
        if visible == false {
            self.sidebarWidthConstraint?.constant = 0
            self.navigationBar.isHidden = true
            self.tabBar.isHidden = false
        } else {
            self.sidebarWidthConstraint?.constant = self.sidebarWidth
            self.tabBar.isHidden = true
            self.navigationBar.isHidden = false
        }
    }

// MARK: View lifecycle
    
    /**
     Building sidebar view and setting so many layout constraints.
     
     - warning: You are not supposed to call this method directly.
     */
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "View"
        
        buildSidebarView()
    }
    
    /**
     We ensure to show or hide the sidebar and the tabBar based on the current trait collection.
     
     - warning: You are not supposed to call this method directly.
     */
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showAndHideSidebar(traitCollection)
    }
    
    /**
     Just selecting the correct sidebar tab.
     
     - warning: You are not supposed to call this method directly.
     */
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let _ = tabTable.indexPathForSelectedRow else {
            tabTable.selectRow(at: IndexPath(row: selectedIndex, section: 0), animated: true, scrollPosition: .none)
            return
        }
    }
    
// MARK: Private shortcuts methods
    
    /**
     Just a shortcut to get the status bar height in realtime, based on its
     visibility status.
     */
    fileprivate var statusHeight : CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    /**
     Detect which is the index of the selected `UITabBar` item.
     */
    func selectedIndex(_ item: UITabBarItem?) -> Int {
        var index = 0
        for _item in tabBar.items! {
            if _item == item {
                return index
            }
            index = index + 1
        }
        return 0
    }
    
    /**
     We need the view that contains the child controller's views in order to set
     its leading constraint to create space for the sidebar.
     
     - warning: On iOS 8 and 9 it is the first subview of the tab bar controller
     */
    fileprivate var contentView : UIView {
        return self.view.subviews[0]
    }

// MARK: Sidebar table view delegate
    
    /**
     Sidebar is a table view and in order to populate it with tabs the 
     `SabBarController` is its delegate.
    
     - warning: You are not supposed to call this method directly.
    */
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tabHeight
    }
    
    /**
     Sidebar is a table view and in order to populate it with tabs the
     `SabBarController` is its delegate.
     
     - warning: You are not supposed to call this method directly.
     */
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return statusHeight
    }
    
    /**
     Sidebar is a table view and in order to populate it with tabs the
     `SabBarController` is its delegate.
     
     - warning: You are not supposed to call this method directly.
     */
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: sidebarWidth, height: statusHeight))
        header.backgroundColor = UIColor.clear
        return header
    }
    
    /**
     Sidebar is a table view and in order to populate it with tabs the
     `SabBarController` is its delegate.
     
     - warning: You are not supposed to call this method directly.
     */
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
    }

// MARK: Sidebar table view data source
    
    /**
     Sidebar is a table view and in order to populate it with tabs the
     `SabBarController` is its data source.
     
     - warning: You are not supposed to call this method directly.
     */
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    /**
     Sidebar is a table view and in order to populate it with tabs the
     `SabBarController` is its data source.
     
     - warning: You are not supposed to call this method directly.
     */
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = tabBar.items {
            return items.count
        }
        return 0
    }
    
    /**
     Sidebar is a table view and in order to populate it with tabs the
     `SabBarController` is its data source.
     
     - warning: You are not supposed to call this method directly, but it can 
     be freely overriden in order to customize the cell appearance.
     */
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tabCellIdentifier", for: indexPath) as! SabBarCell

        cell.tintColor = tabBar.tintColor
        
        if let item = tabBar.items?[indexPath.row] {
            cell.tabLabel.text = item.title

            cell.tabDeselectedImage = item.image?.withRenderingMode(.alwaysTemplate)
            cell.tabSelectedImage = item.selectedImage?.withRenderingMode(.alwaysTemplate)

            if tabBar.selectedItem == item {
                cell.tabImage.tintColor = cell.tintColor
                cell.tabLabel.textColor = cell.tintColor
                cell.tabImage.image = cell.tabSelectedImage
            } else {
                cell.tabImage.image = cell.tabDeselectedImage
            }
        }
        
        return cell
    }
    
// MARK: Tab bar delegate
    
    /**
    We register ourself as `UITabBarDelegate` in order to detect tab changes and
    update also the selected sidebar tab.
    
    - warning: You are not supposed to call this method directly.
    */
    override open func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabTable.selectRow(at: IndexPath(row: selectedIndex(item), section: 0), animated: true, scrollPosition: .top)
    }
    
// MARK: Adapt layout to trait collections

    /**
     In order to adapt the layout (show and hide the sidebar for example)
     to different trait collections we catch this method.
    
     - warning: You are not supposed to call this method directly.
    */
    override open func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.showAndHideSidebar(newCollection)
        }) { _ in

        }
    }

    /**
     Method to show and hide the sidebar, based on the current or a new 
     trait collection.
     */
    fileprivate func showAndHideSidebar(_ traitCollection : UITraitCollection) {
        if let sabBarDelegate = sabBarDelegate {
            let visible = sabBarDelegate.shouldShowSidebar(self, traitCollection: traitCollection)
            toggleSidebar(visible: visible)
        } else {
            if traitCollection.horizontalSizeClass == .regular || traitCollection.verticalSizeClass == .compact {
                toggleSidebar(visible: true)
            } else {
                toggleSidebar(visible: false)
            }
        }
        
        if traitCollection.verticalSizeClass == .compact {
            self.navigationBarHeightConstraint?.constant = navigationBarHeight
            self.headerViewCenterConstraint?.constant = 0
        } else {
            self.navigationBarHeightConstraint?.constant = navigationBarHeight + statusBarHeight
            self.headerViewCenterConstraint?.constant = statusBarHeight / 2.0
        }
    }
    
// MARK: Constraints and sidebar creation
    
    /**
     Setting up constraints in order to keep the header view as centered as 
     possible in relation to the navigation bar and the sidebar.
    */
    fileprivate func centerHeaderView(_ navigationHeight : CGFloat) {
        guard let headerView = headerView else { return }
        
        navigationBar.removeConstraints(headerView.constraints)
        headerView.removeConstraints(headerView.constraints)
        
        let originY = (navigationHeight - headerView.frame.size.height) / 2.0 + statusHeight
        let originX = (sidebarWidth - headerView.frame.size.width) / 2.0
        headerView.frame = CGRect(x: originX, y: originY, width: headerView.frame.size.width, height: headerView.frame.size.height)
        
        navigationBar.addConstraint(NSLayoutConstraint(item: headerView, attribute: .centerX, relatedBy: .equal, toItem: navigationBar, attribute: .centerX, multiplier: 1, constant: 0))
        headerViewCenterConstraint = NSLayoutConstraint(item: headerView, attribute: .centerY, relatedBy: .equal, toItem: navigationBar, attribute: .centerY, multiplier: 1, constant: 0)
        navigationBar.addConstraint(headerViewCenterConstraint!)
        
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .width, relatedBy: .equal, toItem: headerView, attribute: .height, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: headerView.frame.size.height))
        navigationBar.addConstraint(NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: navigationBar, attribute: .height, multiplier: 1, constant: -4))
    }

    internal func buildSidebarView() {
        sidebar.removeFromSuperview()
        
        sidebar = UIView()
        
        if hasNavigation {
            navigationBar.frame = CGRect(x: 0, y: 0, width: sidebarWidth, height: navigationBarHeight + statusHeight)
            navigationBar.translatesAutoresizingMaskIntoConstraints = false
            navigationBar.accessibilityIdentifier = "navigationBar"
            view.addSubview(navigationBar)
            
            view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
            navigationBarWidthConstraint = NSLayoutConstraint(item: navigationBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: sidebarWidth)
            view.addConstraint(navigationBarWidthConstraint!)
            
            navigationBarHeightConstraint = NSLayoutConstraint(item: navigationBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: navigationBarHeight + statusHeight)
            view.addConstraint(navigationBarHeightConstraint!)
            
            sidebar.frame = CGRect(x: 0, y: navigationBarHeight, width: sidebarWidth, height: view.bounds.height)
        } else {
            sidebar.frame = CGRect(x: 0, y: 0, width: sidebarWidth, height: view.bounds.height)
        }
        
        sidebar.accessibilityIdentifier = "Sidebar"
        
        // We don't use a UIVisualEffectView so we are able to match the `UITabBar` `barTintColor`.
        // We use the old fashion rotated `UIToolbar`.
        // If you know a better way, please tell me.
        
        /*
        
        let blurEffect = UIBlurEffect(style: .ExtraLight)
        let visualEffectBackground = UIVisualEffectView(effect: blurEffect)
        visualEffectBackground.frame = sidebar.bounds
        visualEffectBackground.translatesAutoresizingMaskIntoConstraints = false
        visualEffectBackground.accessibilityIdentifier = "visualEffectBackground"
        sidebar.addSubview(visualEffectBackground)
        
        sidebar.addConstraint(NSLayoutConstraint(item: visualEffectBackground, attribute: .Top, relatedBy: .Equal, toItem: sidebar, attribute: .Top, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: visualEffectBackground, attribute: .Bottom, relatedBy: .Equal, toItem: sidebar, attribute: .Bottom, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: visualEffectBackground, attribute: .Leading, relatedBy: .Equal, toItem: sidebar, attribute: .Leading, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: visualEffectBackground, attribute: .Trailing, relatedBy: .Equal, toItem: sidebar, attribute: .Trailing, multiplier: 1, constant: 0))
        
        visualEffectBackground.backgroundColor = tabBar.barTintColor
        
        */
        
        toolbar.frame = CGRect(x: 0, y: 0, width: sidebar.bounds.size.height, height: sidebar.bounds.size.width)
        toolbar.accessibilityIdentifier = "Toolbar"
        toolbar.center = sidebar.center
        toolbar.barTintColor = tabBar.barTintColor
        sidebar.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        sidebar.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .top, relatedBy: .equal, toItem: sidebar, attribute: .top, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .bottom, relatedBy: .equal, toItem: sidebar, attribute: .bottom, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .leading, relatedBy: .equal, toItem: sidebar, attribute: .leading, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .trailing, relatedBy: .equal, toItem: sidebar, attribute: .trailing, multiplier: 1, constant: 0))
        
        tabTable.frame = sidebar.bounds
        tabTable.delegate = self
        tabTable.dataSource = self
        
        tabTable.isScrollEnabled = false
        
        tabTable.backgroundColor = UIColor.clear
        
        tabTable.register(SabBarCell.self, forCellReuseIdentifier: "tabCellIdentifier")
        tabTable.separatorColor = UIColor.clear
        
        tabTable.translatesAutoresizingMaskIntoConstraints = false
        tabTable.accessibilityIdentifier = "tabTable"
        
        sidebar.addSubview(tabTable)
        
        sidebar.addConstraint(NSLayoutConstraint(item: tabTable, attribute: .top, relatedBy: .equal, toItem: sidebar, attribute: .top, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: tabTable, attribute: .bottom, relatedBy: .equal, toItem: sidebar, attribute: .bottom, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: tabTable, attribute: .leading, relatedBy: .equal, toItem: sidebar, attribute: .leading, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: tabTable, attribute: .trailing, relatedBy: .equal, toItem: sidebar, attribute: .trailing, multiplier: 1, constant: 0))
        
        let border = UIView(frame: CGRect(x: 0, y: -navigationBarHeight, width: sidebarWidth, height: sidebar.frame.size.height + navigationBarHeight))
        border.backgroundColor = UIColor.lightGray
        border.translatesAutoresizingMaskIntoConstraints = false
        border.accessibilityIdentifier = "Border"
        view.sendSubview(toBack: border)
        
        sidebar.addSubview(border)
        sidebar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sidebar)
        view.backgroundColor = backgroundColor
        
        if hasNavigation {
            view.addConstraint(NSLayoutConstraint(item: sidebar, attribute: .top, relatedBy: .equal, toItem: navigationBar, attribute: .bottom, multiplier: 1, constant: 0))
            view.bringSubview(toFront: navigationBar)
        } else {
            view.addConstraint(NSLayoutConstraint(item: sidebar, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        }
        
        view.addConstraint(NSLayoutConstraint(item: sidebar, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: sidebar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        
        sidebarWidthConstraint = NSLayoutConstraint(item: sidebar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: sidebarWidth)
        view.addConstraint(sidebarWidthConstraint!)
        
        if separateHeader == false {
            sidebar.addConstraint(NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: sidebar, attribute: .top, multiplier: 1, constant: 0))
        } else {
            view.addConstraint(NSLayoutConstraint(item: border, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        }
        
        sidebar.addConstraint(NSLayoutConstraint(item: border, attribute: .bottom, relatedBy: .equal, toItem: sidebar, attribute: .bottom, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: border, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (1 / UIScreen.main.scale)))
        sidebar.addConstraint(NSLayoutConstraint(item: border, attribute: .leading, relatedBy: .equal, toItem: sidebar, attribute: .trailing, multiplier: 1, constant: 0))
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .leading, relatedBy: .equal, toItem: sidebar, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
    }
}

class SabBarCell: UITableViewCell {
    let imageHeight : CGFloat = 32
    let labelHeight : CGFloat = 14
    
    var tabLabel: UILabel!
    var tabImage: UIImageView!
    
    var tabSelectedImage : UIImage?
    var tabDeselectedImage : UIImage?
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    func commonInit() {
        selectionStyle = .none
        backgroundColor = UIColor.clear

        let centeredView = UIView(frame: CGRect(x: 0, y: (self.frame.size.height - (imageHeight + labelHeight)) / 2.0 , width: self.frame.size.width, height: imageHeight + labelHeight))
        
        centeredView.translatesAutoresizingMaskIntoConstraints = false
        
        tabImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: imageHeight))
        tabImage.translatesAutoresizingMaskIntoConstraints = false
        tabImage.contentMode = .center
        
        tabLabel = UILabel(frame: CGRect(x: 0, y: imageHeight, width: self.frame.size.width, height: labelHeight))
        tabLabel.translatesAutoresizingMaskIntoConstraints = false
        tabLabel.textAlignment = .center
        tabLabel.font = UIFont.systemFont(ofSize: 10)
        
        centeredView.addSubview(tabImage)
        centeredView.addSubview(tabLabel)
        
        centeredView.addConstraint(NSLayoutConstraint(item: tabImage, attribute: .top, relatedBy: .equal, toItem: centeredView, attribute: .top, multiplier: 1, constant: 0))
        centeredView.addConstraint(NSLayoutConstraint(item: tabImage, attribute: .leading, relatedBy: .equal, toItem: centeredView, attribute: .leading, multiplier: 1, constant: 0))
        centeredView.addConstraint(NSLayoutConstraint(item: tabImage, attribute: .trailing, relatedBy: .equal, toItem: centeredView, attribute: .trailing, multiplier: 1, constant: 0))
        tabImage.addConstraint(NSLayoutConstraint(item: tabImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageHeight))
        
        centeredView.addConstraint(NSLayoutConstraint(item: tabLabel, attribute: .top, relatedBy: .equal, toItem: tabImage, attribute: .bottom, multiplier: 1, constant: 0))
        centeredView.addConstraint(NSLayoutConstraint(item: tabLabel, attribute: .bottom, relatedBy: .equal, toItem: centeredView, attribute: .bottom, multiplier: 1, constant: 0))
        centeredView.addConstraint(NSLayoutConstraint(item: tabLabel, attribute: .leading, relatedBy: .equal, toItem: centeredView, attribute: .leading, multiplier: 1, constant: 0))
        centeredView.addConstraint(NSLayoutConstraint(item: tabLabel, attribute: .trailing, relatedBy: .equal, toItem: centeredView, attribute: .trailing, multiplier: 1, constant: 0))
        
        self.addSubview(centeredView)
        
        centeredView.addConstraint(NSLayoutConstraint(item: centeredView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: imageHeight + labelHeight))
        self.addConstraint(NSLayoutConstraint(item: centeredView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: centeredView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: centeredView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            tabImage.tintColor = tintColor
            tabLabel.textColor = tintColor
            tabImage.image = tabSelectedImage
        } else {
            tabImage.tintColor = UIColor.lightGray
            tabLabel.textColor = UIColor.lightGray
            tabImage.image = tabDeselectedImage
        }
    }
}
