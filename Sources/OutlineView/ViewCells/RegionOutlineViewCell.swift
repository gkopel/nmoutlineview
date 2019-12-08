//
//  RegionOutlineViewCell.swift
//  OutlineView
//
//  Created by  on 12/5/19.
//  Copyright © 2019 Netmedia. All rights reserved.
//
#if os(iOS) || targetEnvironment(macCatalyst)
import UIKit
#endif
import NMOutlineView

@IBDesignable @objcMembers class RegionOutlineViewCell: NMOutlineViewCell {

    @IBOutlet @objc dynamic weak var regionName: UILabel!
    
    @IBOutlet @objc dynamic weak var resortsCount: UILabel!
    

}
