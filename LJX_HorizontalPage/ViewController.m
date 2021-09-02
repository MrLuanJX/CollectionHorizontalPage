//
//  ViewController.m
//  LJX_HorizontalPage
//
//  Created by 理享学 on 2021/9/2.
//

#import "ViewController.h"
#import "LJX_CollectionView.h"

@interface ViewController ()

@property(nonatomic, strong)LJX_CollectionView* baseView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createUI];
}

- (void)createUI {
    [self.view addSubview:self.baseView];
}

- (LJX_CollectionView *)baseView {
    if (!_baseView) {
        _baseView = [[LJX_CollectionView alloc] initWithFrame:self.view.bounds];
    }
    return _baseView;
}

@end
