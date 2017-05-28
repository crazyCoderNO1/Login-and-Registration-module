//
//  BTLogin2Button.m
//  biketo
//
//  Created by Carroll on 16/3/11.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTLogin2Button.h"

@implementation BTLogin2Button

- (instancetype)initWithButtonType:(BTLogin2_ButtonType)type
{
    self = [super init];
    if (self) {
        [self configure];
        [self setButtonType:type];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = Iphone_4 ? 15.0f : 45.0f/2;
    
    [self setTitle:@"Submit" forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [self setFrame:CGRectMake(0, 0, 280/Screen_AutoScaleValue, 95/2)];
    
    [self setBackgroundColor:UIColorFromHex(0xFAA2A3)];
    [self setBackgroundImage:[BTLogin2Button imageWithColor:[UIColor red_0xf84646]] forState:UIControlStateSelected];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(280/Screen_AutoScaleValue));
        make.height.equalTo(@(90/Screen_AutoScaleValue));
    }];
}

#pragma mark - Properties

-(void)setTextTips:(NSString *)textTips
{
    [self setTitle:textTips forState:UIControlStateNormal];
}

-(void)setButtonType:(BTLogin2_ButtonType)type
{
    switch (type) {
            
         // 带边框黑字体
        case ButtonType_HaveBorde_BlackFontColor:
        {
            [self setTitleColor:RGB(122, 122, 122) forState:UIControlStateNormal];
            [self setTitleColor:Common_LightGray_Color forState:UIControlStateHighlighted];
        }
            break;
            
        // 带边框白字体
        case ButtonType_HaveBorde_WhiteFontColor:
        {
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:Common_LightGray_Color forState:UIControlStateHighlighted];
        }
            break;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = RGB(227, 227, 227).CGColor;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
