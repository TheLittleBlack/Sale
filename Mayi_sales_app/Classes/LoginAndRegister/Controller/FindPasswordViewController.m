//
//  FindPasswordViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/9.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "LoginTextFieldView.h"

@interface FindPasswordViewController ()

@property(nonatomic,strong)LoginTextFieldView *TheNewPassword;
@property(nonatomic,strong)LoginTextFieldView *confirmPassword;
@property(nonatomic,strong)UIButton *confirmButton;

@end

@implementation FindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.TheNewPassword];
    [self.TheNewPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(85);
        make.left.equalTo(self.view).offset(38);
        make.right.equalTo(self.view).offset(-38);
        make.height.mas_equalTo(64);
        
    }];
    
    [self.view addSubview:self.confirmPassword];
    [self.confirmPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.height.equalTo(self.TheNewPassword);
        make.top.equalTo(self.TheNewPassword.mas_bottom).offset(20);
        
    }];
    
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.width.equalTo(self.TheNewPassword);
        make.top.equalTo(self.confirmPassword.mas_bottom).offset(25);
        make.height.mas_equalTo(44);
        
    }];
    
    
}


-(LoginTextFieldView *)TheNewPassword
{
    if(!_TheNewPassword)
    {
        _TheNewPassword = [[LoginTextFieldView alloc]initWithFrame:CGRectZero andTitleString:@"新密码" andPlaceholderString:@"请输入新密码" andRightClearButton:NO andShowPasswordButton:YES isNumberKeyboard:NO haveVerificationCode:NO];
    }
    return _TheNewPassword;
}

-(LoginTextFieldView *)confirmPassword
{
    if(!_confirmPassword)
    {
        _confirmPassword = [[LoginTextFieldView alloc]initWithFrame:CGRectZero andTitleString:@"确认新密码" andPlaceholderString:@"请输入新密码" andRightClearButton:NO andShowPasswordButton:YES isNumberKeyboard:NO haveVerificationCode:NO];
        
    }
    return _confirmPassword;
}

-(UIButton *)confirmButton
{
    if(!_confirmButton)
    {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.backgroundColor = MainColor;
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.layer.masksToBounds = YES;
        _confirmButton.layer.cornerRadius = 3;
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:18.5];
        
    }
    return _confirmButton;
}


-(void)confirmButtonAction:(UIButton *)sender
{
    MyLog(@"确定");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
