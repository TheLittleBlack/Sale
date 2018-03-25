//
//  SignInViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/26.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "SignInViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SignAddressTableViewCell.h"
#import "CustomerVisitViewController.h"
#import "TeamManageVisitViewController.h"
#define CellID @"cellID"
#define MapHeight ScreenHeight-64-70
#define tableViewCellHeight 60
#define tableViewHeaderHeight 38
#define tableViewShowTop ScreenHeight-(tableViewCellHeight*4+tableViewHeaderHeight)-70
#define tableViewHiddenTop ScreenHeight-tableViewHeaderHeight-70
#define tableViewShowHeight tableViewHeaderHeight+tableViewCellHeight*4

@interface SignInViewController ()<MAMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>

{
    MAUserLocation *_currentLocation;
    BOOL _canlocation;
    NSInteger _selectRow;
}

@property(nonatomic,strong)MAMapView *mapView; //高德地图
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,strong)UIButton *signButton;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UIView *tableHeaderView;
@property(nonatomic,strong)UIButton *showAddressButton;

@end

@implementation SignInViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Hud showLoading];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"签到";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _canlocation = YES;
    _selectRow = 0;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    self.search = [AMapSearchAPI new];
    self.search.delegate = self;
    
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(MapHeight);
        make.left.equalTo(self.view);
        make.top.mas_equalTo(64);

    }];
    
    // 暂时隐藏掉选择地址功能，哼！
//    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.signButton];
    [self.signButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(50);
        make.bottom.equalTo(self.view).offset(-10);
        
    }];
    

    
    
    
}

-(MAMapView *)mapView
{
    if(!_mapView)
    {
       
        [AMapServices sharedServices].enableHTTPS = NO;
        
        ///初始化地图
        _mapView = [[MAMapView alloc] initWithFrame:CGRectZero];
        _mapView.zoomLevel = 16;
        _mapView.showsCompass = NO;
        _mapView.showsScale = NO;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;
        _mapView.delegate = self;
        [_mapView setDesiredAccuracy:kCLLocationAccuracyBest];
        
    }
    return _mapView;
}


-(UIButton *)signButton
{
    if(!_signButton)
    {
        _signButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signButton setTitle:@"拜访签到" forState:UIControlStateNormal];
        _signButton.backgroundColor = MainColor;
        [_signButton addTarget:self action:@selector(signAction:) forControlEvents:UIControlEventTouchUpInside];
        [_signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signButton.layer.masksToBounds = YES;
        _signButton.layer.cornerRadius = 3;
        _signButton.titleLabel.font = [UIFont systemFontOfSize:18.5];
        
    }
    return _signButton;
}


-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableViewHiddenTop, ScreenWidth, tableViewHeaderHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[SignAddressTableViewCell class] forCellReuseIdentifier:CellID];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        
    }
    return _tableView;
}

-(UIView *)tableHeaderView
{
    if(!_tableHeaderView)
    {
        _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, tableViewHeaderHeight)];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, ScreenWidth/2, tableViewHeaderHeight)];
        lable.text = @"选择位置";
        lable.font = [UIFont systemFontOfSize:14];
        lable.textColor = [UIColor blackColor];
        lable.textAlignment = NSTextAlignmentLeft;
        [_tableHeaderView addSubview:lable];
        [_tableHeaderView addSubview:self.showAddressButton];
        [self.showAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.and.height.mas_equalTo(tableViewHeaderHeight);
            make.centerY.equalTo(_tableHeaderView);
            make.right.equalTo(_tableHeaderView).offset(-8);
            
        }];
        
    }
    return _tableHeaderView;
}

-(UIButton *)showAddressButton
{
    if(!_showAddressButton)
    {
        _showAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showAddressButton setImage:[UIImage imageNamed:@"icon_liebiao"] forState:UIControlStateNormal];
        [_showAddressButton setImage:[UIImage imageNamed:@"icon_guanbi"] forState:UIControlStateSelected];
        [_showAddressButton addTarget:self action:@selector(showAddressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _showAddressButton;
}


-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}



// 更新位置成功后调用
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(_canlocation)
    {
        [Hud stop];
        
        _currentLocation = userLocation; // 保存地理信息
        MyLog(@"%f,%f",userLocation.coordinate.longitude,userLocation.coordinate.latitude);
        
        [self getNearInformation]; // 获取附近信息
        [self getLocation]; // 获取大头针详细地址信息
        
        [self.mapView selectAnnotation:self.mapView.userLocation animated:YES]; // 自动显示大头针信息
        
        _canlocation = NO;
    }

    
}

// 点击大头针
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if([view.annotation isKindOfClass:[MAUserLocation class]])
    {

    }
}

-(void)getLocation // 获取大头针所要显示的地址
{
    if(_currentLocation)
    {
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        
        regeo.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        //        regeo.requireExtension = YES;
        [self.search AMapReGoecodeSearch:regeo];  // 开始逆地理编码
    }
}


/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (![response.regeocode.formattedAddress isEqualToString:@""])
    {
        
        if([response.regeocode.addressComponent.building isEqualToString:@""])
        {
            if(response.regeocode.addressComponent.businessAreas.count>0)
            {
                _mapView.userLocation.title = response.regeocode.addressComponent.businessAreas[0].name ;
            }
            
        }
        else if(![response.regeocode.addressComponent.township isEqualToString:@""])
        {
            _mapView.userLocation.title = response.regeocode.addressComponent.township;
        }
        else
        {
            _mapView.userLocation.title = response.regeocode.addressComponent.building;
        }
        
        NSString *addressStr = response.regeocode.formattedAddress;
        NSString *filterStr = [NSString stringWithFormat:@"%@%@",response.regeocode.addressComponent.province,response.regeocode.addressComponent.city];
        NSString *address = [addressStr stringByReplacingOccurrencesOfString:filterStr withString:@""];
        
        _mapView.userLocation.subtitle = address;
        
    }
}

// 获取附近信息
-(void)getNearInformation
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    request.sortrule = 0;
    request.requireExtension = YES;
//    request.types = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.types = @"风景名胜|商务住宅|政府机构及社会团体";
    [self.search AMapPOIAroundSearch:request];  // 开始搜寻
}

// 搜寻成功回调
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count==0)
    {
        return;
    }
    
    [self.dataSource removeAllObjects];
    self.dataSource = [NSMutableArray arrayWithArray:response.pois];
    AMapPOI *firstAddress = [AMapPOI new];
    firstAddress.name = self.mapView.userLocation.title;
    firstAddress.address = self.mapView.userLocation.subtitle;
    firstAddress.distance = 0;
    AMapGeoPoint *point = [AMapGeoPoint new];
    point.longitude = _currentLocation.coordinate.longitude;;
    point.latitude = _currentLocation.coordinate.latitude;
    firstAddress.location = point;
    [self.dataSource insertObject:firstAddress atIndex:0];
    [self.tableView reloadData];
    MyLog(@"%@",self.dataSource);
    
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)signAction:(UIButton *)sender
{
    MyLog(@"拜访签到");
    
    if(self.dataSource.count>0)
    {
        NSDate *nowDate = [NSDate date];
        NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)[nowDate timeIntervalSince1970]*1000];
 
        AMapPOI *poi = self.dataSource[_selectRow];
        NSDictionary *gps = @{@"cloudId":self.visitID,@"type":[NSString stringWithFormat:@"%lu",self.type],@"longitude":[NSString stringWithFormat:@"%.6f",poi.location.longitude],@"latitude":[NSString stringWithFormat:@"%.6f",poi.location.latitude],@"address":[poi.address isEqual:[NSNull null]]?@" ":poi.address,@"userId":[MYManage defaultManager].ID,@"gpsDatetime":timeStamp};
        
        // 字典转字符串 并过滤掉空格及换行符
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:gps options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *DicString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        DicString = [DicString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        DicString = [DicString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        DicString = [DicString stringByReplacingOccurrencesOfString:@" " withString:@""];
        [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:SignIn] withPrameters:@{@"gps":DicString} result:^(id result) {
            
            [Hud showText:@"签到成功"];
            
            if(self.type==2) // 政商拜访
            {
                TeamManageVisitViewController *TMVVC = [TeamManageVisitViewController new];
                TMVVC.urlString = [NSString stringWithFormat:@"%@/%lu",[MayiURLManage MayiWebURLManageWithURL:TeamVisit],self.businessKey];
                TMVVC.businessKey = self.businessKey;
                TMVVC.visitID = self.visitID;
                TMVVC.hidesBottomBarWhenPushed = YES;
                if(self.isFirst) // 第一次
                {
                    [self.navigationController pushViewController:TMVVC animated:YES];
                }
                else
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }
            else // 普通拜访
            {
                
                [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:TakeOutVisitInformation] withPrameters:@{@"visitId":self.visitID} result:^(id result) {
                    
                    CustomerVisitViewController *CVVC = [CustomerVisitViewController new];
                    CVVC.visitData = result[@"data"][@"data"];
                    CVVC.visitID = self.visitID;
                    CVVC.storeName = self.storeName;
                    CVVC.address = poi.address;
                    CVVC.AD = poi.name;
                    CVVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:CVVC animated:YES];
                    
                } error:^(id error) {
                    
                } withHUD:YES];

                
            }
            

            
        } error:^(id error) {
            
        } withHUD:YES];
    }
    else
    {
        [Hud showText:@"正在定位，请稍候"];
        _canlocation = YES;
        
        [self.mapView reloadMap];
    }

}


-(void)showAddressButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if(sender.selected)
    {
        MyLog(@"展开");
        [UIView animateWithDuration:0.25 animations:^{
            
            self.tableView.My_y = tableViewShowTop;
            self.tableView.My_Height = tableViewShowHeight;
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    else
    {
        MyLog(@"关闭列表");
        [UIView animateWithDuration:0.25 animations:^{
            
            self.tableView.My_y = tableViewHiddenTop;
            
        } completion:^(BOOL finished) {
            
            self.tableView.My_Height = tableViewHeaderHeight;
            
        }];
       
        
    }
    
    [self.tableView reloadData];
    
}
















#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AMapPOI *poi = self.dataSource[indexPath.row];
    SignAddressTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.firstLabel.text = poi.name;
    cell.secondLabel.text = poi.address;
    cell.distanceLabel.text = [NSString stringWithFormat:@"%lu m",poi.distance];
    if(indexPath.row==_selectRow)
    {
        cell.selectImageView.hidden = NO;
        cell.distanceLabel.hidden = YES;
    }
    else
    {
        cell.selectImageView.hidden = YES;
        cell.distanceLabel.hidden = NO;
    }
    

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    SignAddressTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    _selectRow = indexPath.row;
    [self.tableView reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return tableViewHeaderHeight;
    }
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return self.tableHeaderView;
    }
    return [UIView new];
}


@end
