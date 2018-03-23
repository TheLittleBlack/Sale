//
//  VisitCaseViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/21.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "VisitCaseViewController.h"
#import "UIButton+WebCache.h"
#import "LPDQuoteSystemImagesView.h"
#define TextFieldHeight ScreenHeight/4

@interface VisitCaseViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LPDQuoteSystemImagesViewDelegate>

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)LPDQuoteSystemImagesView *imageView;
@property(nonatomic,strong)NSMutableArray *imageViewArray;

@end

@implementation VisitCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageViewArray = [NSMutableArray new];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"拜访情况";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(commit)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    
    [self.view addSubview:self.textView];
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(TextFieldHeight);
        make.top.equalTo(self.view).with.offset(64+10);
        
    }];
    

    
    [self.view addSubview:self.imageView];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.textView.mas_bottom).offset(20);
        make.width.mas_equalTo(ScreenWidth-30);
        make.height.mas_equalTo(100);
        
    }];


    
    
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
        NSDictionary *worklogDic = self.visitData[@"worklog"];
        NSArray *array = [NSArray array];
        NSMutableArray *imageViewDownload = [NSMutableArray array];
        if(worklogDic && ![worklogDic isEqual:[NSNull null]])
        {
            array = worklogDic[@"photos"];
        }
        if(array.count>0)
        {
            for (int i=0; i<array.count; i++) {
                NSDictionary *photo = array[i];
                [imageViewDownload addObject:photo[@"pathUrl"]];
                [self.imageViewArray addObject:photo[@"url"]];
            }
            _imageView.xiaoHeiImageArray = [NSMutableArray arrayWithArray:imageViewDownload]; // 如果一开始就有图片
        }
    }
    return _imageView;
}

-(UITextView *)textView
{
    if(!_textView)
    {
        _textView = [UITextView new];
        _textView.layer.borderColor = [UIColor colorWithWhite:210/255.0 alpha:1].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.font = [UIFont systemFontOfSize:16];
        NSDictionary *worklogDic = self.visitData[@"worklog"];
        if(_saveLogContent) // 保存在本地的
        {
            _textView.text = _saveLogContent;
            _textView.textColor = [UIColor blackColor];
        }
        else if(worklogDic&& ![worklogDic isEqual:[NSNull null]]) // 从网络数据获取
        {
            _textView.text = worklogDic[@"logContent"];
            _textView.textColor = [UIColor blackColor];
        }
        else   // 没有则显示默认值
        {
            _textView.text = @"记录本次工作的日志";
            _textView.textColor = [UIColor colorWithWhite:210/255.0 alpha:1];
        }
        
        _textView.delegate = self;
    }
    return _textView;
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"记录本次工作的日志";
        textView.textColor = [UIColor colorWithWhite:210/255.0 alpha:1];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"记录本次工作的日志"]){
        textView.text=@"";
    }
    
    textView.textColor=[UIColor blackColor];
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)commit
{
    if([self.textView.text isEqualToString:@"记录本次工作的日志"]||!self.textView.text)
    {
        [Hud showText:@"请填写工作日志"];
    }
    else
    {
        NSDictionary *dic;
        if(self.imageViewArray.count>0)
        {
            dic = @{@"logContent":self.textView.text,@"type":@"2",@"cloudId":self.visitID,@"urls":self.imageViewArray,@"userId":[MYManage defaultManager].ID};
        }
        else
        {
            dic = @{@"logContent":self.textView.text,@"type":@"2",@"cloudId":self.visitID,@"userId":[MYManage defaultManager].ID};
        }
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *DicString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:SaveVisit] withPrameters:@{@"workLog":DicString} result:^(id result) {
            
            MyLog(@"完成");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitConclusionSaveSuccess" object:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            [Hud showText:@"提交成功"];
            
            
        } error:^(id error) {
            
        } withHUD:YES];
    }
    
    
    
    
    
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





@end

