//
//  MDMoreTableViewCell.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDMoreTableViewCell.h"

@implementation MDMoreTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"MDMoreTableViewCell" owner:self options:nil] lastObject];
    }
    
    return self;
}

- (void)bindDataWithListModel:(MDListModel *)model{
    
    if (!model) {
        
    }
    // -- 左侧图
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"threeDefault"]];
    
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:[model.imgextra[0] valueForKey:@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"threeDefault"]];
    
     [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:[model.imgextra[1] valueForKey:@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"threeDefault"]];
    
    [self.titleLabel setText:model.title];
    
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

    [self.titleLabel setTextColor:RGB_MD(51, 51, 51)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
