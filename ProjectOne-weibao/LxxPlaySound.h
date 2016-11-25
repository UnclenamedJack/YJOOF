//
//  LxxPlaySound.h
//  ProjectOne-weibao
//
//  Created by jack on 16/6/3.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface LxxPlaySound : NSObject
{
    SystemSoundID soundID;
}
-(id)initForPlayingVibrate;
-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type;
-(id)initForPlayingSoundEffectWith:(NSString *)fileName;
-(void)play;

@end
