//
//  BaseWebViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/16.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "BaseWebViewController.h"
#import "LoginViewController.h"
#import "ScanQRCodeViewController.h"

@interface BaseWebViewController () <UIWebViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property(nonatomic,strong)UIView *stateView;

@end

@implementation BaseWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [self.webView reload];
//}

-(instancetype)init
{
    if(self = [super init])
    {
        _autoManageBack = YES; // 设置默认值
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [Hud showLoading];
    self.view.backgroundColor = [UIColor whiteColor];
    MyLog(@"%@",self.urlString);
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    
    
    [self.view addSubview:self.webView];
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.mas_equalTo(0);
        
    }];
    
    [self.view addSubview:self.stateView];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.view).offset(0);
        
    }];
    
    
    
}


-(UIView *)stateView
{
    if(!_stateView)
    {
        _stateView = [UIView new];
        _stateView.backgroundColor = [UIColor whiteColor];
    }
    return _stateView;
}


-(UIWebView *)webView
{
    if(!_webView)
    {
        _webView = [UIWebView new];
        _webView.scalesPageToFit = YES;
        _webView.userInteractionEnabled = YES;
        _webView.delegate = self;
        NSURL *url = [NSURL URLWithString:_urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:6];
        [_webView loadRequest:request];
    }
    return _webView;
}

#pragma mark <UIWebViewDelegate>

//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.navigationController.navigationBar.hidden = YES;
    MyLog(@"开始加载");
    
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    MyLog(@"加载完成");
    self.navigationController.navigationBar.hidden = YES;
    [Hud stop];
    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 获取js调用的方法
    context[@"takePhotos"] = ^(){
        
        NSLog(@"打开相机");
        
        [self openCamera];
        
    };
    
    context[@"scanCode"] = ^(){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"扫描二维码");
            
            ScanQRCodeViewController *SQRC = [ScanQRCodeViewController new];
            [self.navigationController pushViewController:SQRC animated:YES];
            
        });

    };

    

    context[@"callPhone"] = ^(){

        NSArray *args = [JSContext currentArguments];

        NSString *phoneNumber = [args[0] toString];
        
        if(phoneNumber&&![phoneNumber isEqualToString:@""]&&![phoneNumber isEqualToString:@"null"])
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIWebView *callWebView = [[UIWebView alloc] init];
                NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]];
                [callWebView loadRequest:[NSURLRequest requestWithURL:telURL]];
                [self.view addSubview:callWebView];
                
            });
            
        }

        MyLog(@"%@",phoneNumber);

    };
    

    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSURL *URL = request.URL;
    MyLog(@"请求的URL：%@",URL);
    [self requestUrl:[NSString stringWithFormat:@"%@",URL]];
    
    NSArray *urlArray = [[NSString stringWithFormat:@"%@",URL] componentsSeparatedByString:@"."];
    NSString *actionType = urlArray.lastObject;
    MyLog(@"点击事件类型：%@",actionType);
    [self urlActionType:actionType];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",URL];
    NSString *lastStr = [urlStr substringWithRange:NSMakeRange(urlStr.length-4, 4)];
    
    if([urlStr containsString:@"mayisale://mobile.task.manage.goBack"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    
    // 自动返回
    if ([lastStr isEqualToString:@"Back"]&&self.autoManageBack) {
        
        if([urlStr containsString:@"approvalList.goBack"]) // 特殊情况，这个需要直接pop回去而不是goback
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        if(self.webView.canGoBack) // 如果能返回上一级
        {
            [self.webView goBack];
        }
        else
        {
            [self.navigationController popToRootViewControllerAnimated:YES]; // 不能则pop回去
        }
        
        return NO;
    }
    else if ([actionType isEqualToString:@"goBack"]) // 不自动管理，也要拦截掉该事件防止报错
    {
        return NO;
    }
    else if([actionType isEqualToString:@"timeout"])
    {
        // 登录过期
        LoginViewController *LVC = [LoginViewController new];
        [self presentViewController:LVC animated:YES completion:^{

            [Hud showText:@"登录信息过期，请重新登录" withTime:2];
            
        }];
    }
    else if ([actionType isEqualToString:@"toAddDailyWork"]) // 添加工作日志
    {
        return NO;
    }
    else if ([actionType isEqualToString:@"toSign"]) // 签到
    {
        return NO;
    }
    else if([actionType isEqualToString:@"toPhoto"]) // 拍照
    {
        return NO;
    }
    else if([actionType isEqualToString:@"toReturnMenu"]) // 返回
    {
        return NO;
    }
    return YES;
}


-(void)requestUrl:(NSString *)url
{
    
}

-(void)callPhone:(NSString *)phoneNumber
{
    NSLog(@"打电话");
}

-(void)takePhotos
{
    NSLog(@"打开相机");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    MyLog(@"web加载出错：%@",[error localizedDescription]);
    self.navigationController.navigationBar.hidden = NO;
    [Hud stop];
    [Hud showText:@"网络错误"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)urlActionType:(NSString *)actionString
{
    
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:imagrPicker animated:YES completion:nil];
    });
    
    
    
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
                
//                [Hud showText:@"上传成功"];
//
//                NSDictionary *dict = responseObject[@"data"];
//                if(dict)
//                {
//
//                    NSString *remoteFileUrl = dict[@"data"][@"remoteFileUrl"];
//                    NSString *textJS = [NSString stringWithFormat:@"Hybrid.reciveUrl(\"%@\")",remoteFileUrl];
//                    [self.context evaluateScript:textJS];
//                }

                
                [Hud stop];
                
                MyLog(@"%@",responseObject);
                
                NSDictionary *dict = responseObject[@"data"];
                if(dict)
                {
                    NSString *remoteFileUrl = dict[@"data"][@"remoteFileUrl"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSString *textJS = [NSString stringWithFormat:@"Hybrid.reciveUrl(\"%@\")",remoteFileUrl];
                        [self.context evaluateScript:textJS];
                        
                    });
                }
                
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
