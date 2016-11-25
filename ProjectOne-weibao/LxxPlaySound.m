//
//  LxxPlaySound.m
//  ProjectOne-weibao
//
//  Created by jack on 16/6/3.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#import "LxxPlaySound.h"

@implementation LxxPlaySound
-(id)initForPlayingVibrate {
    self = [super init];
    if (self) {
        soundID = kSystemSoundID_Vibrate;
    }
    return self;
}

-(id)initForPlayingSystemSoundEffectWith:(NSString *)resourceName ofType:(NSString *)type {
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:resourceName ofType:type];
        if (path) {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
            if (error == kAudioServicesNoError) {
                soundID = theSoundID;
            }else{
                NSLog(@"Failed to create sound");
            }
        }
    }
    return self;
}
-(id)initForPlayingSoundEffectWith:(NSString *)fileName {
    self = [super init];
    if (self) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        if (fileURL) {
            SystemSoundID theSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &theSoundID);
            if (error == kAudioServicesNoError) {
                soundID = theSoundID;
            }else{
                NSLog(@"Failed to create sound");
            }
        }
    }
    return self;
}
-(void)play {
    AudioServicesPlaySystemSound(soundID);
}
-(void)dealloc {
    AudioServicesDisposeSystemSoundID(soundID);
}
@end
