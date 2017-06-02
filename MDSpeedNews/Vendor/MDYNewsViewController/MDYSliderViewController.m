//
//  MDYSliderViewController.m
//  MDYNews
//
//  Created by Medalands on 15/2/27.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDYSliderViewController.h"

#import "MDYBlurHelp.h"

#import "UIImageView+LBBlurredImage.h"

#define COMMON_SHOW_ClOSE_DURATION_TIME  0.4  // 点击 展开 或 关闭侧边栏的动画时间


@interface MDYSliderViewController ()<UIGestureRecognizerDelegate>
{
    UIView   *_mainContentView;// 中间视图的父View
    UIView   *_leftSideView;// 左边视图的父View
    UIView   *_rightSideView;// 右边视图的父View
    
    CGFloat  _leftSpace; // 左View 距离屏幕右边的最近距离
    
    
    UIPanGestureRecognizer   *_panGestureRec;// 滑动手势 控制左右两侧View的 滑动显示
    UITapGestureRecognizer   *_tapGestureRec;  // 点击手势 加在模糊图片上 点击隐藏左侧View

    
    
    
    BOOL _showingLeft;  // 记录 左侧View 出现的状态 YES 表示左侧View 正在出现
    BOOL _showingRight; // 记录 右侧View 出现的状态  YES 表示右侧View 正在出现

    UIImageView  *_mainBackgroundIV; // 模糊图片

    
}


@end

@implementation MDYSliderViewController

-(void)dealloc
{
    _mainContentView = nil;
    _leftSideView = nil;
    _rightSideView = nil;
    
    _panGestureRec = nil;
    
    _leftVC = nil;
    _rightVC = nil;
    _mainVC = nil;
    
    _mainBackgroundIV = nil;
}

- (id)init{
    if (self = [super init])
    {
        _canShowLeft=YES;
        _canShowRight=YES;
        
        _showingLeft = NO;
        
        _showingRight = NO;
                
    }
    
    return self;
}



+ (MDYSliderViewController*)sharedSliderController
{
    static MDYSliderViewController * sharedSVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSVC = [[self alloc] init];
    });
    
    return sharedSVC;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 隐藏 导航栏 因为滑动导航栏 需要触发滑动事件 而系统导航栏已有功能比较多 避免造成冲突   所以 自定义导航栏
    [[self navigationController] setNavigationBarHidden:YES];
    
}


-(void)loadView
{
    [super loadView];
 
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"@@@@@@@");

    
    // 实例化三个view 左 中 右
    [self initSubViews];
    
    // 设置 三个子 VC
    [self initChildControllers];
    
    
    _tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];
    _tapGestureRec.delegate=self;
    _tapGestureRec.enabled = NO;
    
    _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [_mainContentView addGestureRecognizer:_panGestureRec];
    [self.view addGestureRecognizer:_panGestureRec];
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes
{
    static CGFloat startX; // 记录最开始滑动的位置  在一次滑动结束前 只会赋一次值
    static CGFloat lastX; // 每次滑动的前一个坐标
    static CGFloat durationX; // 最后产生的移动坐标x 和 上一次产生的移动坐标之间的差值
    CGPoint touchPoint = [panGes locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    if (panGes.state == UIGestureRecognizerStateBegan) // 开始滑动时
    {
        startX = touchPoint.x;
        lastX = touchPoint.x;
    }
    if (panGes.state == UIGestureRecognizerStateChanged) // 正在滑动时
    {
        CGFloat currentX = touchPoint.x; // 当前移动到的位置
        durationX = currentX - lastX;
        lastX = currentX;
        if (durationX > 0) // 右滑 左侧View 出现
        {
            if(!_showingLeft && !_showingRight && _canShowLeft && _leftVC)
            {
                _showingLeft = YES;
                [self.view bringSubviewToFront:_leftSideView];
            }
        }else // 左滑 右侧View 出现
        {
            if(!_showingRight && !_showingLeft && _canShowRight && _rightVC)
            {
                _showingRight = YES;
                [self.view bringSubviewToFront:_rightSideView];
            }
        }
        
        if (_showingLeft)
        {
            if (_leftSideView.frame.origin.x >= -_leftSpace && durationX > 0)// 如果 左侧View 已经完全出现 并且是向 左滑 则返回什么都不做
            {
                return;
            }
            if (!_canShowLeft||_leftVC==nil) // 如果 不可以出现左侧View 或 左侧VC 为nil 则返回什么都不做
            {
                return;
            }

           

            // 设置左侧View的 x 坐标
            CGFloat x = durationX + _leftSideView.frame.origin.x;
            
            // 设置 模糊图片
            [self configureViewBlurWith:x + _mainContentView.frame.size.width scale:1.];
            
            
            if (x>=-_leftSpace)
            {
                x = -_leftSpace;
            }
            
            if (_leftSideView.frame.origin.x != x)
            {
                [_leftSideView setFrame:CGRectMake(x, _leftSideView.frame.origin.y, _leftSideView.frame.size.width, _leftSideView.frame.size.height)];
            }
            
            
        }
        else    //transX < 0
        {
            if (!_canShowRight || _rightVC == nil) // 如果 不允许出现右侧View 或者右侧的Vc 是nil 则不做操作
            {
                return;
            }
            
           
            
            // 设置右侧 View 的frame 只改变 X
            CGFloat x = durationX + _rightSideView.frame.origin.x;
            
            
            if (x <= _mainContentView.frame.size.width - _rightSideView.frame.size.width)
            {
                x =_mainContentView.frame.size.width - _rightSideView.frame.size.width;
            }
            
            // 设置 模糊图片  传入的参数： (self.view.frame.size.width - x) 表示移动到的位置 距离屏幕左边界的位置
            [self configureViewBlurWith:_mainVC.view.frame.size.width - x scale:1.];
            
            
            [_rightSideView setFrame:CGRectMake(x, _rightSideView.frame.origin.y, _rightSideView.frame.size.width, _rightSideView.frame.size.height)];
        }
    }
    else if (panGes.state == UIGestureRecognizerStateEnded) // 滑动结束时
    {
        if (_showingLeft) //
        {
            if (!_canShowLeft||_leftVC==nil)
            {
                return;
            }
            
            if ((_leftSideView.frame.origin.x + _leftSideView.frame.size.width) > (_leftSideView.frame.size.width - _leftSpace)/2) // 如果 左侧View 出现的 偏移 大于 最大偏移的 一半 则完全出现左侧view
            {
                float durationTime = (-_leftSideView.frame.origin.x)/(_mainVC.view.frame.size.width);// 计算动画的时间 左侧view的x坐标 绝对值越大（view 出现的区域越小） 动画时间越大
                [UIView animateWithDuration:durationTime animations:^
                 {
                     [self configureViewBlurWith:_mainVC.view.frame.size.width-_leftSpace scale:1.]; // 设置为最大的透明度
                     [_leftSideView setFrame:CGRectMake(-_leftSpace, _leftSideView.frame.origin.y, _leftSideView.frame.size.width, _leftSideView.frame.size.height)];
                 } completion:^(BOOL finished)
                 {
                     _leftSideView.userInteractionEnabled = YES;
                     _tapGestureRec.enabled = YES;
                 }];
            }else // 如果 左侧View 出现的 偏移 小于等于 最大偏移的 一半 则隐藏左侧view
            {
                float durationTime = 1 - (-_leftSideView.frame.origin.x)/(_mainVC.view.frame.size.width);// 计算动画的时间 左侧view的x坐标 绝对值越小（view 出现的区域越大） 动画时间越大
                [UIView animateWithDuration:durationTime animations:^
                 {
                     [self configureViewBlurWith:0 scale:1.]; // 模糊图片透明度设为0
                     [_leftSideView setFrame:CGRectMake(-_leftSideView.frame.size.width, _leftSideView.frame.origin.y, _leftSideView.frame.size.width, _leftSideView.frame.size.height)];
                 } completion:^(BOOL finished)
                 {
                     [self.view sendSubviewToBack:_leftSideView]; //左侧View 放在最下层
                     
                     [self setDefaultSettingFroShowMiddle];
                 }];
            }
            
            return;
        }
        if (_showingRight)
        {
            if (!_canShowRight || _rightVC == nil)
            {
                return;
            }
            
            if (_rightSideView.frame.origin.x < _mainVC.view.frame.size.width / 2) // 如果右侧View 出现的范围大于一半 右侧View 出现
            {
                float durationTime = (_rightSideView.frame.origin.x)/(_mainVC.view.frame.size.width); // 计算 动画的时间 右侧View x坐标 是动画要移动的距离 越大 动画时间越大
                [UIView animateWithDuration:durationTime animations:^
                 {
                     // 设置模糊图片 透明度 1
                     [self configureViewBlurWith:_mainVC.view.frame.size.width scale:1];
                     
                     // 设置右侧View的x坐标
                     [_rightSideView setFrame:CGRectMake(0, _rightSideView.frame.origin.y, _rightSideView.frame.size.width, _rightSideView.frame.size.height)];
                 } completion:^(BOOL finished)
                 {
                     _rightSideView.userInteractionEnabled = YES;
                     _tapGestureRec.enabled = YES;
                     
                     if (self.finishShowRight != nil) // 右侧View 出现后 调用的Block
                     {
                         self.finishShowRight();
                     }
                 }];
            }else  // 如果右侧View 出现的范围 小于等于 一半 隐藏右侧View
            {
                float durationTime = 1 - (_rightSideView.frame.origin.x)/(_mainVC.view.frame.size.width); // 计算动画时间
                [UIView animateWithDuration:durationTime animations:^
                 {
                     [self configureViewBlurWith:0 scale:1]; // 模糊图片全透明
                     [_rightSideView setFrame:CGRectMake(_mainVC.view.frame.size.width, _rightSideView.frame.origin.y, _rightSideView.frame.size.width, _rightSideView.frame.size.height)];
                 } completion:^(BOOL finished)
                 {
                     [self.view sendSubviewToBack:_rightSideView];
                     
                     [self setDefaultSettingFroShowMiddle];
                 }];
            }
        }
    }
}

-(void)initSubViews
{
    // Frame 在屏幕右边
    _rightSideView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_rightSideView];
    
    // Frame 在屏幕左边
    _leftSideView = [[UIView alloc] initWithFrame:CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self.view addSubview:_leftSideView];
    
    // Frame 在屏幕中    
    _mainContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mainContentView];
}

- (void)initChildControllers
{
    
    
if (_canShowRight&&_rightVC != nil) {
        
        [self addChildViewController:_rightVC];
        
        _rightVC.view.frame = CGRectMake(0, 0, _rightSideView.frame.size.width, _rightSideView.frame.size.height);
        
        [_rightSideView addSubview:_rightVC.view];
    }
    if (_canShowLeft&&_leftVC != nil) {
        
        [self addChildViewController:_leftVC];
        
        _leftSpace = self.view.frame.size.width - _leftVC.view.frame.size.width;
        
        _leftVC.view.frame = CGRectMake(_leftSpace, 0, _leftVC.view.frame.size.width, _leftVC.view.frame.size.height);
        
        [_leftSideView addSubview:_leftVC.view];
    }
    
    
    if (_mainVC )
    {
        _mainVC.view.frame = _mainContentView.frame;
        
        [self addChildViewController:_mainVC];
        
        [_mainContentView addSubview:_mainVC.view];

    }
}


-(void)setMainContentViewController:(UIViewController *)mainVc
{
    if (![mainVc isEqual:_mainVC]) // 先判断 设置的是不是 同一个VC 如果是 则不操作
    {
        if (_mainVC.view.superview) // 如果当前中间view 在父View上
        {
            [_mainVC.view removeFromSuperview];
        }
        
        _mainVC = mainVc;
        
//        if(mainVc.parentViewController)
        
        [self addChildViewController:mainVc];
        
        [_mainContentView addSubview:_mainVC.view];
    }
    
    [self closeSideBar];
    
}




#pragma mark -  给View 添加模糊的效果

// 参数解释 nValue 滑动到的位置坐标 x 拿来算相对于mainVc.view 的位置 当做 最大透明度的倍数
//         nScale  最大的透明度
- (void)configureViewBlurWith:(float)nValue scale:(float)nScale
{
    nScale = nScale * 0.90;
    
    if(_mainBackgroundIV == nil)
    {
        _mainBackgroundIV = [[UIImageView alloc] initWithFrame:_mainVC.view.bounds];
        _mainBackgroundIV.userInteractionEnabled = YES;
        [_mainBackgroundIV addGestureRecognizer:_tapGestureRec];
        [_tapGestureRec setEnabled:YES];
        
        UIImage *image = [MDYBlurHelp getImageFromView:_mainVC.view];// view 转换成图片
        
        // 图片添加模糊效果
        [_mainBackgroundIV setImageToBlur:image
                               blurRadius:kLBBlurredImageDefaultBlurRadius
                          completionBlock:^(){}];
        
        [_mainVC.view addSubview:_mainBackgroundIV]; // 加了模糊效果的图片 加到 中间的View（mainVC.view）
    }
    // 设置透明度
    [_mainBackgroundIV setAlpha:(nValue/_mainVC.view.frame.size.width) * nScale];
}

/**
 *  销毁 模糊 imageView 下次出现时 再 重新实例化
 */
- (void)removeconfigureViewBlur
{
    [_mainBackgroundIV removeFromSuperview];
    
    _mainBackgroundIV = nil;
}

#pragma mark - GestureDelegate

//#warning 待测试
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 屏蔽 滑动tableView 时 触发这个滑动事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        
        NSLog(@"待测试方法");
        
        return NO;
    }
    
    return  YES;
}

#pragma mark - 关闭侧边栏

- (void)closeSideBar
{
    [self closeSideBarWithAnimate:YES complete:^(BOOL finished) {}];
}

- (void)closeSideBarWithAnimate:(BOOL)animated complete:(void(^)(BOOL finished))complete
{
    if(_showingLeft) // 左边栏已经展开 关闭左边栏
    {
        if (animated) // 执行 动画
        {
            //            float durationTime = 1 - (-_leftSideView.frame.origin.x)/(_MainVC.view.frame.size.width);
            [UIView animateWithDuration:COMMON_SHOW_ClOSE_DURATION_TIME animations:^
             {
                 [self configureViewBlurWith:0 scale:1.]; //模糊图片 全透明
                 
                 // 左侧View 移出 屏幕
                 [_leftSideView setFrame:CGRectMake(-_leftSideView.frame.size.width, _leftSideView.frame.origin.y, _leftSideView.frame.size.width, _leftSideView.frame.size.height)];
             } completion:^(BOOL finished)
             {
                 [self.view sendSubviewToBack:_leftSideView]; // 左侧View 放在最底层
                 
                 
                 
                 [self setDefaultSettingFroShowMiddle];
                 
                 
                 
                 if (complete)
                 {
                   complete(YES);
                 }
             }];
        }else // 不执行动画
        {
            [self configureViewBlurWith:0 scale:1.];//模糊图片 全透明
            
            // 左侧View 移除 屏幕
            [_leftSideView setFrame:CGRectMake(-_leftSideView.frame.size.width, _leftSideView.frame.origin.y, _leftSideView.frame.size.width, _leftSideView.frame.size.height)];
            [self.view sendSubviewToBack:_leftSideView];
            
            
            [self setDefaultSettingFroShowMiddle];
    
            
            if (complete)
            {
                complete(YES);
            }

        }
    }else // 左边栏已经展开 关闭左边栏
    {
        if (animated)
        {

            [UIView animateWithDuration:COMMON_SHOW_ClOSE_DURATION_TIME animations:^
             {
                 [self configureViewBlurWith:0 scale:1];// 模糊图片透明化
                 
                 // 右侧View移出屏幕
                 [_rightSideView setFrame:CGRectMake(_mainVC.view.frame.size.width, _rightSideView.frame.origin.y, _rightSideView.frame.size.width, _rightSideView.frame.size.height)];
             } completion:^(BOOL finished)
             {
                 [self.view sendSubviewToBack:_rightSideView];// 右侧View 移到最底层
                 
                 [self setDefaultSettingFroShowMiddle];
                 
                 if(complete)
                 {
                     complete(YES);
                 }
                 
             }];
        }else
        {
            [self configureViewBlurWith:0 scale:1];// 模糊图片透明化
            
            // 右侧View移出屏幕
            [_rightSideView setFrame:CGRectMake(_mainVC.view.frame.size.width, _rightSideView.frame.origin.y, _rightSideView.frame.size.width, _rightSideView.frame.size.height)];
            
            [self.view sendSubviewToBack:_rightSideView];// 右侧View 移到最底层
            
            [self setDefaultSettingFroShowMiddle];
            
            if(complete)
            {
                complete(YES);
            }
        }
    }
}

/**
 * 显示中间页面 进行的 设置
 */
-(void)setDefaultSettingFroShowMiddle
{
    // 状态参数设置
    _showingLeft = NO;
    _showingRight = NO;
    _tapGestureRec.enabled = NO;
    
    [self removeconfigureViewBlur];
    
    if (self.showMiddleVc)
    {
        self.showMiddleVc();
    }
    
}


- (void)showLeftViewController
{
    if (_showingLeft) {
        [self closeSideBar];
        return;
    }

    if (!_canShowLeft||_leftVC==nil) {
        return;
    }
    _showingLeft = YES;
    [self.view bringSubviewToFront:_leftSideView];

    [self configureViewBlurWith:0 scale:1.];
    [UIView animateWithDuration:COMMON_SHOW_ClOSE_DURATION_TIME animations:^
     {
         [self configureViewBlurWith:_mainVC.view.frame.size.width- _leftSpace scale:1.];
         [_leftSideView setFrame:CGRectMake(-_leftSpace, _leftSideView.frame.origin.y, _leftSideView.frame.size.width, _leftSideView.frame.size.height)];
     } completion:^(BOOL finished)
     {
         _leftSideView.userInteractionEnabled = YES;
         _tapGestureRec.enabled = YES;
     }];

    
}


-(void)showRightViewController
{
    
    
    if (_showingRight) {
        [self closeSideBar];
        return;
    }
    if (!_canShowRight||_rightVC==nil) {
        return;
    }
    _showingRight = YES;
    [self.view bringSubviewToFront:_rightSideView];
    
    [self configureViewBlurWith:0 scale:1];
    [UIView animateWithDuration:COMMON_SHOW_ClOSE_DURATION_TIME animations:^
     {
         [self configureViewBlurWith:_mainVC.view.frame.size.width scale:1];
         [_rightSideView setFrame:CGRectMake(0, _rightSideView.frame.origin.y, _rightSideView.frame.size.width, _rightSideView.frame.size.height)];
     } completion:^(BOOL finished)
     {
         _rightSideView.userInteractionEnabled = YES;
         _tapGestureRec.enabled = YES;
         
         if (self.finishShowRight != nil)
         {
             self.finishShowRight();
         }
     }];

    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
