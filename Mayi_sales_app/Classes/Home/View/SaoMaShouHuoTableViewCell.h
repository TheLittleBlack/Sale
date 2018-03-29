//
//  SaoMaShouHuoTableViewCell.h
//  Mayi_sales_app
//
//  Created by JayJay on 2018/3/21.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaoMaShouHuoTableViewCellDelegate <NSObject>

-(void)lookButtonWidthIndex:(NSInteger)index;

@end

@interface SaoMaShouHuoTableViewCell : UITableViewCell

@property(nonatomic,weak)id <SaoMaShouHuoTableViewCellDelegate> delegate;
@property(nonatomic,strong)UIImageView *logoImageView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *boxNumberLabel;
@property(nonatomic,strong)UIButton *LookBoxButton;
@property(nonatomic,strong)UILabel *yiSaoMiaoLabel;
@property(nonatomic,strong)UILabel *gongJiXiangLabel;
@property(nonatomic,strong)UILabel *shaoJiXiangLabel;
@property(nonatomic,assign)NSInteger number;  // 一共扫了几箱
@property(nonatomic,strong)NSString *boxNumber;  //箱码
@property(nonatomic,assign)NSInteger index;

@end
