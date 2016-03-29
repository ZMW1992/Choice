//
//  TravelDetailHeaderView.m
//  Choice
//
//  Created by lanouhn on 16/1/12.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "TravelDetailHeaderView.h"

@interface TravelDetailHeaderView ()

@property (nonatomic, retain) UILabel *label;
@end

@implementation TravelDetailHeaderView

- (void)dealloc
{
    self.text = nil;
    self.label = nil;
    [super dealloc];
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithRed:248/255.0 green:244/255.0 blue:225/255.0 alpha:1.0];
        UILabel *label = [[UILabel alloc] init];
        label.center = self.center;
        [label sizeToFit];
        label.numberOfLines = 0;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.textColor = [UIColor greenColor];
        label.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:label];
        self.label = label;
        [label release];
       
    }
    return  self;
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        [_text release];
        _text = [text retain];
    }
    self.label.text = text;
}


















@end
