//
//  BaseWebViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/16.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "BaseWebViewController.h"
#import "LoginViewController.h"

@interface BaseWebViewController () <UIWebViewDelegate>


@property(nonatomic,strong)UIView *stateView;

@end

@implementation BaseWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [self.webView reload];
//}

-(instancetype)init
{
    if(self = [super init])
    {
        _autoManageBack = YES; // 设置默认值
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [Hud showLoading];
    self.view.backgroundColor = [UIColor whiteColor];
    MyLog(@"%@",self.urlString);
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    
    
    [self.view addSubview:self.webView];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.mas_equalTo(0);
        
    }];
    
    [self.view addSubview:self.stateView];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.view).offset(0);
        
    }];
    
    
    
}


-(UIView *)stateView
{
    if(!_stateView)
    {
        _stateView = [UIView new];
        _stateView.backgroundColor = [UIColor whiteColor];
    }
    return _stateView;
}


-(UIWebView *)webView
{
    if(!_webView)
    {
        _webView = [UIWebView new];
        _webView.scalesPageToFit = YES;
        _webView.userInteractionEnabled = YES;
        _webView.delegate = self;
        NSURL *url = [NSURL URLWithString:_urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
        [_webView loadRequest:request];
    }
    return _webView;
}

#pragma mark <UIWebViewDelegate>

//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.navigationController.navigationBar.hidden = YES;
    MyLog(@"开始加载");
    
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    MyLog(@"加载完成");
    self.navigationController.navigationBar.hidden = YES;
    [Hud stop];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *URL = request.URL;
    MyLog(@"请求的URL：%@",URL);
    
    NSArray *urlArray = [[NSString stringWithFormat:@"%@",URL] componentsSeparatedByString:@"."];
    NSString *actionType = urlArray.lastObject;
    MyLog(@"点击事件类型：%@",actionType);
    [self urlActionType:actionType];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",URL];
    NSString *lastStr = [urlStr substringWithRange:NSMakeRange(urlStr.length-4, 4)];
    
    // 自动返回
    if ([lastStr isEqualToString:@"Back"]&&self.autoManageBack) {
        if(self.webView.canGoBack) // 如果能返回上一级
        {
            [self.webView goBack];
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];  // 不能则pop回去
        }
        
        return NO;
    }
    else if ([actionType isEqualToString:@"goBack"]) // 不自动管理，也要拦截掉该事件防止报错
    {
        return NO;
    }
    else if([actionType isEqualToString:@"timeout"])
    {
        // 登录过期
        LoginViewController *LVC = [LoginViewController new];
        [self presentViewController:LVC animated:YES completion:^{

            [Hud showText:@"登录信息过期，请重新登录" withTime:2];
            
        }];
    }
    else if ([actionType isEqualToString:@"toAddDailyWork"]) // 添加工作日志
    {
        return NO;
    }
    else if ([actionType isEqualToString:@"toSign"]) // 签到
    {
        return NO;
    }
    else if([actionType isEqualToString:@"toPhoto"]) // 拍照
    {
        return NO;
    }
    else if([actionType isEqualToString:@"toReturnMenu"]) // 返回
    {
        return NO;
    }
    return YES;
}




- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    MyLog(@"web加载出错：%@",[error localizedDescription]);
    self.navigationController.navigationBar.hidden = NO;
    [Hud stop];
    [Hud showText:@"网络错误"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)urlActionType:(NSString *)actionString
{
    
}


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
