//
//  NMOutlineViewCell.swift
//
//  Created by Greg Kopel on 11/05/2017.
//  Copyright © 2017 Netmedia. All rights reserved.
//

import UIKit

@objc(NMOutlineViewCell)
@IBDesignable @objcMembers open class NMOutlineViewCell: UITableViewCell {
    
    // MARK: Properties
    @objc dynamic public var objectValue: Any {
        return itemValue.item
    }
    
    static var observerContext = 0
    
    @objc dynamic internal var itemValue: NMOutlineView.NMItem! {
        didSet {
            itemValue.addObserver(self, forKeyPath: #keyPath(NMOutlineView.NMItem.isExpanded), options: [.new], context: &NMOutlineViewCell.observerContext)
        }
    }
    
    /// Expand/Collapse control
    @objc dynamic public var toggleButton: UIButton! = UIButton(type: .custom)
    
    @IBInspectable @objc dynamic open var isExpanded: Bool  {
        get {
            return self.toggleButton.isSelected
        }
        set(newState) {
            self.toggleButton.isSelected = newState
        }
    }

    /// Cell indentation level
    @IBInspectable @objc dynamic public var nmIndentationLevel: Int = 0
    
    
    @objc dynamic override open var indentationWidth: CGFloat {
        didSet {
            if indentationWidth < buttonSize.width {
                self.indentationWidth = buttonSize.width
            }
            layoutIfNeeded()
        }
    }

    /// Toggle Button is Hidden
    @IBInspectable @objc dynamic open var buttonIsHidden: Bool {
        get {
            return self.toggleButton.isHidden
        }
        set(newValue) {
            self.toggleButton.isHidden = newValue
            layoutIfNeeded()
        }
        
    }
    
    /// Toggle Button Size
    @IBInspectable @objc dynamic open var buttonSize: CGSize = CGSize.zero
    {
        didSet {
            toggleButton.frame.size = buttonSize
            if indentationWidth < buttonSize.width {
                super.indentationWidth = buttonSize.width
                self.indentationWidth = buttonSize.width
            }
            layoutIfNeeded()
        }
    } 


    /// Toggle Button Collapsed Image
    @IBInspectable @objc dynamic public var buttonImage: UIImage!
    {
        set(newImage) {
            toggleButton.setImage(newImage, for: .normal)
        }
        get {
            return toggleButton.image(for: .normal)
        }
    }
    
    
    /// Toggle Button Expanded Image
    @IBInspectable @objc dynamic public var buttonExpandedImage: UIImage!
    {
        set(newImage) {
           self.toggleButton.setImage(newImage, for: .selected)
        }
        get {
            return toggleButton.image(for: .selected)
        }
    }
    
    
    /// Toggle Button Tint Color
    ///
    @IBInspectable @objc dynamic open var buttonColor: UIColor!
    // Toggle Button Tint Color
    {
        set(newColor) {
            toggleButton.tintColor = newColor
        }
        get {
            return toggleButton.tintColor
        }
    }

    
    @objc dynamic open var onToggle: ((NMOutlineViewCell) -> Void)?

    
    // MARK: Initializer
    @objc override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.nmIndentationLevel = 0
        self.indentationWidth = 27
        self.buttonSize = CGSize(width: 19, height: 19)
        self.buttonIsHidden = false
        self.buttonImage = UIImage(named: "arrowtriangle.right.fill")
        self.buttonExpandedImage = UIImage(named: "arrowtriangle.down.fill")
        self.isExpanded = false
        self.toggleButton.contentVerticalAlignment  = .center
        self.toggleButton.contentHorizontalAlignment = .center
        self.toggleButton.addTarget(self, action: #selector(toggleButtonAction(sender:)), for: .touchUpInside)
        self.addSubview(toggleButton)
        self.contentView.frame = CGRect(x: self.indentationWidth, y: 0, width: self.bounds.size.width - self.indentationWidth, height: self.bounds.size.height)
        self.toggleButton.frame = CGRect(x: self.indentationWidth - self.buttonSize.width, y: (self.bounds.size.height - self.buttonSize.height)/2.0, width: self.buttonSize.width, height: self.buttonSize.height)
    }
    
    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc override open func awakeFromNib() {
        super.awakeFromNib()
       if self.buttonSize == CGSize.zero {
           self.buttonSize = CGSize(width: 19, height: 19)
        }
        if self.indentationWidth == 0 {
            self.indentationWidth = 27
        }
      if self.buttonImage == nil {
            self.buttonImage = UIImage(named: "arrowtriangle.right.fill")
        }
        if self.buttonExpandedImage == nil {
            self.buttonExpandedImage = UIImage(named: "arrowtriangle.down.fill")
        }
        self.toggleButton.contentVerticalAlignment  = .center
        self.toggleButton.contentHorizontalAlignment = .center
        self.toggleButton.addTarget(self, action: #selector(toggleButtonAction(sender:)), for: .touchUpInside)
        self.addSubview(self.toggleButton)
        self.contentView.frame = CGRect(x: self.indentationWidth, y: 0, width: self.bounds.size.width - self.indentationWidth, height: self.bounds.size.height)
        self.toggleButton.frame = CGRect(x: self.indentationWidth - self.buttonSize.width, y: (self.bounds.size.height - self.buttonSize.height)/2.0, width: self.buttonSize.width, height: self.buttonSize.height)
    }
    
    
    @objc override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        if self.indentationWidth == 0 {
            self.indentationWidth = 27
        }
        if self.buttonSize == CGSize.zero {
            self.buttonSize = CGSize(width: 19, height: 19)
        }
        if self.buttonImage == nil {
            self.buttonImage = UIImage(named: "arrowtriangle.right.fill")
        }
        if self.buttonExpandedImage == nil {
            self.buttonExpandedImage = UIImage(named: "arrowtriangle.down.fill")
        }
        self.toggleButton.contentVerticalAlignment  = .center
        self.toggleButton.contentHorizontalAlignment = .center
        self.toggleButton.addTarget(self, action: #selector(toggleButtonAction(sender:)), for: .touchUpInside)
        self.addSubview(self.toggleButton)
        self.contentView.frame = CGRect(x: self.indentationWidth, y: 0, width: self.bounds.size.width - self.indentationWidth, height: self.bounds.size.height)
        self.toggleButton.frame = CGRect(x: self.indentationWidth - self.buttonSize.width, y: (self.bounds.size.height - self.buttonSize.height)/2.0, width: self.buttonSize.width, height: self.buttonSize.height)
        layoutIfNeeded()
    }
    
    // MARK: Layout
    
    @objc override open func layoutSubviews() {
        super.layoutSubviews()
        
        let indentationX = CGFloat(self.nmIndentationLevel + (self.toggleButton.isHidden ? 0 : 1)) * self.indentationWidth
        contentView.frame = CGRect(x: indentationX, y: 0, width: bounds.size.width - indentationX, height: bounds.size.height)
        
        let size = contentView.bounds.size
        
        // Toggle button
        if !toggleButton.isHidden {
            let btnSize = toggleButton.frame.size
            let btnFrame = CGRect(x:indentationX - btnSize.width, y: (size.height - btnSize.height)/2.0, width: btnSize.width, height: btnSize.height)
            toggleButton.frame = btnFrame.integral
        }
        setNeedsDisplay()
    }
    
    
    // MARK: API
    @objc override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc open func update(with item: Any) {
        fatalError("update(with:Any) method of Type NMOutlineTableViewCell must be implemented")
    }
    
    
    @IBAction @objc func toggleButtonAction(sender: UIButton) {
        if let onToggle = self.onToggle {
            onToggle(self)
        }
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &NMOutlineViewCell.observerContext {
            guard let item = object as? NMOutlineView.NMItem else { return }
            self.isExpanded = item.isExpanded
        }
        
    }
    
}

