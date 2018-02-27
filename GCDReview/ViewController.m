//
//  ViewController.m
//  GCDReview
//
//  Created by 何松泽 on 2018/2/26.
//  Copyright © 2018年 何松泽. All rights reserved.
//

#import "ViewController.h"
#import "Semaphore.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*同步串行*/
//    [self sync_serial];
    
    /*同步并发*/
//    [self sync_concurrent];
    
    /*异步串行*/
//    [self async_serial];
    
    /*异步并发*/
//    [self asyns_concurrent];

    /*线程切换*/
//    [self threadChange];
    
    /*设置栅栏*/
//    [self barrier];
    
    /*延时操作*/
//    [self delay];
    
    /*一次性代码*/
//    [self run_once];
    
    /*迭代线程*/
//    [self run_apply];
    
    /*队列组*/
//    [self run_group];
    
    /*安全线程*/
    [Semaphore shareSemaphore];
}

#pragma mark - 同步串行
- (void)sync_serial {
    NSLog(@"%@==Begin in thread:%@",NSStringFromSelector(_cmd),[NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("sync_serial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"\n1、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"\n2、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 5; i++) {
            NSLog(@"\n3、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    NSLog(@"%@==End in thread:%@",NSStringFromSelector(_cmd),[NSThread currentThread]);
}

#pragma mark - 同步并行
- (void)sync_concurrent {
    NSLog(@"%@==Begin in thread:%@",NSStringFromSelector(_cmd),[NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("sync_concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"\n1、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"\n2、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    dispatch_sync(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"\n3、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    NSLog(@"%@==End in thread:%@",NSStringFromSelector(_cmd),[NSThread currentThread]);
}

#pragma mark - 异步串行
- (void)async_serial {
    NSLog(@"%@==Begin in thread:%@",NSStringFromSelector(_cmd),[NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("async_serial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"\n1、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"\n2、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"\n3、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    NSLog(@"%@==End in thread:%@",NSStringFromSelector(_cmd),[NSThread currentThread]);
}

#pragma mark - 异步并行
- (void)asyns_concurrent {
    NSLog(@"%@==Begin in thread:%@",NSStringFromSelector(_cmd),[NSThread currentThread]);
    
    dispatch_queue_t queue = dispatch_queue_create("asyns_concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"\n1、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"\n2、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        
        for (int i = 0; i < 2; i++) {
            NSLog(@"\n3、%@======>%@",[NSThread currentThread],NSStringFromSelector(_cmd));
        }
    });
    
    NSLog(@"%@==End in thread:%@",NSStringFromSelector(_cmd),[NSThread currentThread]);
}

#pragma mark - 线程切换（可用于请求数据以及UI刷新之间的转换）
- (void)threadChange {
    
    NSArray *countryArr = [[NSArray alloc] init];
    countryArr = @[@"美国",@"中国",@"刚果",@"日本"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        
        NSLog(@"我现在哪都不想去====>%@",[NSThread currentThread]);

        [NSThread sleepForTimeInterval:2];
        NSString *countryStr = countryArr[arc4random_uniform((int)countryArr.count)];
        
        dispatch_async(mainQueue, ^{
            
            [NSThread sleepForTimeInterval:1];
            
            NSLog(@"我要移民到:%@====>%@",countryStr,[NSThread currentThread]);
        });
    });
}

#pragma mark - 栅栏（可以分块按顺序的异步并发请求）
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("barrier", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"北京烤鸭吃法begin===>%@",[NSThread currentThread]);
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1、摊开面饼=====>%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"2、放入片皮鸭=====>%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"3、放入青瓜等配菜=====>%@",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"4、将面饼卷起来=====>%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"5、一口吃掉=====>%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"6、喝水=====>%@",[NSThread currentThread]);
    });
    NSLog(@"付钱end===>%@",[NSThread currentThread]);
}

#pragma mark - 延时操作（延时将任务加入队列，不保证立即处理）
- (void)delay {
    dispatch_queue_t queue = dispatch_queue_create("after", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"出发begin======>%@",[NSThread currentThread]);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"先到先点菜======>%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"吃小菜======>%@",[NSThread currentThread]);
    });
    
    dispatch_after((int64_t)(3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1、人到齐了=====>%@",[NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"2、动筷子啦=====>%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
       NSLog(@"3、吃肉=====>%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"4、喝椰汁=====>%@",[NSThread currentThread]);
    });
    
    NSLog(@"付钱end======>%@",[NSThread currentThread]);
}

#pragma mark - 一次性代码（block中代码只执行一遍，常用于创建单例）
- (void)run_once {
    static dispatch_once_t onceToken;
    
    for (int i = 0; i < 10; i++) {
        dispatch_once(&onceToken, ^{
            NSLog(@"我是一次性饭盒===>%@===>%p",[NSThread currentThread],&onceToken);
        });
    }
}

#pragma mark - 迭代（写for循环也可以，直接用这个代码可读性更强）
- (void)run_apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"点了三个墨西哥鸡肉卷%@",[NSThread currentThread]);
    dispatch_apply(3, queue, ^(size_t index) {
        [NSThread sleepForTimeInterval:0.5];
        
        NSLog(@"在吃第%zd个%@",index,[NSThread currentThread]);
    });
    NSLog(@"吃完了%@",[NSThread currentThread]);
}

#pragma mark - 队列组（常用，多接口请求非常实用）
- (void)run_group {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1、请求数据=====>%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2、请求数据=====>%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        dispatch_async(queue, ^{
            NSLog(@"将数据整合=====>%@",[NSThread currentThread]);
        });
        
        dispatch_barrier_async(queue, ^{
            NSLog(@"存储数据=====>%@",[NSThread currentThread]);
        });
        
        [NSThread sleepForTimeInterval:1];
        NSLog(@"接口请求完了，刷新UI");
    });
    
    //不完成别想下班（与notify同时进行）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"我先下班了=====>%@",[NSThread currentThread]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
