//
//  SaoMaShouHuoFootView.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/3/21.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "SaoMaShouHuoFootView.h"

@implementation SaoMaShouHuoFootView


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        
        [self addSubview:self.imageButton];
        [self.imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self).offset(20);
            make.top.equalTo(self).offset(10);
            make.bottom.equalTo(self).offset(-10);
            make.width.equalTo(self.imageButton.mas_height);
            
        }];
        
    }
    
    return self;
}

-(UIButton *)imageButton
{
    if(!_imageButton)
    {
        _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_imageButton setImage:[UIImage imageNamed:@"camera_press"] forState:UIControlStateNormal];
        [_imageButton addTarget:self action:@selector(imageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _imageButton;
}

-(void)imageButtonAction:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(takePhote)]){
        [self.delegate takePhote];
    }
}

-(void)layoutSubviews
{
    
}



@end
