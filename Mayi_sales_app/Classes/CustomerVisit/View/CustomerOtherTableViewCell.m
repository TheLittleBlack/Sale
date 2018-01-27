//
//  CustomerOtherTableViewCell.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/1/2.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "CustomerOtherTableViewCell.h"

@implementation CustomerOtherTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        [self addSubview:self.finishImageView];
        
        [self addSubview:self.titleLabel];
        
        [self addSubview:self.gotoImageView];

        [self addSubview:self.finishLabel];
        
        [self addSubview:self.underLineView];
        
        
    }
    return self;
}

-(UILabel *)finishLabel
{
    if(!_finishLabel)
    {
        _finishLabel = [UILabel new];
        _finishLabel.textColor = [UIColor colorWithWhite:180/255.0 alpha:1];
        _finishLabel.font = [UIFont systemFontOfSize:15];
        _finishLabel.text = @"已完成";
        _finishLabel.textAlignment = NSTextAlignmentRight;
        _finishLabel.hidden = YES;
    }
    return _finishLabel;
}

-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        
    }
    return _titleLabel;
}

-(UIImageView *)gotoImageView
{
    if(!_gotoImageView)
    {
        _gotoImageView = [UIImageView new];
        _gotoImageView.image = [UIImage imageNamed:@"icon_jiantou"];
    }
    return _gotoImageView;
}

-(UIView *)underLineView
{
    if(!_underLineView)
    {
        _underLineView = [UIView new];
        _underLineView.backgroundColor = [UIColor colorWithWhite:210/255.0 alpha:1];
    }
    return _underLineView;
}

-(UIImageView *)finishImageView
{
    if(!_finishImageView)
    {
        _finishImageView = [UIImageView new];
        _finishImageView.image = [UIImage imageNamed:@"need_done_logo"];
    }
    return _finishImageView;
}


-(void)layoutSubviews
{
    
    [self.finishImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.and.width.mas_equalTo(20);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(15);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.height.equalTo(self);
        make.width.mas_equalTo(ScreenWidth/2);
        make.left.equalTo(self.finishImageView.mas_right).offset(5);

    }];
    
    [self.gotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.and.height.mas_equalTo(16);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        
    }];

    [self.finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.and.top.equalTo(self);
        make.width.mas_equalTo(ScreenWidth/4);
        make.right.equalTo(self.gotoImageView.mas_left).offset(-10);
        
    }];
    
    [self.underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(0.8);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.and.left.equalTo(self);
        
    }];
    
}

@end
