//
//  MDYSliderViewController.h
//  MDYNews
//
//  Created by Medalands on 15/2/27.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDYSliderViewController : UIViewController

/**
 * 左划 VC
 */
@property(nonatomic,strong)UIViewController  *leftVC;

/**
 * 右划 VC
 */
@property(nonatomic,strong)UIViewController  *rightVC;

/**
 * 主页面 VC
 */
@property(nonatomic,strong)UIViewController  *mainVC;

/**
 * 控制是否可以 出现左View
 */
@property(nonatomic,assign)BOOL canShowLeft;

/**
 * 控制是否可以 出现右View
 */
@property(nonatomic,assign)BOOL canShowRight;

/**
 * 显示 中间的页面后 调用
 */
@property(nonatomic,copy)void(^showMiddleVc)();


/**
 * 右侧页面出现后 调用BLock
 */
@property(nonatomic,copy)void(^finishShowRight)();

/**
 * 记录 左侧View 出现的状态 YES 表示左侧View 正在出现
 */
@property(nonatomic,assign)BOOL showingLeft;

/**
 * 记录 右侧View 出现的状态  YES 表示右侧View 正在出现
 */
@property(nonatomic,assign)BOOL showingRight;


+ (MDYSliderViewController*)sharedSliderController;


/**
 *   点击左侧view  进行 中间VC的替换
 */
-(void)setMainContentViewController:(UIViewController *)mainVc;

/**
 *  控制 左侧 右侧 出现的方法
 */
- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes;

/**
 *  左侧VC  出现
 */
- (void)showLeftViewController;

/**
 * 右侧 VC 出现
 */
- (void)showRightViewController;

/**
 * 关闭侧边栏
 */
- (void)closeSideBar;


@end
