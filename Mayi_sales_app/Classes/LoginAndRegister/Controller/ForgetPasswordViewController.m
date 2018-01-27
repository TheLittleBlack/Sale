//
//  ForgetPasswordViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/9.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "LoginTextFieldView.h"
#import "FindPasswordViewController.h"

@interface ForgetPasswordViewController ()

@property(nonatomic,strong)LoginTextFieldView *phoneNumber;
@property(nonatomic,strong)LoginTextFieldView *verificationCode;
@property(nonatomic,strong)UIButton *nextButton;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.phoneNumber];
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).offset(85);
        make.left.equalTo(self.view).offset(38);
        make.right.equalTo(self.view).offset(-38);
        make.height.mas_equalTo(64);
        
    }];
    
    [self.view addSubview:self.verificationCode];
    [self.verificationCode mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.and.height.equalTo(self.phoneNumber);
        make.top.equalTo(self.phoneNumber.mas_bottom).offset(20);
        
    }];
    
    [self.view addSubview:self.nextButton];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.width.equalTo(self.phoneNumber);
        make.top.equalTo(self.verificationCode.mas_bottom).offset(25);
        make.height.mas_equalTo(44);
        
    }];
    
}

-(LoginTextFieldView *)phoneNumber
{
    if(!_phoneNumber)
    {
        _phoneNumber = [[LoginTextFieldView alloc]initWithFrame:CGRectZero andTitleString:@"你的手机号码是？" andPlaceholderString:@"请输入手机号码" andRightClearButton:YES andShowPasswordButton:NO isNumberKeyboard:YES haveVerificationCode:NO];
    }
    return _phoneNumber;
}

-(LoginTextFieldView *)verificationCode
{
    if(!_verificationCode)
    {
        _verificationCode = [[LoginTextFieldView alloc]initWithFrame:CGRectZero andTitleString:@"短信验证码" andPlaceholderString:@"请输入验证码" andRightClearButton:NO andShowPasswordButton:NO isNumberKeyboard:YES haveVerificationCode:YES];
        
    }
    return _verificationCode;
}

-(UIButton *)nextButton
{
    if(!_nextButton)
    {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        _nextButton.backgroundColor = MainColor;
        [_nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.cornerRadius = 3;
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:18.5];
        
    }
    return _nextButton;
}


-(void)nextButtonAction:(UIButton *)sender
{
    FindPasswordViewController *FPVC = [FindPasswordViewController new];
    [self.navigationController pushViewController:FPVC animated:YES];
    MyLog(@"下一步");
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
