//
//  MDSNScrollView.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDSNScrollView.h"

@interface MDSNScrollView ()<UIScrollViewDelegate>

/**
 *  滚动视图 承载NewsListView
 */
@property (nonatomic , strong) UIScrollView *listScrollView;

/**
 *  保存View对象的数组
 */
@property (nonatomic , strong) NSMutableArray *viewsArr;

@end

@implementation MDSNScrollView

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpListScrollView];
        
        self.viewsArr = [NSMutableArray array];
    }
    
    return self;
}

- (void) setUpListScrollView{
    
    self.listScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    
    // -- 整页翻动
    [self.listScrollView setPagingEnabled:YES];
    
    [self.listScrollView setDelegate:self];
    
    // -- 隐藏竖直方向滚动条
    [self.listScrollView setShowsVerticalScrollIndicator:NO];
    
    // -- 背景颜色
    [self.listScrollView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.listScrollView];
}

// -- 取到当前的View 并return
- (MDSNNewListView *) getCurrentNewsListView{
    
    NSInteger currentIndex = self.listScrollView.contentOffset.x / KScreenWidth;
    // --
    MDSNNewListView *tmpView = nil;
    
    if (self.viewsArr.count > currentIndex) {
        
        tmpView = [self.viewsArr objectAtIndex:currentIndex];
    }
    else{
        
        NSLog(@"数组越界 %s in %@",__FUNCTION__,[self class]);
    }
    
    return tmpView;
}

// -- 添加MDSNNewListView的对象
- (void)loadNewsListView:(MDSNNewListView *)view{
    
    // -- 重新设置Frame
    [view setFrame:CGRectMake(self.viewsArr.count * KScreenWidth, 0, KScreenWidth, KScreenHeight - 64 - 43)];
    
    // -- 保存View到记录数组中
    [self.viewsArr addObject:view];
    
    // -- 滚动范围
    [self.listScrollView setContentSize:CGSizeMake(self.viewsArr.count * KScreenWidth, KScreenHeight - 64 - 43)];
    
    [self.listScrollView addSubview:view];
}

#pragma -
#pragma mark - 根据分类频道选中按钮的下标进行操作 -
- (void) scrollToNewListViewWithIndex:(NSInteger)index{
    
    CGFloat contentOffSetX = (index - 1) * KScreenWidth;
    
    [self.listScrollView setContentOffset:CGPointMake(contentOffSetX, 0)];
    
    [self endScrollAndSendCurrentViewToResfresh];
}

#pragma -
#pragma mark - ScrollViewDelegate -
// -- 停止拖拽的时候调用 decelerate 减速
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    // -- 停止减速（停止滚动了）
    if (decelerate == NO) {
        
        [self endScrollAndSendCurrentViewToResfresh];
    }
}

// -- 停止减速的时候调用
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self endScrollAndSendCurrentViewToResfresh];
}

// -- 停止滚动的时候把当前的View传出去，然后以便后续进行自动刷新
- (void) endScrollAndSendCurrentViewToResfresh{
    
    // -- 拿到当前视图的页数
    NSInteger pageIndex = self.listScrollView.contentOffset.x / KScreenWidth;
    
    MDSNNewListView *tmpView = [self getCurrentNewsListView];
    
    if (self.getEndToView) {
        
        self.getEndToView(tmpView);
    }
    
    if (self.getEndscrollToIndex) {
        
        self.getEndscrollToIndex(pageIndex + 1);
    }
}

- (void) deleteViewWithIndex:(NSInteger)index{
    
    if (self.viewsArr.count > index) {
        
        // -- 拿到这个View
        UIView *tmpView = self.viewsArr[index];
        
        // -- 从父视图上删掉
        [tmpView removeFromSuperview];
        
        // -- 从新计算后边的View的Frame
        for (NSInteger i = index; i < self.viewsArr.count; i++) {
            
            UIView *view = self.viewsArr[i];
            
            [view setFrame:CGRectOffset(view.frame, - KScreenWidth, 0)];
        }
        
        // -- 从数组里移除
        [self.viewsArr removeObject:tmpView];
        
        // -- 设置滚动范围
        [self.listScrollView setContentSize:CGSizeMake(self.viewsArr.count * KScreenWidth, self.listScrollView.frame.size.height)];
        
        // -- 调用一下
        [self endScrollAndSendCurrentViewToResfresh];
    }
    else{
        
        NSLog(@"数组越界");
    }
}

@end
