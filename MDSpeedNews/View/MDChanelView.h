//
//  MDChanelView.h
//  MDSpeedNews
//
//  Created by Medalands on 15/10/27.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MDChanelViewDelegate <NSObject>

// -- 必须实现的代理方法
@required

- (void) showDownViewTouchUpInside:(UIButton *)sender;

@end

@interface MDChanelView : UIView

- (void) loadButtonWithTitle:(NSString *)title;

/**
 *  把当前点击的按钮在数组中得下标传出去
 */
@property (nonatomic , copy) void(^chanelButtonIdex)(NSInteger index);

- (void) chanelButtonDefaultClick;

- (void) scrollToChanelViewWithIndex:(NSInteger)index;

// -- 代理用assign修饰避免循环引用
@property (nonatomic , assign) id<MDChanelViewDelegate>delegate;

@property (nonatomic , strong) UIButton *moreButton;

/**
 *  删除相对应index的频道按钮
 *
 *  @param index NSInteger
 */
- (void) deleteButtonWithIndex:(NSInteger)index;






@end
