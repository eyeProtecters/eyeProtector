//
//  BasicData.m
//  protectEyer
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 wjy. All rights reserved.
//

#import "BasicDate.h"

@implementation BasicDate

static BasicDate * singletonBasicDate = nil;

+ (BasicDate *) sharedBasicDate
{
    if (singletonBasicDate == nil) {
        singletonBasicDate  = [[BasicDate alloc] init];
    }
    return singletonBasicDate ;
}


@end
