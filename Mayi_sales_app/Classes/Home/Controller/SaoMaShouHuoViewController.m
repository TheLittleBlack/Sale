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
#import "UIImageView+WebCache.h"
#import "ScanQRCodeViewController.h"
#define CellID @"cellID"
#define tableHeaderID @"headerID"
#define HeaderViewHeight 130
#define TimerCountDown 60  //定时器倒计时

@interface SaoMaShouHuoViewController ()<UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate,AMapSearchDelegate,SaoMaShouHuoFootViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    BOOL _canlocation;
    BOOL _showDeleteButton;
    CGFloat _countDown;
    CGFloat _longitude;
    CGFloat _latitude;
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
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSMutableArray *barCodes; // 成功收货才数组

@end

@implementation SaoMaShouHuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _canlocation = YES;
    _showDeleteButton = NO;
    _countDown = TimerCountDown;
    
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
    
    
    
    
    [self StartTimer];
    
    
    [self.mapView reloadMap];
    
    
    self.bottomLeftLabel.text = [NSString stringWithFormat:@"合计: %@箱",[self dealAllBox]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ScanQR:) name:@"ScanQRFinish" object:nil];
    
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
        _numberLabel.numberOfLines = 0;
        
        NSString *type = @"";
        NSInteger channel = [self.data[@"channel"] integerValue];
        if(channel==8)
        {
            type = @"(代客下单)";
        }
        else if(channel==9)
        {
            type = @"(三方加盟店)";
        }
        else if(channel==10)
        {
            type = @"(车销)";
        }
        else if(channel==11)
        {
            type = @"(B2B微商城)";
        }
        
        _numberLabel.text = [NSString stringWithFormat:@"%@%@",self.data[@"orderSn"],type];
        
        
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

        
        _nameLabel.text = [NSString stringWithFormat:@"%@",[self.data[@"customerName"] isEqual:[NSNull null]]?@"":self.data[@"customerName"]];
        
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
        NSArray *array = self.data[@"orderItems"];
        
        _dataSource = [NSMutableArray arrayWithArray:array];
    }
    return _dataSource;
}

-(NSMutableArray *)barCodes
{
    if(!_barCodes)
    {
        _barCodes = [NSMutableArray new];
    }
    return _barCodes;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *subData = self.dataSource[indexPath.row];
    SaoMaShouHuoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",subData[@"pdtName"]];
    NSString *imageUrl = subData[@"productGoodsUrl"];
    if(imageUrl&&![imageUrl isEqual:[NSNull null]])
    {
        NSLog(@"%@",imageUrl);
        imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // 图片可能带有中文名，需要进行编码
        [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrl]]];
    }
    cell.boxNumberLabel.text = [NSString stringWithFormat:@"箱码:%@",[subData[@"barCode"] isEqual:[NSNull null]]?@"":subData[@"barCode"]];
    NSString *qtyReceived = [subData[@"qtyReceived"] isEqual:[NSNull null]]?@"0":subData[@"qtyReceived"];
    NSString *convertNumber = [subData[@"convertNumber"] isEqual:[NSNull null]]?@"0":subData[@"convertNumber"];
    NSInteger convert = [convertNumber integerValue];
    cell.yiSaoMiaoLabel.text = [NSString stringWithFormat:@"已扫%lu箱",[qtyReceived integerValue]/convert];
    NSString *qtyShipped = [subData[@"qtyShipped"] isEqual:[NSNull null]]?@"0":subData[@"qtyShipped"];
    cell.gongJiXiangLabel.text = [NSString stringWithFormat:@"共%lu箱",[qtyShipped integerValue]/convert];
    NSInteger queShao = [qtyShipped integerValue] - [qtyReceived integerValue]/convert;
    cell.shaoJiXiangLabel.text = [NSString stringWithFormat:@"少%lu箱",queShao];

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
    else
    {
        [footView.imageButton setImage:[UIImage imageNamed:@"camera_press"] forState:UIControlStateNormal];
    }
    
    if(_showDeleteButton)
    {
        footView.deleteButton.hidden = NO;
    }
    else
    {
        footView.deleteButton.hidden = YES;
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
        _longitude = userLocation.coordinate.longitude;
        _latitude = userLocation.coordinate.latitude;
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
        self.address = response.regeocode.formattedAddress;
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

// 点击删除照片
-(void)deleteAction
{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        _showDeleteButton = NO;
        self.photo = NULL;
        [self.tableView reloadData];
        
    });
}


-(void)continueAction
{
    NSLog(@"继续扫码");
    ScanQRCodeViewController *SQVC = [ScanQRCodeViewController new];
    UINavigationController *NVC = [[UINavigationController alloc]initWithRootViewController:SQVC];
    [self presentViewController:NVC animated:YES completion:^{
        
    }];
   
}

-(void)confirmAction
{
    NSLog(@"确认收货");
    
    if(!self.photo)
    {
        
        [Hud showText:@"请拍摄照片"];
        
        return;
    }
    
    if(self.barCodes.count<1)
    {
        [Hud showText:@"未进行收货，不能提交订单"];
        
        return;
    }
    
    NSInteger number = [self checkNumber];
    
    if(number>0)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"系统提示" message:[NSString stringWithFormat:@"还差%lu件,确认收货？",number] preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self shouHuo];
            
        }]];
        
        
        // 为了不产生延时的现象，直接放在主线程中调用
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self presentViewController:alert animated:YES completion:^{
            }];
            
        });
    }
    
    

}

// 执行收货
-(void)shouHuo
{
    NSDictionary *receiveLocation = @{@"longitude":[NSString stringWithFormat:@"%f",_longitude?_longitude:0.00],@"latitude":[NSString stringWithFormat:@"%f",_latitude?_latitude:0.00],@"address":self.address,@"imgUrl":self.imageUrl?self.imageUrl:@""};
    // 字典转字符串 并过滤掉空格及换行符
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:receiveLocation options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *DicString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DicString = [DicString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    DicString = [DicString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    DicString = [DicString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    
    NSData *jsonDataB = [NSJSONSerialization dataWithJSONObject:self.barCodes options:NSJSONWritingPrettyPrinted error:nil];
    NSString *DicStringB = [[NSString alloc] initWithData:jsonDataB encoding:NSUTF8StringEncoding];
    DicStringB = [DicStringB stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    DicStringB = [DicStringB stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    DicStringB = [DicStringB stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:ReceiveConfirmation] withPrameters:@{@"orderSn":self.data[@"orderSn"],@"barCodes":DicStringB,@"receiveLocation":DicString} result:^(id result) {
        
        NSInteger ok = [result[@"data"][@"ok"] integerValue];
        if(ok)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } error:^(id error) {
        
    } withHUD:YES];
}


-(void)backAction
{
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"系统提示" message:@"收货未结束，退出将不会保留已扫箱码，确认退出？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    
    
    // 为了不产生延时的现象，直接放在主线程中调用
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self presentViewController:alert animated:YES completion:^{
        }];
        
    });
    
    
    
    
    
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
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg", nil];
        
        //上传图片，只能用POST
        [manager POST:url parameters:nil constructingBodyWithBlock:^(id  _Nonnull formData) {
            
//            UIImage *smallImage = [self scaleImage:image toKb:0.1];
            
            //将图片转成data
            NSData *data = UIImageJPEGRepresentation(image,0.0001);
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
                    _showDeleteButton = YES; // 有照片了就把删除按钮显示出来
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

// 计算合计几箱
-(NSString *)dealAllBox
{
    NSInteger number = 0;
    for (NSDictionary *data in self.dataSource) {
        
        NSString *numberStr = data[@"qtyReceived"];
        if(numberStr&&![numberStr isEqual:[NSNull null]])
        {
            number += [numberStr integerValue];
        }
        
    }
    
    return [NSString stringWithFormat:@"%lu",number];
}


// 扫码回调
-(void)ScanQR:(NSNotification *)notification
{
    NSString *QRString = notification.userInfo[@"QRString"];
    NSLog(@"%@",QRString);
    
    [self updateDate];

    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:ScanReceive] withPrameters:@{@"orderSn":self.data[@"orderSn"],@"barCode":QRString} result:^(id result) {
        
        [Hud showText:result[@"data"][@"message"]];
        
        NSInteger errorType = [result[@"data"][@"data"][@"errorType"] integerValue];
        if(errorType==0)
        {
            NSLog(@"收货成功");
            [self.barCodes addObject:QRString];
            
            [self updateDate];
            
        }
        
    } error:^(id error) {
        
    } withHUD:YES];
    
    
}




-(void)updateDate
{
    
    NSDictionary *prameters = @{@"page":@"1",@"rows":@"50"};
    
    // 字典转字符串 并过滤掉空格及换行符
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:prameters options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *DicString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    DicString = [DicString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    DicString = [DicString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    DicString = [DicString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:FindReceiveOrders] withPrameters:@{@"query":DicString} result:^(id result) {
        
        [Hud stop];
        
        NSArray *targetArray = result[@"data"][@"data"][@"list"];
        for (NSDictionary *data in targetArray) {
            if(data[@"orderSn"]==self.data[@"orderSn"])
            {
                self.data = data;
            }
        }
 
        [self.tableView reloadData];
        self.bottomLeftLabel.text = [NSString stringWithFormat:@"合计: %@箱",[self dealAllBox]];
        
    } error:^(id error) {
        
    } withHUD:NO];
    
}


//点击取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


-(void)StartTimer
{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self.timer fire];

}

-(void)timerAction
{

    _countDown--;
    
    if(_countDown==0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            _countDown = TimerCountDown;
            [self.mapView reloadMap];
            [self.tableView reloadData];
            
        });
    }
}

-(void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// 还差几件
-(NSInteger )checkNumber
{
    
    NSInteger number = 0;
    for (NSDictionary *data in self.dataSource) {
        
        NSString *qtyReceivedStr = [data[@"qtyReceived"] isEqual:[NSNull null]]?@"0":data[@"qtyReceived"];
        NSString *qtyStr = [data[@"qty"] isEqual:[NSNull null]]?@"0":data[@"qty"];
        NSString *convertNumberStr = [data[@"convertNumber"] isEqual:[NSNull null]]?@"0":data[@"convertNumber"];
        NSInteger qtyReceived = [qtyReceivedStr integerValue];
        NSInteger qty = [qtyStr integerValue];
        NSInteger convertNumber = [convertNumberStr integerValue];
        
        if(qty-qtyReceived>0)
        {
            number += (qty - qtyReceived)/convertNumber;
        }
        
    }
    
    return number;
    
}

































@end
