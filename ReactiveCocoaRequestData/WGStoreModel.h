//
//  wgStoreModel.h
//  YingXiaoGuanJia
//
//  Created by WuGuMoFang on 16/3/7.
//  Copyright © 2016年 wugumofang. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  "shopId": "4110027",
    "shopName": "欧尚上海南汇店"
 */
@interface WGStoreModel : NSObject
@property(nonatomic,copy)NSString * shopId;
@property(nonatomic,copy)NSString * shopName;
@property(nonatomic,copy)NSString *sid;
@property(nonatomic,assign)NSInteger state;  //1是选中状态
@end
