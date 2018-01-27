//
//  LoginTextFieldView.m
//  RisingClouds
//
//  Created by JianRen on 17/12/4.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import "LoginTextFieldView.h"
#define TimerCountDown 60  //定时器倒计时

@interface LoginTextFieldView ()<UITextFieldDelegate>

{
    NSInteger _countDown ;  //倒计时
}

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *showButton; // 显示密码
@property(nonatomic,strong)UIButton *sendcodeButton; // 发送验证码
@property(nonatomic,strong)UIView *sendButtonLeftLine; // 发送验证码左边的线
@property(nonatomic,strong)UIView *underLine; // 下划线
@property(nonatomic,strong)NSTimer *timer;


@end

@implementation LoginTextFieldView

-(instancetype)initWithFrame:(CGRect)frame andTitleString:(NSString *)titleString andPlaceholderString:(NSString *)placeholderString andRightClearButton:(BOOL)clearButton andShowPasswordButton:(BOOL)showPasswordButton isNumberKeyboard:(BOOL)isNumberKeyboard haveVerificationCode:(BOOL)haveVerificationCode;
{
    if(self = [super initWithFrame:frame])
    {
     
        
        
        CGFloat titleLabelHeight =  [titleString sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font }].height+2;
        
        [self addSubview:self.titleLabel];
         self.titleLabel.text = titleString;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.and.right.and.top.equalTo(self);
            make.height.mas_equalTo(titleLabelHeight);
            
        }];
        

        CGFloat textFieldHeight =  [placeholderString sizeWithAttributes:@{NSFontAttributeName : self.textField.font }].height+6;
        [self addSubview:self.textField];
        
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc]initWithString:placeholderString];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithWhite:205/255.0 alpha:1]
                            range:NSMakeRange(0, placeholderString.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:18.5]
                            range:NSMakeRange(0, placeholderString.length)];
        self.textField.attributedPlaceholder = placeholder;

        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {

            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
            make.width.mas_equalTo(self).multipliedBy(0.7);
            make.height.mas_equalTo(textFieldHeight);
            
        }];
        
        if(clearButton)
        {
            self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.titleLabel);
                make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
                make.width.mas_equalTo(self).multipliedBy(1.0);
                make.height.mas_equalTo(textFieldHeight);
                
            }];
        }
        
        if(isNumberKeyboard)
        {
            self.textField.keyboardType = UIKeyboardTypePhonePad;
        }
        
        if(showPasswordButton)
        {
            [self addSubview:self.showButton];
            [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.width.mas_equalTo(44);
                make.height.mas_equalTo(32);
                make.right.equalTo(self);
                make.centerY.equalTo(self.textField);
            }];
             self.textField.secureTextEntry = YES;
        }
        
        // 带发送验证码按钮
        if(haveVerificationCode)
        {
            
            CGFloat sendCodeButtonWidth =  [self.sendcodeButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.sendcodeButton.titleLabel.font }].width+2;
            [self addSubview:self.sendcodeButton];
            [self.sendcodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.width.mas_equalTo(sendCodeButtonWidth);
                make.right.equalTo(self);
                make.top.and.bottom.equalTo(self.textField);
                
            }];
            
            [self addSubview:self.sendButtonLeftLine];
            [self.sendButtonLeftLine mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.mas_equalTo(1);
                make.top.and.bottom.equalTo(self.textField);
                make.right.equalTo(self.sendcodeButton.mas_left).offset(-10);
                
            }];
            
            
        }
        
        
        
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
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:13];
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
        _underLine.backgroundColor = [UIColor colorWithRed:205/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        
    }
    return _underLine;
}

-(UIButton *)showButton
{
    if(!_showButton)
    {
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showButton addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
        [_showButton setImage:[UIImage imageNamed:@"icon_yanjing"] forState:UIControlStateNormal];
        [_showButton setImage:[UIImage imageNamed:@"icon_yanjing2"] forState:UIControlStateSelected];
    }
    return _showButton;
}

-(UIView *)sendButtonLeftLine
{
    if(!_sendButtonLeftLine)
    {
        _sendButtonLeftLine = [UIView new];
        _sendButtonLeftLine.backgroundColor = [UIColor colorWithRed:205/255.0 green:180/255.0 blue:180/255.0 alpha:1];
        
    }
    return _sendButtonLeftLine;
}

-(UIButton *)sendcodeButton
{
    if(!_sendcodeButton)
    {
        _sendcodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendcodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        _sendcodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_sendcodeButton setTitleColor:MainColor forState:UIControlStateNormal];
        [_sendcodeButton addTarget:self action:@selector(sendCodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sendcodeButton;
}

-(void)sendCodeButtonAction:(UIButton *)sender
{
    MyLog(@"发送验证码");
    
    [self StartTimer];
    
}


-(void)StartTimer
{
    [self stopTimer];
    _countDown = TimerCountDown;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self.timer fire];
    self.sendcodeButton.backgroundColor = [UIColor colorWithWhite:180/255.0 alpha:1];
    [self.sendcodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendcodeButton.enabled = NO;
}

-(void)timerAction
{
    _countDown--;
    [self.sendcodeButton setTitle:[NSString stringWithFormat:@"%lu S",_countDown] forState:UIControlStateNormal];
    
    if(_countDown==0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.sendcodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
            self.sendcodeButton.backgroundColor = [UIColor whiteColor];
            [self.sendcodeButton setTitleColor:MainColor forState:UIControlStateNormal];
            self.sendcodeButton.enabled = YES;
            [self stopTimer];
        });
    }
}

-(void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}



-(void)showAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if(sender.selected)
    {
        self.textField.secureTextEntry = NO;
    }
    else
    {
        self.textField.secureTextEntry = YES;
    }
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

-(void)dealloc
{
    [self stopTimer];
}

@end
