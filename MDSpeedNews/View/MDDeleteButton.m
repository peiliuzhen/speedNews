//
//  MDDeleteButton.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/30.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDDeleteButton.h"

@implementation MDDeleteButton

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpDeleteButton];
    
    }
    return self;
}

- (void) setUpDeleteButton{
    
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.deleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    
    [self.deleteButton setFrame:CGRectMake(self.frame.size.width - 13, -6.5, 19, 19)];
    
    [self addSubview:self.deleteButton];
}

// -- 设置删除按钮的状态
- (void) setDeleteButtonStatus:(MDDeleteButtonStatus)status{
    
    switch (status) {
            // -- 正常状态
        case MDDeleteButtonStatusNormal:
            [self.deleteButton setHidden:YES];
            break;
            // -- 可以删除的状态
        case MDDeleteButtonStatusCanDelete:
            [self.deleteButton setHidden:NO];
            break;
            // -- 不可以删除的状态
        case MDDeleteButtonStatusCanNotDelete:
            [self.deleteButton setHidden:YES];
            break;
            
        default:
            break;
    }
}

@end
