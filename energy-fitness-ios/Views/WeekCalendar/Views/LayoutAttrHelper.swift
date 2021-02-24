//
//  LayoutAttrHelper.swift
//  WeekCalendar
//
//  Created by Maksim on 29/11/2020.
//  Copyright © 2020 Maksim Belenko. All rights reserved.
//

import UIKit

class LayoutAttrHelper {
    
    var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    
    func findAll(_ attributes: [UICollectionViewLayoutAttributes], intersect rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        
        cachedAttributes = attributes
        
        var attributesArray = [UICollectionViewLayoutAttributes]()
        
        guard let lastIndex = attributes.indices.last,
              let index = binSearch(rect, start: 0, end: lastIndex) else {
            return attributesArray
        }
        
        
        for attribute in attributes[..<index].reversed() {
            guard attribute.frame.maxY >= rect.minY else { break }
            attributesArray.append(attribute)
        }

        for attribute in attributes[index...] {
            guard attribute.frame.minY <= rect.maxY else { break }
            attributesArray.append(attribute)
        }
        
        return attributesArray
    }
    
    
    // Perform a binary search on the cached attributes array.
    func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start {
            return nil
        }
        
        let mid = (start + end) / 2
        let attr = cachedAttributes[mid]
        
        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxX < rect.minX {
                return binSearch(rect, start: (mid + 1), end: end)
            } else {
                return binSearch(rect, start: start, end: (mid - 1))
            }
        }
    }

}
