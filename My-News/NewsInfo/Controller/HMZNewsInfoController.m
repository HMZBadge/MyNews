//
//  HMZNewsInfoController.m
//  My-News
//
//  Created by 赵志丹 on 15/11/26.
//  Copyright © 2015年 赵志丹. All rights reserved.
//

#import "HMZNewsInfoController.h"

@interface HMZNewsInfoController ()<UIWebViewDelegate>

@end

@implementation HMZNewsInfoController

// 控制器加载view
- (void)loadView{
    self.view = [[UIWebView alloc] init];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back2)];
    
}

- (void)back2{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.newsInfoURL]];
    
    // 3.发送请求
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showNewsInfo:html];
        });
    }] resume];

}

- (void)showNewsInfo:(NSString *)newsInfoHtml{
    UIWebView *webView = (UIWebView *)self.view;
    webView.frame = self.view.bounds;
    //[self.view addSubview:webView];
    [webView loadHTMLString:newsInfoHtml baseURL:[NSURL URLWithString:self.newsInfoURL]];
    webView.scalesPageToFit = YES;
}



- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}





@end
