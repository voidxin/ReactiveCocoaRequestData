//
//  DetailViewModel.m
//  ReactiveCocoaRequestData
//
//  Created by voidxin on 16/6/14.
//  Copyright © 2016年 wugumofang. All rights reserved.
//

#import "DetailViewModel.h"
@interface DetailViewModel()
@property(nonatomic,strong)RACSignal *numberSignal;
@end
@implementation DetailViewModel
-(id)init{
    self=[super init];
    if (self) {
        [self initWithSubscrible];
    }
    return self;
}
-(void)initWithSubscrible{
    
}
- (RACSignal *)numberSignal{
    @weakify(self);
    if (!_numberSignal) {
        _numberSignal=[RACObserve(self, staffNumber) map:^id(NSString *text) {
            @strongify(self);
            return @([self valibleNumber:text]);
        }];
    }
    return _numberSignal;
}

- (RACCommand *)confirmCommand{
    if (!_confirmCommand) {
        _confirmCommand=[[RACCommand alloc]initWithEnabled:self.numberSignal signalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                [subscriber sendNext:self.staffNumber];
                [subscriber sendCompleted];
                return nil;
            }];
        }];
    }
    return _confirmCommand;
}

-(BOOL)valibleNumber:(NSString *)str{
    if (str.length>5) {
        return true;
    }
    return false;
}

@end
