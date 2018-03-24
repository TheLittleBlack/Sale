//
//  BaseWebViewController.h
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/16.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface BaseWebViewController : UIViewController

@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,copy)NSString *urlString;
@property(nonatomic,assign)BOOL autoManageBack ; // 是否自动监听返回事件 默认为Yes
@property(nonatomic,strong)JSContext *context;

-(void)urlActionType:(NSString *)actionString; // 通过该方法将点击类型丢给子类实现
-(void)requestUrl:(NSString *)url;  // 调用到的url全路径


@end
