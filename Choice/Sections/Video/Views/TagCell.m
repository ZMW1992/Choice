//
//  TagCell.m
//  Choice
//
//  Created by lanouhn on 16/1/13.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "TagCell.h"
#import "Video.h"

@interface TagCell ()

@property (nonatomic, retain)UILabel *tagLabel;

@end




@implementation TagCell




- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor cyanColor];
        // 添加子控件
        [self.contentView addSubview:self.tagLabel];
        
    }
    return self;
}


- (void)configureTagLabelWithVideo:(Video *)video {
    
    self.tagLabel.text = video.tagName;
   
}





#pragma mark - 第一个分区的item
- (UILabel *)tagLabel {
    
    if (!_tagLabel) {
        self.tagLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width - 20, 30)]autorelease];
 

        
        
//        _tagLabel.backgroundColor = [UIColor cyanColor];
        
    }
    
    return [[_tagLabel retain] autorelease];
}


- (void)layoutSubviews {
    self.tagLabel.frame = CGRectMake(10, 0, self.bounds.size.width - 20, 30);
}









@end

