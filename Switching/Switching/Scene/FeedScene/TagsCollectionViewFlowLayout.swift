//
//  TagsCollectionViewFlowLayout.swift
//  Switching
//
//  Created by JNGSJN on 2020/11/02.
//

import UIKit

class TagsCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        if let currentAttribute = attributes?.first {
            currentAttribute.frame = CGRect(x: self.sectionInset.left, y: currentAttribute.frame.origin.y, width: currentAttribute.frame.size.width, height: currentAttribute.frame.size.height)
        }
        return attributes
    }
}
