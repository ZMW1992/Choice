//
//  TagCell.h
//  Choice
//
//  Created by lanouhn on 16/1/13.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Video;
@interface TagCell : UICollectionViewCell

- (void)configureTagLabelWithVideo:(Video *)video;

@end
