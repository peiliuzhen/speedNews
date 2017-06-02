//
//  DetilViewController.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/28.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "DetilViewController.h"
#import "MDHTMLService.h"

@interface DetilViewController ()

@property (nonatomic , strong) UIWebView *tmpWebView;

@end

@implementation DetilViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.navigationItem setTitle:@"详情"];
    
    [self setDefaultNavigationLeftBarButton];
    
    [self setUpWebView];
    
    NSString *baseURL = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/%@/full.html",self.getListModel.docid];
    
    __weak typeof(self) weakSelf = self;
    
    [self showHUD];
    
    [HttpRequest GET:baseURL parameters:nil success:^(id responseObject) {
        
        [weakSelf hideHUD];
        
        NSDictionary *dict = responseObject[self.getListModel.docid];
        
        // -- 解析HTML字符串
        NSString *htmlString = [MDHTMLService htmlStringFromDic:dict];
        
        // -- webView加载HTML字符串
        [weakSelf.tmpWebView loadHTMLString:htmlString baseURL:nil];
        
    } failure:^(NSError *error) {
        
        [weakSelf hideHUD];
        
        [RequestSever showMsgWithError:error];
    }];
}

- (void) setUpWebView{
    
    self.tmpWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    
    // -- 适应屏幕大小
    [self.tmpWebView setScalesPageToFit:YES];
    
    [self.tmpWebView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.tmpWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
