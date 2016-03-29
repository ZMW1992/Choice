//
//  GroupCell.m
//  Choice
//
//  Created by lanouhn on 16/1/11.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "GroupCell.h"
#import "Video.h"
#import "UIImageView+WebCache.h"

@interface GroupCell ()


@property (nonatomic, retain)UIImageView *icon;
@property (nonatomic, retain)UILabel *groupName;


@property (nonatomic, retain)UIView *aView;


@end



@implementation GroupCell

- (void)dealloc {
    self.icon = nil;
    self.groupName = nil;
    
    self.aView = nil;
    [super dealloc];
}





#pragma mark - 第二个分区的item
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *aView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)]autorelease];
        aView.backgroundColor = [UIColor whiteColor];
        aView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        aView.layer.borderWidth = 0.5;
        [self.contentView addSubview:aView];
        
        // 添加子控件
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.groupName];
        
        
    }
    return self;
}


- (void)setValueForSubviewsWithVideo:(Video *)video {
    
    self.groupName.text = video.modulesName;
    
    // 使用图片异步加载的第三方
    [self.icon sd_setImageWithURL:[NSURL URLWithString:video.modulsCover] placeholderImage:[UIImage imageNamed:@""]];
    
    
}


- (UIImageView *)icon {
    
    if (!_icon) {
        self.icon = [[[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 30, 30)]autorelease];
        
     //   _icon.backgroundColor = [UIColor brownColor];
        
    }
    
    return [[_icon retain] autorelease];
}


- (UILabel *)groupName {
    
    if (!_groupName) {
        self.groupName = [[[UILabel alloc]initWithFrame:CGRectMake(20, 50, 60, 30)]autorelease];
        _groupName.font = [UIFont systemFontOfSize:12.0];
//        _groupName.backgroundColor = [UIColor orangeColor];
    }
    
    return [[_groupName retain]autorelease];
}










@end
