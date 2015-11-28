//
//  HMZNewsCell.m
//  My-News
//
//  Created by 赵志丹 on 15/11/26.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZNewsCell.h"
#import "HMZNews.h"
#import <UIImageView+AFNetworking.h>

@interface HMZNewsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *digestLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyCountLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *extraImageViews;

@end
@implementation HMZNewsCell

- (void)setNews:(HMZNews *)news{
    _news = news;
    self.iconView.image = nil;//先清空一下,防止cell重用时图片用了上一张的
    //首先设置我们的iconView的值
    [self.iconView setImageWithURL:[NSURL URLWithString:news.imgsrc]];
    //设置标题
    self.titleLable.text = news.title;
    //设置我们的内容
    self.digestLabel.text = news.digest;
    //回帖数
    self.replyCountLabel.text = [NSString stringWithFormat:@"%d跟帖",news.replyCount];
    
    //判断多张图的情况,给我们的多图的cell设置我们的配置,主要是设置,第2张和第3张
    if (news.imgextra.count ==2 ) {//多图的cell
        for (int i=0; i<2; i++) {
            UIImageView *everyImageView = self.extraImageViews[i];
            NSString *imageURLString= news.imgextra[i][@"imgsrc"];
            [everyImageView setImageWithURL:[NSURL URLWithString:imageURLString]];
        }
    }
}
@end
