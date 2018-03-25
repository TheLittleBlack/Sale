//
//  PlanVisitViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/24.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "PlanVisitViewController.h"

@interface PlanVisitViewController ()

@end

@implementation PlanVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)urlActionType:(NSString *)actionString
{
    if([actionString isEqualToString:@"goBack"])
    {
        // 添加工作日报
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    MyLog(@"加载完成");
    [Hud stop];
    
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"scanCode"] = ^(){
        
        NSArray *args = [JSContext currentArguments];
        
        MyLog(@"%@",[args[0] toString]);
        
    };
    
}



@end
