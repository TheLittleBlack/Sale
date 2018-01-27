//
//  SignAddressTableViewCell.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/27.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "SignAddressTableViewCell.h"

@implementation SignAddressTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {

        [self addSubview:self.firstLabel];
        [self addSubview:self.secondLabel];
        [self addSubview:self.distanceLabel];
        [self addSubview:self.selectImageView];
        
    }
    return self;
}

-(UILabel *)firstLabel
{
    if(!_firstLabel)
    {
        _firstLabel = [UILabel new];
        _firstLabel.textColor = [UIColor blackColor];
        _firstLabel.font = [UIFont systemFontOfSize:15];
    }
    return _firstLabel;
}

-(UILabel *)secondLabel
{
    if(!_secondLabel)
    {
        _secondLabel = [UILabel new];
        _secondLabel.textColor = [UIColor colorWithWhite:130/255.0 alpha:1];
        _secondLabel.font = [UIFont systemFontOfSize:14];
    }
    return _secondLabel;
}

-(UILabel *)distanceLabel
{
    if(!_distanceLabel)
    {
        _distanceLabel = [UILabel new];
        _distanceLabel.textColor = [UIColor blackColor];
        _distanceLabel.font = [UIFont systemFontOfSize:14];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _distanceLabel;
}

-(UIImageView *)selectImageView
{
    if(!_selectImageView)
    {
        _selectImageView = [UIImageView new];
        _selectImageView.image =[UIImage imageNamed:@"icon_xuanzhong"];
        _selectImageView.hidden = YES;
    }
    return _selectImageView;
}


-(void)layoutSubviews
{
    
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self).offset(-(15/2)-3);
        make.left.equalTo(self).offset(15);
        make.height.mas_equalTo(16);
        make.right.equalTo(self).offset(-100);
        
    }];
    
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.firstLabel.mas_bottom).offset(5);
        make.left.and.right.equalTo(self.firstLabel);
        make.height.mas_equalTo(15);
        
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        make.width.mas_equalTo(80);
        make.height.equalTo(self);
        
    }];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.height.mas_equalTo(32);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
        
    }];
    
}

@end
