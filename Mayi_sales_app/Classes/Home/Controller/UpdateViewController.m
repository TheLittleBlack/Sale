//
//  UpdateViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/1/14.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "UpdateViewController.h"

@interface UpdateViewController ()

@end

@implementation UpdateViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.navigationController.navigationBar.hidden = NO;
    MyLog(@"开始加载");
    
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    MyLog(@"加载完成");
    self.navigationController.navigationBar.hidden = NO;
    [Hud stop];
    
}


@end
