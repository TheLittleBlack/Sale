//
//  LoginViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/4.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ScheduleViewController.h"
#import "MineViewController.h"
#import "LoginTextFieldView.h"
#import "ForgetPasswordViewController.h"
#import "PhoneNumberLoginViewController.h"


@interface LoginViewController ()<LoginTextFieldViewDelegate>

@property(nonatomic,strong)UITabBarController *tabBarController;
@property(nonatomic,strong)UIImageView *logoImageView;
@property(nonatomic,strong)LoginTextFieldView *usernameTF;
@property(nonatomic,strong)LoginTextFieldView *passwordTF;
@property(nonatomic,strong)UIButton *loginButton;
@property(nonatomic,strong)UIButton *phoneLogin;
@property(nonatomic,strong)UIButton *forgetPassword;

@end

@implementation LoginViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(80);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(75);
        
    }];
    
    [self.view addSubview:self.usernameTF];
    [self.usernameTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.logoImageView.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(38);
        make.right.equalTo(self.view).offset(-38);
        make.height.mas_equalTo(64);
        
    }];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    if(username)
    {
        self.usernameTF.textField.text = username;
    }
    
    

    
    [self.view addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.height.and.left.equalTo(self.usernameTF);
        make.top.equalTo(self.usernameTF.mas_bottom).offset(15);
        
    }];
    
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    if(password)
    {
        self.passwordTF.textField.text = password;
    }
    
    
    
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.width.equalTo(self.usernameTF);
        make.top.equalTo(self.passwordTF.mas_bottom).offset(25);
        make.height.mas_equalTo(44);
        
    }];
    
    
    // 暂时隐藏 =>  手机登录、忘记密码功能
    
//    CGSize phoneLoginButtonSize = [self.phoneLogin.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.phoneLogin.titleLabel.font}];
//    [self.view addSubview:self.phoneLogin];
//    [self.phoneLogin mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.loginButton);
//        make.top.equalTo(self.loginButton.mas_bottom).offset(30);
//        make.width.mas_equalTo(phoneLoginButtonSize.width+10);
//        make.height.mas_equalTo(phoneLoginButtonSize.height+4);
//
//    }];
//
//    [self.view addSubview:self.forgetPassword];
//    [self.forgetPassword mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.and.height.width.equalTo(self.phoneLogin);
//        make.right.equalTo(self.loginButton);
//
//    }];
    
    
    
   

    
    
    
    

}

-(UIImageView *)logoImageView
{
    if(!_logoImageView)
    {
        _logoImageView = [UIImageView new];
        _logoImageView.backgroundColor = [UIColor whiteColor];
        _logoImageView.image = [UIImage imageNamed:@"loginIcon"];
    }
    return _logoImageView;
}

-(LoginTextFieldView *)usernameTF
{
    if(!_usernameTF)
    {
        _usernameTF = [[LoginTextFieldView alloc]initWithFrame:CGRectZero andTitleString:@"用户名 / 手机号码" andPlaceholderString:@"请输入账号" andRightClearButton:YES andShowPasswordButton:NO isNumberKeyboard:NO haveVerificationCode:NO];
    }
    return _usernameTF;
}

-(LoginTextFieldView *)passwordTF
{
    if(!_passwordTF)
    {
        _passwordTF = [[LoginTextFieldView alloc]initWithFrame:CGRectZero andTitleString:@"密码" andPlaceholderString:@"请输入密码" andRightClearButton:NO andShowPasswordButton:YES isNumberKeyboard:NO haveVerificationCode:NO];
        _passwordTF.delegate = self;
        
    }
    return _passwordTF;
}

-(UIButton *)loginButton
{
    if(!_loginButton)
    {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.backgroundColor = MainColor;
        [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 3;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:18.5];
        
    }
    return _loginButton;
}

-(UIButton *)phoneLogin
{
    if(!_phoneLogin)
    {
        _phoneLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneLogin setTitle:@"手机验证登录" forState:UIControlStateNormal];
        _phoneLogin.titleLabel.font = [UIFont systemFontOfSize:13.5];
        _phoneLogin.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_phoneLogin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_phoneLogin addTarget:self action:@selector(phoneLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneLogin;
}

-(UIButton *)forgetPassword
{
    if(!_forgetPassword)
    {
        _forgetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forgetPassword.titleLabel.font = [UIFont systemFontOfSize:13];
        _forgetPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_forgetPassword setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_forgetPassword addTarget:self action:@selector(forgetPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _forgetPassword;
}

-(void)loginAction:(UIButton *)sender
{
    
    [self.view endEditing:YES];
    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:LoginURL] withPrameters:@{@"passport":self.usernameTF.textField.text,@"password":self.passwordTF.textField.text} result:^(id result) {
            
            MyLog(@"登录成功");
        
            [MYManage defaultManager].token = result[@"token"];
            [[MYManage defaultManager] setDataWithDictionary:result[@"data"]];
            [[MYManage defaultManager] setUserInfoWithDictionary:result[@"userInfo"]];
            [[NSUserDefaults standardUserDefaults]setValue:self.usernameTF.textField.text forKey:@"username"];
            [[NSUserDefaults standardUserDefaults]setValue:self.passwordTF.textField.text forKey:@"password"];
            
            _tabBarController = [UITabBarController new];
            [_tabBarController.tabBar setTintColor:MainColor];
            
            [self creatViewControllerView:[HomeViewController new] andTitle:@"首页" andImage:@"icon_home" andSelectedImage:@"icon_home01"];
            [self creatViewControllerView:[MessageViewController new] andTitle:@"消息" andImage:@"icon_xiaoxi" andSelectedImage:@"icon_xiaoxi01"];
            [self creatViewControllerView:[ScheduleViewController new] andTitle:@"日程" andImage:@"icon_richeng" andSelectedImage:@"icon_richeng01"];
            [self creatViewControllerView:[MineViewController new] andTitle:@"我的" andImage:@"icon_wo" andSelectedImage:@"icon_wo01"];
        
            // 设置cookie
            [self setCookie:result[@"token"]];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = self.tabBarController;
            
       
        

    } error:^(id error) {
        MyLog(@"%@",error);
    } withHUD:YES];



    
    
}

- (void)setCookie:(NSString *)token{
    
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"ASESSIONID" forKey:NSHTTPCookieName];
    [cookieProperties setObject:token forKey:NSHTTPCookieValue];
    [cookieProperties setObject:WebMainURL forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:60*60*24] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
}


-(void)phoneLoginAction:(UIButton *)sender
{
    MyLog(@"手机验证登录");
    PhoneNumberLoginViewController *PNVC = [PhoneNumberLoginViewController new];
    [self.navigationController pushViewController:PNVC animated:YES];
}

-(void)forgetPasswordAction:(UIButton *)sender
{
    MyLog(@"忘记密码");
    ForgetPasswordViewController *FPVC = [ForgetPasswordViewController new];
    [self.navigationController pushViewController:FPVC animated:YES];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end
