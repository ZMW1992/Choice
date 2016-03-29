//
//  CommentCell.h
//  Choice
//
//  Created by lanouhn on 16/1/15.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class Video;
@class Play;
@interface CommentCell : UITableViewCell


// 定义接口
- (void)assignForCommentCellSubviews:(Play *)play;

+ (CGFloat)getHeightWith:(Play *)play;

@end
