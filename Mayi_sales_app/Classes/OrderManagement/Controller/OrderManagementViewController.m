//
//  OrderManagementViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/24.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "OrderManagementViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LoginViewController.h"

@interface OrderManagementViewController ()

@end

@implementation OrderManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
}

-(void)urlActionType:(NSString *)actionString
{
    
    if([actionString isEqualToString:@""])
    {
        
        
        
    }
    
    
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 获取js调用的方法
    context[@"callPhone"] = ^(){
        
        NSArray *args = [JSContext currentArguments];
        
        NSString *phoneNumber = [args[0] toString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIWebView *callWebView = [[UIWebView alloc] init];
            NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
            [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
            [self.view addSubview:callWebView];
        });
    };
    
    
    
    NSURL *URL = request.URL;
    NSString *urlStr = [NSString stringWithFormat:@"%@",URL];
    MyLog(@"请求的URL：%@",urlStr);
    
    if([urlStr containsString:@"mobile.orderManager.goBack"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    NSArray *urlArray = [[NSString stringWithFormat:@"%@",URL] componentsSeparatedByString:@"."];
    NSString *actionType = urlArray.lastObject;
    MyLog(@"点击事件类型：%@",actionType);
    
    
    NSString *lastStr = [urlStr substringWithRange:NSMakeRange(urlStr.length-4, 4)];
    
    // 自动返回
    if ([lastStr isEqualToString:@"Back"]&&self.autoManageBack) {
        
        if([urlStr containsString:@"approvalList.goBack"]) // 特殊情况，这个需要直接pop回去而不是goback
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
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




-(void)requestUrl:(NSString *)url
{

}


@end
