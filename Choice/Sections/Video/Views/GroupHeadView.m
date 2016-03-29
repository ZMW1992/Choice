//
//  GroupHeadView.m
//  Choice
//
//  Created by lanouhn on 16/1/11.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "GroupHeadView.h"

@implementation GroupHeadView

- (void)dealloc {
    self.headLabel = nil;
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headLabel];
    }
    return self;
}



-(UILabel *)headLabel {
    
    if (!_headLabel) {
        self.headLabel = [[UILabel alloc]initWithFrame:self.bounds];
        
//        _headLabel.backgroundColor = [UIColor cyanColor];
    }
    
    return [[_headLabel retain]autorelease];
}





@end
