//
//  BTLogin2ThirdPartyLoginView.h
//  biketo
//
//  Created by Carroll on 16/3/25.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTLogin2ThirdPartyLoginViewProtocol <NSObject>

- (void)didTapWechatButton;
- (void)didTapQQButton;
- (void)didTapWeiboButton;

@end

@interface BTLogin2ThirdPartyLoginView : UIView

@property (nonatomic, weak) id<BTLogin2ThirdPartyLoginViewProtocol>delegate;

@end
