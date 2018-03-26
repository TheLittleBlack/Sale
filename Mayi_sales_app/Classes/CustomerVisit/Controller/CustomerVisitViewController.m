//
//  CustomerVisitViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/21.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "CustomerVisitViewController.h"
#import "CustomerVisitFirstTableViewCell.h"
#import "VisitCaseViewController.h"
#import "PhotoViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "CustomerOtherTableViewCell.h"
#import "OrderViewController.h"
#import "NSString+URLEncoded.h"
#import "PriceInfoViewController.h"
#define FirstCell @"firstCell"
#define CellID @"cellID"

@interface CustomerVisitViewController ()<UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate,AMapSearchDelegate>

{
    BOOL _canlocation;
    NSInteger i;
    BOOL _photoFinish;
    BOOL _visitFinish;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,strong)NSString *updateStoreName;
@property(nonatomic,strong)NSString *updateAddress;
@property(nonatomic,strong)NSString *saveLogContent; // 保存拜访总结，用于查看
@property(nonatomic,strong)NSString *saveVisitPhoto; // 保存拜访总结的照片


@end

@implementation CustomerVisitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ImageCache"]; // 新进入此界面删除之前的缓存
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _canlocation = YES;
    i = 0;
    _photoFinish = NO;
    _visitFinish = NO;
 
    if(self.visitData && ![self.visitData[@"storeName"] isEqual:[NSNull null]] )
    {
        self.navigationItem.title = self.visitData[@"storeName"];
    }
    else if(self.storeName)
    {
        self.navigationItem.title = self.storeName;
    }
    else
    {
        self.navigationItem.title = @"拜访详情";
    }
    
    
    // 如果照片及拜访情况存在数据，则显示已完成状态，并赋值
    
    NSArray *photoInfos = self.visitData[@"photoInfos"];
    if(photoInfos&&photoInfos.count>0)
    {
        MyLog(@"");
        _photoFinish = YES;
    }

    
    NSDictionary *worklogDic = self.visitData[@"worklog"];
    if(![worklogDic isEqual:[NSNull null]])
    {
        MyLog(@"");
        _visitFinish = YES;
    }

    
    

    MyLog(@"============%@===========",self.visitData);

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
  
    [self.view addSubview:self.tableView];
    

    
    // 拜访照片添加成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VisitPhotoUploadSuccess:) name:@"VisitPhotoUploadSuccess" object:nil];
    // 拜访总结添加成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VisitConclusionSaveSuccess:) name:@"VisitConclusionSaveSuccess" object:nil];
    
    [self.mapView reloadMap];
    
    
    

    
    
}



-(MAMapView *)mapView
{
    if(!_mapView)
    {
        //初始化地图
        _mapView = [MAMapView new];
        [AMapServices sharedServices].enableHTTPS = NO;
        _mapView.zoomLevel = 16;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        [_mapView setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    return _mapView;
}

-(AMapSearchAPI *)search
{
    if(!_search)
    {
        _search = [AMapSearchAPI new];
        self.search.delegate = self;
    }
    return _search;
}


-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
        [_tableView registerClass:[CustomerOtherTableViewCell class] forCellReuseIdentifier:CellID];
        [_tableView registerClass:[CustomerVisitFirstTableViewCell class] forCellReuseIdentifier:FirstCell];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorInset = UIEdgeInsetsZero;
        
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
//        NSArray *array = @[
//                           @"定位",@"照片",@"陈列检查",@"价格信息",@"库存管理",@"市场秩序",@"订单执行",@"拜访情况"
//                           ];
        
        NSArray *array = @[
                           @"  定位",@"* 照片",@"  价格信息",@"  订单执行",@"* 拜访情况"
                           ];
        
        _dataSource = [NSMutableArray arrayWithArray:array];
        
        // 如果竞品信息的开关打开了
        if([MYManage defaultManager].isJPSJ)
        {
            [_dataSource addObject:@"* 竞品信息"];
        }
        
    }
    return _dataSource;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0)
    {
        
        CustomerVisitFirstTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:FirstCell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.storeName) // 存在则是刚刚签到跳转的
        {
            cell.titleLabel.text = self.AD;
            cell.describeLabel.text = self.address;
        }
        else // 否则则是点击继续任务进来的
        {
            NSDictionary *gps = self.visitData[@"gps"];
            cell.titleLabel.text = ![gps isEqual:[NSNull null]]?gps[@"address"]:@"";
            cell.describeLabel.text = ![gps isEqual:[NSNull null]]?gps[@"address"]:@"";
        }
        
        if(self.updateAddress&&self.updateStoreName)
        {
            cell.titleLabel.text = self.updateStoreName;
            cell.describeLabel.text = self.updateAddress;
        }

        return cell;
    }
    else
    {
        
        CustomerOtherTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = self.dataSource[indexPath.section];
        cell.titleLabel.textColor = [UIColor blackColor];
//        cell.finishLabel.hidden = YES;
        cell.finishImageView.image = [UIImage imageNamed:@"need_done_logo"];
        if(indexPath.section==1&&_photoFinish)
        {
//            cell.finishLabel.hidden = NO;
            cell.finishImageView.image = [UIImage imageNamed:@"over_logo"];
            cell.titleLabel.textColor = [UIColor colorWithWhite:180/255.0 alpha:1];
        }
        else if(indexPath.section==4&&_visitFinish)
        {
//            cell.finishLabel.hidden = NO;
            cell.finishImageView.image = [UIImage imageNamed:@"over_logo"];
            cell.titleLabel.textColor = [UIColor colorWithWhite:180/255.0 alpha:1];
        }
        return cell;
    }
    
    

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
            
            //定位功能可用
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否刷新签到位置？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"刷新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [Hud showLoading];
                _canlocation = YES;
                [self.mapView reloadMap];
                
                
            }]];
            
            
            // 为了不产生延时的现象，直接放在主线程中调用
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self presentViewController:alert animated:YES completion:^{
                }];
                
            });
            
            
        }else {
            
            //定位不能用
            
            [Hud showText:@"请打开定位功能"];
            
        }
        

        
        
        
        
      
    }
    if(indexPath.section==1)
    {
        MyLog(@"照片");
        PhotoViewController *PVC = [PhotoViewController new];
        PVC.visitID = self.visitID;
        PVC.visitData = self.visitData;
        [self.navigationController pushViewController:PVC animated:YES];
    }
    if(indexPath.section==2)
    {
        NSLog(@"价格信息");
        PriceInfoViewController *PIVC = [PriceInfoViewController new];
        PIVC.urlString = [NSString stringWithFormat:@"%@%@&%@&%@",[MayiURLManage MayiWebURLManageWithURL:PriceAnomalies],self.visitData[@"gps"][@"cloudId"],self.visitData[@"custId"],self.visitData[@"custNo"]];
        PIVC.autoManageBack = NO;
        [self.navigationController pushViewController:PIVC animated:YES];
        
    }
    if(indexPath.section==3)
    {
        OrderViewController *OVC = [OrderViewController new];
        OVC.urlString = [[NSString stringWithFormat:@"%@/2/%@/%@/%@",[MayiURLManage MayiWebURLManageWithURL:OrderDown],self.visitData[@"custNo"],self.visitData[@"storeName"],self.visitID] URLEncodedString];
        OVC.autoManageBack = NO;
        [OVC setHidesBottomBarWhenPushed:YES] ;
        [self.navigationController pushViewController:OVC animated:YES];
    }
    if(indexPath.section==4)
    {
        MyLog(@"拜访情况");
        VisitCaseViewController *VCC = [VisitCaseViewController new];
        VCC.visitID = self.visitID;
        VCC.visitData = self.visitData;
        VCC.saveLogContent = _saveLogContent;
        VCC.saveVisitPhoto = _saveVisitPhoto;
        [self.navigationController pushViewController:VCC animated:YES];
    }
    if(indexPath.section==5&&[MYManage defaultManager].isJPSJ)
    {
        NSLog(@"竞品信息"); // ↓ 这里与上面的价格信息相似，只是URL不同
        PriceInfoViewController *PIVC = [PriceInfoViewController new];
        PIVC.urlString = [NSString stringWithFormat:@"%@%@&%@&%@",[MayiURLManage MayiWebURLManageWithURL:CompetingGoodsCollection],self.visitData[@"gps"][@"cloudId"],self.visitData[@"custId"],self.visitData[@"custNo"]];
        PIVC.autoManageBack = NO;
        [self.navigationController pushViewController:PIVC animated:YES];
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 80;
    }
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}



// 更新位置成功后调用
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(_canlocation)
    {
        [Hud stop];
        
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        MyLog(@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        [self.search AMapReGoecodeSearch:regeo];  // 开始逆地理编码
        
        _canlocation = NO;
    }
    
    
}


/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        i++;
        
        if(i>1) // 过滤第一次自动回调
        {
            if([response.regeocode.addressComponent.building isEqualToString:@""])
            {
                if(response.regeocode.addressComponent.businessAreas.count>0)
                {
                    self.updateStoreName = response.regeocode.addressComponent.businessAreas[0].name;
                }
                else if (response.regeocode.addressComponent.streetNumber.street)
                {
                    self.updateStoreName = response.regeocode.addressComponent.streetNumber.street;
                }
                else
                {
                    self.updateStoreName = response.regeocode.addressComponent.township;
                }
                
            }
            else
            {
                self.updateStoreName = response.regeocode.addressComponent.building;
            }
            
            NSString *addressStr = response.regeocode.formattedAddress;
            NSString *filterStr = [NSString stringWithFormat:@"%@%@",response.regeocode.addressComponent.province,response.regeocode.addressComponent.city];
            NSString *address = [addressStr stringByReplacingOccurrencesOfString:filterStr withString:@""];
            
            self.updateAddress = address;
            
            // 更新定成功，重新请求该任务的签到接口
            
            NSDictionary *gps = @{@"cloudId":self.visitID,@"type ":@"1",@"longitude":[NSString stringWithFormat:@"%.6f",response.regeocode.addressComponent.streetNumber.location.longitude],@"latitude":[NSString stringWithFormat:@"%.6f",response.regeocode.addressComponent.streetNumber.location.latitude],@"address":self.updateAddress,@"userId":[MYManage defaultManager].ID};
            // 字典转字符串 并过滤掉空格及换行符
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:gps options:NSJSONWritingPrettyPrinted error:nil];

            NSString *DicString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            DicString = [DicString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            DicString = [DicString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            DicString = [DicString stringByReplacingOccurrencesOfString:@" " withString:@""];
            [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:SignIn] withPrameters:@{@"gps":DicString} result:^(id result) {

                [Hud showText:@"刷新成功"];

                [self.tableView reloadData];

            } error:^(id error) {

            } withHUD:YES];


        }
        

        
    }
}



-(void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)commit
{
    MyLog(@"提交");
    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:FinishVisit] withPrameters:@{@"visitId":self.visitID} result:^(id result) {
        
        NSInteger ok =  [result[@"data"][@"ok"] integerValue];
        if(ok)
        {
            [Hud showText:@"提交成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        
        }
        else
        {
            [Hud showText:result[@"data"][@"message"]];
            
        }
        
        
    } error:^(id error) {
        
    } withHUD:YES];
    
}

-(void)VisitPhotoUploadSuccess:(NSNotification*) notification
{

    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:TakeOutVisitInformation] withPrameters:@{@"visitId":self.visitID} result:^(id result) {
        
        self.visitData = nil;
        self.visitData = result[@"data"][@"data"];
        
        _photoFinish = YES;
        [self.tableView reloadData];
        
    } error:^(id error) {
        
    } withHUD:NO];
    

}

-(void)VisitConclusionSaveSuccess:(NSNotification*) notification
{
    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:TakeOutVisitInformation] withPrameters:@{@"visitId":self.visitID} result:^(id result) {
        
        self.visitData = nil;
        self.visitData = result[@"data"][@"data"];
        
        _visitFinish = YES;
        [self.tableView reloadData];
        
    } error:^(id error) {
        
    } withHUD:NO];
    
    
//    NSDictionary *data = [notification object];
//    _saveLogContent = data[@"logContent"];
//    _saveVisitPhoto = data[@"selectPhoneURL"];
//     = YES;
//    [self.tableView reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}




@end
