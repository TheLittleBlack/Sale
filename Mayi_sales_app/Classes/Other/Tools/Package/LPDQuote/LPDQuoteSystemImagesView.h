//
//  LPDQuoteSystemImagesView.h
//  LPDQuoteSystemImagesController
//
//  Created by Assuner on 2016/12/16.
//  Copyright © 2016年 Assuner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPDPhotoArrangeCell.h"
#import "LPDPhotoArrangeCVlLayout.h"


#import "LPDImagePickerController.h"
#import "UIView+HandyValue.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "LPDImageManager.h"
#import "LPDVideoPlayerController.h"
#import "LPDPhotoPreviewController.h"

@protocol LPDQuoteSystemImagesViewDelegate <NSObject>
@optional

- (void)doAfterDidSelectedPhotosWithView:(LPDQuoteSystemImagesView *)thisView andNumberOf:(NSInteger )number andClickSessionNumber:(NSInteger )sessionNumber withImage:(UIImage *)image;

- (void)delectButtonActionOfNumber:(NSInteger )number andSessionNumber:(NSInteger)sessionNumber;

@end

@interface LPDQuoteSystemImagesView : UIView

@property(strong, nonatomic) LPDImagePickerController *lpdImagePickerVc;

@property(nonatomic,strong)NSMutableArray *xiaoHeiImageArray;

@property (assign, nonatomic) NSUInteger maxSelectedCount;       ///最大可选照片数
@property (assign, nonatomic) NSUInteger countPerRowInAlbum;     ///相册每行照片数

@property (assign, nonatomic) BOOL isShowTakePhotoSheet;         ///是否弹出拍照 图库Sheet

@property (strong, nonatomic) NSMutableArray *selectedPhotos;    ///选中的照片 UIImage数组 可copy
@property (strong, nonatomic) NSMutableArray *selectedAssets;    ///需要用到的模型数组

@property (strong, nonatomic) UICollectionView *collectionView;  ///选中图片排列集合view

@property(nonatomic,assign)NSInteger theNumber; // 当存在多个类时，用于记录鉴别

@property(nonatomic,assign)NSInteger sessionNumber; // 如果这个类有多个图片占位，用它来得知我们刚才点击的是哪一个图片

@property(nonatomic,assign)BOOL qianMian;

@property (weak, nonatomic) UIViewController<LPDQuoteSystemImagesViewDelegate>* navcDelegate;

- (instancetype)initWithFrame:(CGRect)frame withCountPerRowInView:(NSUInteger)ArrangeCount cellMargin:(CGFloat)cellMargin;

@end
