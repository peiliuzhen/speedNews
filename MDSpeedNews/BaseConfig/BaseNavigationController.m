//
//  BaseNavigationController.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "BaseNavigationController.h"
#import "UIImage+Category.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    UIImage *tmpImage = [UIImage imageWithColor:RGBA_MD(43.0, 139.0, 39.0, 0.90)];
    
    // -- 设置导航栏背景图片
    [self.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
    
    // -- 设置导航栏文字颜色和大小
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
