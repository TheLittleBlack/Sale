//
//  CustomerVisitViewController.h
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/21.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerVisitViewController : UIViewController

@property(nonatomic,strong)NSDictionary *visitData;
@property(nonatomic,strong)NSString *visitID;
@property(nonatomic,strong)NSString *storeName;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *AD; // 小地址

@end
