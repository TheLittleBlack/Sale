//
//  CustomerOtherTableViewCell.h
//  Mayi_sales_app
//
//  Created by JayJay on 2018/1/2.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerOtherTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *finishLabel; // 完成标记
@property(nonatomic,strong)UIImageView *gotoImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIView *underLineView;
@property(nonatomic,strong)UIImageView *finishImageView; // 完成情况icon

@end
