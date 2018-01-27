//
//  OrderViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/1/8.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)urlActionType:(NSString *)actionString
{
    if([actionString isEqualToString:@"goBack"])
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}

@end
