//
//  BTLogin2Button.h
//  biketo
//
//  Created by Carroll on 16/3/11.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BTLogin2_ButtonType) {
    ButtonType_HaveBorde_BlackFontColor, //带灰边框黑字体
    ButtonType_HaveBorde_WhiteFontColor //带灰边框白字体
};

@interface BTLogin2Button : UIButton

@property (nonatomic, strong) NSString *textTips;

- (instancetype)initWithButtonType:(BTLogin2_ButtonType)type;

+ (UIImage *)imageWithColor:(UIColor *)color;

@end
