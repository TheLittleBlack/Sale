//
//  ResetPasswordViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/24.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

-(void)urlActionType:(NSString *)actionString
{
    if([actionString isEqualToString:@"resetPasswordSuccess"])
    {
        // 修改成功
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Hud showText:@"修改密码成功" withTime:2];
    }
    
    
}



@end
