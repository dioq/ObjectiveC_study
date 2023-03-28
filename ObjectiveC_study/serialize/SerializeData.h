//
//  SerializeData.h
//  AnalyseData
//
//  Created by Dio Brand on 2023/3/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SerializeData : NSObject

+ (instancetype)sharedManager;

-(void)start;

@end

NS_ASSUME_NONNULL_END
