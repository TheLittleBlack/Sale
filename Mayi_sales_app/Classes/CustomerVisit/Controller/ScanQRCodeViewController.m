//
//  ScanQRCodeViewController.m
//  RisingClouds
//
//  Created by JianRen on 17/4/10.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

#define TOP (ScreenHeight-220)/2
#define LEFT (ScreenWidth-220)/2

#define kScanRect CGRectMake(LEFT, TOP, 220, 220)

@interface ScanQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    CAShapeLayer *cropLayer;
    BOOL isAddView;
}

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (strong,nonatomic)UIImageView * QRLogin;
@property (nonatomic, strong) UIImageView * line;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Hud showLoading];
    self.navigationItem.title = @"扫一扫";
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setBarButtonItem];
    
    
}

-(void)setBarButtonItem
{

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    
}


-(void)configView{
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:kScanRect];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), ScreenWidth, 50)];
    label.text = @"将二维码放进框内，即可自动扫描";
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    
    [self.view addSubview:self.QRLogin];
    [self.QRLogin mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.height.and.width.mas_equalTo(40);
        make.centerX.equalTo(self.view);
        make.top.equalTo(label.mas_bottom).with.offset(22);
        
    }];
    
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, TOP+10, 220, 2)];
    _line.image = [UIImage imageNamed:@"dan01"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
}


-(UIImageView *)QRLogin
{
    if(!_QRLogin)
    {
        _QRLogin = [UIImageView new];
        _QRLogin.image = [UIImage imageNamed:@"We"];
    }
    return _QRLogin;
}



-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (2*num == 200) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(LEFT, TOP+10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}


//黑色背景
- (void)setCropRect:(CGRect)cropRect{
    cropLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, cropRect);
    CGPathAddRect(path, nil, self.view.bounds);
    
    [cropLayer setFillRule:kCAFillRuleEvenOdd];
    [cropLayer setPath:path];
    [cropLayer setFillColor:[UIColor blackColor].CGColor];
    [cropLayer setOpacity:0.6];
    
    
    [cropLayer setNeedsDisplay];
    
    [self.view.layer addSublayer:cropLayer];
}

- (void)setupCamera
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device==nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备没有摄像头" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        [Hud stop];
        return;
    }
    
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描区域
    CGFloat top = TOP/ScreenHeight;
    CGFloat left = LEFT/ScreenWidth;
    CGFloat width = 220/ScreenWidth;
    CGFloat height = 220/ScreenHeight;
    ///top 与 left 互换  width 与 height 互换
    [_output setRectOfInterest:CGRectMake(top,left, height, width)];
    
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    //    AVMetadataObjectTypeEAN13Code,
    //    AVMetadataObjectTypeEAN8Code,
    //    AVMetadataObjectTypeUPCECode,
    //    AVMetadataObjectTypeCode39Code,
    //    AVMetadataObjectTypeCode39Mod43Code,
    //    AVMetadataObjectTypeCode93Code,
    //    AVMetadataObjectTypeCode128Code,
    //    AVMetadataObjectTypePDF417Code
    
    // 条码类型 AVMetadataObjectTypeQRCode
    [_output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypePDF417Code,nil]];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
    
    if(!isAddView)
    {
        [self configView];
        isAddView = YES;
    }
    
    [Hud stop];

   
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        //停止扫描
        [_session stopRunning];
        [timer setFireDate:[NSDate distantFuture]];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        MyLog(@"扫描结果：%@",stringValue);
        
//        NSArray *arry = metadataObject.corners;
//        for (id temp in arry) {
//            MyLog(@"%@",temp);
//        }
        
        [self dealQRString:stringValue];
        
        
    }

    
}

//处理扫描到的信息
-(void)dealQRString:(NSString *)QRString
{
    //将json转成字符串
    NSData *jsonData = [QRString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    MyLog(@"%@",dictionary);
    
    if([self.type isEqualToString:@"价格异常"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScanQRFinishForPrice" object:self userInfo:@{@"QRString":QRString}];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScanQRFinish" object:self userInfo:@{@"QRString":QRString}];
    }
    
    
    
    [self backAction];

}



//由于要写两次，所以就封装了一个方法
-(void)alertControllerMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden = NO;
    
    [self setCropRect:kScanRect];
    
    [self performSelector:@selector(setupCamera) withObject:nil afterDelay:0.3];
    
    
    
    
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self stopTimer];
    
    [self removeView];

    
}

//移除扫描的相关控件
-(void)removeView
{
    [_session stopRunning];
    [_preview removeFromSuperlayer];
    [cropLayer removeFromSuperlayer];
    _preview = nil;
    _session = nil;
    cropLayer = nil;
}

//停止定时器
-(void)stopTimer
{
    [timer invalidate];
    timer = nil;
}

@end
