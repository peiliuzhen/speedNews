//
//  MDGategoryModel.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDGategoryModel.h"

@implementation MDGategoryModel

- (id)initWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self) {
        
        self.tid = dict[@"tid"];
        
        self.tname = dict[@"tname"];
        
        self.dict = dict;
    }
    
    return self;
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
