//
//  NMOutlineViewCell.swift
//
//  Created by Greg Kopel on 11/05/2017.
//  Copyright © 2017 Netmedia. All rights reserved.
//

import UIKit

class NMOutlineViewCell: UITableViewCell {

    
    // MARK: Properties
    var value: Any?
    var toggleButton: UIButton!
    var isExpanded: Bool = false
    var isAnimating: Bool = false
    
    // Cell indentation level
    var nmIndentationLevel = 0
    
    var onToggle: ((NMOutlineViewCell) -> Void)?

    
    // MARK: Initializer
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Expand/collapse button
        let toggleButton = UIButton(type: .custom)
        self.toggleButton = toggleButton
        toggleButton.addTarget(self, action: #selector(NMOutlineViewCell.toggleButtonAction(sender:)), for: .touchUpInside)
        toggleButton.frame = CGRect(x: 0, y: 0, width: NMOutlineView.buttonSize.width, height: NMOutlineView.buttonSize.height)
        self.addSubview(toggleButton)
        toggleButton.setTitle(NMOutlineView.buttonLabel, for: .normal)
        toggleButton.setTitleColor(NMOutlineView.buttonColor, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let indentationX = CGFloat(nmIndentationLevel) * NMOutlineView.nmIndentationWidth
        contentView.frame = CGRect(x: indentationX, y: 0, width: bounds.size.width - indentationX, height: bounds.size.height)
        
        let size = contentView.bounds.size
        
        // Toggle button
        if !toggleButton.isHidden {
            let btnSize = toggleButton.frame.size
            let btnFrame = CGRect(x: bounds.size.width - size.width - btnSize.width, y: (size.height - btnSize.height)/2.0, width: btnSize.width, height: btnSize.height)
            toggleButton.frame = btnFrame.integral
        }
    }
    
    
    // MARK: API

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc func toggleButtonAction(sender: UIButton) {
        if let onToggle = self.onToggle {
            onToggle(self)
            updateState(!isExpanded, animated: true)
        }
    }
    
    
    func updateState(_ isExpanded: Bool, animated: Bool) {
        self.isExpanded = isExpanded
        
        // Update toggle button state
        if !toggleButton.isHidden && !isAnimating {
            
            var transform: CGAffineTransform
            
            if isExpanded {
                transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            } else {
                transform = CGAffineTransform.identity
            }
            
            if animated {
                // Animate button image rotation
                isAnimating = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    UIView.animate(withDuration: 0.2,  animations: {
                        self.toggleButton.transform = transform
                    }, completion: { (finished) in
                        self.isAnimating = false
                    })
                }
            } else {
                toggleButton.transform = transform
            }
        }
    }
}

