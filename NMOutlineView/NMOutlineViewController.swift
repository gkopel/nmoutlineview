//
//  NMOutlineViewController.swift
//  OutlineView
//
//  Created by  on 12/3/19.
//  Copyright © 2019 Netmedia. All rights reserved.
//

import UIKit

@objcMembers open class NMOutlineViewController: UIViewController {
    
    @IBOutlet @objc dynamic public var outlineView: NMOutlineView!

    @objc open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        outlineView = NMOutlineView()
        outlineView.datasource = self
    }
    

    @objc override open func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        outlineView.datasource = self
    }

}

@objc extension NMOutlineViewController: NMOutlineViewDatasource {
    
    @objc open func outlineView(_ outlineView: NMOutlineView, numberOfChildrenOfCell parentCell: NMOutlineViewCell?) -> Int {
        return 0
    }
    
    @objc open func outlineView(_ outlineView: NMOutlineView, isCellExpandable cell: NMOutlineViewCell) -> Bool {
        return false
    }
    
    @objc open func outlineView(_ outlineView: NMOutlineView, childCell index: Int, ofParentAtIndexPath parentIndexPath: IndexPath?) -> NMOutlineViewCell {
        return NMOutlineViewCell()
    }
    
    @objc open func outlineView(_ outlineView: NMOutlineView, didSelectCell cell: NMOutlineViewCell) {
        return
    }

}
