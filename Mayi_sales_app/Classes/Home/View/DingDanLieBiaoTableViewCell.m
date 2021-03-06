//
//  DingDanLieBiaoTableViewCell.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/3/22.
//  Copyright © 2018年 JayJay. All rights reserved.
//




#import "DingDanLieBiaoTableViewCell.h"

@implementation DingDanLieBiaoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.orderLabel];
        [self addSubview:self.timeLabel];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).offset(5);
        make.top.equalTo(self).offset(10);
        make.width.mas_equalTo(ScreenWidth*0.95);
        
    }];
    
    [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.width.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.width.equalTo(self.nameLabel);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        
    }];
    

    
}


-(UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorWithWhite:50/255.0 alpha:1];
        _nameLabel.text = @"这里是标题";
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

-(UILabel *)timeLabel
{
    if(!_timeLabel)
    {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:16];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [UIColor colorWithWhite:50/255.0 alpha:1];
        _timeLabel.text = @"时间";
    }
    return _timeLabel;
}

-(UILabel *)orderLabel
{
    if(!_orderLabel)
    {
        _orderLabel = [UILabel new];
        _orderLabel.font = [UIFont systemFontOfSize:16];
        _orderLabel.textAlignment = NSTextAlignmentLeft;
        _orderLabel.textColor = [UIColor colorWithWhite:50/255.0 alpha:1];
        _orderLabel.text = @"订单编号";
    }
    return _orderLabel;
}


@end
