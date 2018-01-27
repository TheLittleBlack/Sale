//
//  PhotoViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2017/12/22.
//  Copyright © 2017年 JayJay. All rights reserved.
//

#import "PhotoViewController.h"
#import "LPDQuoteSystemImagesView.h"
#import "UIImageView+WebCache.h"

@interface PhotoViewController ()<LPDQuoteSystemImagesViewDelegate>

{
    NSInteger _currentUploadNumber;
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)LPDQuoteSystemImagesView *menTouZhao;
@property(nonatomic,strong)LPDQuoteSystemImagesView *chenLieZhao;
@property(nonatomic,strong)LPDQuoteSystemImagesView *ZiPaiZhao;
@property(nonatomic,strong)NSMutableArray *menTouZhaoArray;
@property(nonatomic,strong)NSMutableArray *chenLieZhaoArray;
@property(nonatomic,strong)NSMutableArray *ziPaiZhaoArray;

@property(nonatomic,strong)NSMutableArray *menTouZhaoArrayDownload;
@property(nonatomic,strong)NSMutableArray *chenLieZhaoArrayDownload;
@property(nonatomic,strong)NSMutableArray *ziPaiZhaoArrayDownload;


@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _currentUploadNumber = 0;
    
    self.ziPaiZhaoArray = [NSMutableArray new];
    self.menTouZhaoArray = [NSMutableArray new];
    self.chenLieZhaoArray = [NSMutableArray new];
    self.ziPaiZhaoArrayDownload = [NSMutableArray new];
    self.menTouZhaoArrayDownload = [NSMutableArray new];
    self.chenLieZhaoArrayDownload = [NSMutableArray new];
    
    NSArray *photoArray = self.visitData[@"photoInfos"];
    
    MyLog(@"%@",photoArray);
    
    if(photoArray.count>0)
    {
        for (int i=0; i<photoArray.count; i++) {

            NSDictionary *photoData = photoArray[i];
            if([photoData[@"type"] integerValue]==1) // 下载自拍照
            {
                
                [self.ziPaiZhaoArrayDownload addObject:photoData[@"pathUrl"]];
                [self.ziPaiZhaoArray addObject:photoData[@"url"]];
            }
            if([photoData[@"type"] integerValue]==2) // 下载门头照
            {
                
                [self.menTouZhaoArrayDownload addObject:photoData[@"pathUrl"]];
                [self.menTouZhaoArray addObject:photoData[@"url"]];
            }
            if([photoData[@"type"] integerValue]==3) // 下载自陈列照
            {
                
                [self.chenLieZhaoArrayDownload addObject:photoData[@"pathUrl"]];
                [self.chenLieZhaoArray addObject:photoData[@"url"]];
            }

        }
    }


    
    
//    NSDictionary *imageData = [[NSUserDefaults standardUserDefaults] valueForKey:@"ImageCache"];
//    if(imageData)
//    {
//        self.menTouZhaoArray = [NSMutableArray arrayWithArray:imageData[@"menTou"]];
//        self.chenLieZhaoArray = [NSMutableArray arrayWithArray:imageData[@"menTui"]];
//        self.chanPinChenLieArray = [NSMutableArray arrayWithArray:imageData[@"cahnPin"]];
//        self.xuanChuanWuLiaoArray = [NSMutableArray arrayWithArray:imageData[@"xuanChuan"]];
//        self.diWeiArray = [NSMutableArray arrayWithArray:imageData[@"diTui"]];
//        self.ziPaiZhaoArray = [NSMutableArray arrayWithArray:imageData[@"ziPai"]];
//    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"照片";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"icon_fanghui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.and.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        
    }];
    
 
    
    [self addPhotoSelectPackageWithTitle:@"*自拍照" top:15 maxPhotoNum:5 WithLPDQuoteSystemImagesView:self.ZiPaiZhao andNumber:2 underLine:YES withDownloadImageArray:self.ziPaiZhaoArrayDownload];
    
    [self addPhotoSelectPackageWithTitle:@"*门头照" top:15+134 maxPhotoNum:5 WithLPDQuoteSystemImagesView:self.menTouZhao andNumber:0 underLine:YES withDownloadImageArray:self.menTouZhaoArrayDownload];

    [self addPhotoSelectPackageWithTitle:@"*陈列照" top:15+134*2 maxPhotoNum:5 WithLPDQuoteSystemImagesView:self.chenLieZhao andNumber:1 underLine:NO withDownloadImageArray:self.chenLieZhaoArrayDownload];


    
}

-(void)addPhotoSelectPackageWithTitle:(NSString *)title top:(NSInteger )top maxPhotoNum:(NSInteger )maxNum WithLPDQuoteSystemImagesView:(LPDQuoteSystemImagesView *)ImagesView andNumber:(NSInteger)number underLine:(BOOL)underLine withDownloadImageArray:(NSArray *)array
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = title ;
    [self.scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.scrollView).offset(17);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(ScreenWidth);
        make.top.mas_equalTo(top);
        
    }];
    
    //设置大小 每行多少个预览图 间距
    ImagesView = [[LPDQuoteSystemImagesView alloc] initWithFrame:CGRectMake(15, top+15, ScreenWidth-30, 100) withCountPerRowInView:4 cellMargin:12];
    //设置选择图片的最大数值
    ImagesView.maxSelectedCount = maxNum;
    //是否可滚动
    ImagesView.collectionView.scrollEnabled = YES;
    //添加代理
    ImagesView.navcDelegate = self;
    ImagesView.theNumber = number;
    if(array.count>0)
    {
        ImagesView.xiaoHeiImageArray = [NSMutableArray arrayWithArray:array]; // 如果一开始就有图片
    }
    
    [self.scrollView addSubview:ImagesView];
    
    if(underLine)
    {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, top+15+100+5, ScreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:230/255.0 alpha:1];
        [self.scrollView addSubview:lineView];
    }


    
}


////获取所选择的图片
//_imageArray = _quoteSystemImagesView.selectedPhotos;

-(UIScrollView *)scrollView
{
    if(!_scrollView)
    {
        _scrollView = [UIScrollView new];
        _scrollView.contentSize = CGSizeMake(ScreenWidth,ScreenHeight-64);
    }
    return _scrollView;
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)finish
{
    
    if(self.ziPaiZhaoArray.count==0||self.menTouZhaoArray.count==0||self.chenLieZhaoArray.count==0)
    {
        [Hud showText:@"请补全照片信息"];
        return;
    }

    MyLog(@"完成\n");
    MyLog(@"所有的图片路径\n:%@\n,%@\n,%@\n",self.menTouZhaoArray,self.chenLieZhaoArray,self.ziPaiZhaoArray);
    
    NSMutableArray *photoInfo = [NSMutableArray new];
    NSString *cloudId = self.visitID;
    NSString *userId = [MYManage defaultManager].ID;
    NSString *latitude = @"0";
    NSString *longitude = @"0";
    
    
    if(self.menTouZhaoArray.count>0)
    {
        for (NSString *imageUrl in self.menTouZhaoArray) {
            NSDictionary *info = @{@"cloudId":cloudId,@"latitude":latitude,@"longitude":longitude,@"type":@"2",@"url":imageUrl,@"userId":userId};
            [photoInfo addObject:info];
        }
    }
    
    if(self.chenLieZhaoArray.count>0)
    {
        for (NSString *imageUrl in self.chenLieZhaoArray) {
            NSDictionary *info = @{@"cloudId":cloudId,@"latitude":latitude,@"longitude":longitude,@"type":@"3",@"url":imageUrl,@"userId":userId};
            [photoInfo addObject:info];
        }
    }
    
    if(self.ziPaiZhaoArray.count>0)
    {
        for (NSString *imageUrl in self.ziPaiZhaoArray) {
            NSDictionary *info = @{@"cloudId":cloudId,@"latitude":latitude,@"longitude":longitude,@"type":@"1",@"url":imageUrl,@"userId":userId};
            [photoInfo addObject:info];
        }

    }
    
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:photoInfo options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *DicString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    [MyNetworkRequest postRequestWithUrl:[MayiURLManage MayiURLManageWithURL:SaveImage] withPrameters:@{@"photoInfo":DicString} result:^(id result) {
        
        if([result[@"code"] integerValue] == 200)
        {
         
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VisitPhotoUploadSuccess" object:self];
            [self.navigationController popViewControllerAnimated:YES];
            [Hud showText:@"保存成功"];

        }
        
        
    } error:^(id error) {
        
    } withHUD:YES];
    

    
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
    
    if(number==0) // 门头照
    {
        [self.menTouZhaoArray removeObjectAtIndex:sessionNumber];
    }
    else if (number==1) // 陈列照
    {
        [self.chenLieZhaoArray removeObjectAtIndex:sessionNumber];
    }
    else if (number==2) // 自拍照
    {
        [self.ziPaiZhaoArray removeObjectAtIndex:sessionNumber];
    }
    
 

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
        NSData *data = UIImageJPEGRepresentation(image,0.3);
        //第一个代表文件转换后data数据，第二个代表图片的名字，第三个代表图片放入文件夹的名字，第四个代表文件的类型
        [formData appendPartWithFileData:data name:@"dataFile" fileName:@"file.jpeg" mimeType:@"image/jpeg"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        MyLog(@"uploadProgress = %@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [collectionView.xiaoHeiImageArray addObject:image];
        
        [collectionView.collectionView reloadData];
    
        _currentUploadNumber++;
        
        NSString *imageUrl = responseObject[@"data"][@"data"][@"remoteFileUrl"];
        MyLog(@"%@",responseObject[@"data"][@"data"][@"imgUrl"]);
        
        if(number==0) // 门头照
        {
            [self.menTouZhaoArray addObject:imageUrl];
        }
        else if (number==1) // 陈列照
        {
            [self.chenLieZhaoArray addObject:imageUrl];
        }
        else if (number==2) // 自拍照
        {
            [self.ziPaiZhaoArray addObject:imageUrl];
        }
        
        
        
 
        [Hud stop];
        [Hud showText:[NSString stringWithFormat:@"上传成功"] withTime:2];
        _currentUploadNumber = 0;
        MyLog(@"%@",self.ziPaiZhaoArray);
            

        
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
