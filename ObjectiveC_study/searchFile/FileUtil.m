#import "FileUtil.h"

@implementation FileUtil


-(void)getAllTargetPath:(NSDictionary *)fileInfo filePaths:(NSMutableArray *)filePathArray {
    NSString *homeDir = @"/Users/dio/Repository/FileTraverse/FileTraverse/app";
    
    NSArray *searchFileArray = [fileInfo objectForKey:@"search"];
    for(int i = 0; i < searchFileArray.count; i++) {
        NSDictionary *itemDict = [searchFileArray objectAtIndex:i];
        NSString *path = [itemDict objectForKey:@"path"];
        NSString *fileName = [itemDict objectForKey:@"fileName"];
        
        NSString *dirPathAbsolute = [NSString stringWithFormat:@"%@%@",homeDir,path];
        [self searchEntryPath:dirPathAbsolute targetFileName:fileName allPath:filePathArray];
    }
    
    //    NSArray *searchFileArray = [fileInfo objectForKey:@"search1"];
    //    for(int i = 0; i < searchFileArray.count; i++) {
    //        NSDictionary *itemDict = [searchFileArray objectAtIndex:i];
    //        [self search1WithDict:itemDict allPath:filePathArray];
    //    }
}

// 递归遍历所有子目录 寻找目标文件
-(void)searchEntryPath:(NSString *)entryPath targetFileName:(NSString *)targetFileName allPath:(NSMutableArray *)allFilePath {
    //    NSLog(@"entryPath:%@",entryPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 获取目录下的所有内容(文件和目录)
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:entryPath error:&error];
    if(error) {
        NSLog(@"%@获取所有子目录出错!",entryPath);
        return;
    }
    for (int i = 0; i < contents.count; i++) {
        NSString *currentFileName = [contents objectAtIndex:i];
        NSString *curentFilePath = [NSString stringWithFormat:@"%@%@",entryPath,currentFileName];
        BOOL isDirectory;
        [fileManager fileExistsAtPath:curentFilePath isDirectory:&isDirectory];
        if(isDirectory) { // 如果是目录 递归遍历所有子目录
            NSString *newEntryPath = [curentFilePath stringByAppendingString:@"/"];
            [self searchEntryPath:newEntryPath targetFileName:targetFileName allPath:allFilePath];
        }else {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", targetFileName];
            BOOL match = [predicate evaluateWithObject:currentFileName];
            if(match) {
                //                NSLog(@"match:\n%@",curentFilePath);
                [allFilePath addObject:curentFilePath];
            }
        }
    }
}

// 搜索优化
-(void)search1WithDict:(NSDictionary *)fileInfo allPath:(NSMutableArray *)allFilePath {
    NSString *homeDir = @"/Users/dio/Repository/FileTraverse/FileTraverse/app";
    NSDictionary *itemDict = fileInfo;
    //    NSLog(@"current:\n%@",itemDict);
    NSString *path = [itemDict objectForKey:@"path"];
    NSString *fileName = [itemDict objectForKey:@"fileName"];
    BOOL recursion = NO;
    if([itemDict objectForKey:@"recursion"]) {
        recursion = [[itemDict objectForKey:@"recursion"] boolValue];
    }
    
    
    NSString *pathAbsolute;
    if([path hasPrefix:@"/Users/dio"]) {
        pathAbsolute = path;
    }else {
        pathAbsolute = [NSString stringWithFormat:@"%@%@",homeDir,path];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *resultPaths = [NSMutableArray array];
    [self searchEntryPath:pathAbsolute targetFileName:fileName recursion:recursion allPath:resultPaths];
    //        NSLog(@"resultPaths.count:%lu",resultPaths.count);
    NSDictionary *next = [itemDict objectForKey:@"next"];
    //        NSLog(@"next:\n%@",next);
    if(next) { // 如果有下一级要寻找的任务, 就执行寻找任务
        for(int i = 0;i < resultPaths.count; i++) {
            NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:next];
            NSString *current_path = [resultPaths objectAtIndex:i];
            NSString *next_path = [next valueForKey:@"path"];
            NSString *new_path = [NSString stringWithFormat:@"%@%@",current_path,next_path];
            [muDict setValue:new_path forKey:@"path"];
            //            NSLog(@"current_path:%@",current_path);
            //            NSLog(@"next_path:%@",next_path);
            //            NSLog(@"new_path:%@",new_path);
            [self search1WithDict:muDict allPath:allFilePath];
        }
    }else { // 如果没有下一级要寻找的任务,就把当前寻找到文件添加到 目标数组当中
        for(int i = 0;i < resultPaths.count; i++) {
            NSString *tmpPath = [resultPaths objectAtIndex:i];
            BOOL isDirectory;
            [fileManager fileExistsAtPath:tmpPath isDirectory:&isDirectory];
            if(!isDirectory) { // 如果是目录且需要查找所有子目录, 就递归遍历所有子目录
                [allFilePath addObject:tmpPath];
            }
        }
    }
    
}

// 搜索
-(void)searchEntryPath:(NSString *)entryPath targetFileName:(NSString *)targetFileName recursion:(BOOL)recursion allPath:(NSMutableArray *)allFilePath {
    //    NSLog(@"entryPath:%@",entryPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 获取目录下的所有内容(文件和目录)
    NSError *error;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:entryPath error:&error];
    if(error) {
        NSLog(@"%@\nerror:%@",entryPath,[error localizedFailureReason]);
        return;
    }
    for (int i = 0; i < contents.count; i++) {
        NSString *tmpFileName = [contents objectAtIndex:i];
        NSString *tmpPath = [NSString stringWithFormat:@"%@%@",entryPath,tmpFileName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", targetFileName];
        BOOL match = [predicate evaluateWithObject:tmpFileName];
        if(match) {
            //            NSLog(@"match:\n%@",tmpPath);
            [allFilePath addObject:tmpPath];
        }
        if(recursion) {
            BOOL isDirectory;
            [fileManager fileExistsAtPath:tmpPath isDirectory:&isDirectory];
            if(isDirectory) { // 如果是目录且需要查找所有子目录, 就递归遍历所有子目录
                NSString *newEntryPath = [tmpPath stringByAppendingString:@"/"];
                [self searchEntryPath:newEntryPath targetFileName:targetFileName recursion:recursion allPath:allFilePath];
            }
        }
    }
}

@end
