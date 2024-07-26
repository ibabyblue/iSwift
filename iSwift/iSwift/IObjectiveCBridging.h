//
//  IObjectiveCBridging.h
//  iSwift
//
//  Created by ibabyblue on 2024/5/16.
//  测试混编-文件

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IObjectiveCBridging : NSObject
- (void)invokeSwift;
- (void)foo;
+ (void)sFoo;
@end

NS_ASSUME_NONNULL_END
