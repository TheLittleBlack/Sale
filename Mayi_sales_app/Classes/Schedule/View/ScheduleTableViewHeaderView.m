//
//  ScheduleTableViewHeaderView.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/19.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "ScheduleTableViewHeaderView.h"

@implementation ScheduleTableViewHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {

        [self addSubview:self.topView];
        
        [self addSubview:self.firstLabel];
        
        [self addSubview:self.secondLabel];
        
        [self addSubview:self.dateLabel];
        
    }
    
    return self;
}

-(UILabel *)firstLabel
{
    if(!_firstLabel)
    {
        _firstLabel = [UILabel new];
        _firstLabel.textColor = [UIColor blackColor];
        _firstLabel.font = [UIFont systemFontOfSize:12];
        _firstLabel.text = @"共有0个日程";
    }
    return _firstLabel;
}

-(UILabel *)secondLabel
{
    if(!_secondLabel)
    {
        _secondLabel = [UILabel new];
        _secondLabel.font = [UIFont systemFontOfSize:12];
        _secondLabel.textColor = [UIColor redColor];
        _secondLabel.text = @"(未完成0个)";

    }
    return _secondLabel;
}

-(UILabel *)dateLabel
{
    if(!_dateLabel)
    {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.text = @" ";
        
    }
    return _dateLabel;
}

-(UIView *)topView
{
    if(!_topView)
    {
        _topView = [UIView new];
        _topView.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
    }
    return _topView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.top.and.right.equalTo(self);
        make.height.mas_equalTo(10);
        
    }];
    
    
    CGSize firstLabelSize = [self.firstLabel.text sizeWithAttributes:@{NSFontAttributeName : self.firstLabel.font}];
    [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self).offset(5);
        make.height.mas_equalTo(firstLabelSize.height+2);
//        make.width.mas_equalTo(firstLabelSize.width+8);
        
    }];
    
    CGSize secondLabelSize = [self.secondLabel.text sizeWithAttributes:@{NSFontAttributeName : self.secondLabel.font}];
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.and.height.equalTo(self.firstLabel);
        make.left.equalTo(self.firstLabel.mas_right).offset(8);
        make.width.mas_equalTo(secondLabelSize.width+6);

    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.and.height.equalTo(self.firstLabel);
        make.left.equalTo(self.secondLabel.mas_right).offset(4);
        
    }];

}
@end
