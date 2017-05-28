//
//  BTLogin2ViewController.h
//  biketo
//
//  Created by Carroll on 16/3/9.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "BTRootViewController.h"

typedef void (^LoginSuccessBlock)();

@protocol BTLogin2VCProtocol <NSObject>

-(void)textFieldEditingDidBegin;
-(void)textFieldEditingDidEnd;

@end

@interface BTLogin2ViewController : BTRootViewController

//若app中操作需要登录，必须赋值
@property (nonatomic, copy) LoginSuccessBlock successBlock;

@property (nonatomic, weak) id <BTLogin2VCProtocol> delegate;

@end
