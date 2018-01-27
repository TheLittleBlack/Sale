//
//  SignInViewController.h
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/26.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import <UIKit/UIKit.h>

// 签到

@interface SignInViewController : UIViewController

@property(nonatomic,strong)NSString *visitID;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)NSInteger businessKey;
@property(nonatomic,assign)BOOL isFirst;
@property(nonatomic,strong)NSString *storeName;

@end
