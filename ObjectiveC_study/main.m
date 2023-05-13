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
#import "Parse.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        [[Random new] start];
//        [[Regular new] start];
//        [[MyManager sharedManager] start];
        [[Parse new] parse];
    }
    return 0;
}
