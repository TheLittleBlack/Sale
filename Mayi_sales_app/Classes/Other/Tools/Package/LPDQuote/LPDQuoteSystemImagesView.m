//
//  LPDQuoteSystemImagesView.m
//  LPDQuoteSystemImagesController
//
//  Created by Assuner on 2016/12/16.
//  Copyright © 2016年 Assuner. All rights reserved.
//

#import "LPDQuoteSystemImagesView.h"
#import "ShowBigImageViewController.h"
#import "UIImageView+WebCache.h"

@interface LPDQuoteSystemImagesView ()<LPDImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

{
    CGFloat _itemWH;
    NSMutableArray *_models;
};

//@property (assign, nonatomic) BOOL isSelectOriginalPhoto;            ///是否选了原图

@property (assign, nonatomic) NSUInteger countPerRowInView;           ///view每行照片数

@property (assign, nonatomic) CGFloat margin;                         ///已选图片页面Cell的间距
@property (assign, nonatomic) UIEdgeInsets contentInsets;             ///collectionView的edge配置

@property (strong, nonatomic) UIImagePickerController *imagePickerVc; ///系统的picker，调用相机

@end

@implementation LPDQuoteSystemImagesView

- (instancetype)initWithFrame:(CGRect)frame withCountPerRowInView:(NSUInteger)ArrangeCount cellMargin:(CGFloat)cellMargin{
    if(self = [super initWithFrame: frame]){
        self.backgroundColor = [UIColor whiteColor];
        _selectedPhotos = [[NSMutableArray alloc] init];
        _selectedAssets = [[NSMutableArray alloc] init];
        _xiaoHeiImageArray = [NSMutableArray new];
        
        _maxSelectedCount = 9;
        _countPerRowInView = 5;
        _countPerRowInAlbum = 4;
        _margin = 12;
        _contentInsets = UIEdgeInsetsMake(12, 4, 12, 8);
        
        if(ArrangeCount > 0){
            _countPerRowInView = ArrangeCount;
        }
        
        if(cellMargin > 0){
            _margin = cellMargin;
            _contentInsets = UIEdgeInsetsMake(10, _margin/2-2, 0, _margin/2+2);
        }
        
        [self configCollectionView];
        }
    return self;
}


- (UIImagePickerController *)imagePickerVc {///系统的picker，可调用相机
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        
        UIBarButtonItem *lpdBarItem, *BarItem;
        if (iOS9Later) {
            lpdBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[LPDImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            lpdBarItem = [UIBarButtonItem appearanceWhenContainedIn:[LPDImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [lpdBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    /**********LPDPhotoArrangeCVlLayout******** 拖动排序用这个**********************/
    
    _itemWH = self.lpd_width / _countPerRowInView - _margin;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 水平滚动
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.lpd_width, self.lpd_height) collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.contentInset = _contentInsets;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[LPDPhotoArrangeCell class] forCellWithReuseIdentifier:@"LPDPhotoArrangeCell"];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.xiaoHeiImageArray.count < _maxSelectedCount) {
    return self.xiaoHeiImageArray.count + 1;
    }else {
    return self.xiaoHeiImageArray.count  ;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LPDPhotoArrangeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LPDPhotoArrangeCell" forIndexPath:indexPath];
    cell.videoThumbnail.hidden = YES;
    if(self.xiaoHeiImageArray.count<_maxSelectedCount) {
      if (indexPath.row == self.xiaoHeiImageArray.count) {
          
        [cell.imageThumbnail setImage:[UIImage imageNamed:@"camera_press"]];
        cell.imageThumbnail.layer.borderWidth = 1;
        cell.nookDeleteBtn.hidden = YES;
       
      } else {
          
          if( [self.xiaoHeiImageArray[indexPath.row] isKindOfClass:[UIImage class]] )
          {
              cell.imageThumbnail.image = self.xiaoHeiImageArray[indexPath.row];
          }
          else if ([self.xiaoHeiImageArray[indexPath.row] isKindOfClass:[NSString class]])
          {
              [cell.imageThumbnail sd_setImageWithURL:[NSURL URLWithString:self.xiaoHeiImageArray[indexPath.row]]];
          }
        
        cell.imageThumbnail.layer.borderWidth = 0;
        cell.nookDeleteBtn.hidden = NO;
        
        }
    }else {
        
        if( [self.xiaoHeiImageArray[indexPath.row] isKindOfClass:[UIImage class]] )
        {
            cell.imageThumbnail.image = self.xiaoHeiImageArray[indexPath.row];
        }
        else if ([self.xiaoHeiImageArray[indexPath.row] isKindOfClass:[NSString class]])
        {
            [cell.imageThumbnail sd_setImageWithURL:[NSURL URLWithString:self.xiaoHeiImageArray[indexPath.row]]];
        }
        
        cell.imageThumbnail.layer.borderWidth = 0;
        cell.nookDeleteBtn.hidden = NO;
    }
     cell.nookDeleteBtn.tag = indexPath.row;
     [cell.nookDeleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
   
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.sessionNumber = indexPath.row;
    
    if (indexPath.row == self.xiaoHeiImageArray.count) {
       
       [self pushImagePickerController];
        
    } else { //预览照片
        
      
        
        ShowBigImageViewController *SBVC = [ShowBigImageViewController new];
        SBVC.image = self.xiaoHeiImageArray[indexPath.row];
        [self.navcDelegate presentViewController:SBVC animated:YES completion:nil];
        
//        LPDImagePickerController *selectImagePickerVc = [[LPDImagePickerController alloc] initWithSelectedAssets:nil selectedPhotos:self.xiaoHeiImageArray index:indexPath.row];
//        selectImagePickerVc.maxImagesCount = _maxSelectedCount;
//        selectImagePickerVc.allowPickingOriginalPhoto = NO;
//
//        [selectImagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//            self.xiaoHeiImageArray = [NSMutableArray arrayWithArray:photos];
//            [_collectionView reloadData];
//            _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
//        }];
//        [self.navcDelegate presentViewController:selectImagePickerVc animated:YES completion:nil];
        
    }
}

#pragma mark - LPDPhotoArrangeCVDataSource

/// 长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < self.xiaoHeiImageArray.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < self.xiaoHeiImageArray.count && destinationIndexPath.item < self.xiaoHeiImageArray.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = self.xiaoHeiImageArray[sourceIndexPath.item];
    [self.xiaoHeiImageArray removeObjectAtIndex:sourceIndexPath.item];
    [self.xiaoHeiImageArray insertObject:image atIndex:destinationIndexPath.item];
    
//    id asset = _selectedAssets[sourceIndexPath.item];
//    [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
//    [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
    
    [_collectionView reloadData];
}
// 根据本项目需求，移除从相册选择照片功能，改为直接打开相机
- (void)pushImagePickerController {
   
    [self takePhoto];
    
//    LPDImagePickerController *lpdImagePickerVc = [[LPDImagePickerController alloc] initWithMaxImagesCount:self.maxSelectedCount columnNumber:self.countPerRowInAlbum delegate:self pushPhotoPickerVc:YES];
//
//    lpdImagePickerVc.allowPickingVideo = NO;
//    lpdImagePickerVc.allowPickingOriginalPhoto = NO;
//    lpdImagePickerVc.sortAscendingByModificationDate = NO;
//
//    if (self.maxSelectedCount > 1) {
//        // 设置目前已经选中的图片数组去初始化picker
//        lpdImagePickerVc.selectedAssets = _selectedAssets;
//        lpdImagePickerVc.showSelectBtn = NO;
//
//    }else {
//        lpdImagePickerVc.showSelectBtn = YES;
//    }
//
//    [self.navcDelegate presentViewController:lpdImagePickerVc animated:NO completion:nil];
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self.navcDelegate presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    
    if(self.navcDelegate && [self.navcDelegate respondsToSelector:@selector(doAfterDidSelectedPhotosWithView:andNumberOf:andClickSessionNumber:withImage:)]){
        [self.navcDelegate doAfterDidSelectedPhotosWithView:self andNumberOf:self.theNumber andClickSessionNumber:self.sessionNumber withImage:image];
    }
    

}

//- (void)reloadPhotoArray {
//
//    [[LPDImageManager manager] getCameraRollAlbum:lpdImagePickerVc.allowPickingVideo allowPickingImage:lpdImagePickerVc.allowPickingImage completion:^(LPDAlbumModel *model) {
//        _model = model;
//        [[LPDImageManager manager] getAssetsFromFetchResult:_model.result allowPickingVideo:lpdImagePickerVc.allowPickingVideo allowPickingImage:lpdImagePickerVc.allowPickingImage completion:^(NSArray<LPDAssetModel *> *models) {
//            [lpdImagePickerVc hideProgressHUD];
//
//            LPDAssetModel *assetModel;
//            if (lpdImagePickerVc.sortAscendingByModificationDate) {
//                assetModel = [models lastObject];
//                [_models addObject:assetModel];
//            } else {
//                assetModel = [models firstObject];
//                [_models insertObject:assetModel atIndex:0];
//            }
//
//            if (lpdImagePickerVc.maxImagesCount <= 1) {
//
//                [lpdImagePickerVc.selectedModels addObject:assetModel];
//                [self doneButtonClick];
//
//                return;
//            }
//
//            if (lpdImagePickerVc.selectedModels.count < lpdImagePickerVc.maxImagesCount) {
//                assetModel.isSelected = YES;
//                [lpdImagePickerVc.selectedModels addObject:assetModel];
//                [self refreshBottomToolBarStatus];
//            }
//            [_collectionView reloadData];
//
//            _shouldScrollToBottom = YES;
//            [self scrollCollectionViewToBottom];
//        }];
//    }];
//}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
//    [_selectedAssets addObject:asset];
    [self.xiaoHeiImageArray addObject:image];
    [_collectionView reloadData];
   
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}



#pragma mark - LPDImagePickerControllerDelegate


/// 用户点击了取消 代理
- (void)lpd_imagePickerControllerDidCancel:(LPDImagePickerController *)picker {
     NSLog(@"cancel");
}






// 用不到



// lpdImagePicker每次选照片后的保存和更新操作
//- (void)imagePickerController:(LPDImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
//    _selectedAssets = [NSMutableArray arrayWithArray:assets];
//
//    [_collectionView reloadData];
//
//    if(self.navcDelegate && [self.navcDelegate respondsToSelector:@selector(doAfterDidSelectedPhotosWithView:andNumberOf:andClickSessionNumber:)]){
//        [self.navcDelegate doAfterDidSelectedPhotosWithView:self andNumberOf:self.theNumber andClickSessionNumber:self.sessionNumber];
//    }
//
//    //test**********[self printAssetsName:assets];
//}

// 选择了一个视频的代理方法
- (void)imagePickerController:(LPDImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    
    /*************** 打开这段代码发送视频
     [[LPDImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
     NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    }]; ***********************/
    
   [_collectionView reloadData];
}





#pragma mark - DeleteBtn
- (void)deleteBtnClik:(UIButton *)sender {
    [self.xiaoHeiImageArray removeObjectAtIndex:sender.tag];
//    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    if(self.xiaoHeiImageArray.count == _maxSelectedCount - 1){
        [_collectionView reloadData];
    }else{
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
    }
    
    
    if(self.navcDelegate && [self.navcDelegate respondsToSelector:@selector(delectButtonActionOfNumber:andSessionNumber:)]){
        [self.navcDelegate delectButtonActionOfNumber:self.theNumber andSessionNumber:sender.tag];
    }
    
    
}

/// 打印图片名字test
/**- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        NSLog(@"图片名字:%@",fileName);
    }
}**/

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
