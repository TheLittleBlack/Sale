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

@end
