
//
//  AboutUSViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/13.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "AboutUSViewController.h"

@interface AboutUSViewController ()

@property(nonatomic,strong)UILabel *companyName;
@property(nonatomic,strong)UIImageView *logoImage;
@property(nonatomic,strong)UILabel *versionInfo;
@property(nonatomic,strong)UILabel *URLaddress;
@property(nonatomic,strong)UILabel *address;

@end

@implementation AboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];

    
    [self.view addSubview:self.logoImage];
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.and.height.mas_equalTo(100);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(64+10);
        
    }];


    [self.view addSubview:self.companyName];
    [self.companyName mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.logoImage.mas_bottom).offset(5);

    }];

    [self.view addSubview:self.versionInfo];
    [self.versionInfo mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.view).offset(60);
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(self.companyName.mas_bottom).offset(30);

    }];

    [self.view addSubview:self.URLaddress];
    [self.URLaddress mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.and.left.equalTo(self.versionInfo);
        make.top.equalTo(self.versionInfo.mas_bottom).offset(15);

    }];

    [self.view addSubview:self.address];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.and.left.equalTo(self.versionInfo);
        make.top.equalTo(self.URLaddress.mas_bottom).offset(15);

    }];

}

-(UILabel *)companyName
{
    if(!_companyName)
    {
        _companyName = [UILabel new];
        _companyName.font = [UIFont systemFontOfSize:15];
        _companyName.textColor = [UIColor blackColor];
        _companyName.numberOfLines = 0;
        _companyName.text = @"上海小工蚁电子商务有限公司";
        _companyName.textAlignment = NSTextAlignmentCenter;

    }
    return _companyName;
}

-(UILabel *)versionInfo
{
    if(!_versionInfo)
    {
        _versionInfo = [UILabel new];
        _versionInfo.font = [UIFont systemFontOfSize:17];
        _versionInfo.textColor = [UIColor blackColor];
        _versionInfo.numberOfLines = 0;
        _versionInfo.text = @"版本信息: V:0.0.6";
        
    }
    return _versionInfo;
}

-(UILabel *)URLaddress
{
    if(!_URLaddress)
    {
        _URLaddress = [UILabel new];
        _URLaddress.font = [UIFont systemFontOfSize:17];
        _URLaddress.textColor = [UIColor blackColor];
        _URLaddress.numberOfLines = 0;
        _URLaddress.text = @"网站地址: http://www.mayi888.com";
        
    }
    return _URLaddress;
}

-(UILabel *)address
{
    if(!_address)
    {
        _address = [UILabel new];
        _address.font = [UIFont systemFontOfSize:17];
        _address.textColor = [UIColor blackColor];
        _address.numberOfLines = 0;
        _address.text = @"联系地址: 上海市普陀区怒江北路399号";
        
    }
    return _address;
}

-(UIImageView *)logoImage
{
    if(!_logoImage)
    {
        _logoImage = [UIImageView new];
        _logoImage.image = [UIImage imageNamed:@"ant_logo"];
    }
    return _logoImage;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
