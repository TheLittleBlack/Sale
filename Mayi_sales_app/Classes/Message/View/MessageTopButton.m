//
//  MessageTopButton.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/10.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "MessageTopButton.h"

@interface MessageTopButton()

@property(nonatomic,strong)UIImageView *downImage;

@end

@implementation MessageTopButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
        
        CGSize titleSize = [self.myTitle.text sizeWithAttributes:@{NSFontAttributeName : self.myTitle.font}];
        
        [self addSubview:self.myTitle];
        [self.myTitle mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(self);
            make.width.mas_equalTo(titleSize.width + 2);
            make.height.equalTo(self);
            make.centerX.equalTo(self).offset(-15/2);
            
        }];
        
//        [self addSubview:self.downImage];
//        [self.downImage mas_makeConstraints:^(MASConstraintMaker *make) {
//           
//            make.width.and.height.mas_equalTo(15);
//            make.centerY.equalTo(self);
//            make.left.equalTo(self.myTitle.mas_right).offset(3);
//            
//        }];
        
        
        
    }
    
    return self;
}

-(void)layoutIfNeeded
{
    [super layoutIfNeeded];
    
    CGSize titleSize = [self.myTitle.text sizeWithAttributes:@{NSFontAttributeName : self.myTitle.font}];
    
    [self.myTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.width.mas_equalTo(titleSize.width + 2);
        make.height.equalTo(self);
        make.centerX.equalTo(self).offset(-15/2);
        
    }];
}



-(UILabel *)myTitle
{
    if(!_myTitle)
    {
        _myTitle = [UILabel new];
        _myTitle.font = [UIFont systemFontOfSize:15];
        _myTitle.textColor = [UIColor blackColor];
//        _myTitle.text = @"全部消息";
    }
    return _myTitle;
}

-(UIImageView *)downImage
{
    if(!_downImage)
    {
        _downImage = [UIImageView new];
        _downImage.image = [UIImage imageNamed:@"icon_jiantou01"];
    }
    return _downImage;
}

@end
