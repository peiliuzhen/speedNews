//
//  MDMoreChanelView.h
//  MDSpeedNews
//
//  Created by Medalands on 15/10/29.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDMoreChanelView : UIView

@property (nonatomic , assign) CGRect showFrame;

/**
 *  显示View
 */
- (void) showMoreChanelView;

/**
 *  隐藏View
 */
- (void) hideMoreChanelView;

/**
 *  创建正在展示区域的频道的方法
 *
 *  @param title <#title description#>
 */
- (void) addShowingChanelWithTitle:(NSString *)title;

/**
 *  创建不在展示区域的频道方法
 *
 *  @param title <#title description#>
 */
- (void) addNotShowingChanelWithTitle:(NSString *)title;

/**
 *  创建中间的Label和他下边的滚动视图的方法
 */
- (void) addMiddleLabelAndScrollView;

/**
 *  点击展示区域按钮的时候把 当前按钮在数组中的 下标+1 传出去
 */
@property (nonatomic , copy) void(^jumpToIndex)(NSInteger index);

/**
 *  点击非展示区域按钮的时候 把当前按钮在数组中的 下标+1 传出去
 */
@property (nonatomic , copy) void(^getIndexToAddChanel)(NSInteger index);

@property (nonatomic , copy) void(^getIndexToDeleteChanel)(NSInteger index);


/**
 *  开启删除模式
 *
 *  @param sender UIButton
 */
- (void) startDeleteModel:(UIButton *)sender;




















@end
