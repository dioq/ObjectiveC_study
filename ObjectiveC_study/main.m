//
//  main.m
//  ObjectiveC_study
//
//  Created by Dio Brand on 2023/3/28.
//

#import <Foundation/Foundation.h>
#import "Regular.h"
#import "MyManager.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [[Regular new] start];
//        [[MyManager sharedManager] start];
    }
    return 0;
}
