//
//  NMOutlineViewController.swift
//  OutlineView
//
//  Created by  on 12/3/19.
//  Copyright © 2019 Netmedia. All rights reserved.
//


import UIKit

@objc(NMOutlineViewController)
@IBDesignable @objcMembers open class NMOutlineViewController: UIViewController {
    
    @IBOutlet @objc dynamic open var outlineView: NMOutlineView!

    @objc open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.view = NMOutlineView(frame: UIScreen.main.bounds, style: .plain)
    }
    

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.outlineView?.datasource = self
    }
    

}

@objc extension NMOutlineViewController: NMOutlineViewDatasource {
    
    @objc open func outlineView(_ outlineView: NMOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        fatalError("NMOutlineViewDatasource Protocol method method numberOfChildrenOfItem must be imoplemented")
    }
    
    
    @objc open func outlineView(_ outlineView: NMOutlineView, isItemExpandable item: Any) -> Bool {
        fatalError("NMOutlineViewDatasource Protocol method method isItemExpandable must be imoplemented")
    }
    
    
    @objc open func outlineView(_ outlineView: NMOutlineView, cellFor item: Any) -> NMOutlineViewCell {
        fatalError("NMOutlineViewDatasource Protocol method method outlineView(_: NMOutlineView, cellFor: Any) -> NMOutlineViewCell must be imoplemented")
    }
    
    
    @objc open func outlineView(_ outlineView: NMOutlineView, child index: Int, ofItem item: Any?) -> Any {
        fatalError("NMOutlineViewDatasource Protocol method outlineView(_: NMOutlineView, child: Int, ofItem: Any?) -> Any must be implemented")
    }
    
    
    @objc open func outlineView(_ outlineView: NMOutlineView, didSelect cell: NMOutlineViewCell) {
        fatalError("NMOutlineViewDatasource Protocol method method outlineView(_: NMOutlineView, didSelect: NMOutlineViewCell) must be imoplemented")
    }
    
    
    @objc open func outlineView(_ outlineView: NMOutlineView, shouldExpandItem item: Any) -> Bool {
        fatalError("NMOutlineViewDatasource Protocol method method outlineView(_: NMOutlineView, shouldExpandItem: Any) -> Bool must be imoplemented")
    }
    

}
