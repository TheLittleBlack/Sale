
//
//  PhoneNumberLoginViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/9.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "PhoneNumberLoginViewController.h"
#import "LoginTextFieldView.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ScheduleViewController.h"
#import "MineViewController.h"

@interface PhoneNumberLoginViewController ()

@property(nonatomic,strong)LoginTextFieldView *phoneNumber;
@property(nonatomic,strong)LoginTextFieldView *verificationCode;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,strong)UITabBarController *tabBarController;

@end

@implementation PhoneNumberLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"手机验证登录";
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
        _phoneNumber = [[LoginTextFieldView alloc]initWithFrame:CGRectZero andTitleString:@"手机号码" andPlaceholderString:@"请输入手机号码" andRightClearButton:YES andShowPasswordButton:NO isNumberKeyboard:YES haveVerificationCode:NO];
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
        [_nextButton setTitle:@"登录" forState:UIControlStateNormal];
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
    MyLog(@"登录");
    
    [[NSUserDefaults standardUserDefaults]setValue:self.phoneNumber.textField.text forKey:@"username"];
    
    _tabBarController = [UITabBarController new];
    [_tabBarController.tabBar setTintColor:MainColor];
    
    [self creatViewControllerView:[HomeViewController new] andTitle:@"首页" andImage:@"icon_home" andSelectedImage:@"icon_home01"];
    [self creatViewControllerView:[MessageViewController new] andTitle:@"消息" andImage:@"icon_xiaoxi" andSelectedImage:@"icon_xiaoxi01"];
    [self creatViewControllerView:[ScheduleViewController new] andTitle:@"日程" andImage:@"icon_richeng" andSelectedImage:@"icon_richeng01"];
    [self creatViewControllerView:[MineViewController new]andTitle:@"我的" andImage:@"icon_wo" andSelectedImage:@"icon_wo01"];
    
    [UIApplication sharedApplication].keyWindow.rootViewController = self.tabBarController;
}


//创建视图控制器
-(void)creatViewControllerView:(UIViewController *)VC andTitle:(NSString *)titleString andImage:(NSString *)image andSelectedImage:(NSString *)selectedImage
{
    
    VC.tabBarItem.title = titleString;
    VC.tabBarItem.image =[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    VC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *NVC = [[UINavigationController alloc]initWithRootViewController:VC];
    [_tabBarController addChildViewController:NVC];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
