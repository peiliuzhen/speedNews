//
//  MDTopTableViewCell.m
//  MDSpeedNews
//
//  Created by Medalands on 15/10/23.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDTopTableViewCell.h"

@implementation MDTopTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"MDTopTableViewCell" owner:self options:nil] lastObject];
    }
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return self;
}

- (void)bindDataWithListModel:(MDListModel *)model{
    
    if (!model) {
        
    }
    
    // -- 标题
    [self.titleLabel setText:model.title];
    
    // -- 图片
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"topDefault"]];
}

- (void)awakeFromNib {

    // -- 设置文本字号
    [self.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
    
    // -- 设置文本颜色
    [self.titleLabel setTextColor:[UIColor whiteColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
