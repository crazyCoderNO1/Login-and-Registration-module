//
//  BTLogin2PasswdSettingViewController.h
//  biketo
//
//  Created by Carroll on 16/3/14.
//  Copyright © 2016年 MagicCycling Media Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTRootViewController.h"

@interface BTLogin2PasswdSettingViewController : BTRootViewController

@property (nonatomic, strong) NSMutableDictionary *VCParamters;

-(instancetype)initWithParamters:(NSDictionary *)params;

@end
