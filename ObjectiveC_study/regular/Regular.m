//
//  Regular.m
//  ObjectiveC_study
//
//  Created by Dio Brand on 2023/3/28.
//

#import "Regular.h"

@implementation Regular

-(void)start {
    //    [self match01];
    //        [self match02];
    //    [self match03];
    //        [self match04];
    //        [self match05];
    [self match06];
}

-(void)match01 {
    // 不加任何正则表符号时,就是判断字符串是否相等
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"Caches"];
    NSString *appFileName = @"Caches";
    NSLog(@"%@",appFileName);
    BOOL match = [predicate evaluateWithObject:appFileName];
    if(match) {
        NSLog(@"is right file");
    }else{
        NSLog(@"not is right file");
    }
}

-(void)match02 {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"wxid.*.rcr"];
    NSArray <NSString *> * mobiles = @[
        @"wxid.wirworoio.rcr",
        @"wxid.i8913jfa.rcr",
        @"wxid.1312930.rcr",
        @"wxid.9319301.rcr",
        @"wxid.i8913jfa.txt",
        @"wxid.1312930.data",
        @"wxid.9319301.dt"
    ];
    
    for (NSString *mobile in mobiles) {
        BOOL match = [predicate evaluateWithObject:mobile];
        NSLog(@"字符串%@,%@", mobile, match ? @"合适" : @"不合适");
    }
}

-(void)match03 {
    // 在字符串中筛选出以Window开头的所有子串.
    NSError *error = nil;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"Windows[0-9a-zA-Z]+" options:(NSRegularExpressionAllowCommentsAndWhitespace) error:&error];
    
    NSString *content = @"历史上比较受欢迎的电脑操作系统版本有: WindowsXp, WindowsNT, Windows98, Windows95等";
    if (!error) {
        NSArray<NSTextCheckingResult *> * result = [reg matchesInString:content options:(NSMatchingReportCompletion) range:(NSRange){0, content.length}];
        for (NSTextCheckingResult *ele in result) {
            NSLog(@"element == %@\n", [content substringWithRange:ele.range]);
        }
    }
}

-(void)match04 {
    /*
     手机号: ^1[3-9]\\d{9}$
     身份证号: ^[0-9]{15}$)|([0-9]{17}([0-9]|X)$
     中文姓名: ^[\u4E00-\u9FA5]{2,}
     网址链接: ^(http|https|ftp)\://([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&%\$\-]+)*@)?((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.[a-zA-Z]{2,4})(\:[0-9]+)?(/[^/][a-zA-Z0-9\.\,\?\'\\/\+&%\$#\=~_\-@]*)*$
     */
    // 判断手机号是否合法
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1[3-9]\\d{9}$"];
    NSArray <NSString *> * mobiles = @[
        @"17826830415",
        @"12826830415",
        @"27826830415",
        @"1782683041"
    ];
    
    for (NSString *mobile in mobiles) {
        BOOL match = [predicate evaluateWithObject:mobile];
        NSLog(@"手机号码[%@]%@", mobile, match ? @"合法" : @"不合法");
    }
}

-(void)match05 {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @".+"];
    NSString *appFileName = @"Caches";
    NSLog(@"%@",appFileName);
    BOOL match = [predicate evaluateWithObject:appFileName];
    if(match) {
        NSLog(@"is right file");
    }else{
        NSLog(@"not is right file");
    }
}

-(void)match06 {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[a-zA-Z1-9][a-zA-Z0-9]{31}"];
    NSArray <NSString *> * mobiles = @[
        @"a05e50829484c4f4efddf33499b8108f",
        @"00000000000000000000000000000000",
        @"51d808e2774354ea1169b81dd2ceedc0",
        @"1782683041"
    ];
    for (NSString *mobile in mobiles) {
        BOOL match = [predicate evaluateWithObject:mobile];
        NSLog(@"%@  --> %@", mobile, match ? @"合适" : @"不合适");
    }
}

@end
