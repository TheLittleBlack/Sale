//
//  SaoMaShouHuoFootView.h
//  Mayi_sales_app
//
//  Created by JayJay on 2018/3/21.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SaoMaShouHuoFootViewDelegate <NSObject>

-(void)takePhote;

@end


@interface SaoMaShouHuoFootView : UITableViewHeaderFooterView

@property(nonatomic,strong)UIButton *imageButton;
@property(nonatomic,weak)id <SaoMaShouHuoFootViewDelegate> delegate;

@end

