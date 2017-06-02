//
//  HttpRequest.m
//  TableView
//
//  Created by Micheal on 15/7/13.
//  Copyright (c) 2015年 Micheal. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // -- application/json 看情况使用这俩text/html
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"application/json",nil]];
    
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



@end
