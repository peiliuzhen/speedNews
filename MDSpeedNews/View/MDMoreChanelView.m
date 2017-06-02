//
//  MDMoreChanelView.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/29.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDMoreChanelView.h"
#import "MDDeleteButton.h"

@interface MDMoreChanelView (){
    
    CGFloat buttonWidth;
    
    CGFloat buttonHeight;
    
    // -- 距离左边和右边的距离
    CGFloat xSpace;
    
    CGFloat buttonSpaceX;
    
    CGFloat buttonSapceY;
}

@property (nonatomic , assign) CGRect originFrame;

// -- 记录Button Y坐标
@property (nonatomic , assign) CGFloat lastButtonY;

@property (nonatomic , strong) UILabel  *middleLabel;

@property (nonatomic , strong) UIScrollView *buttonScrollView;

/**
 *  保存展示区域的频道
 */
@property (nonatomic , strong) NSMutableArray *showingArr;

/**
 *  保存非展示区域的频道
 */
@property (nonatomic , strong) NSMutableArray *notShowingArr;

/**
 *  判断是否是删除状态
 */
@property (nonatomic , assign) BOOL isDelete;

/**
 *  最多可以添加的频道个数
 */
@property (nonatomic , assign) NSInteger maxAddNumChaenls;

@end

@implementation MDMoreChanelView

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.originFrame = frame;
        
        [self setUpButton];
    }
    
    return self;
}

- (void) setUpButton{
    
    buttonWidth = MDXFrom6(75);
    
    buttonHeight = MDXFrom6(34);
    
    // -- 距离左边和右边的距离
    xSpace = MDXFrom6(15);
    
    buttonSpaceX = (KScreenWidth - 4 *buttonWidth - 2 * xSpace)/3;
    
    buttonSapceY = MDXFrom6(15);
    
    // -- 初始化删除状态
    self.isDelete = NO;
    
    // -- 初始化最多可以添加频道个数为24个
    self.maxAddNumChaenls = 24;
    
    // -- 初始化数组
    self.showingArr = [NSMutableArray array];
    
    self.notShowingArr = [NSMutableArray array];
}

// -- 添加展示区域的频道
- (void)addShowingChanelWithTitle:(NSString *)title{
    
    self.lastButtonY =  self.showingArr.count / 4 *(buttonHeight + buttonSapceY) +buttonSapceY;
    
    MDDeleteButton *button = [self buttonSetDefaultAndFrame:CGRectMake(xSpace + self.showingArr.count % 4 * (buttonWidth + buttonSpaceX), self.lastButtonY, buttonWidth, buttonHeight)];
    
    [button.deleteButton addTarget:self action:@selector(redDeleteButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [button addTarget:self action:@selector(showingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [self addSubview:button];
    
    // -- 添加到展示区域的数组中
    [self.showingArr addObject:button];
}

// -- 小红叉按钮点击事件
- (void) redDeleteButtonDidPress:(UIButton *)sender{

    NSLog(@"11111");
    
    // -- 拿到对应的按钮（sender是小红点 要拿得是他得父视图 通过superview）
    MDDeleteButton *button = (MDDeleteButton *)sender.superview;
    
    // -- 改变按钮的删除状态为正常状态
    [button setDeleteButtonStatus:MDDeleteButtonStatusNormal];
    
    // -- 拿到数组中下标
    NSInteger buttonIndex = [self.showingArr indexOfObject:button];
    
    NSLog(@"在数组中的下标是%ld",buttonIndex);
    
    // -- Block 传去下标+1
    if (self.getIndexToDeleteChanel) {
        
        self.getIndexToDeleteChanel(buttonIndex + 1);
    }
    
    // -- 从本身数组里干掉
    [self.showingArr removeObject:button];
    
    // -- 删除旧的点击事件
    [button removeTarget:self action:@selector(showingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    // -- 添加到新的数组里
    [self.notShowingArr addObject:button];
    
    // -- 添加新的点击事件
    [button addTarget:self action:@selector(notShowingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    // -- 交换父视图
    [self.buttonScrollView addSubview:button];
    
    // -- 重新计算Frame
    [button setFrame:CGRectMake(xSpace + (self.notShowingArr.count-1) % 4 * (buttonWidth + buttonSpaceX), (self.notShowingArr.count - 1) / 4 *(buttonHeight + buttonSapceY) + buttonSapceY, buttonWidth, buttonHeight)];
    
    // -- 计算滚动视图的滚动范围
    [self.buttonScrollView setContentSize:CGSizeMake(KScreenWidth,buttonHeight + buttonSapceY + button.frame.origin.y)];
    
    __weak typeof(self) weakSelf = self;
    
    // -- 从新计算展示区域当前按钮之后按钮的Frame
    [UIView animateWithDuration:0.3 animations:^{
        
        for (NSInteger i = buttonIndex; i < weakSelf.showingArr.count; i++) {
            
            MDDeleteButton *tmpButton = weakSelf.showingArr[i];
            
            weakSelf.lastButtonY = i / 4 *(buttonHeight + buttonSapceY) + buttonSapceY;
            
            [tmpButton setFrame:CGRectMake(i % 4 *(buttonWidth + buttonSpaceX) + xSpace, weakSelf.lastButtonY, buttonWidth, buttonHeight)];
        }
    }];
    
//    MDDeleteButton *lastButton = [self.showingArr lastObject];
    
    // --
    self.lastButtonY = (self.showingArr.count - 1) / 4 *(buttonHeight + buttonSapceY) + buttonSapceY;
    
    // -- 改变MiddleLabel的Frame
    [self.middleLabel setFrame:CGRectMake(0, self.lastButtonY + buttonHeight + buttonSapceY, KScreenWidth, 43)];
    
    // -- 改变滚动视图的Frame
    [self.buttonScrollView setFrame:CGRectMake(0, self.middleLabel.frame.origin.y + 43, KScreenWidth, KScreenHeight - 64 - 43 - self.middleLabel.frame.origin.y - 43)];
}

// -- 展示区域按钮点击事件
- (void) showingButtonDidPress:(UIButton *)sender{
    
    if (self.isDelete) {
        
        return;
    }
    
    NSLog(@"点击了展示区域里的按钮");
    
    // -- 拿到当前按钮在数组中的下标位置
    NSInteger buttonIndex = [self.showingArr indexOfObject:sender];
    
    if (self.jumpToIndex) {
        
        self.jumpToIndex(buttonIndex + 1);
    }
}

// -- 添加不在展示区域的频道
- (void)addNotShowingChanelWithTitle:(NSString *)title{
    
    MDDeleteButton *button = [self buttonSetDefaultAndFrame:CGRectMake(xSpace + self.notShowingArr.count % 4 * (buttonWidth + buttonSpaceX), self.notShowingArr.count / 4 *(buttonHeight + buttonSapceY) + buttonSapceY, buttonWidth, buttonHeight)];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(notShowingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonScrollView addSubview:button];
    
    // -- 添加到数组中
    [self.notShowingArr addObject:button];
    
    // -- 设置滚动视图ContentSize
    [self.buttonScrollView setContentSize:CGSizeMake(KScreenWidth, button.frame.origin.y + buttonHeight + buttonSapceY)];
}

// -- 非展示区域按钮点击事件
- (void) notShowingButtonDidPress:(MDDeleteButton *)sender{
    
    if (self.showingArr.count >= self.maxAddNumChaenls) {
        
        [ViewHelps showHUDWithText:@"最\n多\n添\n加\n24\n个\n频\n道"];
        
        return;
    }
    
    NSLog(@"点击了非展示区域的按钮");
    
    // -- 拿到按钮在数组中的下标
    NSInteger buttonIndex = [self.notShowingArr indexOfObject:sender];
    
    // -- Block 把下标传出去
    if (self.getIndexToAddChanel) {
        
        self.getIndexToAddChanel(buttonIndex + 1);
    }
    
    // -- 从本身数组中干掉
    [self.notShowingArr removeObject:sender];
    
    // -- 干掉原来的点击事件
    [sender removeTarget:self action:@selector(notShowingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    // -- 添加到展示区域数组
    [self.showingArr addObject:sender];
    
    // -- 添加在展示区域中的点击事件
    [sender addTarget:self action:@selector(showingButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [sender.deleteButton addTarget:self action:@selector(redDeleteButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
#warning - 这是正确的 -
    // -- 重新设置Frame 让这个新的Frame 和原来在滚动视图上的Farme保持一致
    [sender setFrame:CGRectMake(sender.frame.origin.x, self.buttonScrollView.frame.origin.y - self.buttonScrollView.contentOffset.y + sender.frame.origin.y, buttonWidth, buttonHeight)];
    
    // -- 改变父视图
    [self addSubview:sender];
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.4 animations:^{
        
        weakSelf.lastButtonY =  (weakSelf.showingArr.count - 1) / 4 *(buttonHeight + buttonSapceY) +buttonSapceY;
        
        // -- 计算添加到展示区域中的新的Frame
        [sender setFrame:CGRectMake(xSpace + (weakSelf.showingArr.count - 1) % 4 * (buttonWidth + buttonSpaceX), weakSelf.lastButtonY, buttonWidth, buttonHeight)];
        
        // -- 计算Label y坐标
        weakSelf.lastButtonY += buttonHeight + buttonSapceY;
        
        // -- 设置Label新的Frame
        [weakSelf.middleLabel setFrame:CGRectMake(0, weakSelf.lastButtonY, weakSelf.middleLabel.frame.size.width, 43)];
        
        // -- 计算滚动视图的 y坐标
        weakSelf.lastButtonY += 43;
        
        // -- 设置滚动视图新的Frame
        [weakSelf.buttonScrollView setFrame:CGRectMake(0, weakSelf.lastButtonY, KScreenWidth, KScreenHeight - 64 - 43 - weakSelf.lastButtonY)];
        
        // -- 重新布局非展示区域剩下按钮的位置
        for (NSInteger i = buttonIndex; i < weakSelf.notShowingArr.count; i++) {
            
            MDDeleteButton *button = weakSelf.notShowingArr[i];
            
            // -- 从新计算Frame 和一开始计算Frame的方法一样
            [button setFrame:CGRectMake(xSpace + i % 4 * (buttonWidth + buttonSpaceX), i / 4 *(buttonHeight + buttonSapceY) + buttonSapceY, buttonWidth, buttonHeight)];
        }
        
        // -- 拿到最后一个按钮的对象（我们要用这个按钮的Y值计算滚动视图的ContentSize）
        MDDeleteButton *button = [weakSelf.notShowingArr lastObject];
        
        // -- 设置滚动视图的ContentSize
        [weakSelf.buttonScrollView setContentSize:CGSizeMake(KScreenWidth, button.frame.origin.y + buttonHeight + buttonSapceY)];
    }];
}

- (MDDeleteButton *) buttonSetDefaultAndFrame:(CGRect)frame{
    
    MDDeleteButton *button = [[MDDeleteButton alloc] initWithFrame:frame];
    
    [button setImage:[UIImage imageNamed:@"column"] forState:UIControlStateNormal];
    
    [button setDeleteButtonStatus:MDDeleteButtonStatusNormal];
    
    [button.layer setCornerRadius:10.0f];
    
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -75, 0, 0)];
    
    [button setTitleColor:RGB_MD(51, 51, 51) forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    
    return button;
}

- (void) startDeleteModel:(UIButton *)sender{
    
    if (self.isDelete) {
        
        self.isDelete = NO;
        
        // -- 进入非删除模式
        [self.middleLabel setHidden:NO];
        
        [self.buttonScrollView setHidden:NO];
        
        for (MDDeleteButton *button in self.showingArr) {
            
            [button setDeleteButtonStatus:MDDeleteButtonStatusNormal];
        }
    }
    else{
        
        self.isDelete = YES;
        
        // -- 进入删除模式
        [self.middleLabel setHidden:YES];
        
        [self.buttonScrollView setHidden:YES];
        
        for (NSInteger i = 0; i < self.showingArr.count; i++) {
            
            // -- 头条不能被删除
            if (i == 0) {
                
                MDDeleteButton *button = self.showingArr[0];
                
                [button setDeleteButtonStatus:MDDeleteButtonStatusCanNotDelete];
            }
            else{
                
                MDDeleteButton *button = self.showingArr[i];

                [button setDeleteButtonStatus:MDDeleteButtonStatusCanDelete];
            }
        }
    }
}

- (void) showMoreChanelView{
    
    // -- 如果是删除状态
    if (self.isDelete) {
        
        // -- 恢复为正常
        [self startDeleteModel:nil];
    }
    
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration:0.3 animations:^{
        
        [weakSelf setFrame:weakSelf.showFrame];
        
        // -- 显示出来
        [weakSelf setAlpha:1.0];
    }];
}

- (void) hideMoreChanelView{
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [weakSelf setFrame:weakSelf.originFrame];

    }];
}

// -- 添加滚动视图方法
- (void)addMiddleLabelAndScrollView{
    
    // -- Label
    self.lastButtonY +=  buttonHeight + buttonSapceY;
    
     self.middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.lastButtonY, KScreenWidth, 43)];
    
    [self.middleLabel setBackgroundColor:[UIColor whiteColor]];
    
    [self.middleLabel setTextColor:RGB_MD(153, 153, 153)];
    
    [self.middleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    [self.middleLabel setText:@"   点击标签添加栏目"];
    
    [self addSubview:self.middleLabel];
    
    // -- UIScrollView
    self.lastButtonY += 43;
    
    self.buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.lastButtonY, KScreenWidth, KScreenHeight - 64 - 43 - self.lastButtonY)];
    
    // -- 背景颜色透明
    [self.buttonScrollView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.buttonScrollView];
}


















@end
