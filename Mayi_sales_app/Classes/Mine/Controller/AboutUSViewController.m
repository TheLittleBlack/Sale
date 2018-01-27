
//
//  AboutUSViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/13.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "AboutUSViewController.h"

@interface AboutUSViewController ()

@property(nonatomic,strong)UILabel *label;

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
   
    NSString *labelText = @"帮助企业重新理解互联网战略，结合中国独特的商业环境，提供最合适的互联网技术解决方案，实现线上线下物流结合的新零售。";
    self.label.text = labelText;
//    CGSize Size = [labelText sizeWithAttributes:@{NSFontAttributeName : self.label.font}];
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(64+15);
        make.right.equalTo(self.view).offset(-15);
//        make.height.mas_equalTo(Size.height+8);
        
    }];
    
    [self.label sizeToFit];
    
    
    

}

-(UILabel *)label
{
    if(!_label)
    {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = [UIColor blackColor];
        _label.numberOfLines = 0;

    }
    return _label;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
