//
//  MessageDetailsWebViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/1/11.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "MessageDetailsWebViewController.h"

@interface MessageDetailsWebViewController ()

@end

@implementation MessageDetailsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}


-(void)urlActionType:(NSString *)actionString
{
    if([actionString isEqualToString:@"goBack"])
    {

        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}
@end
