//
//  MDNormalTableViewCell.h
//  MDSpeedNews
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDListModel.h"

@interface MDNormalTableViewCell : UITableViewCell

/**
 *  显示新闻图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;

/**
 *  显示标题的Label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  显示内容的Label
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void) bindDataWithListModel:(MDListModel *)model;;

@end
