//
//  SecondNoteModel.m
//  RoamProject
//
//  Created by lanouhn on 15-9-4.
//  Copyright (c) 2015年 lanouhn. All rights reserved.
//

#import "SecondNoteModel.h"

@implementation SecondNoteModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)dealloc
{
    [_avatar_m release];
    [_name release];
    [super dealloc];
}

@end
