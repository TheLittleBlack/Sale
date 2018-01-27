//
//  ShowBigImageViewController.m
//  Mayi_sales_app
//
//  Created by JayJay on 2018/1/2.
//  Copyright © 2018年 JayJay. All rights reserved.
//

#import "ShowBigImageViewController.h"

@interface ShowBigImageViewController ()

@property(nonatomic,strong)UIImageView *imageView;

@end

@implementation ShowBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.and.mas_equalTo(ScreenWidth);
        make.left.equalTo(self.view);
        make.height.mas_equalTo(ScreenHeight/1.5);
        make.centerY.equalTo(self.view);
        
    }];
}

-(UIImageView *)imageView
{
    if(!_imageView)
    {
        _imageView = [UIImageView new];
        _imageView.image = self.image;
    }
    return _imageView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
