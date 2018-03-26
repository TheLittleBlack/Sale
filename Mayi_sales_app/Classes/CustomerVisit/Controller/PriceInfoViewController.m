//
//  PriceInfoViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/3/22.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "PriceInfoViewController.h"
#import "ScanQRCodeViewController.h"

@interface PriceInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation PriceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}


-(void)urlActionType:(NSString *)actionString
{
    if([actionString isEqualToString:@"goBack"])
    {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"打开相机");
            
            [self openCamera];
            
        });
        
    };
    
    context[@"scanCode"] = ^(){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"扫描二维码");
            
            ScanQRCodeViewController *SQRC = [ScanQRCodeViewController new];
            UINavigationController *NVC = [[UINavigationController alloc]initWithRootViewController:SQRC];
            [self presentViewController:NVC animated:YES completion:^{
                
            }];
            
            
        });
        
        
    };
    
    context[@"callPhone"] = ^(){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"打电话");
            
            NSArray *args = [JSContext currentArguments];
            
            NSString *phoneNumber = args[0];
            
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
            
            
            
        });
        
    };
    
    
    
    
//    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//
//    NSDictionary *testDic = @{@"locations":locations};
//    // 字典转字符串 并过滤掉空格及换行符
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:testDic options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *DicString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    DicString = [DicString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    DicString = [DicString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//    DicString = [DicString stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//
//
//    NSString *textJS = [NSString stringWithFormat:@"Hybrid.reciveUrl(%@)",DicString];
    
    
    
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
            NSData *data = UIImageJPEGRepresentation(image,0.0001);
            //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
            [formData appendPartWithFileData:data name:@"dataFile" fileName:@"file.jpeg" mimeType:@"image/jpeg"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            MyLog(@"uploadProgress = %@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [Hud stop];
            
            MyLog(@"%@",responseObject);
            

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            [Hud stop];
            
            [Hud showText:@"网络出错，请重新上传"];
            
            MyLog(@"error = %@",error);
        }];
        
    }];
}




@end
