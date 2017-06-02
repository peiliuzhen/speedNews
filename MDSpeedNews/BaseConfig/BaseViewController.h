//
//  BaseViewController.h
//  MDSpeedNews
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

// -- NavigationBarButtonItem
- (void) setNavigationLeftBarButtonWithImageNamed:(NSString *)imageName;

- (void) setNavigationRightBarButtonWithImageNamed:(NSString *)imageName;

- (void) leftButtonTouchUpInside:(id)sender;

- (void) rightButtonTouchUpInside:(id)sender;

// -- 设置默认返回导航栏按钮
- (void) setDefaultNavigationLeftBarButton;

// -- MBProgressHUDMethod
- (void) showHUD;

- (void) hideHUD;

@end
