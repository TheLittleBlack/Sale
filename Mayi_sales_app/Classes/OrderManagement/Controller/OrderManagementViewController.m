//
//  OrderManagementViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/24.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "OrderManagementViewController.h"

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



-(void)requestUrl:(NSString *)url
{
    if([url containsString:@"mobile.orderManager.goBack"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
