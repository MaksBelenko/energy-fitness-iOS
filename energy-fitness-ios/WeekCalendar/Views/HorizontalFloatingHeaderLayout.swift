//
//  HorizontalFloatingHeaderLayout.swift
//  WeekCalendar
//
//  Created by Maksim on 07/10/2020.
//  Copyright © 2020 Maksim Belenko. All rights reserved.
//

import UIKit

@objc public protocol HorizontalFloatingHeaderLayoutDelegate: AnyObject {
    //Item size
    func collectionView(_ collectionView: UICollectionView,horizontalFloatingHeaderItemSizeAt indexPath:IndexPath) -> CGSize
    
    //Header size
    func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderSizeAt section: Int) -> CGSize
    
    //Section Inset
    @objc optional func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderSectionInsetAt section: Int) -> UIEdgeInsets
    
    //Item Spacing
    @objc optional func collectionView(_ collectionView: UICollectionView, horizontalFloatingHeaderItemSpacingForSectionAt section: Int) -> CGFloat
    
    //Line Spacing
    @objc optional func collectionView(_ collectionView: UICollectionView,horizontalFloatingHeaderColumnSpacingForSectionAt section: Int) -> CGFloat
}

public class HorizontalFloatingHeaderLayout: UICollectionViewLayout {
    
    private let layoutHelper = LayoutAttrHelper()
    
    //MARK: - Properties
    public override var collectionViewContentSize: CGSize {
        get {
            return getContentSize()
        }
    }
    
    //MARK: - Headers properties
    //Variables
    private var sectionHeadersAttributes: [IndexPath:UICollectionViewLayoutAttributes] {
        get {
            return getSectionHeadersAttributes()
        }
    }
    //MARK: - Items properties
    //Variables
    private var itemsAttributesCache = [IndexPath : UICollectionViewLayoutAttributes]()
    private var attributesCacheArray = [UICollectionViewLayoutAttributes]()
    //PrepareItemsAtributes only
    private var currentMinX: CGFloat = 0
    private var currentMinY: CGFloat = 0
    private var currentMaxX: CGFloat = 0
    
    //MARK: - PrepareForLayout methods
    public override func prepare() {
        guard let collectionView = collectionView else { return }
        
        resetAttributes()
        let sectionCount = collectionView.numberOfSections
        guard sectionCount > 0 else { return }
        
        for section in 0..<sectionCount {
            configureVariables(forSection: section)
            let itemCount = collectionView.numberOfItems(inSection:section)
            guard itemCount > 0 else { continue }
            
            for index in 0..<itemCount {
                let indexPath = IndexPath(row: index, section: section)
                let attribute = getItemAttribute(at: indexPath)
                itemsAttributesCache[indexPath] = attribute
                attributesCacheArray.append(attribute)
            }
        }
    }
    
    
    private func resetAttributes(){
        itemsAttributesCache.removeAll()
        attributesCacheArray.removeAll()
        currentMinX = 0
        currentMaxX = 0
        currentMinY = 0
    }
    
    private func configureVariables(forSection section: Int){
        let sectionInset = getInset(forSection: section)
        let lastSectionInset = getInset(forSection: section - 1)
        currentMinX = (currentMaxX + sectionInset.left + lastSectionInset.right)
        currentMinY = sectionInset.top + headerSize(forSection: section).height
        currentMaxX = 0.0 // setting section therefore 0
    }
    
    private func getItemAttribute(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let size = getItemSize(for: indexPath)
        let newMaxY = currentMinY + size.height
        let origin = (newMaxY > availableHeight(atSection: indexPath.section))
                                ? newLineOrigin(size: size, indexPath: indexPath)
                                : sameLineOrigin(size: size)
        
        let frame = CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height)
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attribute.frame = frame
        updateVariables(itemFrame: frame, indexPath: indexPath)
        return attribute
    }
    
    //Applying corrected layout
    private func newLineOrigin(size: CGSize, indexPath: IndexPath) -> CGPoint{
        let x = currentMaxX + getColumnSpacing(forSection: indexPath.section)
        let y = getInset(forSection: indexPath.section).top + headerSize(forSection: indexPath.section).height
        return CGPoint(x: x, y: y)
    }
    
    private func sameLineOrigin(size:CGSize)->CGPoint{
        return CGPoint(x: currentMinX, y: currentMinY)
    }
    
    private func updateVariables(itemFrame frame: CGRect, indexPath: IndexPath){
        currentMaxX = max(currentMaxX, frame.maxX) + getItemSpacing(forSection: indexPath.section)
        currentMinX = frame.minX
        currentMinY = frame.maxY + getItemSpacing(forSection: indexPath.section)
    }
    
    
    //MARK: - LayoutAttributesForElementsInRect methods
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let itemsA = layoutHelper.findAll(attributesCacheArray, intersect: rect)
        let headersA = Array(sectionHeadersAttributes.values) //findAll(Array(sectionHeadersAttributes.values), intersect: rect)
        return itemsA + headersA
    }
    
    
    //MARK: - ContentSize methods
    private func getContentSize() -> CGSize {
        guard let collectionView = collectionView else { return CGSize.zero }
        
        let lastSection = collectionView.numberOfSections - 1
        let contentWidth = lastItemMaxX() + getInset(forSection: lastSection).right
        let contentHeight = collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    private func lastItemMaxX() -> CGFloat{
        guard let collectionView = collectionView else { return CGFloat.zero }
        
        let lastSection = collectionView.numberOfSections - 1
        let lastIndexInSection = collectionView.numberOfItems(inSection: lastSection) - 1
        
        if let lastItemAttributes = layoutAttributesForItem(at: IndexPath(row: lastIndexInSection, section: lastSection)) {
            return lastItemAttributes.frame.maxX
        } else {
            return 0
        }
    }
    
    //MARK: - LayoutAttributes methods
    //MARK: For ItemAtIndexPath
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemsAttributesCache[indexPath]
    }
    
    //MARK: - For SupplementaryViewOfKind
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return sectionHeadersAttributes[indexPath]
        default:
            return nil
        }
    }
    
    //MARK: - Utility methods
    //MARK: SectionHeaders Attributes methods
    private func getSectionHeadersAttributes() -> [IndexPath:UICollectionViewLayoutAttributes] {
        
        guard let collectionView = collectionView else { return [:] }
        
        let sectionCount = collectionView.numberOfSections
        guard sectionCount > 0 else { return [:] }
        
        var attributes = [IndexPath : UICollectionViewLayoutAttributes]()
        for section in 0..<sectionCount {
            let indexPath = IndexPath(row: 0, section: section)
            attributes[indexPath] = attributeForSectionHeader(at: indexPath)
        }
        
        return attributes
    }
    
    
    private func attributeForSectionHeader(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes{
        let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                         with: indexPath)
        let headerPosition = getHeaderPosition(for: indexPath)
        let headerSize = getHeaderSize(for: indexPath)
        let frame = CGRect(x: headerPosition.x, y: headerPosition.y, width: headerSize.width, height: headerSize.height)
        attribute.frame = frame
        
        return attribute
    }
    
    private func getHeaderSize(for indexPath: IndexPath) -> CGSize{
        return headerSize(forSection: indexPath.section)
    }
    
    private func getHeaderPosition(for indexPath: IndexPath) -> CGPoint{
        if let itemsCount = collectionView?.numberOfItems(inSection: indexPath.section),
            let firstItemAttributes = layoutAttributesForItem(at: indexPath),
            let lastItemAttributes = layoutAttributesForItem(at: IndexPath(row: itemsCount-1, section: indexPath.section))
        {
            let edgeX = collectionView!.contentOffset.x + collectionView!.contentInset.left
            let xByLeftBoundary = max(edgeX, firstItemAttributes.frame.minX - getInset(forSection: indexPath.section).left)
            
            let width = getHeaderSize(for: indexPath).width
            let xByRightBoundary = lastItemAttributes.frame.maxX - width
            let x = min(xByLeftBoundary, xByRightBoundary)
            return CGPoint(x: x, y: 0)
        } else {
            return CGPoint(x: getInset(forSection: indexPath.section).left, y: 0)
        }
    }
    
    
    //MARK: - Invalidating layout methods
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        if !isSizeChanged(for: newBounds){
            context.invalidateSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader, at: headersIndexPaths())
        }
        return context
    }
    
    private func isSizeChanged(for newBounds: CGRect) -> Bool{
        let oldBounds = collectionView!.bounds
        return oldBounds.width != newBounds.width || oldBounds.height != newBounds.height
    }
    
    private func headersIndexPaths()->[IndexPath]{
        return Array(sectionHeadersAttributes.keys)
    }
    
    //MARK: - Utility methods
    private func getItemSize(for indexPath:IndexPath) -> CGSize{
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? HorizontalFloatingHeaderLayoutDelegate else {
                return CGSize.zero
        }
        
        return delegate.collectionView(collectionView, horizontalFloatingHeaderItemSizeAt: indexPath)
    }
    
    private func headerSize(forSection section:Int) -> CGSize{
        guard   let collectionView = collectionView,
            let delegate = collectionView.delegate as? HorizontalFloatingHeaderLayoutDelegate,
            section >= 0 else {
                return CGSize.zero
        }
        
        return delegate.collectionView(collectionView, horizontalFloatingHeaderSizeAt: section)
    }
    
    private func getInset(forSection section:Int) -> UIEdgeInsets{
        let defaultValue = UIEdgeInsets.zero
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? HorizontalFloatingHeaderLayoutDelegate,
            section >= 0 else {
                return defaultValue
        }
        
        return delegate.collectionView?(collectionView, horizontalFloatingHeaderSectionInsetAt: section) ?? defaultValue
    }
    
    private func getColumnSpacing(forSection section: Int) -> CGFloat{
        let defaultValue:CGFloat = 0.0
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? HorizontalFloatingHeaderLayoutDelegate,
            section >= 0 else {
                return defaultValue
        }
        
        return delegate.collectionView?(collectionView, horizontalFloatingHeaderColumnSpacingForSectionAt: section) ?? defaultValue
    }
    
    private func getItemSpacing(forSection section: Int) -> CGFloat{
        let defaultValue:CGFloat = 0.0
        guard let collectionView = collectionView,
            let delegate = collectionView.delegate as? HorizontalFloatingHeaderLayoutDelegate,
            section >= 0 else {
                return defaultValue
        }
        
        return delegate.collectionView?(collectionView, horizontalFloatingHeaderItemSpacingForSectionAt: section) ?? defaultValue
    }
    
    private func availableHeight(atSection section:Int)->CGFloat{
        guard let collectionView = collectionView else {
            return 0.0
        }
        
        func totalInset()->CGFloat{
            let sectionInset = getInset(forSection: section)
            let contentInset = collectionView.contentInset
            return sectionInset.top + sectionInset.bottom + contentInset.top + contentInset.bottom
        }
        
        guard section >= 0 else {
            return 0.0
        }
        
        return collectionView.bounds.height - totalInset()
    }
}
