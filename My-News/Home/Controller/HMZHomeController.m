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

@end

@implementation HMZHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChannel];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.contentCollectionView.delegate = self;
    self.contentCollectionView.dataSource = self;
    self.contentCollectionView.pagingEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置内容视图的布局
    [self setupContentLoayout];
}

- (void)setupChannel{
    CGFloat x, y, w, h;
    y = 0;
    w = 80;
    h = self.channelScrollView.bounds.size.height;
    for (int i = 0 ; i < self.channels.count; ++i) {
        x = i * w;
        HMZChannelLabel *label = [[HMZChannelLabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [self.channelScrollView addSubview:label];
        label.text = [self.channels[i] tname];
    }
    self.channelScrollView.contentSize = CGSizeMake(self.channels.count * w, 0);
}

- (void)setupContentLoayout{
//    self.contentCollectionView.
    self.contentCollectionView.w = [UIScreen mainScreen].bounds.size.width;
    self.contentCollectionView.h = [UIScreen mainScreen].bounds.size.height - 64 - 44;
    //1.每个item的大小
    self.flowLayout.itemSize = self.contentCollectionView.bounds.size;
    
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;
}

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

@end
