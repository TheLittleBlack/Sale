//
//  MessageBaseTableViewCell.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/10.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "MessageBaseTableViewCell.h"

@implementation MessageBaseTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
    
        [self addSubview:self.iconImageView];
        [self addSubview:self.bodyView];
        [self.bodyView addSubview:self.headerImageView];
        [self.headerImageView addSubview:self.headerTitleLabel];
        [self.bodyView addSubview:self.bodyTextLabel];
        [self.bodyView addSubview:self.state];
        [self.bodyView addSubview:self.date];
        [self addSubview:self.isReadView];

        
    }
    return self;
}

-(UIImageView *)iconImageView
{
    if(!_iconImageView)
    {
        _iconImageView = [UIImageView new];
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
    }
    return _iconImageView;
}



-(UIView *)bodyView
{
    if(!_bodyView)
    {
        _bodyView = [UIView new];
        _bodyView.backgroundColor = [UIColor whiteColor];
        _bodyView.layer.cornerRadius = 5;
//        _bodyView.layer.borderColor = [UIColor colorWithWhite:245/255.0 alpha:1].CGColor;
//        _bodyView.layer.borderWidth = 0.5;

    }
    return _bodyView;
}

-(UIImageView *)headerImageView
{
    if(!_headerImageView)
    {
        _headerImageView = [UIImageView new];
    }
    return _headerImageView;
}

-(UILabel *)headerTitleLabel
{
    if(!_headerTitleLabel)
    {
        _headerTitleLabel = [UILabel new];
        _headerTitleLabel.textColor = [UIColor whiteColor];
        _headerTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _headerTitleLabel;
}

-(UILabel *)bodyTextLabel
{
    if(!_bodyTextLabel)
    {
        _bodyTextLabel = [UILabel new];
        _bodyTextLabel.font = [UIFont systemFontOfSize:14];
        _bodyTextLabel.textColor = [UIColor blackColor];
        _bodyTextLabel.numberOfLines = 0;

    }
    return _bodyTextLabel;
}

-(UILabel *)name
{
    if(!_name)
    {
        _name = [UILabel new];
        _name.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
        _name.font = [UIFont systemFontOfSize:12];
    }
    return _name;
}

-(UILabel *)state
{
    if(!_state)
    {
        _state = [UILabel new];
        _state.text = @" ";
        _state.textColor = [UIColor redColor];
        _state.font = [UIFont systemFontOfSize:12];
    }
    return _state;
}

-(UILabel *)date
{
    if(!_date)
    {
        _date = [UILabel new];
        _date.textColor = [UIColor colorWithWhite:140/255.0 alpha:1];
        _date.font = [UIFont systemFontOfSize:12];
        _date.textAlignment =NSTextAlignmentRight;
    }
    return _date;
}

-(UIView *)isReadView
{
    if(!_isReadView)
    {
        _isReadView = [UIView new];
        _isReadView.backgroundColor = [UIColor redColor];
        _isReadView.layer.cornerRadius = 5;
        _isReadView.layer.masksToBounds = YES;
        _isReadView.layer.hidden = NO;
    }
    return _isReadView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self).offset(20);
        make.left.mas_equalTo(10);
        make.width.and.height.mas_equalTo(40);
        
    }];
    
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.iconImageView).offset(5);
        make.bottom.equalTo(self).offset(-15);
        
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.bodyView).offset(-5);
        make.top.equalTo(self.bodyView);
        make.right.equalTo(self.bodyView).offset(5);
        make.height.mas_equalTo(33);
        
    }];
    
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.and.height.and.right.equalTo(self.headerImageView);
        make.left.equalTo(self.headerImageView).offset(18);
        
    }];
    
    [self.bodyTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.bodyView).offset(18);
        make.right.equalTo(self.bodyView).offset(-25);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(18);
//        make.height.mas_equalTo(50);
        
    }];

    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.bodyTextLabel);
        make.bottom.equalTo(self).offset(-10-17);
        make.width.mas_equalTo(ScreenWidth/2.5);
        make.height.mas_equalTo(17);
        
    }];

    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
       
        
        make.right.equalTo(self.bodyView).offset(-15);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(17);
        make.bottom.equalTo(self).offset(-10-17);
        
    }];
    
    [self.isReadView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.and.width.mas_equalTo(10);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-25);
        
    }];
}



@end
