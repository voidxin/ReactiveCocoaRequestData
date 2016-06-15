//
//  DetailViewModel.h
//  ReactiveCocoaRequestData
//
//  Created by voidxin on 16/6/14.
//  Copyright © 2016年 wugumofang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
@interface DetailViewModel : NSObject
@property(nonatomic,strong)RACCommand *confirmCommand;
@property(nonatomic,strong)NSString *staffNumber;
@end
