//
//  MDMoreTableViewCell.h
//  MDSpeedNews
//
//  Created by Medalands on 15/10/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDListModel.h"

@interface MDMoreTableViewCell : UITableViewCell

/**
 *  左侧ImageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

/**
 *  中间的ImageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;

/**
 *  右侧ImageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

/**
 *  显示标题的Label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void) bindDataWithListModel:(MDListModel *)model;;

@end
