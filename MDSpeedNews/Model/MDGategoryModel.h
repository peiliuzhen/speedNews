//
//  MDGategoryModel.h
//  MDSpeedNews
//
//  Created by Medalands on 15/10/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDBaseModel.h"

@interface MDGategoryModel : MDBaseModel

@property (nonatomic , copy) NSString *tname;

@property (nonatomic , copy) NSString *tid;

@property (nonatomic , strong) NSDictionary *dict;

@end
