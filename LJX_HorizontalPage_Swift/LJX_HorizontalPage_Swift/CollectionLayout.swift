//
//  CollectionLayout.swift
//  LJX_HorizontalPage_Swift
//
//  Created by 理享学 on 2021/9/2.
//

import UIKit

class CollectionLayout: UICollectionViewFlowLayout {
    fileprivate var attributesArrayM = [UICollectionViewLayoutAttributes]()
    
    func rowCountItem(rowCount:NSInteger,countPerRow:NSInteger) {
        self.rowCount = rowCount
        self.countPerRow = countPerRow        
    }
    
    func columnSpacing(columnSpacing:NSInteger,rowSpacing:NSInteger,edge:UIEdgeInsets) {
        self.edgeInsets = edge
        self.columnSpacing = columnSpacing
        self.rowSpacing = rowSpacing
    }

    private lazy var rowCount: NSInteger = {
        let rowCount = NSInteger.init()

        return rowCount
    }()

    private lazy var countPerRow: NSInteger = {
        let countPerRow = NSInteger.init()

        return countPerRow
    }()

    private lazy var edgeInsets: UIEdgeInsets = {
        let edgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)

        return edgeInsets
    }()

    private lazy var columnSpacing: NSInteger = {
        let columnSpacing = NSInteger.init()

        return columnSpacing
    }()

    private lazy var rowSpacing: NSInteger = {
        let rowSpacing = NSInteger.init()

        return rowSpacing
    }()
    
    override func prepare() {
        super.prepare()
        
        let itemTotalCount = (collectionView!.numberOfItems(inSection: 0))
        
        for i in 0..<itemTotalCount {
            let indexPath = IndexPath.init(item: i, section: 0)
            let attributes = self.layoutAttributesForItem(at: indexPath)
            attributesArrayM.append(attributes)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArrayM
    }

    override var collectionViewContentSize: CGSize {
        let itemWidth = CGFloat.init((UIScreen.main.bounds.size.width-CGFloat(self.edgeInsets.left) - CGFloat(self.countPerRow*self.columnSpacing))/CGFloat(self.countPerRow))

        let itemTotalCount : NSInteger = (collectionView?.numberOfItems(inSection: 0))!
        
        let itemCount : NSInteger = self.rowCount*self.countPerRow
        
        let remainder : NSInteger = NSInteger(itemTotalCount%itemCount)
        
        var pageNumber : NSInteger = itemTotalCount / itemCount

        if itemTotalCount <= itemCount {
            pageNumber = 1;
        } else {
            if remainder != 0 {
                pageNumber = pageNumber + 1
            }
        }
    
        let width : CGFloat = CGFloat(Float(self.edgeInsets.left))+CGFloat(Float(pageNumber))*CGFloat(self.countPerRow)*(CGFloat(itemWidth)+CGFloat(self.columnSpacing))-CGFloat(self.columnSpacing)+CGFloat(self.edgeInsets.right)+CGFloat(pageNumber-1)*CGFloat(self.edgeInsets.left)
        // 横向滚动 height为0
        return  CGSize(width: width, height: 0)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes  {
        let itemWidth: CGFloat = (collectionView!.frame.size.width - CGFloat(self.edgeInsets.left) - CGFloat(self.countPerRow*self.columnSpacing)) / CGFloat(Float(self.countPerRow))
        
        let itemHeight: CGFloat = (collectionView!.frame.size.height-CGFloat(self.edgeInsets.top)-CGFloat(self.edgeInsets.bottom)-CGFloat(self.rowCount-1)*CGFloat(self.rowSpacing))/CGFloat(self.rowCount)
        
        let item = indexPath.item

        let pageNumber : NSInteger = NSInteger(item)/NSInteger(self.rowCount*self.countPerRow)

        let x : CGFloat = CGFloat(item%self.countPerRow)+CGFloat(NSInteger(pageNumber)*NSInteger(self.countPerRow))
        
        let y : CGFloat = CGFloat(item/self.countPerRow)-CGFloat(NSInteger(pageNumber)*NSInteger(self.rowCount))

        let itemX : CGFloat = CGFloat(self.edgeInsets.left)+CGFloat((itemWidth+CGFloat(self.columnSpacing))*x)

        let itemY : CGFloat = CGFloat(self.edgeInsets.top)+CGFloat((itemHeight+CGFloat(self.rowSpacing))*y)
        
        let attributes = super.layoutAttributesForItem(at: indexPath as IndexPath) ?? UICollectionViewLayoutAttributes.init()
        
        attributes.frame = CGRect.init(x:(CGFloat(10*pageNumber)+itemX), y: itemY, width: itemWidth, height: itemHeight)

        return attributes
    }
}

