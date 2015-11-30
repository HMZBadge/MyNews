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
#import "UIView+HMZFrame.h"

@interface HMZNewsController ()
@property (nonatomic,strong) NSMutableArray *newsList;
@property (nonatomic,strong) UINavigationController *nav;
@property (weak, nonatomic) IBOutlet UIView *headContainerView;
@end

@implementation HMZNewsController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.headContainerView.w = [UIScreen mainScreen].bounds.size.width;
}

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
    //    [[UILayoutContainerView alloc] init];
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
    NSLog(@"%s",__func__);
    HMZNews *news = self.newsList[indexPath.row];
    
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"News" bundle:nil];
//    HMZNewsInfoController *newsInfoVc =[story instantiateViewControllerWithIdentifier:@"NewsInfo"];
    
    HMZNewsInfoController *newsInfoVc = [[HMZNewsInfoController alloc] init];
    newsInfoVc.newsInfoURL = news.url;
    ç
    [nav pushViewController:newsInfoVc animated:YES];
    //self.nav = [[UINavigationController alloc] init];
    //window.rootViewController = self.nav;
    //[self.nav pushViewController:newsInfoVc animated:YES];
    //NSLog(@"%@",self.nav);
    //    [self.nav pushViewController:newsInfoVc animated:YES];
    //    [self.navigationController pushViewController:newsInfoVc animated:YES];
    //怎样设置modal 的样式..
//    [self setModalPresentationStyle:UIModalPresentationPageSheet];
//    [self presentViewController:newsInfoVc animated:YES completion:nil];
    
    
    
   
     //[self performSegueWithIdentifier:@"newsToInfo" sender:nil];

   
}


@end
