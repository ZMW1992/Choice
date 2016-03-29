//
//  VideoCell.h
//  Choice
//
//  Created by lanouhn on 16/1/8.
//  Copyright © 2016年 小兵. All rights reserved.
//

#import <UIKit/UIKit.h>



/*{
 "resources": [
 {
 "rsId": "XMTQzODA0NDA1Mg==",
 "modules": {
 "modulesId": 1,
 "modulesName": "游戏/动漫",
 "sort": 3,
 "flag": "1",
 "icon": "http://121.40.117.246:8180/beautyidea/upload_files/category_cover/game.png",
 "modulsCover": "http://121.40.117.246:8180/beautyidea/upload_files/category_icons/game.png",
 "modulesColor": "#f44336"
 },
 "title": "Best present ever - The present",
 "link": "http://v.youku.com/v_show/id_XMTQzODA0NDA1Mg==.html",
 "thumbnail": "http://cs.vmovier.com/Uploads/post/2016-01-04/568a400a0b315.png",
 "thumbnailV2": "http://cs.vmovier.com/Uploads/post/2016-01-04/568a400a0b315.png",
 "duration": "275.00",
 "published": "2016-01-07 15:45:35",
 "uptime": "2016-01-07 16:15:30",
 "description": "First this boy will be unhappy with his present, but he will change his mind as you will understand why!\n\n17th edition: Travelling34 Competition and Family Selection - a Très Court by Jacob Frey - Germany",
 "player": "",
 "streamtypes": "[\"flvhd\",\"hd\",\"3gphd\"]",
 "flag": "1",
 "viewCount": 3082,
 "favoriteCount": 0,
 "upcount": 2,
 "downcount": 0,
 "commentcount": 2,
 "tag": "动画,礼物",
 "allRecommend": 0,
 "albumHot": 0,
 "enable": 0
 }*/




@class Video;
@interface VideoCell : UITableViewCell


// 定义接口
- (void)assignForCellSubviews:(Video *)video;


















@end











