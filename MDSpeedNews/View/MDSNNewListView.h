//
//  MDSNNewListView.h
//  MDSpeedNews
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDSNNewListView : UIView

/**
 *  分类频道TID
 */
@property (nonatomic , copy) NSString *tid;

@property (nonatomic , copy) void(^pushViewControllerBlock)(UIViewController *controller);







- (void) autoRefreshCanBe;

@end
