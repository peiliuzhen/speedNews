//
//  MDListCache.h
//  MDSpeedNews
//
//  Created by Medalands on 15/11/2.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDListCache : NSObject

+ (NSDictionary *) readCacheForKey:(NSString *)key;

+ (void) setObjectWithDict:(NSDictionary *)dict WithKey:(NSString *)key;

@end
