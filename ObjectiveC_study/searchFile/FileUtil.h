#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileUtil : NSObject

// 获取所有的目标文件确定路径
-(void)getAllTargetPath:(NSDictionary *)fileInfo filePaths:(NSMutableArray *)filePathArray;

@end

NS_ASSUME_NONNULL_END
