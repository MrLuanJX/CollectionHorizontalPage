//
//  CollectionView.swift
//  LJX_HorizontalPage_Swift
//
//  Created by 理享学 on 2021/9/2.
//

import UIKit

let rowCount = 3    // 行数
let countPerRow = 3 // 每行多少个item
let allCount = 55   // 一共多少个item

let identifier = "HorizontalPageCell"

class CollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }

    func createUI() {
        self.titleLabel.frame = CGRect.init(x: 0, y: 0, width: self.contentView.bounds.size.width, height: self.contentView.bounds.size.height)
        self.contentView.addSubview(self.titleLabel)
    }
    
    // title
    private var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.center
        return titleLabel
    }()
}

//swift中的写法
func RandomColor(value:CGFloat) -> CGFloat {
    return CGFloat(arc4random_uniform(UInt32(value)))/255.0
}

class CollectionView: UIView {
    var dataSource = [String]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.setUpLayout()
        
        for i in 0..<allCount {
            dataSource.append("\(i)")
        }
        
        let dtatSourceCount = Float(dataSource.count)
        pageControl.numberOfPages = Int(ceil(dtatSourceCount/Float(rowCount)/Float(countPerRow)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var collectionView : UICollectionView = {
        let layout = CollectionLayout.init()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.rowCountItem(rowCount: rowCount, countPerRow: countPerRow)
        layout.columnSpacing(columnSpacing: 10, rowSpacing: 10, edge: UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10))
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 300), collectionViewLayout:layout)
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.bounces = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(CollectionCell.classForCoder(), forCellWithReuseIdentifier:identifier)
        
        return collectionView
    }()
    
    private lazy var pageControl : UIPageControl = {
        let pageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: 500, width: self.frame.size.width, height: 50))
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.orange
        
        return pageControl
    }()
    
    func setUpLayout() {
        self.addSubview(collectionView)
        self.addSubview(pageControl)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = NSInteger(Int((scrollView.contentOffset.x/scrollView.frame.size.width+0.5))%NSInteger(dataSource.count))
    }
}

extension CollectionView : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CollectionCell
        cell.contentView.backgroundColor = UIColor.init(red: RandomColor(value: 255), green: RandomColor(value: 255), blue: RandomColor(value: 255), alpha: 1)
        let row = indexPath.row
                
        cell.title = String("\(row)")
        
        return cell
    }
}

 
