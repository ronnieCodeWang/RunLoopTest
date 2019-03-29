//
//  ViewController.m
//  RunLoopTest
//
//  Created by Sunell on 2018/11/21.
//  Copyright © 2018 Sunell. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "MyThread.h"
#import <objc/runtime.h>
#import "Test.h"
@interface ViewController ()

{
    MyThread *_test3;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    /**
     runLoop:
     main方法是不会被执行完的，因为AppDelegate里面有个默认开启的runloop在无限循环的执行，所以永远都不会有返回值，使程序不会关闭掉
     应用场景：
     1、使子线程执行完毕后不被释放掉（正常情况下执行完后子线程就被释放了），下次可以再次执行子线程中的代码，而不用再去创建子线程
     2、NSTimer来控制scrollview滚动图片，如果滑动tableview会造成NSTimer在滑动期间不工作，可以将NSTimer切换到另一个model下执行，这样就互不影响了
     
     performSelector调用和直接调用区别
     */
    
    
//    MyThread *thread1 = [[MyThread alloc] initWithTarget:self selector:@selector(test1) object:nil];
//    [thread1 start];
//
//    MyThread *thread2 = [[MyThread alloc] initWithTarget:self selector:@selector(test2) object:nil];
//    thread2.name = @"test2";
//    [thread2 start];
    
//    MyThread *thread3 = [[MyThread alloc] initWithTarget:self selector:@selector(test3) object:nil];
//    _test3 = thread3;
//    thread3.name = @"test3";
//    [thread3 start];
//    [self testPerformSelector];
    Test *test = [[Test alloc] init];
    [test test];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_test3 != nil) {
        [self performSelector:@selector(test_began) onThread:_test3 withObject:nil waitUntilDone:YES];    }
    
}

//重写该方法，当调用对象的方法找不到时回调都这里
+(BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == NSSelectorFromString(@"test")) {
        NSLog(@"调用了%@方法",NSStringFromSelector(sel));
        return class_addMethod(self, sel, (IMP)sel, "");
        
    }
    return  [super resolveClassMethod:sel];
//    return YES;
}

-(void)sel{
    NSLog(@"走了该方法");
}

-(void)testPerformSelector{
//    performSelector 运行时方法，和直接调用的区别在于，该方法在运行时才会去检测该方法是否实现，下面的test没有实现但编译可以成功，运行时才报错
    [self performSelector:@selector(test)];
    
//    可以先检测该方法是否实现，再调用
    if ([self respondsToSelector:@selector(test_perform)]) {
        [self performSelector:@selector(test_perform)];
    }
}

-(void)test4{
    NSLog(@"22222");
}

-(void)test_began{
    NSLog(@"_test3子线程使用runloop后没有使子线程销毁，这里再次将其唤醒");
}

-(void)test3{
    NSLog(@"进入test3");
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:[NSPort port] forMode:NSRunLoopCommonModes];
    [runLoop run];
    NSLog(@"test3结束");
}


//runLoop开启后，线程不会被销毁，下次还可以继续在该线程中执行方法 [self performSelector:@selector(方法名) onThread:该线程 withObject:nil waitUntilDone:NO];
-(void)test2{
    NSLog(@"进入方法：%@",NSStringFromSelector(_cmd));
//    这三行代码是启动runLoop，使该线程不被销毁，同时下方的打印代码永远不会被执行
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addPort:[NSPort port] forMode:NSRunLoopCommonModes];
    [loop run];
    NSLog(@"runLoop开启后不能执行到这里");
}

//开启一个子线程，当test1方法执行完该子线程就会dealloc释放掉
-(void)test1{
    NSLog(@"进入方法：%@",NSStringFromSelector(_cmd));
}

@end
