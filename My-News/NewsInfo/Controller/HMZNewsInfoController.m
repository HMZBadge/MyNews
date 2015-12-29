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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
//    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:self.newsInfoURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    }] resume];
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.newsInfoURL]];
    
//    // 3.发送请求
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        __weak typeof(self) weakSelf = self;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf showNewsInfo:html];
//        });
//    }] resume];
    
    UIWebView *webView = (UIWebView *)self.view;
    webView.delegate = self;
    webView.frame = self.view.bounds;
    [webView loadRequest:request];
    webView.scalesPageToFit = YES;
}
//
//- (void)showNewsInfo:(NSString *)newsInfoHtml{
//    UIWebView *webView = (UIWebView *)self.view;
//     webView.delegate = self;
//    webView.frame = self.view.bounds;
//    //[self.view addSubview:webView];
//    [webView loadHTMLString:newsInfoHtml baseURL:[NSURL URLWithString:self.newsInfoURL]];
//    webView.scalesPageToFit = YES;
//   
//}

//- (void)showNewsInfo:(NSString *)newsInfoHtml{
//    UIWebView *webView = (UIWebView *)self.view;
//    webView.delegate = self;
//    webView.frame = self.view.bounds;
//    //[self.view addSubview:webView];
//    //[webView loadHTMLString:newsInfoHtml baseURL:[NSURL URLWithString:self.newsInfoURL]];
//    
//    webView loadRequest:<#(nonnull NSURLRequest *)#>
//    webView.scalesPageToFit = YES;
//    
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    /**
     <div class="position lBlue"><a name="top" id="top"></a><a href="http://3g.163.com/x/">网易</a>&gt;<a href="http://3g.163.com/news/">新闻</a>&gt;正文</div>
     <!-- bannerTop Ad -->
     <!-- 通栏 -->
     <div class="bannerTop" id="licl">
     <a href="http://g.163.com/a?CID=38793&#38;Values=637231468&#38;Redirect=http://g.zzsfzc.com.cn/c?z=ran10&#38;la=0&#38;si=66&#38;ci=64&#38;cg=130&#38;c=467&#38;or=600&#38;l=706&#38;bg=706&#38;b=794&#38;u=http://brand.vw.com.cn/newbornshuttle/?utm_source=netease&#38;utm_medium=banner&#38;utm_campaign=Newbornshuttle">
     <img src="http://img1.126.net/channel4/021104/640100_1116.jpg" style="width: 100%"/>
     </a>
     
     </div>
     
     */

    
//    NSMutableString *js1 = [NSMutableString string];
    // 0.删除顶部的导航条
    //[js1 appendString:@"alert(123);"];
//    [js1 appendString:@"var header = document.getElementById('licl');"];
//    //[js1 appendString:@"alert(header);"];
//    [js1 appendString:@"header.parentNode.removeChild(header);"];
//    

//    [webView stringByEvaluatingJavaScriptFromString:js1];

}






@end
