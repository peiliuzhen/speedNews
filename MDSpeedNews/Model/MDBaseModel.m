//
//  MDBaseModel.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDBaseModel.h"

@implementation MDBaseModel

- (id) initWithDictionary:(NSDictionary *)dict{
    
    self = [super init];
    
    if (self) {
        
        // -- 
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

- (void) setValue:(id)value forKey:(NSString *)key{
    
    [super setValue:value forKey:key];
}

// -- 如果字典里的key值没有对应的属性 会调用这个方法
- (void) setValue:(id)value forUndefinedKey:(NSString *)key{
    
    NSLog(@"UndefinedKey %@ in %@",key,[self class]);
}


@end
