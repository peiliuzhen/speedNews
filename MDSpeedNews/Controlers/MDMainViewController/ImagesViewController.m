//
//  ImagesViewController.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/28.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "ImagesViewController.h"

@interface ImagesViewController ()<UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic , strong) UIScrollView *tmpScrollView;

/**
 *  存放图片地址的数组
 */
@property (nonatomic , strong) NSMutableArray *imageURLArr;

@property (nonatomic , strong) UIPageControl *pageControl;

/**
 *  保存下载下来的图片的数组
 */
@property (nonatomic , strong) NSMutableArray *imagesArr;

@end

@implementation ImagesViewController

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // -- 在试图将要出现的时候把导航栏背景颜色改成透明色
    UIImage *tmpImage = [UIImage imageWithColor:RGBA_MD(0, 0, 0, .9)];
    
    [self.navigationController.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    // -- 在试图将要消失的时候再把导航栏颜色改为正常
    UIImage *tmpImage = [UIImage imageWithColor:RGBA_MD(43, 139, 39, 0.9)];
    
    [self.navigationController.navigationBar setBackgroundImage:tmpImage forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // -- 初始化数组
    self.imagesArr = [NSMutableArray array];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self setDefaultNavigationLeftBarButton];
    
    [self setUpImageURLArr];
    
    [self setUpScrollView];
}

- (void) setUpScrollView{
    
    self.tmpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    
    [self.tmpScrollView setDelegate:self];
    
    [self.tmpScrollView setPagingEnabled:YES];
    
    [self.tmpScrollView setShowsHorizontalScrollIndicator:NO];
    
    [self.tmpScrollView setShowsVerticalScrollIndicator:NO];
    
    // -- 关闭弹性
    [self.tmpScrollView setBounces:NO];
    
    for (NSInteger i = 0; i < self.imageURLArr.count; i++) {
        
        // -- 创建一个手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(saveImage)];
        
        UIImageView *tmpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * KScreenWidth, -32, KScreenWidth, self.tmpScrollView.frame.size.height)];
        
        // -- 开启交互
        [tmpImageView setUserInteractionEnabled:YES];
        
        // -- 在UIImageView上添加手势
        [tmpImageView addGestureRecognizer:tapGesture];
        
        // -- 一直在中心
        [tmpImageView setContentMode:UIViewContentModeCenter];
        
        // -- 图片不失真 适应原图大小
        [tmpImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        NSURL *tmpURL = self.imageURLArr[i];
        
        __weak typeof(self) weakSelf = self;
        
        // -- 加载图片
        [tmpImageView sd_setImageWithURL:tmpURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                
                // -- 把下载下来的图片添加到数组中记录
                [weakSelf.imagesArr addObject:image];
            }
        }];
        
        [self.tmpScrollView addSubview:tmpImageView];
    }
    
    [self.tmpScrollView setContentSize:CGSizeMake(KScreenWidth *self.imageURLArr.count, KScreenHeight - 64)];
    
    // -- UIPageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, KScreenHeight - 20, KScreenWidth, 20)];
    
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
    
    [self.pageControl setNumberOfPages:self.imageURLArr.count];
    
    [self.pageControl setCurrentPage:0];
    
    [self.view addSubview:self.tmpScrollView];
    
    [self.view addSubview:self.pageControl];
    
    // -- 显示Title的Label
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, KScreenHeight - 80, KScreenWidth - 10, 40)];
    
    [tmpLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    
    [tmpLabel setTextColor:[UIColor whiteColor]];
    
    [tmpLabel setText:self.getListModel.title];
    
    [self.view addSubview:tmpLabel];
}

// -- 轻点手势响应的点击事件
- (void) saveImage{
    
    UIActionSheet *tmpView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存" otherButtonTitles:nil, nil];
    
    [tmpView showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        // -- 保存
        NSInteger currendIndex = self.tmpScrollView.contentOffset.x / self.tmpScrollView.frame.size.width;
        
        // -- 保存图片到本地相册
        UIImageWriteToSavedPhotosAlbum(self.imagesArr[currendIndex], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else{
        
        // -- 取消
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error) {
        
        NSLog(@"保存失败");
        
        [ViewHelps showHUDWithText:@"保存失败"];
        
        return;
    }
    else{
        NSLog(@"保存成功");
        
        [ViewHelps showHUDWithText:@"保存成功"];
    }
}

- (void) setUpImageURLArr{
    
    // -- 初始化数组
    self.imageURLArr = [NSMutableArray array];
    
    // -- 第一张图片的URL
    [self.imageURLArr addObject:self.getListModel.imgsrc];
    
    // -- 第二张图片的URL
    [self.imageURLArr addObject:[self.getListModel.imgextra[0] valueForKey:@"imgsrc"]];
    
    // -- 第三张图片的URL
    [self.imageURLArr addObject:[self.getListModel.imgextra[1] valueForKey:@"imgsrc"]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger currendIndex = scrollView.contentOffset.x / self.tmpScrollView.frame.size.width;
    
    [self.pageControl setCurrentPage:currendIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
