//
//  MainViewController.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MainViewController.h"
#import "MDSNNewListView.h"
#import "MDSNScrollView.h"
#import "MDGategoryModel.h"
#import "MDChanelView.h"
#import "MDMoreChanelView.h"

@interface MainViewController ()<MDChanelViewDelegate>

@property (nonatomic , strong) MDSNScrollView *tmpScrollView;

@property (nonatomic , strong) MDSNNewListView *snNewListView;

@property (nonatomic , strong) MDChanelView *chanelView;

@property (nonatomic , strong) MDMoreChanelView *moreChanelView;

/**
 *  盖在chanelView上的View
 */
@property (nonatomic , strong) UIView *subChanelView;

/**
 *  保存分类频道的Model
 */
@property (nonatomic , strong) NSMutableArray *categoryArr;

/**
 *  默认频道个数
 */
@property (nonatomic , assign) NSInteger numberOfChanels;

/**
 *  保存展示区域频道
 */
@property (nonatomic , strong) NSMutableArray *showingArr;

/**
 *  保存非展示区域频道
 */
@property (nonatomic , strong) NSMutableArray *notShowingArr;

/**
 *  判断频道是否发生改边
 */
@property (nonatomic , assign) BOOL isChanged;

@end

@implementation MainViewController

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    // -- 动画的操作放在这里
    
    // -- 自动刷新
    MDSNNewListView *tmpView = [self.tmpScrollView getCurrentNewsListView];
    
    [tmpView autoRefreshCanBe];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // -- 初始化数组
    self.categoryArr = [NSMutableArray array];
    
    // -- 默认为NO
    self.isChanged = NO;
    
    self.showingArr = [NSMutableArray array];
    
    self.notShowingArr = [NSMutableArray array];
    
    // -- 初始化默认频道个数（默认是10个频道）
    self.numberOfChanels = 10;
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self.navigationItem setTitle:@"速闻"];
    
    [self setNavigationRightBarButtonWithImageNamed:@"set"];
    
    [self readChanelsInCache];
    
    [self setUpCategoryArr];
    
    [self setUpChanelView];
    
    [self setUpSNScrollView];
    
    [self setUpMoreChanelView];
    
    [self setUpSubChanelView];
}

#pragma -
#pragma mark - 创建更多频道的View -
- (void) setUpMoreChanelView{
    
    __weak typeof(self) weakSelf = self;
    
    self.moreChanelView = [[MDMoreChanelView alloc] initWithFrame:CGRectMake(0, - self.tmpScrollView.frame.size.height, KScreenWidth,  self.tmpScrollView.frame.size.height)];
    
    // -- 背景颜色
    [self.moreChanelView setBackgroundColor:RGBA_MD(236, 236, 236, 0.96)];
    
    // -- 设置出现时候的Frame
    [self.moreChanelView setShowFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - self.chanelView.frame.size.height)];
    
    [self.moreChanelView setAlpha:0];
    
    // -- 1. 创建展示区域的频道
    for (NSInteger i = 0; i < self.showingArr.count; i++) {
        
        MDGategoryModel *model = self.showingArr[i];
        
        [self.moreChanelView addShowingChanelWithTitle:model.tname];
    }
    
    // -- 2.创建Label和滚动视图
    [self.moreChanelView addMiddleLabelAndScrollView];
    
    // -- 3. 创建非展示区域的频道
    for (NSInteger i = 0; i < self.notShowingArr.count; i++) {
        
        MDGategoryModel *model = self.notShowingArr[i];
        
        [self.moreChanelView addNotShowingChanelWithTitle:model.tname];
    }
    
    // -- Block 点击展示区域按钮的时候 回调事件
    [self.moreChanelView setJumpToIndex:^(NSInteger buttonIndex) {
        
        [weakSelf.tmpScrollView scrollToNewListViewWithIndex:buttonIndex];
        
        // -- 第一种方法（最基础的）
//        [weakSelf showDownViewTouchUpInside:weakSelf.chanelView.moreButton];
        
        // -- 第二种方法（高级的）
        [weakSelf.chanelView.moreButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
    
    // -- Block 点击非展示区域按钮的时候 回调事件
    [self.moreChanelView setGetIndexToAddChanel:^(NSInteger index) {
        
        [weakSelf addChanelWithIndex:index];

    }];
    
    // -- Block 点击展示区域删除按钮的回调事件
    [self.moreChanelView setGetIndexToDeleteChanel:^(NSInteger index) {
        
        [weakSelf deleteChanelWithIndex:index];
    }];
    
    // -- 添加到滚动视图上
    [self.tmpScrollView addSubview:self.moreChanelView];
}

- (void) deleteChanelWithIndex:(NSInteger)index{
    
    self.isChanged = YES;
    
    NSInteger buttonIndex = index - 1;
    
    // -- 删除相对应频道
    [self.chanelView deleteButtonWithIndex:buttonIndex];
    
    // -- 删除相对应的列表
    [self.tmpScrollView deleteViewWithIndex:buttonIndex];

    MDGategoryModel *model = self.showingArr[buttonIndex];

    // -- 从本身数组里干掉
    [self.showingArr removeObject:model];
    
    // -- 添加到新数组里去
    [self.notShowingArr addObject:model];
}

- (void) addChanelWithIndex:(NSInteger )index{
    
    self.isChanged = YES;
    
    NSInteger buttonIndex = index - 1;
    
    MDGategoryModel *model = self.notShowingArr[buttonIndex];
    
    // -- 在 chanelView上添加一个button
    [self.chanelView loadButtonWithTitle:model.tname];
    
    // -- 添加一个列表
    MDSNNewListView *tmpListView = [[MDSNNewListView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.tmpScrollView.frame.size.height)];

    tmpListView.tid = model.tid;
    
    __weak typeof(self) weakSelf = self;
    
    // -- 跳转
    [tmpListView setPushViewControllerBlock:^(UIViewController *controller) {
        
        [weakSelf.navigationController pushViewController:controller animated:YES];
    }];
    
    [self.tmpScrollView loadNewsListView:tmpListView];
    
    // -- 从本身数组中干掉
    [self.notShowingArr removeObject:model];
    
    // -- 添加到新数组
    [self.showingArr addObject:model];
}

#pragma -
#pragma mark - 创建分类频道的滚动视图 -
- (void) setUpChanelView{
    
    __weak typeof(self) weakSelf = self;
    
    // -- 分类频道的滚动视图
    self.chanelView = [[MDChanelView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 43)];
    
    // -- 设置代理
    [self.chanelView setDelegate:self];
    
    // -- 循环创建分类频道按钮
    for (NSInteger i = 0; i < self.showingArr.count; i++) {
        
        MDGategoryModel *model = self.showingArr[i];
        
        [self.chanelView loadButtonWithTitle:model.tname];
    }
    
    // -- 选中默认按钮
    [self.chanelView chanelButtonDefaultClick];
    
    // -- Block 回调点击的按钮在数组中的下标
    [self.chanelView setChanelButtonIdex:^(NSInteger index) {
        
        [weakSelf.tmpScrollView scrollToNewListViewWithIndex:index];
        
    }];
    
    [self.view addSubview:self.chanelView];
}

#pragma -
#pragma mark - 创建承载列表的滚动视图和列表 -
- (void) setUpSNScrollView{
    
    __weak typeof(self) weakSelf = self;
    
    // -- 滚动视图
    self.tmpScrollView = [[MDSNScrollView alloc] initWithFrame:CGRectMake(0, 64 + 43, KScreenWidth, KScreenHeight - 64 - 43)];
    
    // -- 超出父视图范围就干掉
    [self.tmpScrollView setClipsToBounds:YES];
    
    // -- 滑动停止的时候拿到当前View
    [self.tmpScrollView setGetEndToView:^(UIView *tmpView) {
        
        MDSNNewListView *listView = (MDSNNewListView *)tmpView;
        
        // -- 进行刷新
        [listView autoRefreshCanBe];
        
    }];
    
    // -- 滑动停止的时候拿到当前View的index
    [self.tmpScrollView setGetEndscrollToIndex:^(NSInteger index) {
        
        [weakSelf.chanelView scrollToChanelViewWithIndex:index];
        
    }];
    
    // -- 循环创建MDSNNewListView 并传入相应的tid
    for (NSInteger i = 0; i < self.showingArr.count; i++) {
        
        MDGategoryModel *model = self.showingArr[i];
        
        self.snNewListView = [[MDSNNewListView alloc] initWithFrame:self.tmpScrollView.bounds];
        
        // -- 跳转
        [self.snNewListView setPushViewControllerBlock:^(UIViewController *controller) {
            
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
        
        // -- 把分类频道tid传到MDSNNewListView里
        self.snNewListView.tid = model.tid;
        
        // --
        [self.tmpScrollView loadNewsListView:self.snNewListView ];
    }
    
    [self.view addSubview:self.tmpScrollView];
}

#pragma -
#pragma mark - SettingButton点击事件 -
- (void) rightButtonTouchUpInside:(id)sender{
    
    if (sender && [sender isKindOfClass:[UIButton class]]) {
        
        // -- 显示设置页面
        [[MDYSliderViewController sharedSliderController] showRightViewController];
    }
}

// -- 获取分类频道接口tname 和 tid
- (void) setUpCategoryArr{
    
    if (self.showingArr.count > 0) {
        
        return;
    }
    
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"allCategory" ofType:@"txt"];
    
    NSData *tmpData = [NSData dataWithContentsOfFile:pathString];
    
    NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:tmpData options:NSJSONReadingMutableLeaves error:nil];
    
    for (NSDictionary *dict in jsonArr) {
        
        NSArray *listArr = dict[@"tList"];
        
        for (NSDictionary *subDict in listArr) {
            
            MDGategoryModel *model = [[MDGategoryModel alloc] initWithDictionary:subDict];
            
            if (self.showingArr.count < self.numberOfChanels) {
                
                [self.showingArr addObject:model];
            }
            else{
                
                [self.notShowingArr addObject:model];
            }
            
            [self.categoryArr addObject:model];
        }
    }
}

// -- 保存频道到cache
- (void) saveChanelsInCache{
    
    NSMutableArray *showingArr = [NSMutableArray array];
    
    for (MDGategoryModel *model in self.showingArr) {
        
        [showingArr addObject:model.dict];
    }
    
    NSMutableArray *notShowingArr = [NSMutableArray array];
    
    for (MDGategoryModel *model in self.notShowingArr) {
        
        [notShowingArr addObject:model.dict];
    }
    
    NSDictionary *tmpDict = @{@"showing":showingArr,@"notShowing":notShowingArr};
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:tmpDict forKey:@"MedalandsChanels"];
    
    // -- 同步
    [userDefault synchronize];
}

// -- 读取cache里的内容
- (void) readChanelsInCache{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *cacheDict = [userDefault objectForKey:@"MedalandsChanels"];
    
    // -- 如果userDefault 没有这个东西 就不往下执行
    if (cacheDict == nil) {
        
        return;
    }
    NSArray *tmpShowingArr = [cacheDict  valueForKey:@"showing"];
    
    NSArray *tmpNotShowingArr = [cacheDict valueForKey:@"notShowing"];
    
    for (NSDictionary *dict  in tmpShowingArr) {
        
        MDGategoryModel *model = [[MDGategoryModel alloc] initWithDictionary:dict];
        
        [self.showingArr addObject:model];
    }
    for (NSDictionary *dict  in tmpNotShowingArr) {
        
        MDGategoryModel *model = [[MDGategoryModel alloc] initWithDictionary:dict];
        
        [self.notShowingArr addObject:model];
    }
}

#pragma -
#pragma mark - 切换栏目和垃圾箱的View -
- (void) setUpSubChanelView{
    
    self.subChanelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth - 50, self.chanelView.frame.size.height)];
    
    // -- 背景颜色
    [self.subChanelView setBackgroundColor:[UIColor whiteColor]];
    
    // -- 一开始先隐藏
    [self.subChanelView setAlpha:0];
    
    // -- Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 43)];
    
    [titleLabel setText:@"切换栏目"];
    
    [titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    
    [titleLabel setTextColor:RGB_MD(153, 153, 153)];
    
    [self.subChanelView addSubview:titleLabel];
    
    // -- Button
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    
    // -- 25 *28
    [deleteButton setFrame:CGRectMake(self.subChanelView.frame.size.width - 14 - 25, (43 - 28)/2, 25, 28)];
    
    [deleteButton addTarget:self action:@selector(deleteChanelButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.subChanelView addSubview:deleteButton];
    
    [self.chanelView addSubview:self.subChanelView];
}

- (void) deleteChanelButtonDidPress:(UIButton *)sender{
    
    [self.moreChanelView startDeleteModel:sender];
}

#pragma -
#pragma mark - 更多分类按钮代理事件 -
- (void) showDownViewTouchUpInside:(UIButton *)sender{
    
    __weak typeof(self) weakSelf = self;
    
    if (sender.selected == YES) {
        
        sender.selected = NO;
        
        [sender setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
        
        // -- 添加动画
        [UIView animateWithDuration:0.3 animations:^{
            
            [weakSelf.subChanelView setAlpha:0];
        }];
        
        if (self.isChanged) {
            
            // -- 保存数据
            [self saveChanelsInCache];
        }
        
        // -- 隐藏
        [self.moreChanelView hideMoreChanelView];
    }
    else{
        
        sender.selected = YES;
        
        [sender setImage:[UIImage imageNamed:@"pull"] forState:UIControlStateNormal];
        
        // -- 添加动画
        [UIView animateWithDuration:0.3 animations:^{
            
            [weakSelf.subChanelView setAlpha:1];
        }];
        
        // -- 出现
        [self.moreChanelView showMoreChanelView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
