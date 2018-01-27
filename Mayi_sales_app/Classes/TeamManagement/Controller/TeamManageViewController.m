//
//  TeamManageViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/16.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "TeamManageViewController.h"
#import "SignInViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface TeamManageViewController ()

@property(nonatomic,strong)NSString *cloudId;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *type;

@end


@implementation TeamManageViewController

//-(void)viewDidAppear:(BOOL)animated
//{
//    [self.webView reload];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    MyLog(@"加载完成");
    [Hud stop];
    

    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 获取js调用的方法
    context[@"getVisitInfo"] = ^(){
        
        NSArray *args = [JSContext currentArguments];
        
        self.cloudId = [args[0] toString];
        self.userId = [args[1] toString];
        self.type = [args[2] toString];
        
    };
    

    
}


-(void)urlActionType:(NSString *)actionString
{

    
    if([actionString isEqualToString:@"toSign"])
    {
        
        SignInViewController *SVC = [SignInViewController new];
        SVC.visitID = self.cloudId;
        SVC.type = [self.type integerValue];
        SVC.businessKey = [self.cloudId integerValue];
        [self.navigationController pushViewController:SVC animated:YES];
        
    }
    
    
}


@end
