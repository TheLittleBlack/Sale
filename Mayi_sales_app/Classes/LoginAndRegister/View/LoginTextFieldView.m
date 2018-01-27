//
//  LoginTextFieldView.m
//  RisingClouds
//
//  Created by JianRen on 17/12/4.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import "LoginTextFieldView.h"


@interface LoginTextFieldView ()<UITextFieldDelegate>

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIButton *showButton; // 显示密码
@property(nonatomic,strong)UIButton *sendcodeButton; // 发送验证码
@property(nonatomic,strong)UIView *sendButtonLeftLine; // 发送验证码左边的线
@property(nonatomic,strong)UIView *underLine; // 下划线


@end

@implementation LoginTextFieldView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
     
        
        
        CGFloat titleLabelHeight =  [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font }].height+2;
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.and.top.equalTo(self);
            make.height.mas_equalTo(titleLabelHeight);
            
        }];
        
        CGFloat textFieldHeight =  [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font }].height+6;
        
        [self addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
            make.width.mas_equalTo(self).multipliedBy(0.7);
            make.height.mas_equalTo(textFieldHeight);
            
        }];
        
        [self addSubview:self.underLine];
        [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.and.bottom.equalTo(self);
            make.height.mas_equalTo(0.5);
            
        }];
        
        
    }
    return self;
}

-(UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"手机号码";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:12.5];
        _titleLabel.textColor = [UIColor blackColor];
        
    }
    return _titleLabel;
}

-(UITextField *)textField
{
    if(!_textField)
    {

        _textField = [UITextField new];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        NSString *placeholderString = @"请输入手机号码";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:placeholderString];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithWhite:190/255.0 alpha:1]
                            range:NSMakeRange(0, placeholderString.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:17]
                            range:NSMakeRange(0, placeholderString.length)];
        _textField.attributedPlaceholder = placeholder;
        
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [UIColor blackColor];
        _textField.delegate = self;
        _textField.tintColor = [UIColor redColor];
        
        
        
    }
    return _textField;
}

-(UIView *)underLine
{
    if(!_underLine)
    {
        _underLine = [UIView new];
        _underLine.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        
    }
    return _underLine;
}

-(void)showAction:(UIButton *)sender
{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(showButtonAction:)]){
        [self.delegate showButtonAction:sender];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //明文切换密文后避免被清空
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.textField && textField.isSecureTextEntry) {
        textField.text = toBeString;
        return NO;
    }
    
    return YES;
}

@end
