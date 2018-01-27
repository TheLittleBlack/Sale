//
//  UIImage+MyBundle.m
//  LPDQuoteSystemImagesController
//
//  Created by 李永光－饿了么－iOS开发 on 2016/12/19.
//  Copyright © 2016年 李永光－饿了么－iOS开发. All rights reserved.
//

#import "UIImage+MyBundle.h"

@implementation UIImage (MyBundle)

+ (UIImage *)imageNamedFromMyBundle:(NSString *)name {
    UIImage *image = [UIImage imageNamed:[@"LPDImagePickerController.bundle" stringByAppendingPathComponent:name]];
    if (image) {
        return image;
    } else {
        image = [UIImage imageNamed:[@"Frameworks/LPDImagePickerController.framework/LPDImagePickerController.bundle" stringByAppendingPathComponent:name]];
        if (!image) {
            image = [UIImage imageNamed:name];
        }
        return image;
    }
}
@end
