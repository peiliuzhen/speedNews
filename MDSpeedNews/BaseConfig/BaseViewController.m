//
//  BaseViewController.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController (){
    
    MBProgressHUD *progressHUD;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

}

#pragma -
#pragma mark - NavigationBarButton -
- (void) setNavigationLeftBarButtonWithImageNamed:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftButton setFrame:CGRectMake(0, 0, 25, 44)];
    
    [leftButton setImage:image forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(leftButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void) setNavigationRightBarButtonWithImageNamed:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightButton setFrame:CGRectMake(0, 0, 25, 44)];
    
    [rightButton setImage:image forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(rightButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

- (void) setDefaultNavigationLeftBarButton{
    
    UIImage *image = [UIImage imageNamed:@"back"];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftButton setFrame:CGRectMake(0, 0, 25, 44)];
    
    [leftButton setImage:image forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(leftButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
}

- (void) leftButtonTouchUpInside:(id)sender{
    
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) rightButtonTouchUpInside:(id)sender{

    
}

- (void) showHUD{
    
    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:progressHUD];
    
    [progressHUD setDimBackground:YES];
    
    [progressHUD show:YES];
}

- (void) hideHUD{
    
    [progressHUD hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
