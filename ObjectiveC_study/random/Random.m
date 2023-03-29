//
//  Random.m
//  ObjectiveC_study
//
//  Created by Dio Brand on 2023/3/28.
//

#import "Random.h"

@implementation Random

-(void)start {
    int x = arc4random() % 100;
    NSLog(@"random : %d", x);
}

@end
