//
//  BTLogin2RegisterViewController.h
//  biketo
//
//  Created by Carroll on 16/3/11.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import "ViewController.h"
#import "BTRootViewController.h"

@protocol BTRegist2VCProtocol <NSObject>

-(void)textFieldEditingDidBegin;
-(void)textFieldEditingDidEnd;

@end

@interface BTLogin2RegisterViewController : BTRootViewController

@property (nonatomic, weak) id <BTRegist2VCProtocol> delegate;


@end
