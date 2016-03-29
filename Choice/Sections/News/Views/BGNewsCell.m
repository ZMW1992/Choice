//
//  BGNewsCell.m
//  Choice
//
//  Created by dream2021 on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "BGNewsCell.h"
#import "BGNews.h"
#import "Header.h"
#import "UIImageView+WebCache.h"

@interface BGNewsCell ()
/**
 *  图片
 */
@property (nonatomic, retain) UIImageView *iconView;
/**
 *  标题
 */
@property (nonatomic, retain) UILabel *titleLab;

/**
 *  文件大小
 */
@property (nonatomic, retain) UILabel *sizeLab;

/**
 *  日期
 */
@property (nonatomic, retain) UILabel *dateLab;
@end

@implementation BGNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleLab];
//        [self.contentView addSubview:self.sizeLab];
        [self.contentView addSubview:self.dateLab];
    }
    return self;
}

#pragma mark - 懒加载
- (UIImageView *)iconView {
    if (!_iconView) {
        self.iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 90, 60)] autorelease];
//        _iconView.backgroundColor = [UIColor cyanColor];
        _iconView.layer.cornerRadius = 10;
        _iconView.layer.masksToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return [[_iconView retain] autorelease];
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        self.titleLab = [[[UILabel alloc] initWithFrame:CGRectMake(110, 10, kSW - 120, 45)] autorelease];
//        _titleLab.backgroundColor = [UIColor blueColor];
        _titleLab.font = [UIFont systemFontOfSize:15.0];
        _titleLab.numberOfLines = 0;
        
    }
    return [[_titleLab retain] autorelease];
}

- (UILabel *)sizeLab {
    if (!_sizeLab) {
        self.sizeLab = [[[UILabel alloc] initWithFrame:CGRectMake(110, 60, 80, 22)] autorelease];
//        _sizeLab.backgroundColor = [UIColor grayColor];
        _sizeLab.font = [UIFont systemFontOfSize:12.0];
    }
    return [[_sizeLab retain] autorelease];
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        self.dateLab = [[[UILabel alloc] initWithFrame:CGRectMake(110, 60, kSW - 120, 20)] autorelease];
        _dateLab.textColor = [UIColor lightGrayColor];
        _dateLab.textAlignment = NSTextAlignmentCenter;
        _dateLab.font = [UIFont systemFontOfSize:12.0];
    }
    return [[_dateLab retain] autorelease];
}


#pragma mark - 赋值
- (void)setModel:(BGNews *)model {
    if (_model != model) {
        [_model release];
        _model = [model retain];
    }
    
    NSData *data = [model.smeta dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSURL *url = [NSURL URLWithString:dic[@"thumb"]];
    [self.iconView sd_setImageWithURL:url];
    
    
    self.titleLab.text = model.post_title;
    self.dateLab.text = model.post_date;
    
}







@end
