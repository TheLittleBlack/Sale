//
//  SDMajletView.h
//  SDMajletManagerDemo
//
//  Created by tianNanYiHao on 2017/5/26.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#pragma mark - 杉德子件View
#import <UIKit/UIKit.h>

typedef void(^SDMajletBlock)(NSMutableArray *inusesTitles);

@protocol SDMajletViewDelegate <NSObject>

-(void)newData:(NSMutableArray *)inUseTitles;

-(void)selectItem:(NSIndexPath *)indexPath;

@end

@interface SDMajletView : UIView

@property (nonatomic, strong) NSMutableArray *inUseTitles;

@property (nonatomic, weak)SDMajletBlock block;

@property(nonatomic,weak)id <SDMajletViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame;

 // 返回新数组
- (void)callBacktitlesBlock:(SDMajletBlock)block;



@end
