//
//  BGNewsDetailView.m
//  Choice
//
//  Created by dream2021 on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "BGNewsDetailView.h"
#import "Header.h"
#import "BGNews.h"
#import "UIImageView+WebCache.h"

@interface BGNewsDetailView ()
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UILabel *titleLab;
@property (nonatomic, retain) UILabel *dateLab;
@property (nonatomic, retain) UILabel *fromLab;
@property (nonatomic, retain) UILabel *summeryLab;

@end

@implementation BGNewsDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.iconView];
        [self addSubview:self.titleLab];
        [self addSubview:self.dateLab];
        [self addSubview:self.fromLab];
        [self addSubview:self.summeryLab];
        
    }
    return self;
}


#pragma mark - 懒加载
- (UIImageView *)iconView {
    if (!_iconView) {
        self.iconView = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 115, kSW - 40, (kSW - 20)*0.545)] autorelease];
//        _iconView.backgroundColor = [UIColor greenColor];
//        _iconView.layer.cornerRadius = 10;
        _iconView.layer.masksToBounds = YES;
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return [[_iconView retain] autorelease];
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        self.titleLab = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, kSW - 20, 55)] autorelease];
//        _titleLab.backgroundColor = [UIColor blueColor];
        _titleLab.font = [UIFont boldSystemFontOfSize:20.0];
        _titleLab.numberOfLines = 0;
        
    }
    return [[_titleLab retain] autorelease];
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        self.dateLab = [[[UILabel alloc] initWithFrame:CGRectMake(10, 70, kSW - 20, 20)] autorelease];
        _dateLab.textColor = [UIColor lightGrayColor];
        _dateLab.font = [UIFont systemFontOfSize:12.0];
    }
    return [[_dateLab retain] autorelease];
}

- (UILabel *)fromLab {
    if (!_fromLab) {
        self.fromLab = [[[UILabel alloc] initWithFrame:CGRectMake(10, 90, kSW - 20, 20)] autorelease];
        _fromLab.textColor = [UIColor lightGrayColor];
        _fromLab.font = [UIFont systemFontOfSize:12.0];
    }
    return [[_fromLab retain] autorelease];
}

- (UILabel *)summeryLab {
    if (!_summeryLab) {
        self.summeryLab = [[[UILabel alloc] init] autorelease];
//        _summeryLab.backgroundColor = [UIColor lightGrayColor];
        _summeryLab.numberOfLines = 0;
        
    }
    return [[_summeryLab retain] autorelease];
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
    self.dateLab.text = [NSString stringWithFormat:@"日期：%@", model.post_date];
    self.fromLab.text = [NSString stringWithFormat:@"来自：%@", model.post_lai];
    self.summeryLab.text = model.post_excerpt;
    
    self.summeryLab.frame = CGRectMake(10, CGRectGetMaxY(self.iconView.frame) + 10, kSW - 20, 0);
    // 自适应高度
    [_summeryLab sizeToFit];
    self.contentSize = CGSizeMake(0, CGRectGetMaxY(self.summeryLab.frame) + 10);
}




@end
