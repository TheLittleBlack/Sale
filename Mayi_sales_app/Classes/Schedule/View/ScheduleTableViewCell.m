//
//  ScheduleTableViewCell.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/19.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "ScheduleTableViewCell.h"

@implementation ScheduleTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        [self addSubview:self.topLine];
        [self addSubview:self.iconImageView];
        [self addSubview:self.myTitleLabel];
        [self addSubview:self.myDescribeLabel];
        [self addSubview:self.rightButton];
        [self addSubview:self.finishImageView];
        
        
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
        _iconImageView.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
        
    }
    return _iconImageView;
}

-(UILabel *)myTitleLabel
{
    if(!_myTitleLabel)
    {
        _myTitleLabel = [UILabel  new];
        _myTitleLabel.textColor = [UIColor blackColor];
        _myTitleLabel.font = [UIFont systemFontOfSize:14];
        _myTitleLabel.text = @"标题";
    }
    return _myTitleLabel;
}

-(UILabel *)myDescribeLabel
{
    if(!_myDescribeLabel)
    {
        _myDescribeLabel = [UILabel new];
        _myDescribeLabel.textColor = [UIColor colorWithWhite:165/255.0 alpha:1];
        _myDescribeLabel.font = [UIFont systemFontOfSize:13];
        _myDescribeLabel.text = @"描述";
        
    }
    return _myDescribeLabel;
}

-(UIButton *)rightButton
{
    if(!_rightButton)
    {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"开始" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.layer.cornerRadius = 3;
        _rightButton.layer.masksToBounds = YES;
        _rightButton.layer.borderWidth = 1;
        _rightButton.layer.borderColor = MainColor.CGColor;
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:14.5];
        
    }
    return _rightButton;
}

-(UIImageView *)finishImageView
{
    if(!_finishImageView)
    {
        _finishImageView = [UIImageView new];
        _finishImageView.image = [UIImage imageNamed:@"dayplay_over_logo"];
        _finishImageView.hidden = YES;
    }
    return _finishImageView;
}

-(UIView *)topLine
{
    if(!_topLine)
    {
        _topLine = [UIView new];
        _topLine.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1];
    }
    return _topLine;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.and.top.equalTo(self);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.height.mas_equalTo(40);
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        
    }];
    
    
    CGSize myTitleLabelSize = [self.myTitleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.myTitleLabel.font}];
    
    [self.myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(ScreenWidth/1.8);
        make.top.equalTo(self.iconImageView).offset(2);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.height.mas_equalTo(myTitleLabelSize.height+2);
        
    }];
    
    CGSize myDescribeLabelSize = [self.myDescribeLabel.text sizeWithAttributes:@{NSFontAttributeName : self.myDescribeLabel.font}];
    [self.myDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.left.equalTo(self.myTitleLabel);
        make.bottom.equalTo(self.iconImageView);
        make.height.mas_equalTo(myDescribeLabelSize.height+2);
        
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        
    }];
    
    [self.finishImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.height.mas_equalTo(48);
        make.centerX.equalTo(self.rightButton);
        make.centerY.equalTo(self);
        
    }];
    
    
    
}

-(void)rightButtonAction:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(CellRightButtonAction:andSelectID:andBusinessKey:andType:andStoreName:)]){
        [self.delegate CellRightButtonAction:sender andSelectID:self.visitID andBusinessKey:self.businessKey andType:self.type andStoreName:self.storeName];
    }
}

@end
