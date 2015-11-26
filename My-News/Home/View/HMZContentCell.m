//
//  HMZContentCell.m
//  My-News
//
//  Created by 赵志丹 on 15/11/23.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZContentCell.h"
#import "HMZChannel.h"
#import "HMZNewsController.h"

@interface HMZContentCell ()


@property (nonatomic,strong) HMZNewsController *newsVc;
@end
@implementation HMZContentCell

- (void)awakeFromNib{
    
    self.newsVc = [[UIStoryboard storyboardWithName:@"News" bundle:nil] instantiateInitialViewController];
    
    [self.contentView addSubview:self.newsVc.view];
    self.newsVc.view.frame = self.bounds;
    
}
- (void)setURLString:(NSString *)URLString{
    _URLString = URLString;
    self.newsVc.URLString = URLString;
}

@end
