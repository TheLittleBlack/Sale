//
//  LoginTextFieldView.h
//  RisingClouds
//
//  Created by JianRen on 17/12/4.
//  Copyright © 2017年 伟健. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginTextFieldViewDelegate <NSObject>

-(void)showButtonAction:(UIButton *)sender;

@end

@interface LoginTextFieldView : UIView

@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,weak)id <LoginTextFieldViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame andTitleString:(NSString *)titleString andPlaceholderString:(NSString *)placeholderString andRightClearButton:(BOOL)clearButton andShowPasswordButton:(BOOL)showPasswordButton isNumberKeyboard:(BOOL)isNumberKeyboard haveVerificationCode:(BOOL)haveVerificationCode;

@end
