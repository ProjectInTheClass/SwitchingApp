//
//  TagFlowLayout.swift
//  MultiplePractice
//
//  Created by JNGSJN on 2020/10/06.
//

import UIKit

class TagFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        if attributes?.count == 1 {
            if let currentAttribute = attributes?.first {
                currentAttribute.frame = CGRect(x: self.sectionInset.left, y: currentAttribute.frame.origin.y, width: currentAttribute.frame.size.width, height: currentAttribute.frame.size.height)
            }
        }
        return attributes

    }
}
