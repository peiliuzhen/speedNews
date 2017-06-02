//
//  MDSNScrollView.h
//  MDSpeedNews
//
//  Created by Medalands on 15/10/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSNNewListView.h"

@interface MDSNScrollView : UIView

/**
 *  添加视图
 *
 *  @param view MDSNNewListView
 */
- (void) loadNewsListView:(MDSNNewListView *)view;

/**
 *  获取当前视图
 *
 *  @return UIView
 */
- (MDSNNewListView *) getCurrentNewsListView;

// -- 返回值+函数名+参数
// -- 声明 实现 调用
// -- 把当前视图传出去让外部能调用
@property (nonatomic , copy) void(^getEndToView)(UIView *view);

@property (nonatomic , copy) void(^getEndscrollToIndex)(NSInteger index);

/**
 *  根据点击频道按钮的index设置滚动视图的偏移量
 *
 *  @param index NSInteger
 */
- (void) scrollToNewListViewWithIndex:(NSInteger)index;

/**
 *  删除相对应的View
 *
 *  @param index NSInteger
 */
- (void) deleteViewWithIndex:(NSInteger)index;









@end
