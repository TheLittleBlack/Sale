//
//  MessageTableViewCell.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/24.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.myTitleLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.tagLabel];
        
    }
    return self;
}

-(UIImageView *)iconImageView
{
    if(!_iconImageView)
    {
        _iconImageView = [UIImageView new];
        _iconImageView.backgroundColor = [UIColor clearColor];
    }
    return _iconImageView;
}

-(UILabel *)myTitleLabel
{
    if(!_myTitleLabel)
    {
        _myTitleLabel = [UILabel new];
        _myTitleLabel.textColor = [UIColor colorWithWhite:50/255.0 alpha:1];
        _myTitleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _myTitleLabel;
}

-(UILabel *)timeLabel
{
    if(!_timeLabel)
    {
        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor colorWithWhite:50/255.0 alpha:1];
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.text = @"00:00";
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

-(UILabel *)tagLabel
{
    if(!_tagLabel)
    {
        _tagLabel = [UILabel new];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.font = [UIFont systemFontOfSize:13];
        _tagLabel.backgroundColor = [UIColor redColor];
        _tagLabel.layer.cornerRadius = 11;
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(18);
        make.centerY.equalTo(self);
        make.width.and.height.mas_equalTo(55);
        
    }];
    
    [self.myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(20);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.equalTo(self);
        
    }];
    
    CGSize timeLabelSize = [self.timeLabel.text sizeWithAttributes:@{NSFontAttributeName : self.timeLabel.font}];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(-18);
//        make.centerY.equalTo(self).offset(-(timeLabelSize.height/2+5));
//        make.centerY.equalTo(self);
        make.width.mas_equalTo(ScreenWidth/4);
        
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.height.mas_equalTo(22);
        make.right.equalTo(self).offset(-20);
//        make.centerY.equalTo(self);
//        make.top.equalTo(self.timeLabel.mas_bottom).offset(8);
        
    }];
    
}

@end
