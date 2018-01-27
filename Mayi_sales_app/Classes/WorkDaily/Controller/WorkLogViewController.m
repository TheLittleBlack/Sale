//
//  WorkLogViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/16.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "WorkLogViewController.h"

@interface WorkLogViewController ()

@end

@implementation WorkLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    
}

-(void)urlActionType:(NSString *)actionString
{
    if([actionString isEqualToString:@"goBack"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}


@end
