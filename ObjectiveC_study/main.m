//
//  main.m
//  ObjectiveC_study
//
//  Created by Dio Brand on 2023/3/28.
//

#import <Foundation/Foundation.h>
#import "Regular.h"
#import "MyManager.h"
#import "Random.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        [[Random new] start];
//        [[Regular new] start];
        [[MyManager sharedManager] start];
    }
    return 0;
}
