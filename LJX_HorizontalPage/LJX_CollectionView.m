//
//  LJX_CollectionView.m
//  LJX_HorizontalPage
//
//  Created by 理享学 on 2021/9/2.
//

#import "LJX_CollectionView.h"
#import "LJX_HorizontalPageFlowlayout.h"

static NSInteger rowCount = 3;      // 行数
static NSInteger countPerRow = 4;   // 每行多少个item
static NSInteger allCount = 45;     // 一共多少个item
#define Random(X)    arc4random_uniform(X)/255.0

@interface LJX_CollectionCell()

/** 标题  */
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation LJX_CollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.contentView addSubview:self.titleLabel];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel               = [[UILabel alloc] init];
        _titleLabel.font          = [UIFont systemFontOfSize:20];
        _titleLabel.textColor     = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end

@interface LJX_CollectionView() <UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong)UICollectionView* collectionView;
@property(nonatomic, strong)NSMutableArray* dataSource;
@property(nonatomic, strong)UIPageControl *pageControl;

@end

@implementation LJX_CollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LJX_CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([LJX_CollectionCell class]) forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:Random(255) green:Random(255) blue:Random(255) alpha:1.0];
    NSInteger row = indexPath.row;
    cell.titleLabel.text = [NSString stringWithFormat:@"第%ld个", (long)row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%ld个item",indexPath.item);
}

//设置页码
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page=(int)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.dataSource.count;
    self.pageControl.currentPage=page;
}

#pragma mark - Lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        // 自定义LJX_HorizontalPageFlowlayout布局
        LJX_HorizontalPageFlowlayout *layout = [[LJX_HorizontalPageFlowlayout alloc] initWithRowCount:rowCount itemCountPerRow:countPerRow];
        // 设置行列间距及collectionView的内边距
        [layout ljx_ColumnSpacing:10 rowSpacing:15 edgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        // 同一个section 内部item的竖直方向间隙
        layout.minimumInteritemSpacing = 0;
        // 同一个section 内部 item的水平方向间隙
        layout.minimumLineSpacing = 0;
        // 水平滑动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 初始化
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 300, [UIScreen mainScreen].bounds.size.width, 300) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.bounces = YES;
        // 翻过整页
        _collectionView.pagingEnabled = YES;
        // 遵守代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        // 纯代码注册
         [_collectionView registerClass:[LJX_CollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([LJX_CollectionCell class])];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
        for (int i=0; i<allCount; i++) {
            [_dataSource addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _dataSource;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.collectionView.frame), [UIScreen mainScreen].bounds.size.width, 50)];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.numberOfPages = ceil((CGFloat)self.dataSource.count/countPerRow/rowCount);
    }
    return _pageControl;
}
@end
