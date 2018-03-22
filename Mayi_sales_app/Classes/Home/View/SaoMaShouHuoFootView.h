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
-(void)deleteAction;

@end


@interface SaoMaShouHuoFootView : UITableViewHeaderFooterView

@property(nonatomic,strong)UIButton *imageButton;
@property(nonatomic,strong)UIButton *deleteButton; // 删除按钮
@property(nonatomic,weak)id <SaoMaShouHuoFootViewDelegate> delegate;

@end

