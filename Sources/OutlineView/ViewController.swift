//
//  ViewController.swift
//  OutlineView
//
//  Created by Greg Kopel on 20.05.2017.
//  Copyright © 2017 Netmedia. All rights reserved.
//
#if os(iOS) || targetEnvironment(macCatalyst)
import UIKit
#endif
import NMOutlineView

@objcMembers class ViewController: NMOutlineViewController {
    
    dynamic var datasource: [TreeNode<[String: Any]>]?
    
    @objc override func viewDidLoad() {
        setupExampleDatasource()
        super.viewDidLoad()
    }
    
    
    @objc override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: NMOutlineView datasource
    
    @objc override func outlineView(_ outlineView: NMOutlineView, numberOfChildrenOfCell parentCell: NMOutlineViewCell?) -> Int {
        
        guard let datasource = datasource else {
            return 0
        }
        if let parentNode = parentCell?.value as? TreeNode<[String: Any]> {
            return parentNode.children.count
        } else {
            // Top level items
            return datasource.count
        }
    }
    
    
    @objc override func outlineView(_ outlineView: NMOutlineView, childCell index: Int, ofParentAtIndexPath parentIndexPath: IndexPath?) -> NMOutlineViewCell {
        
        guard let datasource = datasource else {
            return NMOutlineViewCell(style: .default, reuseIdentifier: NMOutlineView.cellIdentifier)
        }

        if let parentIndexPath = parentIndexPath,
            let rootIndex = parentIndexPath.first {
            
            // Item that has a parent
            let rootNode = datasource[rootIndex]
            if let node = rootNode.nodeAtIndexPath(parentIndexPath) {
                let childNode = node.children[index]
                
                if childNode.children.count > 0 {
                    // Region
                    var cell = outlineView.dequeReusableCell(withIdentifier: "RegionCell", style: .default) as? RegionOutlineViewCell
                    if cell == nil {
                        cell = RegionOutlineViewCell(style: .default, reuseIdentifier: "RegionCell")
                    }
                    let region = childNode.value
                    let resortsCount = childNode.childCount()
                    if let name = region["name"] as? String {
                        cell!.regionName.text = "\(name)"
                        cell!.resortsCount.text = "\(resortsCount)"
                    }
                    
                    
                    cell!.value = childNode
                    return cell!
                } else {
                    // Resort
                    var cell = outlineView.dequeReusableCell(withIdentifier: "ResortCell", style: .subtitle) as? ResortOutlineViewCell
                    if cell == nil {
                        cell = ResortOutlineViewCell(style: .default, reuseIdentifier: "ResortCell")
                    }
                    
                    let resort = childNode.value
                    if let name = resort["name"] as? String {
                        cell!.resortName.text = name
                    }
                    if let tracks = resort["tracks"] as? String {
                        cell!.resortDetail.text = tracks
                    }
                    
                    
                    cell!.value = childNode
                    return cell!
                }
            } else {
                print("Error: no child node found")
                return NMOutlineViewCell()
            }
            
        } else {
            // Root level -> Country
            var cell = outlineView.dequeReusableCell(withIdentifier: "CountryCell", style: .default) as? CountryOutlineViewCell
            if cell == nil {
                cell = CountryOutlineViewCell(style: .default, reuseIdentifier: "CountryCell")
            }

            let node = datasource[index]
            let country = node.value
            let resortsCount = node.childCount()
            if let name = country["name"] as? String {
                cell!.countryName.text = "\(name)"
                cell!.regionsCount.text = "\(resortsCount)"
                
            }
            if let flag = country["flag"] as? String {
                let image = UIImage(named: flag)
                cell!.countryFlag.image = image
            }
            cell!.value = node
            return cell!
        }
    }
    
    
    @objc override func outlineView(_ outlineView: NMOutlineView, isCellExpandable cell: NMOutlineViewCell) -> Bool {
        guard let node = cell.value as? TreeNode<[String: Any]> else {
            return false
        }
        
        if node.children.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    
    
    @objc override func outlineView(_ outlineView: NMOutlineView, didSelectCell cell: NMOutlineViewCell) {
        guard let node = cell.value as? TreeNode<[String: Any]> else {
            return
        }
        
        let nodeValue = node.value
        if let name = nodeValue["name"] {
            print("Selected \(name)")
        }
        
    }
    
    
    
    
    // MARK: - Example Datasource
    
    func setupExampleDatasource() {
        
        ////////// Austria
        let austria = TreeNode<[String: Any]>(value: ["name": "Austria", "flag": "1"])
        
        let salzburgerland = TreeNode<[String: Any]>(value: ["name": "Salzburgerland"])
        let kaprun = TreeNode<[String: Any]>(value: ["name": "Kaprun", "tracks": "easy: 13 km, medium: 25 km, hard: 3 km"])
        let bad_gastein = TreeNode<[String: Any]>(value: ["name": "Bad Gastein", "tracks": "easy: 33 km, medium: 63 km, hard: 4 km"])
        let zel_amm_see = TreeNode<[String: Any]>(value: ["name": "Zell am See", "tracks": "easy: 25 km, medium: 27 km, hard: 25 km"])
        
        salzburgerland.addChild(kaprun)
        salzburgerland.addChild(bad_gastein)
        salzburgerland.addChild(zel_amm_see)
        
        let tyrol = TreeNode<[String: Any]>(value: ["name": "Tyrol"])
        let hintertux = TreeNode<[String: Any]>(value: ["name": "Hintertux", "tracks": "easy: 14 km, medium: 35 km, hard: 11 km"])
        let kizbuehel = TreeNode<[String: Any]>(value: ["name": "Kitzbuehel", "tracks": "easy: 91 km, medium: 57 km, hard: 25 km"])
        let soelden = TreeNode<[String: Any]>(value: ["name": "Soelden", "tracks": "easy: 69 km, medium: 45 km, hard: 30 km"])
        let pitzal = TreeNode<[String: Any]>(value: ["name": "Pitzal", "tracks": "easy: 13 km, medium: 21 km, hard: 5 km"])
        tyrol.addChild(hintertux)
        tyrol.addChild(kizbuehel)
        tyrol.addChild(soelden)
        tyrol.addChild(pitzal)
        austria.addChild(salzburgerland)
        austria.addChild(tyrol)
        
        /////////  Switzerland
        let switzerland = TreeNode<[String: Any]>(value: ["name": "Switzerland", "flag": "2"])
        let crans_montana = TreeNode<[String: Any]>(value: ["name": "Crans Montana", "tracks": "easy: 60 km, medium: 80 km, hard: 20 km"])
        let wengen = TreeNode<[String: Any]>(value: ["name": "Wengen", "tracks": "easy: 20 km, medium: 58 km, hard: 20 km"])
        let zermatt = TreeNode<[String: Any]>(value: ["name": "Zermatt", "tracks": "easy: 31 km, medium: 119 km, hard: 12 km"])
        switzerland.addChild(crans_montana)
        switzerland.addChild(wengen)
        switzerland.addChild(zermatt)
        
        ////////// France
        let france = TreeNode<[String: Any]>(value: ["name": "France", "flag": "3"])
        let isere = TreeNode<[String: Any]>(value: ["name": "Dauphine/Isere"])
        let alpe_dhuez = TreeNode<[String: Any]>(value: ["name": "Alpe D'Huez", "tracks": "easy: 40 km, medium: 120 km, hard: 60 km"])
        let les2alps = TreeNode<[String: Any]>(value: ["name": "Les 2 Alpes", "tracks": "easy: 89 km, medium: 78 km, hard: 44 km"])
        
        
        let savoi = TreeNode<[String: Any]>(value: ["name": "Savoi"])
        let meribel = TreeNode<[String: Any]>(value: ["name": "Meribel", "tracks": "easy: 60 km, medium: 28 km, hard: 12 km"])
        let valdisere = TreeNode<[String: Any]>(value: ["name": "Val d'Isere", "tracks": "easy: 86 km, medium: 35 km, hard: 14 km"])
        let lesarcs = TreeNode<[String: Any]>(value: ["name": "Les Arcs", "tracks": "easy: 84 km, medium: 77 km, hard: 39 km"])
        
        isere.addChild(alpe_dhuez)
        isere.addChild(les2alps)
        savoi.addChild(meribel)
        savoi.addChild(valdisere)
        savoi.addChild(lesarcs)
        
        france.addChild(isere)
        france.addChild(savoi)
        
        
        ////////// Italy
        let italy = TreeNode<[String: Any]>(value: ["name": "Italy", "flag": "4"])
        let livigno = TreeNode<[String: Any]>(value: ["name": "Livigno", "tracks": "easy: 45 km, medium: 50 km, hard: 15 km"])
        let valdifiemme = TreeNode<[String: Any]>(value: ["name": "Val di Fiemme", "tracks": "easy: 58 km, medium: 78 km, hard: 11 km"])
        let valdisole = TreeNode<[String: Any]>(value: ["name": "Val di Sole", "tracks": "easy: 45 km, medium: 56 km, hard: 35 km"])
        let cortina = TreeNode<[String: Any]>(value: ["name": "Cortina d'Ampezzo", "tracks": "easy: 70 km, medium: 49 km, hard: 21 km"])
        italy.addChild(livigno)
        italy.addChild(valdifiemme)
        italy.addChild(valdisole)
        italy.addChild(cortina)
        
        datasource = [austria, switzerland, france, italy]
    }
    
    
}


@objcMembers open class TreeNode<T> {
    dynamic var value: T
    
    weak var parent: TreeNode<T>?
    var children = [TreeNode<T>]()
    
    init(value: T) {
        self.value = value
    }
    
    func addChild(_ node: TreeNode<T>) {
        children.append(node)
        node.parent = self
    }
    
    
    func nodeAtIndexPath(_ indexPath: IndexPath) -> TreeNode<T>? {
        if indexPath.count == 1 {
            return self
        } else {
            let nextPath = indexPath.dropFirst()
            let childNode = self.children[nextPath.first!]
            return childNode.nodeAtIndexPath(nextPath)
        }
    }
    
    // Counts children recursively
    func childCount() -> Int {
        if self.children.count > 0 {
            var count = 0
            for child in self.children {
                count += child.childCount()
            }
            return count
            
        } else {
            return 1
        }
    }
    
}

