#import "MyManager.h"
#import "FileUtil.h"

@implementation MyManager

+ (instancetype)sharedManager {
    static MyManager *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[super allocWithZone:NULL] init];
    });
    return staticInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

-(id)copyWithZone:(struct _NSZone *)zone{
    return [[self class] sharedManager];
}

// 开始工作
-(void)start {
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:@"/Users/dio/Repository/ObjectiveC_study/ObjectiveC_study/searchFile/files.json"];
    NSError *error;
    NSDictionary *pathDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
    if(error) {
        NSLog(@"convert json error:\n%@",[error localizedFailureReason]);
        return;
    }
//    NSLog(@"%@",pathDict);

    NSMutableArray *allFilePath = [NSMutableArray array];
    FileUtil *fileUtil = [FileUtil new];
    [fileUtil getAllTargetPath:pathDict filePaths:allFilePath];

    for(int i = 0; i < allFilePath.count; i++) {
        NSString *path = [allFilePath objectAtIndex:i];
        NSLog(@"%@",path);
    }
}

@end
