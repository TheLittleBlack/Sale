//
//  TestCellCollectionViewCell.m
//  SDMajletManagerDemo
//
//  Created by tianNanYiHao on 2017/5/27.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SDMajletCell.h"

@interface SDMajletCell()
{
    UIImageView *iconImageView;
    UILabel *titleLab;
    CAShapeLayer *_borderLayer;
}
@end

@implementation SDMajletCell


-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self buidUI];
    }return self;
}


-(void)buidUI{
    
    
    iconImageView = [[UIImageView alloc] init];
    [self addSubview:iconImageView];
    
    
    
    titleLab = [[UILabel alloc] init];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor darkTextColor];
    [self addSubview:titleLab];
    

    
    
}




-(void) setFont:(CGFloat)font{
    _font = font;
    titleLab.font = [UIFont systemFontOfSize:_font];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    titleLab.text = title;
}
-(void)setIconName:(NSString *)iconName{
    _iconName = iconName;
    
    UIImage *image = [UIImage imageNamed:_iconName];
    iconImageView.image = [UIImage imageNamed:_iconName];
    
    CGSize size = self.bounds.size;
    iconImageView.frame = CGRectMake(0, 0, image.size.width,image.size.height);
    iconImageView.center = CGPointMake(size.width/2, image.size.height/2);
    titleLab.frame = CGRectMake(0, iconImageView.frame.size.height, size.width, (size.height-image.size.height)/1.5);

}



-(void)setIsMoving:(BOOL)isMoving{
    _isMoving = isMoving;
    if (_isMoving) {
        titleLab.textColor = [UIColor clearColor];
        iconImageView.image = [UIImage imageNamed:@""];
   
    }else{
        titleLab.textColor = [UIColor darkTextColor];
        iconImageView.image = [UIImage imageNamed:_iconName];
     
    }
    
}





@end
