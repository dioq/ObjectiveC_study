#import "FileUtil.h"

@implementation FileUtil


-(void)getAllTargetPath:(NSDictionary *)fileInfo filePaths:(NSMutableArray *)filePathArray {
    NSString *homeDir = @"/Users/dio/Repository/FileTraverse/FileTraverse/app";
    
    //    NSArray *searchFileArray = [fileInfo objectForKey:@"search"];
    //    for(int i = 0; i < searchFileArray.count; i++) {
    //        NSDictionary *itemDict = [searchFileArray objectAtIndex:i];
    //        NSString *path = [itemDict objectForKey:@"path"];
    //        NSString *fileName = [itemDict objectForKey:@"fileName"];
    //
    //        NSString *dirPathAbsolute = [NSString stringWithFormat:@"%@%@",homeDir,path];
    //        [self searchEntryPath:dirPathAbsolute targetFileName:fileName allPath:filePathArray];
    //    }
    
    NSArray *search1FileArray = [fileInfo objectForKey:@"search1"];
    for(int i = 0; i < search1FileArray.count; i++) {
        NSDictionary *itemDict = [search1FileArray objectAtIndex:i];
        //把路径转换成绝对路径
        NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:itemDict];
        NSString *path = [itemDict objectForKey:@"path"];
        NSString *pathAbsolute = [NSString stringWithFormat:@"%@%@",homeDir,path];
        [muDict setValue:pathAbsolute forKey:@"path"];
        [self search1WithDict:[muDict copy] outPath:filePathArray];
    }
}

// 递归遍历所有子目录 寻找目标文件
-(void)searchEntryPath:(NSString *)entryPath targetFileName:(NSString *)targetFileName outPath:(NSMutableArray *)outPaths {
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
            [self searchEntryPath:newEntryPath targetFileName:targetFileName outPath:outPaths];
        }else {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", targetFileName];
            BOOL match = [predicate evaluateWithObject:currentFileName];
            if(match) {
                //                NSLog(@"match:\n%@",curentFilePath);
                [outPaths addObject:curentFilePath];
            }
        }
    }
}

// 搜索优化
-(void)search1WithDict:(NSDictionary *)fileInfo outPath:(NSMutableArray *)outPaths {
    NSString *path = [fileInfo objectForKey:@"path"];
    NSString *fileName = [fileInfo objectForKey:@"fileName"];
    BOOL recursion = NO; // 是否递归
    if([fileInfo objectForKey:@"recursion"]) {
        recursion = [[fileInfo objectForKey:@"recursion"] boolValue];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *resultPaths = [NSMutableArray array];
    [self searchEntryPath:path targetFileName:fileName recursion:recursion outPath:resultPaths];
    // 把当前寻找到的文件添加到 目标数组当中
    for(int i = 0;i < resultPaths.count; i++) {
        NSString *tmpPath = [resultPaths objectAtIndex:i];
        BOOL isDirectory;
        [fileManager fileExistsAtPath:tmpPath isDirectory:&isDirectory];
        if(!isDirectory) { // 如果是文件就添加到输出结果中
            [outPaths addObject:tmpPath];
        }
    }
    
    NSDictionary *next = [fileInfo objectForKey:@"next"];
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
            [self search1WithDict:muDict outPath:outPaths];
        }
    }
}

// 搜索
-(void)searchEntryPath:(NSString *)entryPath targetFileName:(NSString *)targetFileName recursion:(BOOL)recursion outPath:(NSMutableArray *)outPaths {
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
            [outPaths addObject:tmpPath];
        }
        if(recursion) {
            BOOL isDirectory;
            [fileManager fileExistsAtPath:tmpPath isDirectory:&isDirectory];
            if(isDirectory) { // 如果是目录且需要查找所有子目录, 就递归遍历所有子目录
                NSString *newEntryPath = [tmpPath stringByAppendingString:@"/"];
                [self searchEntryPath:newEntryPath targetFileName:targetFileName recursion:recursion outPath:outPaths];
            }
        }
    }
}

@end
