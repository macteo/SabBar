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
