//
//  CustomerVisitFirstTableViewCell.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/21.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "CustomerVisitFirstTableViewCell.h"

@implementation CustomerVisitFirstTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
    
        [self addSubview:self.iconImageView];

        [self addSubview:self.titleLabel];
        
        [self addSubview:self.describeLabel];

        [self addSubview:self.gotoImageView];
        
        [self addSubview:self.underLineView];
        
        
        
    }
    return self;
}

-(UIImageView *)iconImageView
{
    if(!_iconImageView)
    {
        _iconImageView = [UIImageView new];
        _iconImageView.image =[UIImage imageNamed:@"icon_dianpu02"];
        
    }
    return _iconImageView;
}

-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.text = @"店名";
    }
    return _titleLabel;
}

-(UILabel *)describeLabel
{
    if(!_describeLabel)
    {
        _describeLabel = [UILabel new];
        _describeLabel.textColor = [UIColor colorWithWhite:150/255.0 alpha:1];
        _describeLabel.font = [UIFont systemFontOfSize:14];
        _describeLabel.numberOfLines = 0;
        _describeLabel.text = @"地址";
    }
    return _describeLabel;
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

-(void)layoutSubviews
{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.and.height.mas_equalTo(15);
        make.left.equalTo(self).offset(18);
        make.top.equalTo(self).offset(16);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.width.mas_equalTo(ScreenWidth/1.5);
        make.top.equalTo(self.iconImageView);
        
    }];
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconImageView);
        make.width.equalTo(self.titleLabel);
        make.height.equalTo(self.titleLabel).mas_equalTo(30);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(2);
        
    }];
    
    [self.gotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.height.mas_equalTo(17);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
        
    }];
    
    
    [self.underLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(0.8);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.and.left.equalTo(self);
        
    }];
}

@end
