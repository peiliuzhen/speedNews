//
//  MDNormalTableViewCell.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDNormalTableViewCell.h"

@implementation MDNormalTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"MDNormalTableViewCell" owner:self options:nil] lastObject];
    }
    
    return self;
}

- (void)bindDataWithListModel:(MDListModel *)model{
    
    if (!model) {
        
    }
    
    [self.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"newsDefault"]];
    
    [self.titleLabel setText:model.title];
    
    [self.contentLabel setText:model.digest];
    
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

    [self.contentLabel setTextColor:RGB_MD(153, 153, 153)];
    
    [self.titleLabel setTextColor:RGB_MD(51, 51, 51)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
