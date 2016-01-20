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

@objc public protocol SabBarControllerDelegate {
    func shouldShowSabBar(controller: SabBarController, traitCollection: UITraitCollection) -> Bool
}

public class SabBarController: UITabBarController, UITableViewDataSource, UITableViewDelegate {

// MARK: Constants and properties
    
    internal var sidebar = UIView()
    internal let toolbar = UIToolbar()
    internal let tabTable = UITableView(frame: CGRectZero, style: .Plain)

    private var navigationBarHeight : CGFloat {
        return navigationBarHeight(self.traitCollection)
    }
    
    private func navigationBarHeight(traitCollection : UITraitCollection) -> CGFloat {
        if traitCollection.verticalSizeClass == .Compact && traitCollection.horizontalSizeClass == .Compact {
            return 32 // iPhone 6 and below in landscape
        } else {
            return 44 // iPhone 6 Plus and above
        }
    }
    
    private let statusBarHeight : CGFloat = 20
    private var sidebarWidthConstraint : NSLayoutConstraint?
    private var navigationBarWidthConstraint : NSLayoutConstraint?
    private var navigationBarHeightConstraint : NSLayoutConstraint?
    private var headerViewCenterConstraint : NSLayoutConstraint?

    @IBOutlet public var sabBarDelegate : SabBarControllerDelegate?
    
// MARK: User customizable properties
    
    @IBInspectable public var sidebarWidth : CGFloat = 80.0
    @IBInspectable public var cellHeight : CGFloat = 60.0
    @IBInspectable public var hasNavigation : Bool = false
    @IBInspectable public var separateHeader : Bool = false
    
    @IBInspectable public
    var backgroundColor : UIColor = UIColor.whiteColor() {
        didSet {
            self.view.backgroundColor = backgroundColor
        }
    }
    
    @IBInspectable public var imageTint : UIColor? {
        didSet {
            tabBar.tintColor = imageTint
        }
    }
    
    @IBOutlet public var headerView : UIView? {
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
    
    public let navigationBar = UINavigationBar()

// MARK: View lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "View"
        
        buildSidebarView()
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        showAndHideSidebar(traitCollection)
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let _ = tabTable.indexPathForSelectedRow else {
            tabTable.selectRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0), animated: true, scrollPosition: .None)
            return
        }
    }
    
// MARK: Private shortcuts methods
    
    private var statusHeight : CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.height
    }
    
    func selectedIndex(item: UITabBarItem?) -> Int {
        var index = 0
        for _item in tabBar.items! {
            if _item == item {
                return index
            }
            index = index + 1
        }
        return 0
    }
    
    private var contentView : UIView {
        return self.view.subviews[0]
    }

// MARK: Sidebar table view
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
 
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = tabBar.items {
            return items.count
        }
        return 0
    }

    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return statusHeight
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, sidebarWidth, statusHeight))
        header.backgroundColor = UIColor.clearColor()
        return header
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tabCellIdentifier", forIndexPath: indexPath) as! SabBarCell

        cell.tintColor = tabBar.tintColor
        
        if let item = tabBar.items?[indexPath.row] {
            cell.tabLabel.text = item.title

            cell.tabDeselectedImage = item.image?.imageWithRenderingMode(.AlwaysTemplate)
            cell.tabSelectedImage = item.selectedImage?.imageWithRenderingMode(.AlwaysTemplate)

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
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndex = indexPath.row
    }
    
// MARK: Tab bar delegate
    
    override public func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        tabTable.selectRowAtIndexPath(NSIndexPath(forRow: selectedIndex(item), inSection: 0), animated: true, scrollPosition: .Top)
    }
    
// MARK: Sidebar visibility
    
    override public func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition({ [unowned self] _ in
            self.showAndHideSidebar(newCollection)
        }) { _ in

        }
    }

    func showAndHideSidebar(traitCollection : UITraitCollection) {
        if let sabBarDelegate = sabBarDelegate {
            let visible = sabBarDelegate.shouldShowSabBar(self, traitCollection: traitCollection)
            toggleSidebar(visible: visible)
        } else {
            if traitCollection.horizontalSizeClass == .Regular || traitCollection.verticalSizeClass == .Compact {
                toggleSidebar(visible: true)
            } else {
                toggleSidebar(visible: false)
            }
        }
        
        if traitCollection.verticalSizeClass == .Compact {
            self.navigationBarHeightConstraint?.constant = navigationBarHeight
            self.headerViewCenterConstraint?.constant = 0
        } else {
            self.navigationBarHeightConstraint?.constant = navigationBarHeight + statusBarHeight
            self.headerViewCenterConstraint?.constant = statusBarHeight / 2.0
        }
    }
    
    public func toggleSidebar(visible visible: Bool) {
        if visible == false {
            self.sidebarWidthConstraint?.constant = 0
            self.navigationBar.hidden = true
            self.tabBar.hidden = false
        } else {
            self.sidebarWidthConstraint?.constant = self.sidebarWidth
            self.tabBar.hidden = true
            self.navigationBar.hidden = false
        }
    }
    
// MARK: Constraints and sidebar creation
    
    private func centerHeaderView(navigationHeight : CGFloat) {
        guard let headerView = headerView else { return }
        
        navigationBar.removeConstraints(headerView.constraints)
        headerView.removeConstraints(headerView.constraints)
        
        let originY = (navigationHeight - headerView.frame.size.height) / 2.0 + statusHeight
        let originX = (sidebarWidth - headerView.frame.size.width) / 2.0
        headerView.frame = CGRect(x: originX, y: originY, width: headerView.frame.size.width, height: headerView.frame.size.height)
        
        navigationBar.addConstraint(NSLayoutConstraint(item: headerView, attribute: .CenterX, relatedBy: .Equal, toItem: navigationBar, attribute: .CenterX, multiplier: 1, constant: 0))
        headerViewCenterConstraint = NSLayoutConstraint(item: headerView, attribute: .CenterY, relatedBy: .Equal, toItem: navigationBar, attribute: .CenterY, multiplier: 1, constant: 0)
        navigationBar.addConstraint(headerViewCenterConstraint!)
        
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .Width, relatedBy: .Equal, toItem: headerView, attribute: .Height, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: headerView, attribute: .Height, relatedBy: .LessThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: headerView.frame.size.height))
        // navigationBar.addConstraint(NSLayoutConstraint(item: headerView, attribute: .Height, relatedBy: .LessThanOrEqual, toItem: navigationBar, attribute: .Height, multiplier: 1, constant: -4))
        
        // let bottomMargin = (navigationHeight - headerView.frame.size.height) / 2.0
        
        // navigationBar.addConstraint(NSLayoutConstraint(item: headerView, attribute: .Bottom, relatedBy: .GreaterThanOrEqual, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: -bottomMargin))
    }

    internal func buildSidebarView() {
        sidebar.removeFromSuperview()
        
        sidebar = UIView()
        
        if hasNavigation {
            navigationBar.frame = CGRect(x: 0, y: 0, width: sidebarWidth, height: navigationBarHeight + statusHeight)
            navigationBar.translatesAutoresizingMaskIntoConstraints = false
            navigationBar.accessibilityIdentifier = "navigationBar"
            view.addSubview(navigationBar)
            
            view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
            navigationBarWidthConstraint = NSLayoutConstraint(item: navigationBar, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: sidebarWidth)
            view.addConstraint(navigationBarWidthConstraint!)
            
            navigationBarHeightConstraint = NSLayoutConstraint(item: navigationBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: navigationBarHeight + statusHeight)
            view.addConstraint(navigationBarHeightConstraint!)
            
            sidebar.frame = CGRectMake(0, navigationBarHeight, sidebarWidth, view.bounds.height)
        } else {
            sidebar.frame = CGRectMake(0, 0, sidebarWidth, view.bounds.height)
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
        
        sidebar.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Top, relatedBy: .Equal, toItem: sidebar, attribute: .Top, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Bottom, relatedBy: .Equal, toItem: sidebar, attribute: .Bottom, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Leading, relatedBy: .Equal, toItem: sidebar, attribute: .Leading, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Trailing, relatedBy: .Equal, toItem: sidebar, attribute: .Trailing, multiplier: 1, constant: 0))
        
        tabTable.frame = sidebar.bounds
        tabTable.delegate = self
        tabTable.dataSource = self
        
        tabTable.scrollEnabled = false
        
        tabTable.backgroundColor = UIColor.clearColor()
        
        tabTable.registerClass(SabBarCell.self, forCellReuseIdentifier: "tabCellIdentifier")
        tabTable.separatorColor = UIColor.clearColor()
        
        tabTable.translatesAutoresizingMaskIntoConstraints = false
        tabTable.accessibilityIdentifier = "tabTable"
        
        sidebar.addSubview(tabTable)
        
        sidebar.addConstraint(NSLayoutConstraint(item: tabTable, attribute: .Top, relatedBy: .Equal, toItem: sidebar, attribute: .Top, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: tabTable, attribute: .Bottom, relatedBy: .Equal, toItem: sidebar, attribute: .Bottom, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: tabTable, attribute: .Leading, relatedBy: .Equal, toItem: sidebar, attribute: .Leading, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: tabTable, attribute: .Trailing, relatedBy: .Equal, toItem: sidebar, attribute: .Trailing, multiplier: 1, constant: 0))
        
        let border = UIView(frame: CGRectMake(0, -navigationBarHeight, sidebarWidth, sidebar.frame.size.height + navigationBarHeight))
        border.backgroundColor = UIColor.lightGrayColor()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.accessibilityIdentifier = "Border"
        view.sendSubviewToBack(border)
        
        sidebar.addSubview(border)
        sidebar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(sidebar)
        view.backgroundColor = backgroundColor
        
        if hasNavigation {
            view.addConstraint(NSLayoutConstraint(item: sidebar, attribute: .Top, relatedBy: .Equal, toItem: navigationBar, attribute: .Bottom, multiplier: 1, constant: 0))
            view.bringSubviewToFront(navigationBar)
        } else {
            view.addConstraint(NSLayoutConstraint(item: sidebar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        }
        
        view.addConstraint(NSLayoutConstraint(item: sidebar, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: sidebar, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0))
        
        sidebarWidthConstraint = NSLayoutConstraint(item: sidebar, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: sidebarWidth)
        view.addConstraint(sidebarWidthConstraint!)
        
        if separateHeader == false {
            sidebar.addConstraint(NSLayoutConstraint(item: border, attribute: .Top, relatedBy: .Equal, toItem: sidebar, attribute: .Top, multiplier: 1, constant: 0))
        } else {
            view.addConstraint(NSLayoutConstraint(item: border, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        }
        
        sidebar.addConstraint(NSLayoutConstraint(item: border, attribute: .Bottom, relatedBy: .Equal, toItem: sidebar, attribute: .Bottom, multiplier: 1, constant: 0))
        sidebar.addConstraint(NSLayoutConstraint(item: border, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: (1 / UIScreen.mainScreen().scale)))
        sidebar.addConstraint(NSLayoutConstraint(item: border, attribute: .Leading, relatedBy: .Equal, toItem: sidebar, attribute: .Trailing, multiplier: 1, constant: 0))
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Leading, relatedBy: .Equal, toItem: sidebar, attribute: .Trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: contentView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0))
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
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()

        let centeredView = UIView(frame: CGRect(x: 0, y: (self.frame.size.height - (imageHeight + labelHeight)) / 2.0 , width: self.frame.size.width, height: imageHeight + labelHeight))
        
        centeredView.translatesAutoresizingMaskIntoConstraints = false
        
        tabImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: imageHeight))
        tabImage.translatesAutoresizingMaskIntoConstraints = false
        tabImage.contentMode = .Center
        
        tabLabel = UILabel(frame: CGRect(x: 0, y: imageHeight, width: self.frame.size.width, height: labelHeight))
        tabLabel.translatesAutoresizingMaskIntoConstraints = false
        tabLabel.textAlignment = .Center
        tabLabel.font = UIFont.systemFontOfSize(10)
        
        centeredView.addSubview(tabImage)
        centeredView.addSubview(tabLabel)
        
        centeredView.addConstraint(NSLayoutConstraint(item: tabImage, attribute: .Top, relatedBy: .Equal, toItem: centeredView, attribute: .Top, multiplier: 1, constant: 0))
        centeredView.addConstraint(NSLayoutConstraint(item: tabImage, attribute: .Leading, relatedBy: .Equal, toItem: centeredView, attribute: .Leading, multiplier: 1, constant: 0))
        centeredView.addConstraint(NSLayoutConstraint(item: tabImage, attribute: .Trailing, relatedBy: .Equal, toItem: centeredView, attribute: .Trailing, multiplier: 1, constant: 0))
        tabImage.addConstraint(NSLayoutConstraint(item: tabImage, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: imageHeight))
        
        centeredView.addConstraint(NSLayoutConstraint(item: tabLabel, attribute: .Top, relatedBy: .Equal, toItem: tabImage, attribute: .Bottom, multiplier: 1, constant: 0))
        centeredView.addConstraint(NSLayoutConstraint(item: tabLabel, attribute: .Bottom, relatedBy: .Equal, toItem: centeredView, attribute: .Bottom, multiplier: 1, constant: 0))
        centeredView.addConstraint(NSLayoutConstraint(item: tabLabel, attribute: .Leading, relatedBy: .Equal, toItem: centeredView, attribute: .Leading, multiplier: 1, constant: 0))
        centeredView.addConstraint(NSLayoutConstraint(item: tabLabel, attribute: .Trailing, relatedBy: .Equal, toItem: centeredView, attribute: .Trailing, multiplier: 1, constant: 0))
        
        self.addSubview(centeredView)
        
        centeredView.addConstraint(NSLayoutConstraint(item: centeredView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: imageHeight + labelHeight))
        self.addConstraint(NSLayoutConstraint(item: centeredView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: centeredView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: centeredView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            tabImage.tintColor = tintColor
            tabLabel.textColor = tintColor
            tabImage.image = tabSelectedImage
        } else {
            tabImage.tintColor = UIColor.lightGrayColor()
            tabLabel.textColor = UIColor.lightGrayColor()
            tabImage.image = tabDeselectedImage
        }
    }
}
