//
//  MDTopTableViewCell.h
//  MDSpeedNews
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDListModel.h"

@interface MDTopTableViewCell : UITableViewCell

/**
 *  显示大图的imageView
 */
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

/**
 *  显示标题的Label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 *  绑定数据
 *
 *  @param model MDListModel
 */
- (void) bindDataWithListModel:(MDListModel *)model;

@end
