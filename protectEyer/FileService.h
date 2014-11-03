//
//  FileService.h
//  protectEyer
//
//  Created by mac on 14-10-26.
//  Copyright (c) 2014年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileService : NSObject

+ (void)changePassword:(NSString *) password;
+ (NSString *)getPassword;

+ (void)changeTimeArray:(NSInteger *)time;
+ (NSArray *)getTimeArray;

+ (void)changePasswordFlag;
+ (BOOL)getPasswordFlag;

+ (void)setStartTime:(NSDate *) startTime;
+ (NSDate *)getStartTime;

+ (void)setTotalSeconds:(double) totalSeconds;
+ (double)getTotalSeconds;

+ (void)dateChange;

@end
