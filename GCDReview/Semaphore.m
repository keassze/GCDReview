//
//  Semaphore.m
//  GCDReview
//
//  Created by 何松泽 on 2018/2/26.
//  Copyright © 2018年 何松泽. All rights reserved.
//

#import "Semaphore.h"

@implementation Semaphore
{
    dispatch_semaphore_t semaphoreLock;
    int redPocketCount;
}

+ (instancetype)shareSemaphore {
    static Semaphore *semaphore;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        semaphore = [[Semaphore alloc] init];
    });
    return semaphore;
}

- (id)init {
    self = [super init];
    if (self) {
        NSLog(@"currentThread---%@",[NSThread currentThread]);
        
        semaphoreLock = dispatch_semaphore_create(1);
        
        redPocketCount = 20;
        
        dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_queue_t queue3 = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(queue1, ^{
            [weakSelf getPocketMoney];
        });
        
        dispatch_async(queue2, ^{
            [weakSelf getPocketMoney];
        });
        
        dispatch_async(queue3, ^{
            [weakSelf getPocketMoney];
        });
    }
    return self;
}

//抢红包
- (void)getPocketMoney {
    while (1) {
        
        //加锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        
        if (redPocketCount > 0) {
            [NSThread sleepForTimeInterval:0.5];
            
            redPocketCount --;
            NSLog(@"当前剩余红包数:%d====>%@",redPocketCount,[NSThread currentThread]);
        } else {
            NSLog(@"红包已被抢光了~剩余%d",redPocketCount);
            //解锁
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }
        //解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}

@end








