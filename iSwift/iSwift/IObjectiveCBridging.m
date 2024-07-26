//
//  IObjectiveCBridging.m
//  iSwift
//
//  Created by ibabyblue on 2024/5/16.
//

#import "IObjectiveCBridging.h"
#import "iSwift-Swift.h"

@implementation IObjectiveCBridging
- (void)invokeSwift {
    ISwiftBridging *ib = [[ISwiftBridging alloc] init];
    NSString *foo = [ib foo];
    
    [ISwiftBridging sFoo];
}

- (void)foo {
    NSLog(@"invoke oc foo method");
}

+ (void)sFoo {
    NSLog(@"invoke oc sFoo method");
}
@end
