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
#define SCROLLVIEW_WIDTH  [UIScreen mainScreen].bounds.size.width

@interface HMZCycleController ()
@property (weak, nonatomic) UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *contentLayout;
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSArray *cycleList;
@property (nonatomic,assign,getter=isLastImage) BOOL lastImage;
@end

@implementation HMZCycleController

static NSString * const reuseIdentifier = @"CycleCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@",NSStringFromCGRect(self.collectionView.frame));
    //self.collectionView.w = [UIScreen mainScreen].bounds.size.width;//这句话有问题
    //self.collectionView.h = 250;
    
    self.collectionView.pagingEnabled = YES;
    
    self.contentLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 250);
    
    
    self.contentLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.contentLayout.minimumLineSpacing = 0;
    self.contentLayout.minimumInteritemSpacing = 0;
}

- (void)loadData{//加载数据
    __weak typeof(self) weakSelf = self;
    [HMZCycle cycleWithFinishBlock:^(NSArray *cycleList) {
        weakSelf.cycleList = cycleList;
        weakSelf.pageControl.numberOfPages = cycleList.count;
        [weakSelf addTimer];
        [self.collectionView setContentOffset:CGPointMake(0 , 0)];

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
    if (!_pageControl) {
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





#pragma mark - 在滚动视图滚动动画结束, 滚动视图调用的setContentOffset方法时动画结束后调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidStop:scrollView];
}

#pragma mark - 当滚动动画结束后调用
- (void)scrollViewDidStop:(UIScrollView *)scrollView {
    // 获取当前真实滚动到第几页
    NSInteger page = (self.collectionView.contentOffset.x + SCROLLVIEW_WIDTH * 0.5) / SCROLLVIEW_WIDTH;
    // 如果是最后一张时让scrollView再滚动到第1张
    if (page == (self.cycleList.count + 1)) {
        [self.collectionView setContentOffset:CGPointMake(SCROLLVIEW_WIDTH , 0)];
    }
}

#pragma mark - 开始拖拽时移除定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 移除定时器
    [self removeTimer];
}

#pragma mark - 滚动中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 获取当前真实滚动页数
    NSInteger page = (scrollView.contentOffset.x + SCROLLVIEW_WIDTH * 0.5) / SCROLLVIEW_WIDTH;
    // 真实页数减一为pageControl的当前
    page --;
    self.pageControl.currentPage = page;
}

#pragma mark - 停止拖拽时添加定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 添加定时器
    [self addTimer];
}

#pragma mark - 添加定时器
- (void)addTimer {
    // 创建并启动定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(next:) userInfo:nil repeats:YES];
    // 添加定时器到运行循环 并设置运行循环为通过"全检测"模式
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 移出定时器
- (void)removeTimer {
    // 停止定时器
    [self.timer invalidate];
    // 清空指针
    self.timer = nil;
}

#pragma mark - 下一张
- (void)next:(NSTimer *)timer {
    // 取出当前页数
    NSInteger page = self.pageControl.currentPage;
    // 如果page不是5就+1 如果是就变为0
    page != self.cycleList.count ? page++ : (page = 0);
    // 默认从第二张开始滚动
    CGPoint offset = CGPointMake(SCROLLVIEW_WIDTH * (page + 1), 0);
    // 让scrollView滚动
    [self.collectionView setContentOffset:offset animated:YES];
    
}




@end
