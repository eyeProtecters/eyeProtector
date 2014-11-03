//
//  FileService.m
//  protectEyer
//
//  Created by mac on 14-10-26.
//  Copyright (c) 2014年 wjy. All rights reserved.
//

#import "FileService.h"


@implementation FileService

+ (NSString *)getFilePath{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    NSString *totalPath=[NSString stringWithFormat:@"%@/data.plist",documentsDirectory];
    
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    //    NSLog(path);
    //    此路径错误
    return totalPath;
}

+ (NSMutableDictionary *)getDictionary{
    return [[NSMutableDictionary alloc]initWithContentsOfFile:[self getFilePath]];
}

+ (void)changePassword:(NSString *) password{
    NSMutableDictionary *dict = [self getDictionary];
    [dict setObject:password forKey:@"password"];
    [dict writeToFile:[self getFilePath] atomically:YES];
}
+ (NSString *)getPassword{
    NSMutableDictionary *dict = [self getDictionary];
    NSString *password=[dict objectForKey:@"password"];
    return password;
}

//NSInteger 不用*
+ (void)changeTimeArray:(NSInteger) time{
    NSMutableDictionary *dict = [self getDictionary];
    NSMutableArray *timeArray=[dict objectForKey:@"time"];
    NSInteger index=[[dict objectForKey:@"index"]intValue];
    BOOL firstFlag=[(NSNumber*)[dict objectForKey:@"firstFlag"]boolValue];
    
    if(firstFlag){
        [timeArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: time]];
        
        Boolean setting =NO;
        NSNumber *testBoolean =[[NSNumber alloc]initWithBool:setting];
        [dict setObject:testBoolean forKey:@"firstFlag"];
    }else{
        NSInteger previous= [[timeArray objectAtIndex:index]integerValue];
        previous+=time;
        [timeArray replaceObjectAtIndex:index withObject:[NSNumber numberWithInteger: previous]];
    }
    
    [dict setObject:timeArray forKey:@"time"];
    
    [dict writeToFile:[self getFilePath] atomically:YES];
}
+ (NSArray *)getTimeArray{
    NSMutableDictionary *dict = [self getDictionary];
    return [dict objectForKey:@"time"];
}

+ (void)dateChange{
    NSMutableDictionary *dict=[self getDictionary];
    
    Boolean setting =YES;
    NSNumber *testBoolean =[[NSNumber alloc]initWithBool:setting];
    [dict setObject:testBoolean forKey:@"firstFlag"];
    
    NSInteger index=[[dict objectForKey:@"index"]intValue];
    if(index==6){
        index=0;
    }else{
        index++;
    }
    [dict setObject:[NSNumber numberWithInteger: index] forKey:@"index"];
    
    [dict writeToFile:[self getFilePath] atomically:YES];
}

+ (void)changePasswordFlag{
    NSMutableDictionary *dict=[self getDictionary];
    
    if([self getPasswordFlag]){
        Boolean setting =NO;
        NSNumber *testBoolean =[[NSNumber alloc]initWithBool:setting];
        [dict setObject:testBoolean forKey:@"passwordFlag"];
        [dict writeToFile:[self getFilePath] atomically:YES];
    }else{
        Boolean setting =YES;
        NSNumber *testBoolean =[[NSNumber alloc]initWithBool:setting];
        [dict setObject:testBoolean forKey:@"passwordFlag"];
        [dict writeToFile:[self getFilePath] atomically:YES];
    }
}
+ (BOOL)getPasswordFlag{
    NSMutableDictionary *dict=[self getDictionary];
    return [(NSNumber*)[dict objectForKey:@"passwordFlag"]boolValue];
}

+ (void)setStartTime:(NSDate *) startTime{
    NSMutableDictionary *dict = [self getDictionary];
    [dict setObject:startTime forKey:@"startTime"];
    [dict writeToFile:[self getFilePath] atomically:YES];
}
+ (NSDate *)getStartTime{
    NSMutableDictionary *dict = [self getDictionary];
    return [dict objectForKey:@"startTime"];
}

+ (void)setTotalSeconds:(double) totalSeconds{
    NSMutableDictionary *dict = [self getDictionary];
    [dict setObject:[NSNumber numberWithDouble:totalSeconds] forKey:@"totalSeconds"];
    [dict writeToFile:[self getFilePath] atomically:YES];
}
+ (double)getTotalSeconds{
    NSMutableDictionary *dict = [self getDictionary];
    return [[dict objectForKey:@"totalSeconds"] doubleValue];
}

@end
