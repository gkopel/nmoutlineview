//
//  ResortOutlineViewCell.swift
//  OutlineView
//
//  Created by  on 12/5/19.
//  Copyright © 2019 Netmedia. All rights reserved.
//

import UIKit
import NMOutlineView

@objc(ResortOutlineViewCell)
@IBDesignable @objcMembers class ResortOutlineViewCell: NMOutlineViewCell {


    @IBOutlet @objc dynamic  var resortName: UILabel!
    
    @IBOutlet @objc dynamic  var resortDetail: UILabel!


    
    @IBAction func search(_ sender: UIButton) {
        let alert = UIAlertController(title: "Search", message: "Search Completed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.windows.first!.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func detailInfo(_ sender: UIButton) {
        let alert = UIAlertController(title: "Information", message: "Detail Information Presented", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.shared.windows.first!.rootViewController!.present(alert, animated: true, completion: nil)
    }
    


}
