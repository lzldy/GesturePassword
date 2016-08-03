//
//  lzlView.h
//  手势密码锁
//
//  Created by lzldy on 16/2/25.
//  Copyright © 2016年 lzldy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class lzlView;
@protocol lzlLockViewDelegate <NSObject>

-(void)lockView:(lzlView*)lockView didFinishPath:(NSString*)path;

@end


@interface lzlView : UIView

@property (nonatomic,assign) id<lzlLockViewDelegate> delegate;

@end
