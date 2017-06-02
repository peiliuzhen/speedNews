//
//  MDListModel.h
//  MDSpeedNews
//
//  Created by Medalands on 15/10/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDBaseModel.h"

@interface MDListModel : MDBaseModel

/**
 *  标题
 */
@property (nonatomic , copy) NSString *title;

/**
 *  图片
 */
@property (nonatomic , copy) NSString *imgsrc;

/**
 *  描述
 */
@property (nonatomic , copy) NSString *digest;

/**
 *  图片数组 三张图的cell需要用到这个字段
 */
@property (nonatomic , strong) NSArray *imgextra;

/**
 *  判断是不是LongTableViewCell 如果imgType = 1
 */
@property (nonatomic , assign) NSNumber* imgType;

/**
 *  详情URL
 */
@property (nonatomic , copy) NSString *url;

/**
 *  唯一的
 */
@property (nonatomic , copy) NSString *docid;

/**
 *  这是我们自己添加的字段（判断是否已读的条件）
 */
@property (nonatomic , assign) BOOL isRead;


#pragma -
#pragma mark - 暂时用不到 -

@property (nonatomic , copy) NSString *hasCover;

@property (nonatomic , copy) NSString *hasHead;

@property (nonatomic , copy) NSString *skipID;

@property (nonatomic , copy) NSString *replyCount;

@property (nonatomic , copy) NSString *alias;

@property (nonatomic , copy) NSString *hasImg;

@property (nonatomic , copy) NSString *hasIcon;

@property (nonatomic , copy) NSString *skipType;

@property (nonatomic , copy) NSString *cid;

@property (nonatomic , copy) NSString *hasAD;

@property (nonatomic , copy) NSString *order;

@property (nonatomic , copy) NSString *priority;

@property (nonatomic , copy) NSString *lmodify;

@property (nonatomic , copy) NSString *tname;

@property (nonatomic , copy) NSString *ename;

@property (nonatomic , copy) NSString *ads;

@property (nonatomic , copy) NSString *photosetID;

@property (nonatomic , copy) NSString *ptime;

@end
