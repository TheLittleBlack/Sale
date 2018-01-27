//
//  MineViewController.m
//  KingsLuck
//
//  Created by JayJay on 2017/12/3.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "BaseWebViewController.h"
#import "AboutUSViewController.h"
#import "ResetPasswordViewController.h"
#define CellID @"cellID"
#define HeaderViewHeight 166
#define PersonageIconSize 60

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UIImageView *headerImageView; // 头部图片
@property(nonatomic,strong)UIView *CustomTitleView; // 模拟navigation Title
@property(nonatomic,strong)UILabel *CustomTitleLabel;
@property(nonatomic,strong)UIView *PersonageContentView; // 用户信息View
@property(nonatomic,strong)UIImageView *PersonageIcon;  // 用户头像
@property(nonatomic,strong)UIImageView *PersonageRightButton; // 更多信息按钮
@property(nonatomic,strong)UILabel *Username;
@property(nonatomic,strong)UILabel *PhoneNumber;
@property(nonatomic,strong)UIButton *PersonageRightButtonReal; // 覆盖在箭头上面的透明按钮

@end

@implementation MineViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
  
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.and.top.equalTo(self.view);
        make.height.mas_equalTo(HeaderViewHeight);
        
    }];
    
    [self.headerImageView addSubview:self.CustomTitleView];
    [self.CustomTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.equalTo(self.headerImageView);
        make.top.equalTo(self.headerImageView).with.offset(20);
        make.height.mas_equalTo(44);
        
    }];
    
    [self.CustomTitleView addSubview:self.CustomTitleLabel];
    [self.CustomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.and.top.and.height.equalTo(self.CustomTitleView);
        
    }];
    
    [self.headerImageView addSubview:self.PersonageContentView];
    [self.PersonageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.and.right.and.bottom.equalTo(self.headerImageView);
        make.height.mas_equalTo(HeaderViewHeight-64);
        
    }];
    
    [self.PersonageContentView addSubview:self.PersonageIcon];
    [self.PersonageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.height.mas_equalTo(PersonageIconSize);
        make.left.equalTo(self.PersonageContentView).offset(15);
        make.centerY.equalTo(self.PersonageContentView);
        
    }];
    
    [self.PersonageContentView addSubview:self.PersonageRightButton];
    [self.PersonageRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.height.mas_equalTo(20);
        make.right.equalTo(self.PersonageContentView).offset(-10);
        make.centerY.equalTo(self.PersonageContentView);
        
    }];
    
    [self.PersonageContentView addSubview:self.Username];
    [self.Username mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.PersonageIcon.mas_right).offset(20);
        make.right.equalTo(self.PersonageRightButton.mas_left).offset(-15);
        make.top.equalTo(self.PersonageIcon).offset(8);
        make.height.mas_equalTo(PersonageIconSize/3.2);
        
    }];
    
    [self.PersonageContentView addSubview:self.PhoneNumber];
    [self.PhoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.PersonageIcon.mas_right).offset(20);
        make.right.equalTo(self.PersonageRightButton.mas_left).offset(-15);
        make.bottom.equalTo(self.PersonageIcon.mas_bottom).offset(-8);
        make.height.mas_equalTo(PersonageIconSize/3.2);
        
    }];
    
    [self.PersonageContentView addSubview:self.PersonageRightButtonReal];
    [self.PersonageRightButtonReal mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.height.mas_equalTo(PersonageIconSize);
        make.right.equalTo(self.PersonageContentView);
        make.top.equalTo(self.PersonageIcon.mas_top);
        
    }];

    
    [self.view addSubview:self.tableView];

    
}

-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HeaderViewHeight, ScreenWidth, ScreenHeight-49-HeaderViewHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellID];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorInset = UIEdgeInsetsZero;

    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        NSArray *array = @[
                           @"修改密码",
                           @"关于我们",
                           @"退出登录",
                           ];
        _dataSource = [NSMutableArray arrayWithArray:array];
    }
    return _dataSource;
}

-(UIImageView *)headerImageView
{
    if(!_headerImageView)
    {
        _headerImageView = [UIImageView new];
        _headerImageView.image = [UIImage imageNamed:@"gerenbaijing"];
        _headerImageView.userInteractionEnabled = YES;
    }
    return _headerImageView;
}



-(UIView *)CustomTitleView
{
    if(!_CustomTitleView)
    {
        _CustomTitleView = [UIView new];
    }
    return _CustomTitleView;
}

-(UILabel *)CustomTitleLabel
{
    if(!_CustomTitleLabel)
    {
        _CustomTitleLabel = [UILabel new];
        _CustomTitleLabel.textAlignment = NSTextAlignmentCenter;
        _CustomTitleLabel.textColor = [UIColor whiteColor];
        _CustomTitleLabel.font = [UIFont systemFontOfSize:16];
        _CustomTitleLabel.text = @"我的";
    }
    return _CustomTitleLabel;
}

-(UIView *)PersonageContentView
{
    if(!_PersonageContentView)
    {
        _PersonageContentView = [UIView new];
    }
    return _PersonageContentView;
}

-(UIImageView *)PersonageIcon
{
    if(!_PersonageIcon)
    {
        _PersonageIcon = [UIImageView new];
        _PersonageIcon.image = [UIImage imageNamed:@"fangxiao_logo_"];
        _PersonageIcon.layer.masksToBounds = YES;
        _PersonageIcon.layer.cornerRadius = PersonageIconSize/2;
    }
    return _PersonageIcon;
}

-(UIImageView *)PersonageRightButton
{
    if(!_PersonageRightButton)
    {
        _PersonageRightButton = [UIImageView new];
        _PersonageRightButton.image = [UIImage imageNamed:@"icon_jiantou14 bai"];
    }
    return _PersonageRightButton;
}

-(UILabel *)Username
{
    if(!_Username)
    {
        NSString *userName = [MYManage defaultManager].userName;
        _Username = [UILabel new];
        _Username.text = userName;
        _Username.textColor = [UIColor whiteColor];
        _Username.font = [UIFont systemFontOfSize:16];
        _Username.textAlignment = NSTextAlignmentLeft;
        
    }
    return _Username;
}

-(UILabel *)PhoneNumber
{
    if(!_PhoneNumber)
    {
        NSString *mobile = [MYManage defaultManager].mobile;
        _PhoneNumber = [UILabel new];
        _PhoneNumber.text = mobile;
        _PhoneNumber.textColor = [UIColor whiteColor];
        _PhoneNumber.font = [UIFont systemFontOfSize:14];
        _PhoneNumber.textAlignment = NSTextAlignmentLeft;
    }
    return _PhoneNumber;
}

-(UIButton *)PersonageRightButtonReal
{
    if(!_PersonageRightButtonReal)
    {
        _PersonageRightButtonReal = [UIButton buttonWithType:UIButtonTypeCustom];
        [_PersonageRightButtonReal addTarget:self action:@selector(moreData:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PersonageRightButtonReal;
}

-(void)moreData:(UIButton *)sender
{
    BaseWebViewController *web = [BaseWebViewController new];
    web.urlString = [MayiURLManage MayiWebURLManageWithURL:PersonCenter];
    [web setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:web animated:YES];
    NSLog(@"更多详情");
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.dataSource[indexPath.section];
    if(indexPath.section==2)
    {
      cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==2)
    {
        return 18;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        ResetPasswordViewController *web = [ResetPasswordViewController new];
        web.urlString = [MayiURLManage MayiWebURLManageWithURL:ChangePassword];
        [web setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:web animated:YES];
    }
    else if(indexPath.section==1)
    {
        AboutUSViewController *AUSCV = [AboutUSViewController new];
        [AUSCV setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:AUSCV animated:YES];
       
    }
    else if(indexPath.section==2)
    {
        

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您确定要退出吗" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:Logout] withPrameters:@{} result:^(id result) {
                MyLog(@"退出登录");
                LoginViewController *LVC = [LoginViewController new];
                UINavigationController *NVC = [[UINavigationController alloc]initWithRootViewController:LVC];
                [UIApplication sharedApplication].keyWindow.rootViewController = NVC;
            } error:^(id error) {
                
            } withHUD:YES];
            
        }]];
        
        
        // 为了不产生延时的现象，直接放在主线程中调用

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:alert animated:YES completion:^{
            }];
            
        });
        
 
        

    }
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

@end
