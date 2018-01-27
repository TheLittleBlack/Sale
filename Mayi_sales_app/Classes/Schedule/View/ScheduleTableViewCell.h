//
//  ScheduleTableViewCell.h
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/19.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScheduleTableViewCellDelegate <NSObject>

-(void)CellRightButtonAction:(UIButton *)sender andSelectID:(NSString *)visitID andBusinessKey:(NSInteger )businessKey andType:(NSInteger )type andStoreName:(NSString *)storeName;

@end

@interface ScheduleTableViewCell : UITableViewCell

@property(nonatomic,weak)id <ScheduleTableViewCellDelegate> delegate;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *myTitleLabel;
@property(nonatomic,strong)UILabel *myDescribeLabel;
@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)NSString *visitID;
@property(nonatomic,strong)UIImageView *finishImageView;
@property(nonatomic,assign)NSInteger businessKey;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)NSString *storeName;
@property(nonatomic,strong)UIView *topLine;

@end
