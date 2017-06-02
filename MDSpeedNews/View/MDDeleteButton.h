//
//  MDDeleteButton.h
//  MDSpeedNews
//
//  Created by Medalands on 15/10/30.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

// -- 枚举
typedef NS_ENUM(NSInteger, MDDeleteButtonStatus){
    
    MDDeleteButtonStatusNormal = 0,
    MDDeleteButtonStatusCanNotDelete,
    MDDeleteButtonStatusCanDelete
};

@interface MDDeleteButton : UIButton

/**
 *  小红叉删除按钮
 */
@property (nonatomic , strong) UIButton *deleteButton;

/**
 *  判断删除按钮的状态
 *
 *  @param status MDDeleteButtonStatus枚举
 */
- (void) setDeleteButtonStatus:(MDDeleteButtonStatus)status;

@end
