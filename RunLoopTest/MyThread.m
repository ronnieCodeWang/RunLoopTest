//
//  MyThread.m
//  RunLoopTest
//
//  Created by Sunell on 2018/11/22.
//  Copyright © 2018 Sunell. All rights reserved.
//

#import "MyThread.h"

@implementation MyThread

- (void)dealloc
{
    
    NSLog(@"%@子线程释放了",self.name);
}

@end
