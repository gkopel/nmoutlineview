//
//  RegionOutlineViewCell.swift
//  OutlineView
//
//  Created by  on 12/5/19.
//  Copyright © 2019 Netmedia. All rights reserved.
//

import UIKit
import NMOutlineView

@objc(RegionOutlineViewCell)
@IBDesignable @objcMembers class RegionOutlineViewCell: NMOutlineViewCell {

    

    @IBOutlet @objc dynamic  var regionName: UILabel!
    
    @IBOutlet @objc dynamic  var resortsCount: UILabel!
    

}
