//
//  MDSNNewListView.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDSNNewListView.h"
#import "MDTopTableViewCell.h"
#import "MDLongTableViewCell.h"
#import "MDNormalTableViewCell.h"
#import "MDMoreTableViewCell.h"
#import "MDListModel.h"
#import "DetilViewController.h"
#import "ImagesViewController.h"
#import "AppDelegate.h"
#import "SNDocidModel.h"
#import "MDListCache.h"

@interface MDSNNewListView ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  列表TableView
 */
@property (nonatomic , strong) UITableView *listTableView;

/**
 *  TableView数据源
 */
@property (nonatomic , strong) NSMutableArray *dataArr;

/**
 *  记录页数
 */
@property (nonatomic , assign) NSInteger page;

/**
 *  记录最后一次刷新的时候
 */
@property (nonatomic , assign) CFAbsoluteTime lastRefreshTime;

@end

@implementation MDSNNewListView

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setUpDataArr];
        
        [self setUpListTableView];
        
        [self setUpRefreshAndRequestMore];
    }
    
    return self;
}
// -- Getter 取值时候用
// -- Setter 赋值使用用
- (void)setTid:(NSString *)tid{
    
    _tid = tid;
    
    NSLog(@"%@",tid);
    
    NSDictionary *dict = [MDListCache readCacheForKey:self.tid];
    
    NSArray *tmpArr = dict[self.tid];
    
    for (NSDictionary *dict in tmpArr) {
        
        MDListModel *model = [[MDListModel alloc] initWithDictionary:dict];
        
        // -- 设置已读还是未读状态
        model.isRead = [self isHaveDocid:model.docid];
        
        [self.dataArr addObject:model];
    }
}

- (void) setUpDataArr{
    
    self.dataArr = [NSMutableArray array];
    
    self.page = 1;
}

// -- 刷新数据
- (void) loadRefreshData{
    
    __weak typeof(self) weakSelf = self;
    
    NSString *baseURL = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/headline/%@/0-20.html",self.tid];
    
    [HttpRequest GET:baseURL parameters:nil success:^(id responseObject) {
        
        // -- 每次刷新请求成功的时候存在缓存里
        [MDListCache setObjectWithDict:responseObject WithKey:weakSelf.tid];
        
        // -- 清空数组
        [weakSelf.dataArr removeAllObjects];
        
        NSArray *tmpArr = responseObject[weakSelf.tid];
        
        for (NSDictionary *dict in tmpArr) {
            
            MDListModel *model = [[MDListModel alloc] initWithDictionary:dict];
            
            // -- 设置已读还是未读状态
            model.isRead = [weakSelf isHaveDocid:model.docid];
            
            [weakSelf.dataArr addObject:model];
        }
        
        // -- 记录时间
        weakSelf.lastRefreshTime = CFAbsoluteTimeGetCurrent();
        
        // -- 请求成功的时候page = 1
        weakSelf.page = 1;
        
        // -- 重置没有更多数据状态（能上拉加载更多）
        [weakSelf.listTableView.footer resetNoMoreData];
        
        // -- 请求成功刷新列表
        [weakSelf.listTableView reloadData];
        
        // -- 请求成功结束刷新
        [weakSelf.listTableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [RequestSever showMsgWithError:error];
    }];
}

// -- 加载更多数据
- (void) loadMoreData{
    
    self.page ++;
    
    __weak typeof(self) weakSelf = self;
    
    NSString *baseURL = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/headline/%@/%ld-20.html",self.tid,(self.page - 1) * 20];
    
    [HttpRequest GET:baseURL parameters:nil success:^(id responseObject) {
        
        NSArray *tmpArr = responseObject[weakSelf.tid];
        
        for (NSDictionary *dict in tmpArr) {
            
            MDListModel *model = [[MDListModel alloc] initWithDictionary:dict];
            
            // -- 判读是否已读
            model.isRead = [weakSelf isHaveDocid:model.docid];
            
            [weakSelf.dataArr addObject:model];
        }
        
        if (tmpArr.count < 15) {
            
            // -- 设置没有更多数据的状态
            [weakSelf.listTableView.footer noticeNoMoreData];
        }
        else{
            
            [weakSelf.listTableView.footer endRefreshing];
        }
        
        // -- 请求成功的时候刷新列表
        [weakSelf.listTableView reloadData];
        
        // -- 请求成功的时候结束刷新
//        [weakSelf.listTableView.footer endRefreshing];

    } failure:^(NSError *error) {
        
        weakSelf.page -- ;
        
        [RequestSever showMsgWithError:error];
    
    }];
}

#pragma -
#pragma mark - TableView && TableViewDelegate && DataSoure -
- (void) setUpListTableView{
    
    self.listTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    
    [self.listTableView setDelegate:self];
    
    [self.listTableView setDataSource:self];
    
    // -- 去掉分割线
    [self.listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // -- 设置背景颜色为透明
    [self.listTableView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.listTableView];
}

// -- 下拉刷新和上拉加载更多
- (void) setUpRefreshAndRequestMore{
    
    // -- 下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    
    // -- 正常状态
    [header setImages:@[[UIImage imageNamed:@"RefreshOne"]] forState:MJRefreshStateIdle];
    
    // -- 即将开始刷新状态
    [header setImages:@[[UIImage imageNamed:@"RefreshTwo"]] forState:MJRefreshStatePulling];
    
    // -- 进入刷新状态
    [header setImages:@[[UIImage imageNamed:@"RefreshThree"],[UIImage imageNamed:@"RefreshFour"],[UIImage imageNamed:@"RefreshFive"]] forState:MJRefreshStateRefreshing];
    
    [self.listTableView setHeader:header];
    
    // -- 上拉加载更多
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // -- 正常状态
    [footer setImages:@[[UIImage imageNamed:@"RefreshOne"]] forState:MJRefreshStateIdle];
    
    // -- 即将开始刷新状态
    [footer setImages:@[[UIImage imageNamed:@"RefreshTwo"]] forState:MJRefreshStatePulling];
    
    // -- 进入刷新状态
    [footer setImages:@[[UIImage imageNamed:@"RefreshThree"],[UIImage imageNamed:@"RefreshFour"],[UIImage imageNamed:@"RefreshFive"]] forState:MJRefreshStateRefreshing];

    [self.listTableView setFooter:footer];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArr count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MDListModel *model = nil;
    
    if (self.dataArr.count > indexPath.row) {
        
        model = self.dataArr[indexPath.row];
    }
    
    // -- 如果第一行让他显示MDTopTableViewCell
    if (indexPath.row == 0 ) {
        
        static NSString *TopID = @"TopID";
        
        MDTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TopID];
        
        if (!cell) {
            
            cell = [[MDTopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopID];
        }
        
        // -- 绑定数据
        [cell bindDataWithListModel:model];
        
        return cell;
    }
    // -- 如果imgType = 1显示MDLongTableViewCell
    if (model && model.imgType && [model.imgType isEqualToNumber:@(1)]) {
        
        static NSString *LongID = @"LongID";
        
        MDLongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LongID];
        
        if (!cell) {
            
            cell = [[MDLongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LongID];
        }
        
        // -- 绑定数据
        [cell bindDataWithListModel:model];
        
        return cell;
    }
    // -- 如果imgextra.count >1 说明是MDMoreTableViewCell
    if (model && model.imgextra && model.imgextra.count > 1) {
        
        static NSString *MoreID = @"MoreID";
        
        MDMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoreID];
        
        if (!cell) {
            
            cell = [[MDMoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MoreID];
        }
        
        // -- 绑定数据
        [cell bindDataWithListModel:model];
        
        return cell;
    }
    
    static NSString *ID = @"ID";
    
    MDNormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[MDNormalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    // -- 绑定数据
    [cell bindDataWithListModel:model];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MDListModel *model = nil;
    
    if (self.dataArr.count > indexPath.row) {
        
        model = self.dataArr[indexPath.row];
    }
    
    if (indexPath.row == 0) {
        
        return MDXFrom6(230);
    }
    
    if (model && model.imgType && [model.imgType isEqualToNumber:@(1)]) {
        
        return 55.0f + MDXFrom6(100);
    }
    
    if (model && model.imgextra && model.imgextra.count > 1) {
        
        return 34.5 +MDXFrom6(88.5);
    }
    
    return 83.0f;
}

// -- 是否可以自动刷新
- (void) autoRefreshCanBe{
    
    // -- 如果当前时间 - 记录的最后一个刷新的时间 大于10分钟 就可以再次刷新
    if (CFAbsoluteTimeGetCurrent() - self.lastRefreshTime > 10 * 60) {
        
        // -- 刷新
        [self.listTableView.header beginRefreshing];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArr.count > indexPath.row) {
        
        MDListModel *model = self.dataArr[indexPath.row];
        
        if (model && model.imgextra && model.imgextra.count > 1 && model.imgType == nil) {
            
            // -- 让他跳转到ImagesViewController
            ImagesViewController *controller = [[ImagesViewController alloc] init];
            
            controller.getListModel = model;
            
            if (self.pushViewControllerBlock) {
                
                self.pushViewControllerBlock(controller);
            }
        }
        else{
            // -- 后边详情页面其实不是使用model.url 而是根据docid去拼接一个请求地址
            if (model.docid) {
                
                DetilViewController *controller = [[DetilViewController alloc] init];
                
                controller.getListModel = model;
                
                if (self.pushViewControllerBlock) {
                    
                    self.pushViewControllerBlock(controller);
                }
            }
        }
        
        if (indexPath.row != 0) {
            
            // -- 点击TableViewCell的时候执行插入方法
            [self insertNewDocid:model.docid];
            
            // -- 改变成已读状态
            model.isRead = YES;
            
            // -- 更新UI（重新绑定数据）
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            // -- 判断cell类型
            if ([cell isKindOfClass:[MDLongTableViewCell class]]) {
                
                MDLongTableViewCell *longCell = (MDLongTableViewCell  *)cell;
                
                [longCell bindDataWithListModel:model];
            }
            else if ([cell isKindOfClass:[MDNormalTableViewCell class]]){
                
                MDNormalTableViewCell *normalCell = (MDNormalTableViewCell *)cell;
                
                [normalCell bindDataWithListModel:model];
            }
            else if ([cell isKindOfClass:[MDMoreTableViewCell class]]){
                
                MDMoreTableViewCell *moreCell = (MDMoreTableViewCell *)cell;
                
                [moreCell bindDataWithListModel:model];
            }
        }
    }
}

// -- 往CoreData里插入一条新的记录
- (void) insertNewDocid:(NSString *)docid{
    
    // -- 如果为真 说明已经有这条数据
    if ([self isHaveDocid:docid]) {
        
        // -- 不往下执行
        return;
    }
    
    SNDocidModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"SNDocidModel" inManagedObjectContext:KAppDelegate.managedObjectContext];
    
    model.docid = docid;
    
    // -- 保存
    [KAppDelegate saveContext];
}

// -- 查询CoreData是否是我传入参数这条数据的记录（如果有返回YES，没有就返回NO）
- (BOOL) isHaveDocid:(NSString *)docid{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"SNDocidModel"];
    
    // -- [cd] 不区分大小写 不区分发音
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"docid like[cd] %@",docid];
    
    [request setPredicate:pred];
    
    NSArray *resultArr = [KAppDelegate.managedObjectContext executeFetchRequest:request error:nil];
    
    if (resultArr.count > 0) {
        
        return YES;
    }
    
    return NO;
}

@end
