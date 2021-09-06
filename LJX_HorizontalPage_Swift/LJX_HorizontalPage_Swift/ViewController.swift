//
//  ViewController.swift
//  LJX_HorizontalPage_Swift
//
//  Created by 理享学 on 2021/9/6.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height

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

