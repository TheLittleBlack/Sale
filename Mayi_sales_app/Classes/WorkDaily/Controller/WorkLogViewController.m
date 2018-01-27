//
//  WorkLogViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/16.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "WorkLogViewController.h"
#import "AddNewWorkDailyViewController.h"

@interface WorkLogViewController ()

{
    BOOL firstRefresh; // 是否是第一次刷新
}

@end

@implementation WorkLogViewController


-(void)viewDidAppear:(BOOL)animated
{
    if(!firstRefresh)
    {
        [self.webView reload];
        
    }
    
    firstRefresh = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    firstRefresh = YES;
    
    
}

-(void)urlActionType:(NSString *)actionString
{
    if([actionString isEqualToString:@"toAddDailyWork"])
    {
        AddNewWorkDailyViewController *ANDVC =[AddNewWorkDailyViewController new];
        UINavigationController *NVC =[[UINavigationController alloc]initWithRootViewController:ANDVC];
        [self presentViewController:NVC animated:YES completion:^{
            
        }];
        
    }
    
    
}


@end
