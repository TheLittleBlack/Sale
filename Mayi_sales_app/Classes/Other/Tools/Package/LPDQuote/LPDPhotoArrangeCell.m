//
//  LPDPhotoArrangeCell.m
//  LPDQuoteSystemImagesController
//
//  Created by Assuner on 2016/12/16.
//  Copyright © 2016年 Assuner. All rights reserved.
//

#import "LPDPhotoArrangeCell.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>


#define DEL_BTN_WH  RELATIVE_VALUE(24)

@implementation LPDPhotoArrangeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        _imageThumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.lpd_width,self.lpd_height)];
        _imageThumbnail.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _imageThumbnail.contentMode = UIViewContentModeScaleToFill;
        _imageThumbnail.layer.cornerRadius = 4;
        _imageThumbnail.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
        _imageThumbnail.layer.borderWidth = 2;
        _imageThumbnail.clipsToBounds = YES;
        [self addSubview:_imageThumbnail];
        NSLog(@"%f!!!!",DEL_BTN_WH);
        
        _videoThumbnail = [[UIImageView alloc] init];

        [_videoThumbnail setImage:[UIImage imageNamedFromMyBundle:@"LPDVideoPreviewPlay"]];
        _videoThumbnail.contentMode = UIViewContentModeScaleToFill;
        _videoThumbnail.hidden = YES;
        [self addSubview:_videoThumbnail];
        
        _nookDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _nookDeleteBtn.frame = CGRectMake(self.frame.size.width-DEL_BTN_WH, 0, DEL_BTN_WH, DEL_BTN_WH);
        _nookDeleteBtn.imageEdgeInsets = UIEdgeInsetsMake(RELATIVE_VALUE(-12), 0, 0, RELATIVE_VALUE(-12));
        _nookDeleteBtn.alpha = 1.0;
        [_nookDeleteBtn setImage:[UIImage imageNamedFromMyBundle:@"nookDeleteBtn"] forState:UIControlStateNormal];
        [self addSubview:_nookDeleteBtn];
     
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    _imageThumbnail.frame = self.bounds;
    CGFloat width = self.frame.size.width/3;
    _videoThumbnail.frame = CGRectMake(width, width, width, width);
}

- (void)setAsset:(id)asset {
    _asset = asset;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        _videoThumbnail.hidden = (phAsset.mediaType != PHAssetMediaTypeVideo);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    } else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = asset;
        _videoThumbnail.hidden = ![[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
#pragma clang diagnostic pop
    }
}

- (void)setRow:(NSInteger)row {
    _row = row;
    _nookDeleteBtn.tag = row;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc] init];
    UIView *cellSnapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    
    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}

@end
