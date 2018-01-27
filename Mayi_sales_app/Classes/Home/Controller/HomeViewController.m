//
//  HomeViewController.m
//  King's Luck
//
//  Created by JayJay on 2017/12/3.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "HomeViewController.h"
#import "SDMajletView.h"
#import "BaseWebViewController.h"
#import "WorkLogViewController.h"
#import "TeamManageViewController.h"
#import "UITabBar+ShowTip.h"
#import "CustomerManagmentViewController.h"
#import "OrderManagementViewController.h"
#import "ApplyForViewController.h"
#import "ResultsQueryViewController.h"
#import "ActivitiesCheckViewController.h"
#import "UpdateViewController.h"
#define cellID @"CellID"

@interface HomeViewController ()<SDMajletViewDelegate>

{
    BOOL _ForcedUpdate;
    NSString *_ForcedUpdateURL;
    NSInteger _isfirst;
}

@property(nonatomic,strong)SDMajletView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UIButton *tipButton;
@property(nonatomic,strong)NSString *ForcedUpdateText;

@end

@implementation HomeViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(_ForcedUpdate && _isfirst>0) // 强制更新生效
    {
         [self ForcedUpdateWithURL:_ForcedUpdateURL]; // 无限循环
    }
    
    _isfirst ++; // 过滤第一次
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"今世缘";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isfirst = 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_guanli"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    
    self.collectionView = [[SDMajletView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-49) ];
    self.collectionView.inUseTitles = [NSMutableArray arrayWithArray:self.dataSource];
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.tipButton];
    [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
//        make.width.and.height.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight);
        make.width.mas_equalTo(ScreenWidth);
        
    }];
    
    
    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:UnreadMessageStatistics] withPrameters:@{} result:^(id result) {
        
        if([result[@"data"][@"data"][@"TOTAL"] integerValue]>0)
        {
            // 让消息界面显示小红点
            [self.tabBarController.tabBar showBadgeOnItemIndex:1];
            
            [MYManage defaultManager].NOTICE = [result[@"data"][@"data"][@"NOTICE"] integerValue];
            [MYManage defaultManager].SHARE = [result[@"data"][@"data"][@"SHARE"] integerValue];
            [MYManage defaultManager].DAIBAN = [result[@"data"][@"data"][@"DAIBAN"] integerValue];
            [MYManage defaultManager].EXAMINE = [result[@"data"][@"data"][@"EXAMINE"] integerValue];
            [MYManage defaultManager].WORK = [result[@"data"][@"data"][@"WORK"] integerValue];
            
        }

        
    } error:^(id error) {
        
    } withHUD:NO];
    
    
    // 向服务器发送token
    NSString *userID = [MYManage defaultManager].ID;
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"];
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:SubmitDeviceToken] withPrameters:@{@"deviceToken":deviceToken?deviceToken:@"",@"userId":userID,@"equipmentType":@"2"} result:^(id result) {
        
    } error:^(id error) {
        
    } withHUD:NO];
    

    [self checkUpdate];


    
}















-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        MyLog(@"%@",[MYManage defaultManager].userName);
        NSMutableDictionary *userInfo = [[NSUserDefaults standardUserDefaults] valueForKey:[MYManage defaultManager].passport];
        if(!userInfo)
        {
            
            NSArray *array = @[
                               @{@"iconName":@"icon_xianlu",@"title":@"线路拜访"},
                               @{@"iconName":@"icon_houdong",@"title":@"活动检查"},
                               @{@"iconName":@"icon_tuanguo",@"title":@"团购管理"},
                               @{@"iconName":@"icon_kehu",@"title":@"客户管理"},
                               @{@"iconName":@"icon_shenpi",@"title":@"协同审批"},
                               @{@"iconName":@"icon_dindan",@"title":@"订单管理"},
                               @{@"iconName":@"icon_yeji",@"title":@"业绩查询"},
                               @{@"iconName":@"icon_rizhi",@"title":@"工作日志"},
                               ];
            _dataSource = [NSMutableArray arrayWithArray:array];
            
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:@{@"homeIconSorting":array,@"GGTZlastTime":@"",@"SPSWlastTime":@"",@"ZSFXlastTime":@"",@"GZXXlastTime":@""}];
            [[NSUserDefaults standardUserDefaults] setValue:info forKey:[NSString stringWithFormat:@"%@",[MYManage defaultManager].passport]];
            MyLog(@"");
            
        }
        else
        {
            NSMutableArray *saveArray = userInfo[@"homeIconSorting"];
            if(saveArray.count>0)
            {
                _dataSource = [NSMutableArray arrayWithArray:saveArray];
            }
        }

  

        
    }
    return _dataSource;
}

-(void)rightBarButtonAction
{
    NSLog(@"提示");
    _tipButton.hidden = NO;
}

-(UIButton *)tipButton
{
    if(!_tipButton)
    {
        _tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tipButton setImage:[UIImage imageNamed:@"chaozouyingdan"] forState:UIControlStateNormal];
        [_tipButton addTarget:self action:@selector(tipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _tipButton.backgroundColor = [UIColor colorWithWhite:0/255.0 alpha:0.4];
        _tipButton.hidden = YES;
        _tipButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, ScreenHeight-ScreenWidth, 0);
    }
    return _tipButton;
}

-(void)tipButtonAction:(UIButton *)sender
{
    MyLog(@"隐藏");
    sender.hidden = YES;
}

#pragma mark SDMajletViewDelegate
-(void)newData:(NSMutableArray *)inUseTitles
{
    MyLog(@"%@",inUseTitles);
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:[MYManage defaultManager].passport]];
    
    [userInfo setValue:inUseTitles forKey:@"homeIconSorting"];
    [[NSUserDefaults standardUserDefaults] setValue:userInfo forKey:[MYManage defaultManager].passport];
    self.dataSource = inUseTitles;
}

-(void)selectItem:(NSIndexPath *)indexPath
{
    NSString *selectItemName = [self.dataSource[indexPath.row] objectForKey:@"title"];
    MyLog(@"%@",selectItemName);
    
    
    if([selectItemName isEqualToString:@"团购管理"])
    {
        
        TeamManageViewController *TMVC = [TeamManageViewController new];
        TMVC.urlString = [MayiURLManage MayiWebURLManageWithURL:TeamManage];
        [TMVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:TMVC animated:YES];
    }
    else if([selectItemName isEqualToString:@"线路拜访"])
    {

        self.tabBarController.selectedIndex = 2;
        
    }
    else if([selectItemName isEqualToString:@"工作日志"])
    {
        WorkLogViewController * WLVC = [WorkLogViewController new];
        WLVC.urlString = [MayiURLManage MayiWebURLManageWithURL:WorkLog];
        [WLVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:WLVC animated:YES];
    }
    else if([selectItemName isEqualToString:@"活动检查"])
    {
        
//        ActivitiesCheckViewController * ACVC = [ActivitiesCheckViewController new];
//        ACVC.urlString = [MayiURLManage MayiWebURLManageWithURL:ActivitiesCheck];
//        [ACVC setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:ACVC animated:YES];
        [Hud showText:@"敬请期待"]; // 没接口
    }
    else if([selectItemName isEqualToString:@"客户管理"])
    {
        CustomerManagmentViewController *CMVC = [CustomerManagmentViewController new];
        CMVC.urlString = [MayiURLManage MayiWebURLManageWithURL:CustomerManagement];
        [CMVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:CMVC animated:YES];
        
    }
    else if([selectItemName isEqualToString:@"协同审批"])
    {
        
        ApplyForViewController *AFVC = [ApplyForViewController new];
        AFVC.urlString = [MayiURLManage MayiWebURLManageWithURL:CollaborativeApproval];
        [AFVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:AFVC animated:YES];
//        [Hud showText:@"协同审批"]; // 没接口
   
    }
    else if([selectItemName isEqualToString:@"订单管理"])
    {
        
        OrderManagementViewController *OMVC = [OrderManagementViewController new];
        OMVC.urlString = [MayiURLManage MayiWebURLManageWithURL:OrderManagement];
        [OMVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:OMVC animated:YES];
    }
    else if([selectItemName isEqualToString:@"业绩查询"])
    {
//        ResultsQueryViewController *RQVC = [ResultsQueryViewController new];
//        RQVC.urlString = [MayiURLManage MayiWebURLManageWithURL:OrderManagement];
//        [RQVC setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:RQVC animated:YES];
        [Hud showText:@"敬请期待"]; // 没接口
    }

    



    
    
}



#pragma mark

///判断是否需要更新
-(NSInteger )CompareTheVersionWithLatestVersion:(NSString *)latestVer andMustUpdatedVer:(NSString *)mustUpdatedVer
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 获取当前版本
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    MyLog(@"当前版本号:%@",appCurVersion);
    
    NSInteger curVer = [[appCurVersion stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
    
    NSInteger latVer = [[latestVer stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
    
    NSInteger mustVer = [[mustUpdatedVer stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
    
    if(curVer<mustVer)
    {
        MyLog(@"需要强制更新");
        return 2;
    }
    
    if(latVer>curVer)
    {
        MyLog(@"需要更新版本");
        
        return 1;
    }
    
    MyLog(@"已是最新版本");
    
    return 0;
    
}


-(void)checkUpdate
{
   
    // 检测更新
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:CheckUpdate] withPrameters:@{} result:^(id result) {
        

            
            NSDictionary *dic = result[@"data"];
            //最新版本
            NSString *ver = [NSString stringWithFormat:@"%@",dic[@"lastVer"]];
            //更新内容
            NSString *updateContent = dic[@"updateContent"];
            //低于此版本需要强制更新
            NSString *mustUpdatedVer = [NSString stringWithFormat:@"%@",dic[@"mustUpdatedVer"]];
            
            NSInteger compareResults = [self CompareTheVersionWithLatestVersion:ver andMustUpdatedVer:mustUpdatedVer];
            
            // 0 代表无需更新 1 代表需要更新 2 代表需要强制更新
            
            if(compareResults==1)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新提示" message:updateContent preferredStyle:UIAlertControllerStyleAlert];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    UpdateViewController * UVC = [UpdateViewController new];
                    UVC.urlString = dic[@"url"];
                    [UVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:UVC animated:YES];
                    
//                    NSString  *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",APPID];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                    
                    
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"下次" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [self presentViewController:alert animated:YES completion:^{
                }];
                
            }
            else if (compareResults==2)
            {
                _ForcedUpdate = YES;
                _ForcedUpdateURL = dic[@"url"];
                self.ForcedUpdateText = updateContent;
                [self ForcedUpdateWithURL:dic[@"url"]];
                
            }
            else
            {
                MyLog(@"已是最新版本");
            }
            
            
        
        
        
    } error:^(id error) {
        
    } withHUD:NO];
    
}

//强制更新
-(void)ForcedUpdateWithURL:(NSString *)url
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"更新提示" message:self.ForcedUpdateText preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        

        UpdateViewController * UVC = [UpdateViewController new];
        UVC.urlString = url;
        [UVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:UVC animated:YES];
        
//        [self ForcedUpdateWithURL:url]; 无限循环
        
    }]];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}



@end
