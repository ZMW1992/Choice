//
//  AAACell.m
//  Choice
//
//  Created by lanouhn on 16/1/16.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "AAACell.h"
#import "Play.h"
#import "UIImageView+WebCache.h"


@interface AAACell ()

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *cover;

@end

@implementation AAACell





- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
        // 添加子控件
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.cover];
        
    }
    return self;
}


- (void)configureTagLabelWithPlay:(Play *)play {
    
    self.titleLabel.text = play.title;
    
    [self.cover sd_setImageWithURL:[NSURL URLWithString:play.thumbnail] placeholderImage:[UIImage imageNamed:@""]];
    
}






- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 80, 140, 20)] autorelease];
        _titleLabel.font = [UIFont systemFontOfSize:12.0];
//        _titleLabel.backgroundColor = [UIColor redColor];
    }
    
    return [[_titleLabel retain] autorelease];
}


- (UIImageView *)cover {
    
    if (!_cover) {
        self.cover = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 140, 80)] autorelease];
        
  //      _cover.backgroundColor = [UIColor yellowColor];
    }
    return [[_cover retain] autorelease];
}





@end
