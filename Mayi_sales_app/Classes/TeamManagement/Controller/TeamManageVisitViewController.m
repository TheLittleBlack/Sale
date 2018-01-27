//
//  TeamManageVisitViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/1/4.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "TeamManageVisitViewController.h"
#import "SignInViewController.h"

@interface TeamManageVisitViewController ()

@end

@implementation TeamManageVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


-(void)urlActionType:(NSString *)actionString
{

    if([actionString isEqualToString:@"toSign"])
    {

        SignInViewController *SVC = [SignInViewController new];
        SVC.visitID = self.visitID;
        SVC.type = 2;
        SVC.businessKey = self.businessKey;
        [self.navigationController pushViewController:SVC animated:YES];
        
    }
    
    
}

@end
