//
//  CountryOutlineViewCell.swift
//  OutlineView
//
//  Created by  on 12/5/19.
//  Copyright © 2019 Netmedia. All rights reserved.
//


import UIKit
import NMOutlineView

@objc(CountryOutlineViewCell)
@IBDesignable @objcMembers class CountryOutlineViewCell: NMOutlineViewCell {


    @IBOutlet @objc dynamic  var countryFlag: UIImageView!
    
    @IBOutlet @objc dynamic  var countryName: UILabel!
    
    @IBOutlet @objc dynamic  var regionsCount: UILabel!
    

}
