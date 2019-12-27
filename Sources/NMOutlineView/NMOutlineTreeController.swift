//
//  NMOutlineTreeController.swift
//  NMOutlineView
//
//  Created by  on 1/17/20.
//  Copyright © 2020 Netmedia. All rights reserved.
//

import UIKit

public enum NMOutlineTreeError: Error {
    case ChildKeyPath
    case LeafKeyPath
    case CountKeyPath
    case ContentOrArrayNotConforming
}

@IBDesignable
@objcMembers public class NMOutlineTreeController: NMOutlineViewController {
    public override func outlineView(_ outlineView: NMOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return 0
    }
    
    public override func outlineView(_ outlineView: NMOutlineView, isItemExpandable item: Any) -> Bool {
        return true
    }
    
    public override func outlineView(_ outlineView: NMOutlineView, cellFor item: Any) -> NMOutlineViewCell {
        return NMOutlineViewCell(style: .default, reuseIdentifier: NMOutlineView.cellIdentifier)
    }
    
    public override func outlineView(_ outlineView: NMOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return NSObject()
    }
    
    
    @objc dynamic open var objectType: AnyClass!
    
    @objc dynamic open var objectTypeName: String {
        set {
            objectType = NSClassFromString(newValue).self
        }
        get {
            return NSStringFromClass(objectType)
        }
    }
    
    @IBInspectable @objc dynamic open var childrenKeyPath: String!
    @IBInspectable @objc dynamic open var countKeyPath: String!
    @IBInspectable @objc dynamic open var leafKeyPath: String!
    @objc dynamic open var content = Array<Any>()
    
    public init(withContent content: Any, ofType objectType: AnyClass, _ childrenKeyPath: String, _ countKeyPath: String, andLeafKeyPath leafKeyPath: String) throws {
        super.init(nibName: "NMOutlineView", bundle: nil)
        if type(of: content) != objectType {
            if String(describing: type(of: content)) != "Array<\(objectType)>" {
                throw NMOutlineTreeError.ContentOrArrayNotConforming
            } else {
                self.content = (content as! Array<Any>)
            }
        } else {
            self.content.append(content)
        }
        self.objectType = objectType.self
        self.childrenKeyPath = childrenKeyPath
        self.leafKeyPath = leafKeyPath
        self.countKeyPath = countKeyPath
        
        let conditionMirror: Mirror
        
        conditionMirror = Mirror(reflecting: self.content[0])
        /*print("Mirror: " + conditionMirror.description)
          for (label, value ) in conditionMirror.children {
            if let label = label {
                print("label: " + label)
            }
            print("value: \(value)")
          }*/
        if !(conditionMirror.children.contains(where: {label, value in
            label == self.childrenKeyPath
        })) && !class_respondsToSelector(objectType, Selector(childrenKeyPath))
        {
            throw NMOutlineTreeError.ChildKeyPath
        }
        if !(conditionMirror.children.contains(where: {label, value in
            label == self.leafKeyPath
        })) && !class_respondsToSelector(objectType, Selector(leafKeyPath))
        {
            throw NMOutlineTreeError.LeafKeyPath
        }
        if !(conditionMirror.children.contains(where: {label, value in
            label == self.countKeyPath
        })) && !class_respondsToSelector(objectType, Selector(countKeyPath))
        {
            throw NMOutlineTreeError.CountKeyPath
        }
    }
    
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    open func addNode(_ node: Any, at indexPath: IndexPath) {
        
        var indexPath = indexPath
        var children = content
        while indexPath.count > 1,
            let index = indexPath.popFirst(),
            index < children.count {
                let child = children[index]
                let mirrored = Mirror(reflecting: child)
                children = mirrored.children.first(where: {$0.label == childrenKeyPath})?.value as? [Any] ?? []
        }
        children.insert(node, at: indexPath.first!)
        outlineView?.insertRows(at: [indexPath], with: .top)
    }
    
    
    open func removeNode(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            var indexes = indexPath
            var children = content
            while indexes.count > 1,
                let index = indexes.popFirst(),
                index < children.count {
                    let child = children[index]
                    let mirrored = Mirror(reflecting: child)
                    children = mirrored.children.first(where: {$0.label == childrenKeyPath})?.value as? [Any] ?? []
            }
            let index = indexes.last!
            children.remove(at: index)
        }
        outlineView?.deleteRows(at: indexPaths, with: .bottom)
    }

}
