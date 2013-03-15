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


#import "Progress.h"
#import "Make10Util.h"

@implementation Progress

-(id) init {
    if (self = [super init]) {
        CCSprite* sprite = [CCSprite spriteWithSpriteFrameName:@"progress.png"];

        _timeBar = [CCProgressTimer progressWithSprite:sprite];
        _timeBar.type = kCCProgressTimerTypeBar;
        _timeBar.midpoint = ccp(0, 0);
        _timeBar.barChangeRate = ccp(1, 0);
        _timeBar.percentage = 0;
        
        _spriteBg = [CCSprite spriteWithSpriteFrameName:@"progressBar.png"];
        
        [_spriteBg addChild:_timeBar z:1];
        [_timeBar setAnchorPoint: ccp(0,0)];
        [_timeBar setPosition:ccp(0, [Make10Util getProgressPadding])];
    }
    return self;
}


-(void) startWithDuration:(int)duration target:(id)target callback:(SEL)callback {

    id actionScaleDone = [CCCallFuncN actionWithTarget:target selector:callback];
	CCProgressFromTo *progressToFull = [CCProgressFromTo actionWithDuration:duration from:0 to:100];
	CCSequence *asequence = [CCSequence actions:progressToFull, actionScaleDone, nil];

	[_timeBar runAction:asequence];

}

-(void) resetBar {
    /*
     * do nothing
     */
}

-(void) dealloc {
    if (_timeBar) {
        [_timeBar removeFromParentAndCleanup:YES];
        _timeBar = nil;
    }
    
    if (_spriteBg) {
        [_spriteBg removeFromParentAndCleanup:YES];
        _spriteBg = nil;
    }
	[super dealloc];
}
@end
