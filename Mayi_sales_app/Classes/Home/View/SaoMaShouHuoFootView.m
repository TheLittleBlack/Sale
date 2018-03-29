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
            make.top.equalTo(self).offset(20);
            make.height.mas_equalTo(100);
            make.width.equalTo(self.imageButton.mas_height);
            
        }];
        
        [self addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.height.and.width.mas_equalTo(30);
            make.left.equalTo(self.imageButton.mas_right).offset(-15);
            make.top.equalTo(self.imageButton.mas_top).offset(-15);
            
        }];
        
        self.deleteButton.hidden = YES;
        
        [self addSubview:self.errorLabel];
        [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
            make.top.equalTo(self.imageButton.mas_bottom).offset(10);
            
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

-(UIButton *)deleteButton
{
    if(!_deleteButton)
    {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"icon_guangbi1"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _deleteButton;
}

-(void)imageButtonAction:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(takePhote)]){
        [self.delegate takePhote];
    }
}

-(void)deleteButtonAction:(UIButton *)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(deleteAction)]){
        [self.delegate deleteAction];
    }
}

-(UILabel *)errorLabel
{
    if(!_errorLabel)
    {
        _errorLabel = [UILabel new];
        _errorLabel.font = [UIFont systemFontOfSize:14];
        _errorLabel.textAlignment = NSTextAlignmentLeft;
        _errorLabel.textColor = [UIColor colorWithWhite:50/255.0 alpha:1];
        _errorLabel.text = @"阿萨德华和速度哈湖师大hi安徽丢按时的还是毒奶US会丢安徽省丢阿斯达斯UN咦打死uaisdaidijaidnaisniajdoiajsiod啊数据库DNA加拿大建电死的";
        _errorLabel.numberOfLines = 0;
    }
    return _errorLabel;
}



-(void)layoutSubviews
{
    
}



@end
