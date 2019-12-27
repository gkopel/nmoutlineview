NMOutlineView: Hierarchical Menu for iOS 
========================================

## Description
NMOutlineView is a simple implementation of hierarchical menu for iOS. Menu items can be collapsed/expanded and are displayed on different indentation levels. NMOutlineView is internally implemented as UITableView object, it's items (cells) are subclasses of UITableViewCell class, so it's easy to customize their appearance with UITableViewCell API.
NMOutlineView exposes a datasource protocol. The protocol methods are similar to NSOutlineViewDatasource protocol available on macOS.

NMOutlineView and the controller NMOutlineViewController are Interface Builder ready, you can just drag a UIViewController and a UITableView in your Storyboard and then assign the object class NMOutlineViewController and NMOutlineView.  

The Outlineview provide the property "maintainExpandedItems", the property stablish if the view should try to maintain the current expanded cells when a reloadData is issue.  By the default this property is false, meaning that if a reloadData is issue, actual expanded cells will be restarted(collapsed).  You can assign this property directly in the Interface Builder.

See example app for implementation details.

## Installation and Setup
- Add NMOutlineView.swift and NMoutlineViewCell.swift to your project
- Subclass the NMOutlineViewController.
- Implement datasource protocol methods described below.

## Requirements
- Swift 4.0 or later

## Datasource Methods

```swift
/*For your subclasses of NMOutlineViewCell make sure that the method update(with item:Any) is implemented
*/



/* 
Returns the number of child items encompassed by the given item.
*/
func outlineView(_ outlineView: NMOutlineView, numberOfChildrenOfItem item: Any?) -> Int
```


```swift
/*
Returns the child object value for parent item, located at the index position 
*/
func outlineView(_ outlineView: NMOutlineView, child index: Int, ofItem item: Any?) -> Any
```


```swift
/*
Returns a Boolean value that indicates whether the given item is expandable.  
*/
func outlineView(_ outlineView: NMOutlineView, isItemExpandable item: Any) -> Bool
```


```swift
/*
Invoked by outlineView to return the cell view for the giving Item
*/
func outlineView(_ outlineView: NMOutlineView, cellFor item: Any) -> NMOutlineViewCell
```


```swift
/*
Tells the datasource object that the specified row is now selected.  This methos is optional
*/
func outlineView(_ outlineView: NMOutlineView, didSelect cell: NMOutlineViewCell) 
```

```swift
/*
Returns a Boolean value that indicates whether the given item should be expanded. This method is optional
*/
func outlineView(_ outlineView: NMOutlineView, shouldExpandItem item: Any) -> Bool

```

## License
NMoutlineView is available under the MIT license. See the LICENSE file for more info.

