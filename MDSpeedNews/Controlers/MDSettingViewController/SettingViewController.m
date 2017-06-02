//
//  SettingViewController.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/28.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "SettingViewController.h"

#define AppID // -- 留着以后写评分的时候用

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeRightViewController)];
    
    [self.view addGestureRecognizer:tapGesture];
    
    [self setUpDefaultView];
}

- (void) setUpDefaultView{
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2, 0, KScreenWidth/2, KScreenHeight )];
    
    [alphaView setBackgroundColor:RGBA_MD(0, 0, 0, .8)];
    
    [self.view addSubview:alphaView];
    
    CGFloat topSpace = MDXFrom6(86.5);
    
    CGFloat leftSpace = MDXFrom6(55.5);
    
    CGFloat width = MDXFrom6(76);
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace, topSpace, width, width)];
    
    [iconImageView setImage:[UIImage imageNamed:@"icon"]];
    
    [alphaView addSubview:iconImageView];
    
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.frame.origin.y + width + 19, KScreenWidth / 2, 15)];
    
    [tmpLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    [tmpLabel setTextColor:RGB_MD(102, 255, 102)];
    
    // -- 获取系统信息的字典
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *versionNumber = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    [tmpLabel setText:[NSString stringWithFormat:@"速闻 %@",versionNumber]];
    
    [tmpLabel setTextAlignment:NSTextAlignmentCenter];
    
    [alphaView addSubview:tmpLabel];
    
    CGFloat buttonY = tmpLabel.frame.origin.y + tmpLabel.frame.size.height + MDXFrom6(75);
    
    CGFloat buttonHeight = MDXFrom6(44);
    
    for (NSInteger i = 0; i < 2; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setFrame:CGRectMake(0, buttonY, alphaView.frame.size.width, buttonHeight)];
        
        // -- 设置按钮高亮状态颜色
        [button setBackgroundImage:[UIImage imageWithColor:RGB_MD(0, 102, 253)] forState:UIControlStateHighlighted];
        
        // -- 设置Tag值
        [button setTag:i + 1];
        
        [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            
            [button setTitle:@"     应用评分" forState:UIControlStateNormal];
            
            [button setImage:[UIImage imageNamed:@"score"] forState:UIControlStateNormal];
        }else{
            
            [button setTitle:@"     清除缓存" forState:UIControlStateNormal];
            
            [button setImage:[UIImage imageNamed:@"cache"] forState:UIControlStateNormal];
        }
        
        [alphaView addSubview:button];
        
        buttonY = buttonY + buttonHeight + 10;
    }
}

#pragma -
#pragma mark - ButtonTouchUpInside -
- (void) buttonTouchUpInside:(id)sender{
    
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        
        UIButton *btn = (UIButton *)sender;
        
        if (btn.tag == 1) {
            
            // -- 应用评分
            NSLog(@"应用评分");
        }
        else{
            
            // -- 清除缓存
            NSLog(@"清除缓存");
            
            // -- 现在我们清理的缓存只是图片(以后还有文件)
            
            // -- 图片的缓存都在SDImageCache类里
            SDImageCache *tmpCache = [SDImageCache sharedImageCache];
            
            // -- 拿到文件总个数
            NSUInteger numberOfImages = [tmpCache getDiskCount];
            
            // -- 拿到文件总大小
            NSUInteger imagesSize = [tmpCache getSize];
            
//            NSLog(@"%ld %ld",numberOfImages,imagesSize/1024/1024);
            
            float imageSize = [tmpCache getSize];
            
            // -- 清除图片缓存
            [tmpCache clearDiskOnCompletion:^{
                
                [ViewHelps showHUDWithText:[NSString stringWithFormat:@"已经成功清理%.2fMB缓存",imageSize/1024.0/1024.0]];
            }];
        }
    }
}

- (void) closeRightViewController{
    
    // -- 关闭
    [[MDYSliderViewController sharedSliderController] closeSideBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
