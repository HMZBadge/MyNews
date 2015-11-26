//
//  HMZHomeController.m
//  My-News
//
//  Created by 赵志丹 on 15/11/23.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZHomeController.h"
#import "HMZChannel.h"
#import "HMZChannelLabel.h"
#import "HMZContentCell.h"
#import "UIView+HMZFrame.h"

@interface HMZHomeController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *channelScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *contentCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSArray *channels;
@property (nonatomic,strong) NSMutableArray *channelLabels;

@end

@implementation HMZHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.pagingEnabled = YES;
    
    //1.去创建频道标签
    [self createChannelLabels];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置内容视图的布局
    [self setupContentLoayout];
}


- (void)setupContentLoayout{
    self.contentCollectionView.w = [UIScreen mainScreen].bounds.size.width;
    self.contentCollectionView.h = [UIScreen mainScreen].bounds.size.height - 64 - 44;
    //1.每个item的大小
    self.flowLayout.itemSize = self.contentCollectionView.bounds.size;
    //调整为水平滑动
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;

}

- (void)createChannelLabels{
    CGFloat x, y, w, h;
    y = 0;
    w = 80;
    h = self.channelScrollView.bounds.size.height;
    for (int i = 0 ; i < self.channels.count; ++i) {
        x = i * w;
        HMZChannelLabel *channelLabel = [[HMZChannelLabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [self.channelScrollView addSubview:channelLabel];
        channelLabel.text = [self.channels[i] tname];
        
        //tag值的目的是,我想知道,我点击的到底是哪个
        channelLabel.tag = i;
        if (i==0) {
            channelLabel.scale = 1.0;
        }
        //5.添加手势
        [channelLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(channelLabelClick:)]];
        
        //6.添加到数组中
        [self.channelLabels addObject:channelLabel];

    }
    self.channelScrollView.contentSize = CGSizeMake(self.channels.count * w, 0);
}

#pragma mark - channelLabel点击的方法
- (void)channelLabelClick:(UITapGestureRecognizer *)recognizer{
    //切换我们新闻的内容
    HMZChannelLabel *channelLabel = (HMZChannelLabel *)recognizer.view;
    
    CGFloat index = channelLabel.tag;
    
    /**
     如果要想调用 scrollViewDidEndScrollingAnimation ,必须将我们的 setContentOffset animated设置为YES
     */
    [self.contentCollectionView setContentOffset:CGPointMake(index * self.contentCollectionView.bounds.size.width, 0) animated:YES];
}

#pragma mark - scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //1.获取到滚动的范围值
    CGFloat value = scrollView.contentOffset.x / scrollView.bounds.size.width; //1.2
    
    CGFloat maxOffsexX = (self.channelLabels.count -1) ;
    if (value < 0 || value >maxOffsexX ) return;
    
    //左边的索引
    int leftIndex = (int)scrollView.contentOffset.x / scrollView.bounds.size.width; //1
    
    //右边的索引
    int rightIndex = leftIndex + 1;
    
    //右边的缩放比率
    CGFloat rightScale = value - leftIndex;
    //左边的缩放比率
    CGFloat leftScale = 1 - rightScale;
    
    HMZChannelLabel *leftChannelLabel = self.channelLabels[leftIndex];
    leftChannelLabel.scale = leftScale;
    
    if (rightIndex < self.channelLabels.count) {
        HMZChannelLabel *rightChannelLabel = self.channelLabels[rightIndex];
        rightChannelLabel.scale = rightScale;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //1.需要将我们的channelScrollView里面对应的ChannelLable显示在中间
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 这个方法,可能做为一个公共的方法来调用,当然,我们也可以自己来创建一个公共的方法
 
 该方法,可以在两个地方调用,一个是当我点击了ChannelScrollView的channelLabel的时候
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    int currentIndex  = (int)scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    //再取出当前索引对应的Channel
    HMZChannelLabel *channelLabel = self.channelLabels[currentIndex];
    
    CGFloat channelLabelCenterX = channelLabel.center.x;
    
    CGFloat offsexValue = channelLabelCenterX - (self.channelScrollView.bounds.size.width *0.5);
    
    //最大滚出的范围
    CGFloat maxOffsexValue = self.channelScrollView.contentSize.width -self.channelScrollView.bounds.size.width;
    if (offsexValue>maxOffsexValue) {
        offsexValue =maxOffsexValue;
    }
    
    if (offsexValue<0) {
        offsexValue = 0;
    }
    
    //设置我们的
    [self.channelScrollView setContentOffset:CGPointMake(offsexValue, 0) animated:YES];
    
    //将点击到的设置为1,其它通通设置为0
    for (HMZChannelLabel *channelLabel  in self.channelLabels) {
        if (channelLabel.tag ==currentIndex ) {
            channelLabel.scale = 1.0;
        }else{
            channelLabel.scale = 0.0;
        }
    }
}







#pragma mark -UICollectionView数据源代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.channels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ContentCell";
    HMZContentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    HMZChannel *channel = self.channels[indexPath.item];
    cell.URLString = channel.URLString;
    return cell;
}

//懒加载
- (NSArray *)channels{
    if (!_channels) {
        _channels = [HMZChannel channels];
    }
    return _channels;
}

- (NSMutableArray *)channelLabels{
    if (_channelLabels ==nil ) {
        _channelLabels = [NSMutableArray array];
    }
    
    return _channelLabels;
}

@end
