/*******************************************************************************
 *
 * Copyright 2013 Bess Siegal
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 ******************************************************************************/


#import "GameOverScene.h"
#import "IntroLayer.h"
#import <UIKit/UIKit.h>

@implementation GameOverScene
@synthesize layer = _layer;

-(id) init {
    if ((self = [super init])) {
        self.layer = [GameOverLayer node];
        [self addChild:_layer];
    }
    return self;
}

-(void) dealloc {
    [_layer release];
    _layer = nil;
    [super dealloc];
}
@end


@implementation GameOverLayer

CCLabelTTF* _yourScore;
CCLabelTTF* _hiScore;

-(id) init {
    if ((self = [super initWithColor:ccc4(250, 25, 250, 255)])) {
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF* gameOver = [CCLabelTTF labelWithString:@"Game Over" fontName:@"American Typewriter" fontSize:32];
//        gameOver.color = ccc3(0, 0, 0);
        gameOver.position = ccp(winSize.width / 2, winSize.height * (0.75));
        [self addChild:gameOver];
        
        _yourScore = [CCLabelTTF labelWithString:@"" fontName:@"American Typewriter" fontSize:32];
//        _yourScore.color = ccc3(0, 0, 0);
        _yourScore.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:_yourScore];
        
        _hiScore = [CCLabelTTF labelWithString:@"" fontName:@"American Typewriter" fontSize:32];
//        _hiScore.color = ccc3(0, 0, 0);
        _hiScore.position = ccp(winSize.width / 2, winSize.height * (0.25));
        [self addChild:_hiScore];
        
        _home = [Make10Util createHomeSprite];
        NSLog(@"GameOverLayer.init _home = %@", _home);
        [self addChild:_home];
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void) setScore:(int)score {
    NSLog(@"GameOverLayer.setScore _home = %@", _home);
    [_yourScore setString:[NSString stringWithFormat:@"Your score: %d", score]];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber* highScore = [defaults objectForKey:PREF_HIGH_SCORE];
    if (!highScore || score > [highScore intValue]) {
        
        [_hiScore setString:@"Congratulations!\nA new high!"];
        
        [defaults setInteger:score forKey:PREF_HIGH_SCORE];
        
    } else if (score == [highScore intValue]) {
        
        [_hiScore setString:@"Congratulations!\nTied the high!"];
        
    } else {
        
        [_hiScore setString:[NSString stringWithFormat:@"High score: %d", [highScore intValue]]];
    }
    

}

#pragma mark Touches

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    if ([Make10Util isSpriteTouched:_home touches:touches]) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:LAYER_TRANS_TIME scene:[IntroLayer scene] withColor:ccc3(70, 130, 180)]];
    }
}


-(void) dealloc {

    [_yourScore removeFromParentAndCleanup:YES];
    _yourScore = nil;
    [_hiScore removeFromParentAndCleanup:YES];
    _hiScore = nil;
    [_home removeFromParentAndCleanup:YES];
    _home = nil;
    
    [super dealloc];
}
@end
