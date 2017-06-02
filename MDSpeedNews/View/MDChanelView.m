//
//  MDChanelView.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/27.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDChanelView.h"

@interface MDChanelView (){
    
    // -- 记录水平方向按钮的X坐标
    CGFloat horizontalX;
}

/**
 *  承载频道按钮的滚动视图
 */
@property (nonatomic , strong) UIScrollView *chanelScrollView;

/**
 *  记录Button的数组
 */
@property (nonatomic , strong) NSMutableArray *buttonsArr;

/**
 *  绿色小点
 */
@property (nonatomic , strong) UIView *roundView;

@end

@implementation MDChanelView

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // -- 水平按钮坐标初始值为15
        horizontalX = 15;
        
        [self setUpChanelScrollViewAndMoreButton];
    }
    
    return self;
}

- (void) setUpChanelScrollViewAndMoreButton{
    
    // -- 初始化数组
    self.buttonsArr = [NSMutableArray array];
    
    // -- 承载频道按钮的滚动视图
    self.chanelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 50, self.frame.size.height)];
    
    // -- 隐藏水平滚动条
    [self.chanelScrollView setShowsHorizontalScrollIndicator:NO];
    
    [self.chanelScrollView setShowsVerticalScrollIndicator:NO];
    
    [self addSubview:self.chanelScrollView];
    
    // -- More这个按钮
    self.moreButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.moreButton setFrame:CGRectMake(self.frame.size.width - 50, 0, 50, self.frame.size.height)];
    
    [self.moreButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    
    [self.moreButton addTarget:self action:@selector(moreButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.moreButton];
    
    // -- 更多按钮左边的线
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(self.moreButton.frame.origin.x - 2, 0, 2, self.frame.size.height)];
    
    [lineView setImage:[UIImage imageNamed:@"divl"]];
    
    [self addSubview:lineView];
    
    // --
    self.roundView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 5, 5)];
    
    [self.roundView setBackgroundColor:RGB_MD(17, 129, 1)];
    
    [self.roundView.layer setCornerRadius:2.5];
    
    [self.chanelScrollView addSubview:self.roundView];
}

#pragma -
#pragma mark - 显示更多频道的按钮点击事件 -
- (void) moreButtonTouchUpInside:(UIButton *)sender{
    
    // -- 把点击事件代理出去
    if (self.delegate && [self.delegate respondsToSelector:@selector(showDownViewTouchUpInside:)]) {
        
        [self.delegate showDownViewTouchUpInside:sender];
    }
}

- (void) loadButtonWithTitle:(NSString *)title{
    
    UIFont *buttonFont = [UIFont systemFontOfSize:17.0f];
    
    CGRect tmpRect = [title boundingRectWithSize:CGSizeMake(1000, self.frame.size.height) options:0 attributes:@{NSFontAttributeName:buttonFont} context:NULL];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button.titleLabel setFont:buttonFont];
    
    [button setFrame:CGRectMake(horizontalX, 0, tmpRect.size.width, self.frame.size.height)];
    
    // -- 下一个按钮的X值
    horizontalX = horizontalX + tmpRect.size.width + 20;
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button setTitleColor:RGB_MD(153, 153, 153) forState:UIControlStateNormal];
    
    // -- 选中状态文字颜色
    [button setTitleColor:RGB_MD(51, 153, 51) forState:UIControlStateSelected];
    
    // -- 点击事件
    [button addTarget:self action:@selector(selectChanelButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    // -- 数组中添加button
    [self.buttonsArr addObject:button];
    
    [self.chanelScrollView setContentSize:CGSizeMake(horizontalX, self.frame.size.height)];
    
    [self.chanelScrollView addSubview:button];
}

// -- 默认第一个按钮为选中状态
- (void) chanelButtonDefaultClick{
    
    UIButton *tmpButton = [self.buttonsArr firstObject];
    
    [tmpButton setSelected:YES];
    
    [self.roundView setCenter:CGPointMake(tmpButton.center.x, tmpButton.center.y + 12)];
}

// -- 选择频道按钮点击方法
- (void) selectChanelButtonTouchUpInside:(UIButton *)sender{
    
    [self.chanelScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (obj  && [obj isKindOfClass:[UIButton class]]) {
            
            [(UIButton *)obj  setSelected:NO];
        }
    }];

    [sender setSelected:YES];
    
    [self.roundView setCenter:CGPointMake(sender.center.x, sender.center.y + 12)];
    
    // -- 根据数组里存得对象 去查找相对应的下标 index是从0开始的
    NSInteger buttonIndex = [self.buttonsArr indexOfObject:sender];
    
    if (self.chanelButtonIdex) {
        
        // -- 把数组下标传出去
        self.chanelButtonIdex(buttonIndex + 1);
    }
}

// -- 根据当前View的下标对分类频道按钮进行选中操作
- (void) scrollToChanelViewWithIndex:(NSInteger)index{
    
    if (self.buttonsArr.count > index - 1) {
        
        UIButton *tmpButton = self.buttonsArr[index - 1];
        
        // -- 按钮置为未选中的状态
        [self.buttonsArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if (obj && [obj isKindOfClass:[UIButton class]]) {
                
                [(UIButton *)obj setSelected:NO];
            }
        }];
        
        // -- 选中按钮
        [tmpButton setSelected:YES];
        
        [self.roundView setCenter:CGPointMake(tmpButton.center.x, tmpButton.center.y + 12)];
        
        // -- 有Rect 定义的区域是滚动视图内可见的，如果该区域是可见的就不做操作
        [self.chanelScrollView scrollRectToVisible:CGRectMake(tmpButton.center.x - self.chanelScrollView.frame.size.width/2, 0, self.chanelScrollView.frame.size.width, self.chanelScrollView.frame.size.height) animated:YES];
    }
}

- (void) deleteButtonWithIndex:(NSInteger)index{
    
    if (self.buttonsArr.count > index) {
        
        // -- 拿到这个按钮
        UIButton *button = self.buttonsArr[index];
        
        // -- 空出来区域的位置
        CGFloat whiteBlock = button.frame.size.width + 20;
        
        horizontalX -=  whiteBlock;
        
        // -- 从新排列这些按钮
        for (NSInteger i = index ; i < self.buttonsArr.count; i++) {
            
            UIButton *tmpButton = self.buttonsArr[i];
            
            [tmpButton setFrame:CGRectOffset(tmpButton.frame, -whiteBlock, 0)];
        }
        
        // -- 设置滚动视图的滚动范围
        [self.chanelScrollView setContentSize:CGSizeMake(self.chanelScrollView.contentSize.width - whiteBlock, self.chanelScrollView.frame.size.height)];
        
        // -- 从父视图干掉按钮
        [button removeFromSuperview];
        
        // -- 从数组里干掉这个按钮
        [self.buttonsArr removeObject:button];
    }
    else{
        
        NSLog(@"数组越界");
    }
}

@end
