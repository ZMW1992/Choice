//
//  AnnotationView.m
//  MapTest4
//
//  Created by lanouhn on 16/1/16.
//  Copyright © 2016年 LiYaJun. All rights reserved.
//

#import "AnnotationView.h"

@implementation AnnotationView


- (void)dealloc
{
    self.title = nil;
    self.subtitle = nil;
    self.image = nil;
    [super dealloc];
}

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    
    if (self = [super init]) {
        
        _coordinate = coordinate;
    }
    return self;
}

@end
