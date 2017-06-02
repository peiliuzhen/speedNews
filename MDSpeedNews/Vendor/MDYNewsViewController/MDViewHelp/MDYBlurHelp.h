//
//  MDYBlurHelp.h
//  MDYNews
//
//  Created by Medalands on 15/2/27.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface MDYBlurHelp : NSObject

/**
 *  将view转为image
 */
+ (UIImage *)getImageFromView:(UIView *)view;

/**
 * 获取随机颜色color
 */
+ (UIColor *)getRandomColor;

/**
 *根据比例（0...1）在min和max中取值
 */
+ (float)lerp:(float)percent min:(float)nMin max:(float)nMax;

@end
