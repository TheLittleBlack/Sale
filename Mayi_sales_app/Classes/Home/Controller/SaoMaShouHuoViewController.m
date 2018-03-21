//
//  SaoMaShouHuoViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/3/20.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "SaoMaShouHuoViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "SaoMaShouHuoTableViewCell.h"
#import "SaoMaShouHuoFootView.h"
#define CellID @"cellID"
#define tableHeaderID @"headerID"
#define HeaderViewHeight 130

@interface SaoMaShouHuoViewController ()<UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate,AMapSearchDelegate,SaoMaShouHuoFootViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    BOOL _canlocation;
}

@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UILabel *bottomLeftLabel;
@property(nonatomic,strong)UIButton *bottomContinueButton; // 继续扫码
@property(nonatomic,strong)UIButton *bottomConfirmButtom; // 确认收货
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIImageView *numberImageView;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UIImageView *nameImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImage *photo;
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)NSTimer *timer;

@end

@implementation SaoMaShouHuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    _canlocation = YES;
    
    NSLog(@"%@",self.data);
    
    self.navigationItem.title = @"扫码收货";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.tableView);
        make.top.equalTo(self.tableView).offset(-HeaderViewHeight);
        make.height.mas_equalTo(HeaderViewHeight);
        make.width.mas_equalTo(ScreenWidth);
        
    }];
    
    
    [self.headerView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.and.width.mas_equalTo(20);
        make.left.equalTo(self.headerView).offset(15);
        make.top.equalTo(self.headerView).offset(15);
        
    }];
    
    [self.headerView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.headerView).offset(-10);
        make.height.mas_equalTo(40);
        
    }];
    
    [self.headerView addSubview:self.numberImageView];
    [self.numberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.and.width.mas_equalTo(20);
        make.left.equalTo(self.headerView).offset(15);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(10);
        
    }];
    
    [self.headerView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.numberImageView);
        make.left.equalTo(self.numberImageView.mas_right).offset(10);
        make.right.equalTo(self.headerView).offset(-10);
        make.height.mas_equalTo(40);
        
    }];
    
    [self.headerView addSubview:self.nameImageView];
    [self.nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.and.width.mas_equalTo(20);
        make.left.equalTo(self.headerView).offset(15);
        make.top.equalTo(self.numberLabel.mas_bottom).offset(10);
        
    }];
    
    [self.headerView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.nameImageView);
        make.left.equalTo(self.nameImageView.mas_right).offset(10);
        make.right.equalTo(self.headerView).offset(-10);
        make.height.mas_equalTo(40);
        
    }];
    
    
    
    
    
    
    
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.and.bottom.equalTo(self.view);
        make.height.mas_equalTo(60);
        
    }];
    
    

    [self.bottomView addSubview:self.bottomLeftLabel];
    [self.bottomLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView).offset(12);
        make.width.mas_equalTo(ScreenWidth/3);
        
    }];
    
    [self.bottomView addSubview:self.bottomContinueButton];
    [self.bottomContinueButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(ScreenWidth/3-20);
        make.height.mas_equalTo(45);
        make.left.equalTo(self.bottomLeftLabel.mas_right).offset(10);
        make.centerY.equalTo(self.bottomView);
        
    }];
    
    [self.bottomView addSubview:self.bottomConfirmButtom];
    [self.bottomConfirmButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(ScreenWidth/3-20);
        make.height.mas_equalTo(45);
        make.left.equalTo(self.bottomContinueButton.mas_right).offset(10);
        make.centerY.equalTo(self.bottomView);
        
    }];
    
    
    
    
    
    
    
    [self.mapView reloadMap];
    
    
    
}


-(UIView *)headerView
{
    if(!_headerView)
    {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
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

-(UIImageView *)iconImageView
{
    if(!_iconImageView)
    {
        _iconImageView = [UIImageView new];
        _iconImageView.image = [UIImage imageNamed:@"icon_ditu0a2"];
    }
    return _iconImageView;
}

-(UILabel *)addressLabel
{
    if(!_addressLabel)
    {
        _addressLabel = [UILabel new];
        _addressLabel.font = [UIFont systemFontOfSize:15];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _addressLabel.text = @"正在定位...";
        _addressLabel.numberOfLines = 0;
        
    }
    return _addressLabel;
}

-(UIImageView *)numberImageView
{
    if(!_numberImageView)
    {
        _numberImageView = [UIImageView new];
        _numberImageView.image = [UIImage imageNamed:@"icon_dindana"];
    }
    return _numberImageView;
}

-(UIImageView *)nameImageView
{
    if(!_nameImageView)
    {
        _nameImageView = [UIImageView new];
        _nameImageView.image = [UIImage imageNamed:@"icon_dianpu02"];
    }
    return _nameImageView;
}

-(UILabel *)numberLabel
{
    if(!_numberLabel)
    {
        _numberLabel = [UILabel new];
        _numberLabel.font = [UIFont systemFontOfSize:15];
        _numberLabel.textAlignment = NSTextAlignmentLeft;
        _numberLabel.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _numberLabel.text = self.data[@"orderSn"];
        _numberLabel.numberOfLines = 0;
        
    }
    return _numberLabel;
}

-(UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor colorWithWhite:100/255.0 alpha:1];
        _nameLabel.text = self.data[@"customerName"];
        _nameLabel.numberOfLines = 0;
        
    }
    return _nameLabel;
}

-(UIView *)bottomView
{
    if(!_bottomView)
    {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

-(UILabel *)bottomLeftLabel
{
    if(!_bottomLeftLabel)
    {
        _bottomLeftLabel = [UILabel new];
        _bottomLeftLabel.text = @"合计: 0箱";
        _bottomLeftLabel.textAlignment = NSTextAlignmentLeft;
        _bottomLeftLabel.font = [UIFont systemFontOfSize:18];
    }
    return _bottomLeftLabel;
}

-(UIButton *)bottomContinueButton
{
    if(!_bottomContinueButton)
    {
        _bottomContinueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomContinueButton setTitle:@"继续扫码" forState:UIControlStateNormal];
        [_bottomContinueButton setTitleColor:MainColor forState:UIControlStateNormal];
        [_bottomContinueButton addTarget:self action:@selector(continueAction) forControlEvents:UIControlEventTouchUpInside];
        _bottomContinueButton.layer.masksToBounds = YES;
        _bottomContinueButton.layer.cornerRadius = 3;
        _bottomContinueButton.layer.borderWidth = 1;
        _bottomContinueButton.layer.borderColor = MainColor.CGColor;
        _bottomContinueButton.titleLabel.font = [UIFont systemFontOfSize:18];
        
    }
    return _bottomContinueButton;
}

-(UIButton *)bottomConfirmButtom
{
    if(!_bottomConfirmButtom)
    {
        _bottomConfirmButtom = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomConfirmButtom setTitle:@"确认收货" forState:UIControlStateNormal];
        _bottomConfirmButtom.backgroundColor = MainColor;
        [_bottomConfirmButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bottomConfirmButtom addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        _bottomConfirmButtom.layer.masksToBounds = YES;
        _bottomConfirmButtom.layer.cornerRadius = 3;
        _bottomConfirmButtom.titleLabel.font = [UIFont systemFontOfSize:18];
        
    }
    return _bottomConfirmButtom;
}


-(UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64-60) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
        [_tableView registerClass:[SaoMaShouHuoTableViewCell class] forCellReuseIdentifier:CellID];
        [_tableView registerClass:[SaoMaShouHuoFootView class] forHeaderFooterViewReuseIdentifier:tableHeaderID];
        _tableView.contentInset = UIEdgeInsetsMake(HeaderViewHeight, 0, 0, 0);
        _tableView.separatorInset = UIEdgeInsetsZero;
        
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if(!_dataSource)
    {
        NSArray *array = @[
                           @"test1",@"test2"
                           ];
        
        _dataSource = [NSMutableArray arrayWithArray:array];
    }
    return _dataSource;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SaoMaShouHuoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 130;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SaoMaShouHuoFootView *footView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:tableHeaderID];
    footView.delegate = self;
    if(self.photo)
    {
        [footView.imageButton setImage:self.photo forState:UIControlStateNormal];
    }
    return footView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}



// 更新位置成功后调用
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(_canlocation)
    {
        
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        
        regeo.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
        [self.search AMapReGoecodeSearch:regeo];  // 开始逆地理编码
        
        _canlocation = NO;
    }
    
    
}


/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil && ![response.regeocode.formattedAddress isEqualToString:@""])
    {
        
        self.addressLabel.text = response.regeocode.formattedAddress;
        
    }
    else
    {
        self.addressLabel.text = @"定位失败，请重新定位";
    }
}

// 点击拍照按钮
-(void)takePhote
{
    [self openCamera];
}


-(void)continueAction
{
    NSLog(@"继续扫码");
}

-(void)confirmAction
{
    NSLog(@"确认收货");
}


-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



//打开相机
-(void)openCamera
{
    UIImagePickerController *imagrPicker = [[UIImagePickerController alloc]init];
    imagrPicker.delegate = self;
    
    imagrPicker.sourceType = UIImagePickerControllerSourceTypeCamera; // UIImagePickerControllerSourceTypePhotoLibrary
    
    [self presentViewController:imagrPicker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取选中的照片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [Hud showUpload];
        
        
        NSString *url = [MayiURLManage MayiURLManageWithURL:UploadImage];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
        
        //上传图片，只能用POST
        [manager POST:url parameters:nil constructingBodyWithBlock:^(id  _Nonnull formData) {
            
            //将图片转成data
            NSData *data = UIImageJPEGRepresentation(image,0.3);
            //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
            [formData appendPartWithFileData:data name:@"dataFile" fileName:@"file.jpeg" mimeType:@"image/jpeg"];
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            MyLog(@"uploadProgress = %@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [Hud stop];
            
            
            MyLog(@"%@",responseObject);
            
            if([responseObject[@"code"] integerValue]==200)
            {
                
                [Hud showText:@"上传成功"];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.photo = image;
                    [self.tableView reloadData];
                    
                });
                
                self.imageUrl = responseObject[@"data"][@"data"][@"remoteFileUrl"];
                MyLog(@"%@",responseObject[@"data"][@"data"][@"imgUrl"]);
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            [Hud stop];
            
            [Hud showText:@"网络出错，请重新上传"];
            
            MyLog(@"error = %@",error);
        }];
        
        
        
        
        
    }];
}

//点击取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

@end
