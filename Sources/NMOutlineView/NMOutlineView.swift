//
//  NMOutlineView.swift
//
//  Created by Greg Kopel on 11/05/2017.
//  Copyright © 2017 Netmedia. All rights reserved.
//


#if !os(macOS) || targetEnvironment(macCatalyst)
import UIKit
#endif


@objc public protocol NMOutlineViewDatasource: NSObjectProtocol {
    @objc func outlineView(_ outlineView: NMOutlineView, numberOfChildrenOfCell parentCell: NMOutlineViewCell?) -> Int
    @objc func outlineView(_ outlineView: NMOutlineView, isCellExpandable cell: NMOutlineViewCell) -> Bool
    @objc func outlineView(_ outlineView: NMOutlineView, childCell index: Int, ofParentAtIndexPath parentIndexPath: IndexPath?) -> NMOutlineViewCell
    @objc optional func outlineView(_ outlineView: NMOutlineView, didSelectCell cell: NMOutlineViewCell);
}


// MARK: -
@IBDesignable @objcMembers open class NMOutlineView: UIView {
    
    // MARK: Properties

    // Datasource for internal tableview
    @IBOutlet @objc dynamic open var datasource: NMOutlineViewDatasource! {
        didSet {
            // Setup initial state
            if let datasource = datasource {
                let rootItemsCount = datasource.outlineView(self, numberOfChildrenOfCell: nil)
                for index in 0 ..< rootItemsCount {
                    let item = NMItem(withIndexPath: IndexPath(index:index))
                    tableViewDatasource.append(item)
                }
            }
        }
    }
    
    
    // Type property
    static public let cellIdentifier = "CellIdentifier"
    
    // Private properties
    @IBOutlet @objc private dynamic var tableView: UITableView!

    @objc dynamic private var tableViewDatasource = [NMItem]()
    
    
    
    // MARK: Initializers
    
    @objc private func sharedInit() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none;
        tableView.separatorInset = .zero
        tableView.register(NMOutlineViewCell.self, forCellReuseIdentifier: NMOutlineView.cellIdentifier)
    }
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        tableView = UITableView(frame: frame)
        self.addSubview(tableView)
        sharedInit()
        let cell = NMOutlineViewCell(style: .default, reuseIdentifier: NMOutlineView.cellIdentifier)
        tableView.addSubview(cell)
    }
    
    
    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    @objc override open func awakeFromNib() {
        super.awakeFromNib()
        if tableView == nil {
            tableView = UITableView(frame: frame)
        }
        sharedInit()
    }
    
    @objc override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        if tableView == nil {
            tableView = UITableView(frame: frame)
            self.addSubview(tableView)
        }
        sharedInit()
        let cell = NMOutlineViewCell(style: .default, reuseIdentifier: NMOutlineView.cellIdentifier)
        tableView.addSubview(cell)
        setNeedsLayout()
    }
    
    // MARK: Layout
    
    @objc override open func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }
    
    
    // MARK: NMOutlineView methods
    
    @objc open func dequeReusableCell(withIdentifier identifier: String, style: UITableViewCell.CellStyle) -> NMOutlineViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NMOutlineViewCell
            else { return NMOutlineViewCell(style: style, reuseIdentifier: identifier) }
        return cell
    }
    
    
    @objc open func cellAtPoint(_ point: CGPoint) -> NMOutlineViewCell? {
        return tableView.cellForRow(at: tableView.indexPathForRow(at: point) ?? IndexPath()) as? NMOutlineViewCell
    }
    
    
    @objc open func indexPathforCell(at point:CGPoint) -> IndexPath? {
        return tableView.indexPathForRow(at: point)
    }
    
    
    @objc open func toggleChildCellsOf(_ cell: NMOutlineViewCell, atIndex index: Int) {
        
        guard let datasource = self.datasource else {
            return
        }
        
        let cellItem = tableViewDatasource[index]
        
        if cellItem.isExpanded {
            // Collapse
            let childrenCount = datasource.outlineView(self, numberOfChildrenOfCell:cell)
            if childrenCount > 0 {
                cellItem.isExpanded = false
                
                while tableViewDatasource.count > index+1 && tableViewDatasource[index+1].indexPath.count > cellItem.indexPath.count  {
                    tableViewDatasource.remove(at: index+1)
                    let tableViewIndexPath = IndexPath(row: index+1, section: 0)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [tableViewIndexPath], with: .fade)
                    tableView.endUpdates()
                }
            } else {
                print("ERROR: NMOutlineView cell is NOT collapsable")
            }
        } else {
            // Expand
            if datasource.outlineView(self, isCellExpandable: cell) {
                cellItem.isExpanded = true
                let childrenCount = datasource.outlineView(self, numberOfChildrenOfCell:cell)
                let cellItemIndexPath = cellItem.indexPath
                for childIndex in 0..<childrenCount {
                    var itemIndexPath = IndexPath(indexes: cellItemIndexPath)
                    itemIndexPath.append(childIndex)
                    let item = NMItem(withIndexPath: itemIndexPath)
                    tableViewDatasource.insert(item, at: index + childIndex + 1)
                    let tableViewIndexPath = IndexPath(row: index + childIndex + 1, section: 0)
                    tableView.beginUpdates()
                    tableView.insertRows(at: [tableViewIndexPath], with: .fade)
                    tableView.endUpdates()
                }
            } else {
                print("ERROR: NMOutlineView cell is NOT expandable")
            }
        }
    }
    
    // Single item in the collection
    @objc public final class NMItem: NSObject {
        @objc dynamic public var indexPath: IndexPath
        @objc dynamic public var isExpanded = false
        
        @objc public init(withIndexPath indexPath: IndexPath) {
            self.indexPath = indexPath
        }
    }
    
    @objc public func reloadData() {
        tableView.reloadData()
    }
    
}


// MARK: - Internal TableView datasource/delegate

@objc extension NMOutlineView: UITableViewDataSource, UITableViewDelegate {
    
    @objc open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDatasource.count
    }
    
    
    @objc open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let datasource = self.datasource else {
            print("ERROR: no NMOutlineView datasource defined.")
            return NMOutlineViewCell(style: .default, reuseIdentifier: "ErrorCell")
        }
        
        let item = tableViewDatasource[indexPath.row]
        var theCell: NMOutlineViewCell
        if item.indexPath.count > 1, let childIndex = item.indexPath.last {
            // Cell that has a parent
            let parentIndexPath = item.indexPath.dropLast()
            theCell = datasource.outlineView(self, childCell: childIndex, ofParentAtIndexPath: parentIndexPath)
            
        } else if let rootIndex = item.indexPath.first {
            // Root level cell
            theCell = datasource.outlineView(self, childCell: rootIndex, ofParentAtIndexPath: nil)
        } else {
            // Shouldn't get there
            print("ERROR: no NMOutlineView cell found")
            theCell = NMOutlineViewCell(style: .default, reuseIdentifier: "ErrorCell")
        }
        
        theCell.nmIndentationLevel = item.indexPath.count - 1
        theCell.toggleButton.isHidden = !datasource.outlineView(self, isCellExpandable: theCell)
        theCell.updateState(item.isExpanded)
        
        theCell.onToggle = { (sender) in
            if let toggledCellPath = self.tableView.indexPath(for: theCell) {
                self.toggleChildCellsOf(theCell, atIndex: toggledCellPath.row)
            } else {
                print("ERROR: NMOutlineView cell path is nil")
            }
        }
        
        return theCell
        
    }
    
    @objc open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let datasource = self.datasource else {
            print("ERROR: no NMOutlineView datasource defined.")
            return
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? NMOutlineViewCell
             else {
                print("ERROR: unable to find cell at NMOutlineView.tableView IndexPath")
                return
        }
        guard  datasource.responds(to: #selector(NMOutlineViewDatasource.outlineView(_:didSelectCell:))) else {
            print("ERROR: NMOutlineViewDatasource protocol method outlineView(_:didSelectCell:) not implemented")
            return
        }
        datasource.outlineView?(self, didSelectCell: cell)
    }
}






