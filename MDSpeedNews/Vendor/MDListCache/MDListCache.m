//
//  MDListCache.m
//  MDSpeedNews
//
//  Created by Medalands on 15/11/2.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDListCache.h"

@implementation MDListCache

+ (void) setObjectWithDict:(NSDictionary *)dict WithKey:(NSString *)key{
    
    // -- 1.拿到缓存文件夹目录
    NSString *chchePathString = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    // -- 2.拿到缓存文件夹的路径
    NSString *filePath = [chchePathString stringByAppendingPathComponent:@"com.medalands.listData"];
    
    // -- 3.创建一个NSFileManager对象
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    // -- 4.判断文件夹是否存在 如果不存在就创建
    if ([fileManager fileExistsAtPath:filePath] == NO) {
        
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // -- 缓存文件的路径
    NSString *chcheFilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    
    // -- 写入文件
    BOOL isSuccess = [dict writeToFile:chcheFilePath atomically:NO];
    
    if (isSuccess) {
        
        NSLog(@"缓存数据成功,缓存地址为:%@",chcheFilePath);
    }
}

+ (NSDictionary *) readCacheForKey:(NSString *)key{
    
    // -- 1.拿到缓存文件夹目录
    NSString *chchePathString = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    // -- 2.拿到缓存文件夹的文件夹的路径
    NSString *filePath = [chchePathString stringByAppendingPathComponent:@"com.medalands.listData"];
    
    // -- 3.拿到缓存文件的路径
     NSString *chcheFilePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];

    // -- 拿到缓存数据
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:chcheFilePath];
    
    return dict;
}

#warning - 清理缓存的方法讲完GCD再讲如何清理 -





@end
