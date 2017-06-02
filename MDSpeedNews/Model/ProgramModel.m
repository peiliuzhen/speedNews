//
//  ProgramModel.m
//  BWSC_AVS+_Player
//
//  Created by 裴留振 on 16/4/25.
//  Copyright © 2016年 裴留振. All rights reserved.
//

#import "ProgramModel.h"

@implementation ProgramModel

// 对 个别 属性 单独赋值
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"ids"])
    {
        
    }
    else
    {
        [super setValue:value forKey:key];
    }
    
}

-(id)initWithDictionary:(NSDictionary *)dict{
    
    self=[super init];
    
    if (self) {
        
//        self.ids=dict[@"id"];
//        
//        self.freq=dict[@"freq"];
//        
//        self.pronum=dict[@"pronum"];
//        
//        self.sid=dict[@"sid"];
        
        self.name=dict[@"name"];
        self.pid=dict[@"pid"];
        
//        self.ca=dict[@"ca"];
//        
//        self.status=dict[@"status"];
    }
    
    return self;
}
@end
