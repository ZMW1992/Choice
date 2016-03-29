//
//  CommentCell.m
//  Choice
//
//  Created by lanouhn on 16/1/15.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import "CommentCell.h"
//#import "Video.h"
#import "Play.h"
#import "UIImageView+WebCache.h"
#import "Header.h"
@interface CommentCell ()

@property (nonatomic, retain) UIImageView *photo; // 头像
@property (nonatomic, retain) UILabel *userName; // 用户名
@property (nonatomic, retain) UILabel *upTime;
@property (nonatomic, retain) UILabel *comment;

@end

@implementation CommentCell


- (void)assignForCommentCellSubviews:(Play *)play {
    
    self.userName.text = play.nickname;
    self.upTime.text = play.published;
    self.comment.text = play.content;
    
    // 头像异步加载
    NSURL *url = [NSURL URLWithString:play.avatarHd];
    [self.photo sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"zhanwei"]];
    [[SDImageCache sharedImageCache] clearMemory];
    
//    CGRect frame = self.comment.frame;
//    
//    if (![self.comment.text isEqualToString:@""]) {
//        CGFloat height = [play.content boundingRectWithSize:CGSizeMake(kSW-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]} context:nil].size.height;
//        frame.size.height = height;
//        self.comment.frame = frame;
    
       // CGFloat y = CGRectGetMaxY(self.comment.frame) + 5;
    
//    }
  
}


+ (CGFloat)getHeightWith:(Play *)play {
   CGFloat height = [play.content boundingRectWithSize:CGSizeMake(kSW-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0]} context:nil].size.height;
    return height;
}


// 重写自定义cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:233/255.0 green:225/255.0 blue:178/255.0 alpha:0.2];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.upTime];
        [self.contentView addSubview:self.comment];
        [self.contentView addSubview:self.photo];
        
    }
    
    return self;
}



- (UIImageView *)photo {
    
    if (!_photo) {
        self.photo = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)] autorelease];
        _photo.layer.cornerRadius = 15;
        
//        _photo.backgroundColor = [UIColor redColor];
        
    }
    
    return [[_photo retain] autorelease];
}


-(UILabel *)userName {
    
    if (!_userName) {
        self.userName = [[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 0.375*kSW, 30)] autorelease];
        
//        _userName.backgroundColor = [UIColor yellowColor];
        
        _userName.font = [UIFont systemFontOfSize:12.0];
        
    }
    
    return [[_userName retain] autorelease];
    
}


- (UILabel *)upTime {
    
    if (!_upTime) {
        self.upTime = [[[UILabel alloc] initWithFrame:CGRectMake(0.56*kSW, 10, 0.4*kSW, 30)] autorelease];
        
//        _upTime.backgroundColor = [UIColor blueColor];
        _upTime.font = [UIFont systemFontOfSize:12.0];
        
    }
    
    return [[_upTime retain] autorelease];
}


- (UILabel *)comment {
    
    if (!_comment) {
        self.comment = [[[UILabel alloc] initWithFrame:CGRectMake(20, 55, kSW-40, 10)] autorelease];
        
//        _comment.backgroundColor = [UIColor cyanColor];
        _comment.numberOfLines = 0;
        _comment.font = [UIFont systemFontOfSize:12.0];
    }
    
    return [[_comment retain] autorelease];
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
