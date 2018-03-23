//
//  MessageBaseTableViewCell.h
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/10.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageBaseTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UIView *bodyView;
@property(nonatomic,strong)UIImageView *headerImageView;
@property(nonatomic,strong)UILabel *headerTitleLabel;
@property(nonatomic,strong)UILabel *bodyTextLabel;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *date;
@property(nonatomic,strong)UIView *isReadView;
@property(nonatomic,strong)UILabel *state;

@end
