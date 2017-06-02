//
//  ProgramModel.h
//  BWSC_AVS+_Player
//
//  Created by 裴留振 on 16/4/25.
//  Copyright © 2016年 裴留振. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgramModel : NSObject

//@property (nonatomic , assign)BOOL status;
//
//@property (nonatomic , assign)BOOL ca;
//
//@property (nonatomic ,copy)NSString *ids;

@property (nonatomic , copy)NSString *name;

@property (nonatomic , strong)NSArray *pid;

//@property (nonatomic , copy)NSString *sid;
//
//@property (nonatomic , assign)NSNumber *ver;
//
//@property (nonatomic , assign)NSNumber *pronum;
//
//@property (nonatomic , assign)NSNumber *freq;

-(id)initWithDictionary:(NSDictionary *)dict;
@end
