//
//  BaseWebViewController.h
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/16.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseWebViewController : UIViewController

@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,copy)NSString *urlString;
@property(nonatomic,assign)BOOL autoManageBack ; // 是否自动监听返回事件 默认为Yes

-(void)urlActionType:(NSString *)actionString; // 通过该方法将点击类型丢给子类实现

@end
