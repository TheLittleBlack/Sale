//
//  AddNewWorkDailyViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/1/2.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "AddNewWorkDailyViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "LPDQuoteSystemImagesView.h"
#define TextFieldHeight ScreenHeight/3

@interface AddNewWorkDailyViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MAMapViewDelegate,AMapSearchDelegate,LPDQuoteSystemImagesViewDelegate>
{
    BOOL _canlocation ;
}

@property(nonatomic,strong)UITextView *textView;

@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UIButton *addressButton;

@property(nonatomic,strong)MAMapView *mapView;
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,strong)LPDQuoteSystemImagesView *imageView;
@property(nonatomic,strong)NSMutableArray *imageViewArray;

//@property (strong, nonatomic) CLLocationManager* locationManager;

@end

@implementation AddNewWorkDailyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _canlocation = YES;
 
    self.imageViewArray = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工作日报";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    [self.view addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.and.width.mas_equalTo(20);
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(64+20);
        
    }];
    
    [self.view addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(40);
        
    }];
    
    [self.view addSubview:self.addressButton];
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(44);
        make.centerY.equalTo(self.iconImageView);
        make.left.equalTo(self.view);
        
    }];
    
    [self.view addSubview:self.textView];
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(TextFieldHeight);
        make.top.equalTo(self.addressButton.mas_bottom).with.offset(10);
        
    }];
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.width.mas_equalTo(ScreenWidth-30);
        make.height.mas_equalTo(100);
        
    }];
    
    
    [self.mapView reloadMap];
    
}

-(LPDQuoteSystemImagesView *)imageView
{
    if(!_imageView)
    {
        _imageView = [[LPDQuoteSystemImagesView alloc]initWithFrame:CGRectMake(15, 300, ScreenWidth-30, 100) withCountPerRowInView:4 cellMargin:12];
        //设置选择图片的最大数值
        _imageView.maxSelectedCount = 5;
        //是否可滚动
        _imageView.collectionView.scrollEnabled = YES;
        //添加代理
        _imageView.navcDelegate = self;
        _imageView.theNumber = 1;

    }
    return _imageView;
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

-(UITextView *)textView
{
    if(!_textView)
    {
        _textView = [UITextView new];
        _textView.layer.borderColor = [UIColor colorWithWhite:210/255.0 alpha:1].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.text = @"请输入工作内容";
        _textView.textColor = [UIColor colorWithWhite:210/255.0 alpha:1];
        _textView.delegate = self;
    }
    return _textView;
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
        _addressLabel.textColor = [UIColor colorWithWhite:150/255.0 alpha:1];
        _addressLabel.text = @"正在定位...";
        _addressLabel.numberOfLines = 0;
        
    }
    return _addressLabel;
}

-(UIButton *)addressButton
{
    if(!_addressButton)
    {
        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressButton setTitle:@"" forState:UIControlStateNormal];
        [_addressButton addTarget:self action:@selector(addressButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _addressButton;
}



-(void)addressButtonAction
{
//    [self.locationManager stopUpdatingLocation];
//    [self startLocation];
    
    _canlocation = YES;
    self.addressLabel.text = @"正在定位...";
    [self.mapView reloadMap];
    MyLog(@"刷新定位");
}

#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入工作内容";
        textView.textColor = [UIColor colorWithWhite:210/255.0 alpha:1];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入工作内容"]){
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)commit
{
    if([self.textView.text isEqualToString:@"请输入工作内容"]||!self.textView.text)
    {
        [Hud showText:@"请输入工作内容"];
    }
    else
    {
        NSDictionary *dic;
        if(self.imageViewArray.count>0)
        {
            dic = @{@"logContent":self.textView.text,@"type":@"0",@"address":self.addressLabel.text,@"urls":self.imageViewArray};
        }
        else
        {
            dic = @{@"logContent":self.textView.text,@"type":@"0",@"address":self.addressLabel.text};
        }
        

        
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *DicString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        DicString = [DicString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        DicString = [DicString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        DicString = [DicString stringByReplacingOccurrencesOfString:@" " withString:@""];
        

        [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:SaveDaily] withPrameters:@{@"workLogVo":DicString} result:^(id result) {
            
            MyLog(@"完成");
            
            [Hud showText:@"提交成功"];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];

        } error:^(id error) {
            
        } withHUD:YES];
    }
    

    
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


// ==========================================================================


//开始定位

//-(void)startLocation{
//
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.distanceFilter = 100.0f;
//
//    if ([[[UIDevice currentDevice]systemVersion]doubleValue] > 8.0){//iOS 8.0以后调用
//
//        [self.locationManager requestWhenInUseAuthorization];
//    }
//
//
//    [self.locationManager startUpdatingLocation];
//
//}
//
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
//
//    switch (status) {
//
//        case kCLAuthorizationStatusNotDetermined:
//
//            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//
//                [self.locationManager requestWhenInUseAuthorization];
//
//            }break;
//
//        default:break;
//
//    }
//
//}
//
//
//
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
//
//    CLLocation *newLocation = locations[0];
//
//    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
//
//    MyLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
//
//    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
//
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//
//        for (CLPlacemark *place in placemarks) {
//
//
//
//                MyLog(@"位置：%@",place.name);
//
//                MyLog(@"国家：%@",place.country);
//                MyLog(@"城市：%@",place.locality);
//                MyLog(@"区：%@",place.subLocality);
//                MyLog(@"街道：%@",place.thoroughfare);
//                MyLog(@"子街道：%@",place.subThoroughfare);
//
//            self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",place.locality,place.subLocality,place.thoroughfare,place.subThoroughfare?place.subThoroughfare:@" "];
//
//        }
//    }];
//
//    [Hud stop];
//    [self.locationManager stopUpdatingLocation];
//
//}






// ==========================================================================











-(UIImage *)addText:(UIImage *)img text:(NSString *)text1
{
    //get image width and height
    int w = img.size.width;
    int h = img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
    char* text = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Helvetica", 200, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
    CGContextShowTextAtPoint(context, 30, 60, text, strlen(text));
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
   
}


- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}












// 选择图片之后
- (void)doAfterDidSelectedPhotosWithView:(LPDQuoteSystemImagesView *)thisView andNumberOf:(NSInteger)number andClickSessionNumber:(NSInteger)sessionNumber withImage:(UIImage *)image
{
    
    [Hud showUpload];
    
    [self uploadImage:thisView.xiaoHeiImageArray arrayNumber:number withImage:image collectionView:thisView];
    
    
}

// 删除回调
- (void)delectButtonActionOfNumber:(NSInteger )number andSessionNumber:(NSInteger)sessionNumber
{
    
    
    [self.imageViewArray removeObjectAtIndex:sessionNumber];
    
    
    
}

-(void)uploadImage:(NSArray *)imageArray arrayNumber:(NSInteger )number withImage:(UIImage *)image collectionView:(LPDQuoteSystemImagesView *)collectionView
{
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    image = [self fixOrientation:image];
    image = [self addText:image text:dateString];
    
    
    NSString *url = [MayiURLManage MayiURLManageWithURL:UploadImage];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    
    //上传图片
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id  _Nonnull formData) {
        
        //将图片转成data
        NSData *data = UIImageJPEGRepresentation(image,0.0001);
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        [formData appendPartWithFileData:data name:@"dataFile" fileName:@"file.jpeg" mimeType:@"image/jpeg"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        MyLog(@"uploadProgress = %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [collectionView.xiaoHeiImageArray addObject:image];
        
        [collectionView.collectionView reloadData];
        
        
        NSString *imageUrl = responseObject[@"data"][@"data"][@"remoteFileUrl"];
        MyLog(@"%@",responseObject[@"data"][@"data"][@"imgUrl"]);
        
        
        [self.imageViewArray addObject:imageUrl];
        
        [Hud stop];
        [Hud showText:[NSString stringWithFormat:@"上传成功"] withTime:2];
        
        MyLog(@"%@",self.imageViewArray);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [Hud stop];
        [Hud showText:@"网络出错，请重新上传"];
        
        MyLog(@"error = %@",error);
    }];
    
    
}





-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [Hud stop];
    
//    [self.locationManager stopUpdatingLocation];
    
    self.navigationController.navigationBar.hidden = YES;
    
}






@end
