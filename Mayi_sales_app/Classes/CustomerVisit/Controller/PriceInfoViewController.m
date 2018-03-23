//
//  PriceInfoViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/3/22.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "PriceInfoViewController.h"

@interface PriceInfoViewController ()

@end

@implementation PriceInfoViewController

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
