//
//  AddTaskViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/3/22.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "AddTaskViewController.h"

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
}

-(void)requestUrl:(NSString *)url
{
    if([url containsString:@"mayisale://mobile.task.manage.goBack"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
