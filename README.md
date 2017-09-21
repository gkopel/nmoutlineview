NMOutlineView: Hierarchical Menu for iOS 
========================================

## Preview
![NMOutlineView preview](http://netmedia.home.pl/github/nmoutlineview/nmoutlineview-preview2.png)

## Description
NMOutlineView is a simple implementation of hierarchical menu for iOS. Menu items can be collapsed/expanded and are displayed on different indentation levels. NMOutlineView is internally implemented as UITableView object, it's items (cells) are subclasses of UITableViewCell class, so it's easy to customize their appearance with UITableViewCell API.
NMOutlineView exposes a datasource protocol. The protocol methods are similar to NSOutlineViewDatasource protocol available on macOS.
See example app for implementation details.

## Installation and Setup
- Add NMOutlineView.swift and NMoutlineViewCell.swift to your project
- Set your view controller as a datasource object of NMOutlineView instance.
- Implement datasource protocol methods described below.

## Requirements
- Swift 4.0 or later

## Datasource Methods

```swift
/* 
Returns the number of child items encompassed by the given item.
*/
func outlineView(_ outlineView: NMOutlineView, numberOfChildrenOfCell parentCell: NMOutlineViewCell?) -> Int  
```

```swift
/*
Returns a Boolean value that indicates whether the given item is expandable.  
*/
func outlineView(_ outlineView: NMOutlineView, isCellExpandable cell: NMOutlineViewCell) -> Bool 
```

```swift
/*
Invoked by outlineView to return the child cell object of the given parent item. 
*/
func outlineView(_ outlineView: NMOutlineView, childCell index: Int, ofParentAtIndexPath parentIndexPath: IndexPath?) -> NMOutlineViewCell
```

```swift
/*
Tells the datasource object that the specified row is now selected.
*/
func outlineView(_ outlineView: NMOutlineView, didSelectCell cell: NMOutlineViewCell);
```


## License
NMoutlineView is available under the MIT license. See the LICENSE file for more info.

