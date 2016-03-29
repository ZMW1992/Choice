//
//  VideoPlayController.h
//  Choice
//
//  Created by lanouhn on 16/1/15.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoPlayController : UIViewController

@property (nonatomic, copy) NSString *aID;

//@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, assign) NSInteger moduleID;

//@property (nonatomic, copy) NSString *barColor;



@property (nonatomic, retain) NSArray *videoArr;
@property (nonatomic, assign) NSInteger index;



- (void)GETData;


@end
