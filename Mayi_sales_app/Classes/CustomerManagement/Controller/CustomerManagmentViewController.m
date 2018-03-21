//
//  CustomerManagmentViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/24.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "CustomerManagmentViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface CustomerManagmentViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)NSString *cloudId;
@property(nonatomic,strong)NSString *cloudNo;

@end

@implementation CustomerManagmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    MyLog(@"加载完成");
    [Hud stop];

    
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"saveCustomerPhoto"] = ^(){

        NSArray *args = [JSContext currentArguments];
        
        self.cloudId = args[0];
        self.cloudNo = args[1];
        
        MyLog(@"%@,%@",[args[0] toString],[args[1] toString]);
        
    };
    
}


-(void)urlActionType:(NSString *)actionString
{
    if([actionString isEqualToString:@"toReturnMenu"])
    {

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    if([actionString isEqualToString:@"toPhoto"])
    {
        
        [self openCamera];
       
    }
    
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
                NSDictionary *dict = responseObject[@"data"];
                if(dict)
                {
                    
                    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:SaveCustomerPhoto] withPrameters:@{@"url":dict[@"data"][@"remoteFileUrl"],@"cloudId":self.cloudId,@"cloudNo":self.cloudNo} result:^(id result) {
                        
                        [Hud showText:@"插入图片成功"];
                        
                    } error:^(id error) {
                        
                    } withHUD:YES];
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
