//
//  HMZCycleController.m
//  My-News
//
//  Created by 赵志丹 on 15/11/26.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZCycleController.h"
#import "HMZCycle.h"
#import "HMZCycleCell.h"
#import "UIView+HMZFrame.h"
#import <objc/runtime.h>
#import <PureLayout/PureLayout.h>
#define HMZMinSection 3

@interface HMZCycleController ()
@property (weak, nonatomic) UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *contentLayout;

@property (nonatomic,strong) NSArray *cycleList;
@end

@implementation HMZCycleController

static NSString * const reuseIdentifier = @"CycleCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.collectionView.w = [UIScreen mainScreen].bounds.size.width;
    self.collectionView.h = 250;
    self.collectionView.pagingEnabled = YES;
    
    self.contentLayout.itemSize = self.collectionView.bounds.size;
    self.contentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.contentLayout.minimumLineSpacing = 0;
    self.contentLayout.minimumInteritemSpacing = 0;
}

- (void)loadData{//加载数据
    __weak typeof(self) weakSelf = self;
    [HMZCycle cycleWithFinishBlock:^(NSArray *cycleList) {
        weakSelf.cycleList = cycleList;
        weakSelf.pageControl.numberOfPages = cycleList.count;
    }];
}

- (void)setCycleList:(NSArray *)cycleList{
    _cycleList = cycleList;
    [self.collectionView reloadData];
    //1.通过无动画的方式,自动滚动到最中间的那组去
    //2.创建最中的那组
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:HMZMinSection / 2 ];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark -pageControl
- (UIPageControl *)pageControl{
    if (_pageControl) {
        //1.创建一个PageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.pageIndicatorTintColor = [UIColor blueColor];
        pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
        //2.添加到父控件,在使用PureLayout之前一定要先加入到父控件身上
        [self.view addSubview:pageControl];
        
        self.pageControl = pageControl;
        
        //3.pageControl
        [pageControl autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-10];
        [pageControl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:3];
        //[pageControl autoSetDimensionsToSize:CGSizeMake(100, 30)];//设置尺寸
        
        //设置我们的图片,来替换系统原先的圆圈圈
        /**
         _currentPageImage
         _pageImage
         */
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"_pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKey:@"_currentPageImage"];
    }
    return _pageControl;
}

- (void)getUIPageControlPrivate{
    NSMutableArray *properties = [NSMutableArray array];
    
    //我们的一个属性的个数
    unsigned int count = 0;//属性的个数
    //propertyArray 相当于是一个数组
    /**
     class_copyIvarList 这个既可以拿到公有属性,也可以拿到私有属性
     */
    Ivar *propertyArray = class_copyIvarList([UIPageControl class], &count);
    
    for (int i=0; i<count; i++) {
        //获取到类的每一个属性
        Ivar ivar = propertyArray[i];
        
        //进一步获取我们属性的名称
        const char *cPropertyName = ivar_getName(ivar);
        
        //把C语言中的属性名称转成我们OC的字符串
        NSString *propertyName = [[NSString alloc] initWithCString:cPropertyName encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",propertyName);
        
        [properties addObject:propertyName];
    }
    
    free(propertyArray);
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return HMZMinSection;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cycleList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HMZCycleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.cycle = self.cycleList[indexPath.item];
    return cell;
}


#pragma mark <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    NSLog(@"%f",scrollView.bounds.size.width);
    currentPage = currentPage % self.cycleList.count;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:currentPage inSection:HMZMinSection/2];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
@end
