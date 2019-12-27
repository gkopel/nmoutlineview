//
//  NMOutlineView.swift
//
//  Created by Greg Kopel on 11/05/2017.
//  Copyright © 2017 Netmedia. All rights reserved.
//


import UIKit


// MARK: - IndexPath convenience initializer

extension IndexPath {
    init(row index: Int) {
        self.init(row: index, section: 0)
    }
}


// MARK:- NMOutlineDatasource Protocol
@objc(NMOutlineViewDatasource)
public protocol NMOutlineViewDatasource: NSObjectProtocol {
    @objc func outlineView(_ outlineView: NMOutlineView, numberOfChildrenOfItem item: Any?) -> Int
    @objc func outlineView(_ outlineView: NMOutlineView, isItemExpandable item: Any) -> Bool
    @objc optional func outlineView(_ outlineView: NMOutlineView, shouldExpandItem item: Any) -> Bool
    @objc func outlineView(_ outlineView: NMOutlineView, cellFor item: Any) -> NMOutlineViewCell
    @objc optional func outlineView(_ outlineView: NMOutlineView, didSelect cell: NMOutlineViewCell)
    @objc func outlineView(_ outlineView: NMOutlineView, child index: Int, ofItem item: Any?)->Any
}


// MARK: - NMOutlineView Class
@objc(NMOutlineView)
@IBDesignable @objcMembers open class NMOutlineView: UITableView  {
    // MARK: Properties

    // Datasource for internal tableview
    @IBOutlet @objc dynamic open var datasource: NMOutlineViewDatasource! {
        didSet {
            // Setup initial state
            oldTableViewDatasource = []
            self.restartDatasource()
        }
    }

    private func restartDatasource() {
        tableViewDatasource = []
        if let datasource = datasource {
            let rootItemsCount = datasource.outlineView(self, numberOfChildrenOfItem: nil)
            for index in 0 ..< rootItemsCount {
                let item = datasource.outlineView(self, child: index, ofItem: nil)
                let nmItem = NMItem(withItem: item, at: IndexPath(index: index), ofParent: nil, isExpanded: false)
                tableViewDatasource.append(nmItem)
            }
        }
        super.reloadData()
    }
    
    
    // Single item in the collection
    @objc open class NMItem: NSObject  {
        @objc dynamic public var item: Any
        @objc dynamic public var indexPath: IndexPath
        @objc dynamic public var isExpanded = false
        @objc dynamic public var parent: NMItem?
        @objc dynamic public var level: Int  {
            return indexPath.count - 1
        }
        
        public init(withItem item: Any, at indexPath: IndexPath, ofParent parent: NMItem?, isExpanded expanded:Bool) {
            self.item = item
            self.indexPath = indexPath
            self.isExpanded = expanded
            self.parent = parent
            super.init()
        }
    }
    
    // Type property
    static public var cellIdentifier = "nmOutlineViewCell"

    @IBInspectable @objc public dynamic var maintainExpandedItems: Bool = false

    private var oldTableViewDatasource = [NMItem]()
    @objc dynamic private var tableViewDatasource = [NMItem]()
    
    // MARK: Initializers
    
    @objc private func sharedInit() {
        super.dataSource = self
        super.delegate = self
        self.separatorStyle = .none
        self.separatorInset = .zero
        self.register(NMOutlineViewCell.self, forCellReuseIdentifier: NMOutlineView.cellIdentifier)
        self.register(UINib(nibName: "NMOutlineViewCell", bundle: nil), forCellReuseIdentifier: NMOutlineView.cellIdentifier)
    }
    
    
    @objc public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        sharedInit()
        //let cell = NMOutlineViewCell(style: .default, reuseIdentifier: NMOutlineView.cellIdentifier)
        //self.addSubview(cell)
    }
    
    
    @objc required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    @objc override open func awakeFromNib() {
        super.awakeFromNib()
        sharedInit()
    }
    
    
    // MARK: NMOutlineView methods
    
    @objc open func dequeReusableCell(withIdentifier identifier: String, style: UITableViewCell.CellStyle) -> NMOutlineViewCell {
        guard let cell = super.dequeueReusableCell(withIdentifier: identifier) as? NMOutlineViewCell
            else { return NMOutlineViewCell(style: style, reuseIdentifier: identifier) }
        return cell
    }
    
    
    @objc open func locationForPress(_ sender: UILongPressGestureRecognizer) -> CGPoint {
        return sender.location(in: self)
    }
    
    
    @objc open func cellAtPoint(_ point: CGPoint) -> NMOutlineViewCell? {
        return super.cellForRow(at: super.indexPathForRow(at: point) ?? IndexPath()) as? NMOutlineViewCell
    }
    
    
    @objc open override func cellForRow(at indexPath: IndexPath) -> NMOutlineViewCell? {
         guard let index = tableViewDatasource.firstIndex(where: {$0.indexPath == indexPath }) else { return nil }
        return super.cellForRow(at: IndexPath(row: index, section: 0)) as? NMOutlineViewCell
    }
    
    open func cellForItem<T: Equatable>(_ item: T) -> NMOutlineViewCell? {
        guard let index = tableViewDatasource.firstIndex(where: {$0.item as? T == item }) else { return nil }
        return super.cellForRow(at: IndexPath(row: index, section: 0)) as? NMOutlineViewCell
    }
    
    
    @objc open func indexPathforCell(at point:CGPoint) -> IndexPath? {
        return super.indexPathForRow(at: point)
    }
    
    
    @objc open func indexPath(for cell: NMOutlineViewCell) -> IndexPath? {
        guard let tableIndexPath = super.indexPath(for: cell) else { return nil}
        return tableViewDatasource[tableIndexPath.row].indexPath
    }
    
    
    open func tableViewIndex(for cell: NMOutlineViewCell) -> Int? {
        guard let tableIndexPath = super.indexPath(for: cell) else { return nil}
        return tableIndexPath.row
    }
    
    
    @objc open override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        var tableIndexPaths = Array<IndexPath>()
        for indexPath in indexPaths {
            if !(tableViewDatasource.contains(where: {$0.indexPath == indexPath})) {
                if let parentIndex = tableViewDatasource.firstIndex(where: { $0.indexPath == indexPath.dropLast() }),
                    let parentItem = tableViewDatasource.first(where: { $0.indexPath == indexPath.dropLast() }),
                    indexPath.last ?? Int.max < datasource.outlineView(self, numberOfChildrenOfItem: parentItem) - 1,
                    parentIndex + (indexPath.last ?? Int.max) <= tableViewDatasource.count {
                    let childItem = datasource.outlineView(self, child: indexPath.last!, ofItem: parentItem)
                    let item = NMItem(withItem: childItem, at: indexPath, ofParent: parentItem, isExpanded: false)
                    tableViewDatasource.insert(item, at: parentIndex + indexPath.last! + 1)
                    tableIndexPaths.append(IndexPath(row: parentIndex + indexPath.last! + 1))
                }
            }
        }
        super.insertRows(at: tableIndexPaths, with: animation)
    }
    
    
    @objc open override func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        var tableIndexPaths = Array<IndexPath>()
        for indexPath in indexPaths {
            if let index = tableViewDatasource.firstIndex(where: {$0.indexPath == indexPath}) {
                tableViewDatasource.remove(at: index)
                tableIndexPaths.append(IndexPath(row: index))
            }
        }
        super.deleteRows(at: tableIndexPaths, with: animation)
    }
    
    
    @objc open override func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .none) {
        var tableIndexPaths = [IndexPath]()
        for indexPath in indexPaths {
            guard let item = tableViewDatasource.first(where: {$0.indexPath == indexPath }),
                let cell = self.cellForRow(at: indexPath) else { continue }
            if animation != .none ,
                let index = tableViewDatasource.firstIndex(of: item) {
                tableIndexPaths.append(IndexPath(row: index))
            } else {
                if Mirror(reflecting: item.item).displayStyle != .class {
                    item.item = datasource.outlineView(self, child: indexPath.last!, ofItem: item.parent)
                }
                cell.update(with: item.item)
            }
        }
        if !tableIndexPaths.isEmpty {
            super.reloadRows(at: tableIndexPaths, with: animation)
        }
    }
    
    private func reloadItems<T: Equatable>()->T? {
        if !tableViewDatasource.isEmpty && maintainExpandedItems {
            oldTableViewDatasource = tableViewDatasource.filter({$0.isExpanded})
        }
        self.restartDatasource()
        if maintainExpandedItems {
            for item in Array(tableViewDatasource) {
                if let oldItemIndex = oldTableViewDatasource.firstIndex(where: {$0.item as? T == (item.item as? T) }) {
                    if oldTableViewDatasource[oldItemIndex].isExpanded {
                        let _: NSObject? = self.toggleItem(item)
                    }
                    oldTableViewDatasource.remove(at: oldItemIndex)
                }
            }
        }
        return nil
    }
    
    
    @objc open override func reloadData() {
        let _: NSObject? = self.reloadItems() as NSObject?
    }
    
    
    fileprivate func toggleItem<T:Equatable>(_ item: NMItem)->T? {
        guard let datasource = self.datasource,
            let index = tableViewDatasource.firstIndex(of: item) else { return nil}
        
        if item.isExpanded {
            // Collapse
            let childrenCount = datasource.outlineView(self, numberOfChildrenOfItem: item.item)
            item.isExpanded = false
            if childrenCount > 0 {
                var tableViewIndexPaths = [IndexPath]()
                var indexes = IndexSet()
                for i in 0..<childrenCount
                {
                    let childrenItem = tableViewDatasource[index + i + 1]
                    if childrenItem.isExpanded {
                        let _: NSObject? = self.toggleItem(childrenItem)
                    }
                     let tableViewIndexPath = IndexPath(row: index + i + 1, section: 0)
                    tableViewIndexPaths.append(tableViewIndexPath)
                    indexes.insert(index + i + 1)
                }
                if !tableViewIndexPaths.isEmpty {
                    while let index = indexes.last {
                        tableViewDatasource.remove(at: index)
                        indexes = IndexSet(indexes.dropLast())
                    }
                    super.deleteRows(at: tableViewIndexPaths, with: .fade)
                }
                
            } else {
                print("ERROR: NMOutlineView cell is NOT collapsable")
            }
        } else {
            // Expand
            if datasource.outlineView(self, isItemExpandable: item.item) {
                item.isExpanded = true
                var childrenCount = datasource.outlineView(self, numberOfChildrenOfItem: item.item)
                let cellItemIndexPath = item.indexPath
                while childrenCount > 0 {
                    var itemIndexPath = IndexPath(indexes: cellItemIndexPath)
                    itemIndexPath.append(childrenCount - 1)
                    let childItem = datasource.outlineView(self, child: childrenCount - 1, ofItem: item.item)
                    let newItem = NMItem(withItem: childItem, at: itemIndexPath, ofParent: item, isExpanded: false)
                    tableViewDatasource.insert(newItem, at: index + 1)
                    super.insertRows(at: [IndexPath(row: index + 1, section: 0)], with: .fade)
                    if maintainExpandedItems,
                    let oldItemIndex = oldTableViewDatasource.firstIndex(where: {$0.item as? T == childItem as? T}) {
                        if oldTableViewDatasource[oldItemIndex].isExpanded {
                            let _: NSObject? = self.toggleItem(newItem)
                        }
                        oldTableViewDatasource.remove(at: oldItemIndex)
                    }
                    childrenCount -= 1
                }
            } else {
                print("ERROR: NMOutlineView cell is NOT expandable")
            }
        }
        return nil
    }
       
}

// MARK: - Internal TableView datasource/delegate
extension NMOutlineView: UITableViewDataSource, UITableViewDelegate {
    @objc public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    @objc public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDatasource.count
    }
    
    
    @objc public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let datasource = self.datasource else {
            print("ERROR: no NMOutlineView datasource defined.")
            return NMOutlineViewCell(style: .default, reuseIdentifier: "ErrorCell")
        }
        let item = tableViewDatasource[indexPath.row]
        let theCell = datasource.outlineView(self, cellFor: item.item)
        theCell.isExpanded = item.isExpanded
        theCell.itemValue = item
        theCell.nmIndentationLevel = item.level
        theCell.toggleButton.isHidden = !datasource.outlineView(self, isItemExpandable: item.item)
        theCell.onToggle = { (sender) in
            let _:NSObject? = self.toggleItem(item)
        }
        return theCell
    }
    
    
    @objc public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let datasource = self.datasource else {
            print("ERROR: no NMOutlineView datasource defined.")
            return
        }
        guard let cell = super.cellForRow(at: indexPath) as? NMOutlineViewCell
            else {
                print("ERROR: unable to find cell at NMOutlineView.tableView IndexPath")
                return
        }
        guard  datasource.responds(to: #selector(NMOutlineViewDatasource.outlineView(_:didSelect:))) else {
            print("ERROR: NMOutlineViewDatasource protocol method outlineView(_:didSelectCell:) not implemented")
            return
        }
        datasource.outlineView?(self, didSelect: cell)
    }
}


