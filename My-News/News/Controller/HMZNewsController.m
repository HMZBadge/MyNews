//
//  HMZNewsController.m
//  My-News
//
//  Created by 赵志丹 on 15/11/24.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZNewsController.h"
#import "HMZNews.h"
#import "HMZNewsCell.h"
#import "HMZNewsInfoController.h"

@interface HMZNewsController ()
@property (nonatomic,strong) NSMutableArray *newsList;
@property (nonatomic,strong) UINavigationController *nav;
@end

@implementation HMZNewsController


- (void)setURLString:(NSString *)URLString{
    _URLString = URLString;
    
    self.newsList = @[].copy;
    [self.tableView reloadData];
    
    __weak typeof(self) weakSelf = self;
    [HMZNews newsListWithURLString:self.URLString  finishBlock:^(NSMutableArray *newsList) {
        weakSelf.newsList = newsList;
    }];
    
    
}

- (void)setNewsList:(NSMutableArray *)newsList{
    _newsList = newsList;
    [self.tableView reloadData];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMZNews *news = self.newsList[indexPath.row];
    static NSString *identifier = nil;
    if (news.imgType){//是否大图
        identifier = @"BigCell";
    }
    else if (news.imgextra.count == 2) {//是否是多张图
        identifier = @"ImagesCell";
    }
    else{
        identifier = @"BaseCell";
    }
    HMZNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.news = news;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HMZNews *news = self.newsList[indexPath.row];
    CGFloat cellHeight = 0;
    if (news.imgType){
        cellHeight = 180;
    }
    else if (news.imgextra.count == 2) {
        cellHeight = 120;
    }else {
        cellHeight = 80;
    }
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HMZNews *news = self.newsList[indexPath.row];
    HMZNewsInfoController *newsInfoVc = [[HMZNewsInfoController alloc] init];
    newsInfoVc.newsInfoURL = news.url;

//    self.nav = [[UINavigationController alloc] initWithRootViewController:self];
//    [self.nav pushViewController:newsInfoVc animated:YES];
    [self presentViewController:newsInfoVc animated:YES completion:nil];
}


@end
