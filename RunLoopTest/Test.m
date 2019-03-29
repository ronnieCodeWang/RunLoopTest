//
//  Test.m
//  RunLoopTest
//
//  Created by Sunell on 2018/11/30.
//  Copyright © 2018 Sunell. All rights reserved.
//

#import "Test.h"
#import <objc/runtime.h>
@implementation Test

-(instancetype)init{
    if (self == [super init]) {
        return self;
    }
    return self;
}


void testMethod(id self,SEL _cmd){
    NSLog(@"test方法没有实现，使用这个方法替代");
}

+(BOOL)resolveInstanceMethod:(SEL)sel{
    NSLog(@"111111");
    if ((sel = @selector(test))) {
        class_addMethod([self class], sel, (IMP)testMethod, "");
        NSLog(@"test方法调用");
    }
    return false;
}

@end
