//
//  BasicData.h
//  protectEyer
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 wjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicDate : NSObject

+ (BasicDate *) sharedBasicDate;

@property (nonatomic) double totalSeconds;
@property (strong, nonatomic) NSDate* startTime;

@end
