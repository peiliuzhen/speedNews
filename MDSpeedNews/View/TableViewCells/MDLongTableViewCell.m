//
//  MDLongTableViewCell.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDLongTableViewCell.h"

@implementation MDLongTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"MDLongTableViewCell" owner:self options:nil] lastObject];
    }
    
    return self;
}

- (void) bindDataWithListModel:(MDListModel *)model{
    
    if (!model) {
        
    }
    
    // -- 标题
    [self.titleLabel setText:model.title];
    
    // -- 详情
    [self.contentLabel setText:model.digest];
    
    // -- 图片
    [self.longImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"rectDefault"]];
    
    if (model.isRead) {
        
        // -- 如果model.isRead为真 代表已读
        [self setUpReadCellState];
    }
    else
    {
        [self setUpNormalCellState];
    }
}

// -- 正常状态下Cell样式
- (void) setUpNormalCellState{
    
    [self.titleLabel setTextColor:RGB_MD(51, 51, 51)];
}

// -- 已读状态下Cell样式
- (void) setUpReadCellState{
    
    [self.titleLabel setTextColor:RGB_MD(153, 153, 153)];
}

- (void)awakeFromNib {
    
    // -- 设置文本颜色
    [self.contentLabel setTextColor:RGB_MD(153, 153, 153)];
    
    // -- 设置文本字号
    [self.contentLabel setFont:[UIFont systemFontOfSize:12.0f]];
    
    [self.titleLabel setTextColor:RGB_MD(51, 51, 51)];

    [self.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
