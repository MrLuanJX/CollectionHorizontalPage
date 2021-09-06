//
//  ViewController.swift
//  CollectionHorizontalLayout
//
//  Created by 理享学 on 2021/9/2.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

let kCustomDecorationViewKind = "CustomDecorationView"

class CustomDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class CustomHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class CustomFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(collectionView)
    }

    private lazy var collectionView : CollectionView = {
        let collectionView = CollectionView.init(frame: CGRect(x: 0, y: 0, width:SCREEN_WIDTH , height:SCREEN_HEIGHT))
        return collectionView
    }()
}

