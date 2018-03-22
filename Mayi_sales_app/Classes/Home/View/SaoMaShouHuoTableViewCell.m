//
//  SaoMaShouHuoTableViewCell.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/3/21.
//  Copyright © 2018年 JayJay. All rights reserved.
//



#import "SaoMaShouHuoTableViewCell.h"

@implementation SaoMaShouHuoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        [self addSubview:self.logoImageView];
        [self addSubview:self.titleLabel];
        
        [self addSubview:self.yiSaoMiaoLabel];
        [self addSubview:self.gongJiXiangLabel];
        [self addSubview:self.shaoJiXiangLabel];
        [self addSubview:self.boxNumberLabel];
        
    }
    return self;
}

-(UIImageView *)logoImageView
{
    if(!_logoImageView)
    {
        _logoImageView = [UIImageView new];
        _logoImageView.image =[UIImage imageNamed:@"loginIcon"];
    }
    return _logoImageView;
}






-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithWhite:0/255.0 alpha:1];
        _titleLabel.text = @"这里是标题标题标题标题标题标题标题标题标题标题标题标题标题标题";
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

-(UILabel *)boxNumberLabel
{
    if(!_boxNumberLabel)
    {
        _boxNumberLabel = [UILabel new];
        _boxNumberLabel.font = [UIFont systemFontOfSize:15];
        _boxNumberLabel.textAlignment = NSTextAlignmentLeft;
        _boxNumberLabel.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _boxNumberLabel.text = @"箱码:";
    }
    return _boxNumberLabel;
}

-(UILabel *)yiSaoMiaoLabel
{
    if(!_yiSaoMiaoLabel)
    {
        _yiSaoMiaoLabel = [UILabel new];
        _yiSaoMiaoLabel.font = [UIFont systemFontOfSize:15];
        _yiSaoMiaoLabel.textAlignment = NSTextAlignmentLeft;
        _yiSaoMiaoLabel.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _yiSaoMiaoLabel.text = @"已扫0箱";
    }
    return _yiSaoMiaoLabel;
}

-(UILabel *)gongJiXiangLabel
{
    if(!_gongJiXiangLabel)
    {
        _gongJiXiangLabel = [UILabel new];
        _gongJiXiangLabel.font = [UIFont systemFontOfSize:15];
        _gongJiXiangLabel.textAlignment = NSTextAlignmentLeft;
        _gongJiXiangLabel.textColor = [UIColor colorWithWhite:0/255.0 alpha:1];
        _gongJiXiangLabel.text = @"共0箱";
    }
    return _gongJiXiangLabel;
}

-(UILabel *)shaoJiXiangLabel
{
    if(!_shaoJiXiangLabel)
    {
        _shaoJiXiangLabel = [UILabel new];
        _shaoJiXiangLabel.font = [UIFont systemFontOfSize:15];
        _shaoJiXiangLabel.textAlignment = NSTextAlignmentLeft;
        _shaoJiXiangLabel.textColor = MainColor;
        _shaoJiXiangLabel.text = @"少0箱";
    }
    return _shaoJiXiangLabel;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(13);
        make.bottom.equalTo(self).offset(-10);
        make.width.mas_equalTo(self.mas_height).multipliedBy(1.2);
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.logoImageView.mas_right).offset(8);
        make.top.equalTo(self.logoImageView);
        make.right.equalTo(self).offset(-5);
        
    }];
    

    
    CGFloat LabelWidth = [@"已扫00箱" sizeWithAttributes:@{NSFontAttributeName:self.yiSaoMiaoLabel.font}].width + 2;
    
    [self.yiSaoMiaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.mas_bottom).offset(-8);
        make.width.mas_equalTo(LabelWidth);
        
    }];
    
    [self.gongJiXiangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.yiSaoMiaoLabel.mas_right).offset(5);
        make.centerY.and.width.equalTo(self.yiSaoMiaoLabel);
        
    }];
    
    [self.shaoJiXiangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.gongJiXiangLabel.mas_right).offset(5);
        make.centerY.and.width.equalTo(self.yiSaoMiaoLabel);
        
    }];
    
    [self.boxNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.yiSaoMiaoLabel.mas_top).offset(-5);
        make.width.mas_equalTo(self.titleLabel);
        
    }];
    
    
    
}


@end
