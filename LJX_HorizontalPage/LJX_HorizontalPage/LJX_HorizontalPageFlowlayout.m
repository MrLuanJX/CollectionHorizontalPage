//
//  LJX_HorizontalPageFlowlayout.m
//  LJX_HorizontalPage
//
//  Created by 理享学 on 2021/9/2.
//

#import "LJX_HorizontalPageFlowlayout.h"

@implementation LJX_HorizontalPageFlowlayout

#pragma mark - Public
- (void)ljx_ColumnSpacing:(CGFloat)columnSpacing rowSpacing:(CGFloat)rowSpacing edgeInsets:(UIEdgeInsets)edgeInsets {
    
    self.columnSpacing = columnSpacing;
    self.rowSpacing = rowSpacing;
    self.edgeInsets = edgeInsets;
}

- (void)ljx_RowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow {
    self.rowCount = rowCount;
    self.itemCountPerRow = itemCountPerRow;
}

#pragma mark - 构造方法
+ (instancetype)ljx_horizontalPageFlowlayoutWithRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow {
    
    return [[self alloc] initWithRowCount:rowCount itemCountPerRow:itemCountPerRow];
}

- (instancetype)initWithRowCount:(NSInteger)rowCount itemCountPerRow:(NSInteger)itemCountPerRow {
    if (self = [super init]) {
        self.rowCount = rowCount;
        self.itemCountPerRow = itemCountPerRow;
    }
    return self;
}

#pragma mark - 重写父类方法
- (instancetype)init {
    if (self = [super init]) {
        [self ljx_ColumnSpacing:0 rowSpacing:0 edgeInsets:UIEdgeInsetsZero];
    }
    return self;
}

/** 布局前做一些准备工作 */
- (void)prepareLayout {
    [super prepareLayout];
    
    // 从collectionView中获取到有多少个item
    NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:0];
    
    // 遍历出item的attributes,把它添加到管理它的属性数组中去
    for (int i = 0; i < itemTotalCount; i++) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexpath];
        [self.attributesArrayM addObject:attributes];
    }
}

/** 计算collectionView的滚动范围 */
- (CGSize)collectionViewContentSize {
    // 计算出item的宽度
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - self.edgeInsets.left - self.itemCountPerRow * self.columnSpacing) / self.itemCountPerRow;
    // 从collectionView中获取到有多少个item
    NSInteger itemTotalCount = [self.collectionView numberOfItemsInSection:0];
    
    // 理论上每页展示的item数目
    NSInteger itemCount = self.rowCount * self.itemCountPerRow;
    // 余数（用于确定最后一页展示的item个数）
    NSInteger remainder = itemTotalCount % itemCount;
    // 除数（用于判断页数）
    NSInteger pageNumber = itemTotalCount / itemCount;
    // 总个数小于self.rowCount * self.itemCountPerRow
    if (itemTotalCount <= itemCount) {
        pageNumber = 1;
    }else {
        if (remainder == 0) {
            pageNumber = pageNumber;
        }else {
            // 余数不为0,除数加1
            pageNumber = pageNumber + 1;
        }
    }
    
    CGFloat width = self.edgeInsets.left + pageNumber * self.itemCountPerRow * (itemWidth + self.columnSpacing) - self.columnSpacing + self.edgeInsets.right + (pageNumber-1)*self.edgeInsets.left;

    // 只支持水平方向上的滚动
    return CGSizeMake(width, 0);
}

/** 设置每个item的属性(主要是frame) */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // item的宽高由行列间距和collectionView的内边距决定
    CGFloat itemWidth  = (UIScreen.mainScreen.bounds.size.width - self.edgeInsets.left - self.itemCountPerRow * self.columnSpacing) / self.itemCountPerRow;
    CGFloat itemHeight = (self.collectionView.frame.size.height - self.edgeInsets.top - self.edgeInsets.bottom - (self.rowCount - 1) * self.rowSpacing) / self.rowCount;
    
    NSInteger item = indexPath.item;
    // 当前item所在的页
    NSInteger pageNumber = item / (self.rowCount * self.itemCountPerRow);
    NSInteger x = item % self.itemCountPerRow + pageNumber * self.itemCountPerRow;
    NSInteger y = item / self.itemCountPerRow - pageNumber * self.rowCount;
    
    // 计算出item的坐标
    CGFloat itemX = self.edgeInsets.left + (itemWidth + self.columnSpacing) * x;
    CGFloat itemY = self.edgeInsets.top + (itemHeight + self.rowSpacing) * y;
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    // 每个item的frame
    attributes.frame = CGRectMake((10*pageNumber)+itemX, itemY, itemWidth, itemHeight);
        
    return attributes;
}

/** 返回collectionView视图中所有视图的属性数组 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributesArrayM;
}

#pragma mark - Lazy
- (NSMutableArray *)attributesArrayM {
    if (!_attributesArrayM) {
        _attributesArrayM = @[].mutableCopy;
    }
    return _attributesArrayM;
}

@end
