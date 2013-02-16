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

+(Progress*) create {
    return [[self alloc] init];
}


float _scaleX;

-(id) init {
    if (self = [super init]) {
        _sprite = [CCSprite spriteWithFile:@"progress.png"];
//        _sprite setAnchorPoint:<#(CGPoint)#>
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        

//        _timeBar = [CCProgressTimer progressWithSprite:_sprite];
//        //    timeBar.type = kCCProgressTimerTypeHorizontalBarLR;
//        _timeBar.type = kCCProgressTimerTypeBar;
//        _timeBar.midpoint = ccp(0, 0);
//        _timeBar.barChangeRate = ccp(1, 0);
//        _timeBar.percentage = 0;

        /*
         * How big the progress must grow
         */
//        _scaleX = 2 * (winSize.width - [Make10Util getMarginSide])/ _sprite.contentSize.width;
        _scaleX = (winSize.width - 2 * [Make10Util getMarginSide])/ _sprite.contentSize.width;
        
        _spriteBg = [CCSprite spriteWithFile:@"progressBar.png"];
        
//        [_spriteBg addChild:_timeBar z:1];
//        [_timeBar setAnchorPoint: ccp(0,0)];
        
    }
    return self;
}


-(void) startWithDuration:(int)duration target:(id)target callback:(SEL)callback {
    _progressAction = [CCScaleTo actionWithDuration:duration scaleX:_scaleX scaleY:1];
    id actionScaleDone = [CCCallFuncN actionWithTarget:target selector:callback];
    [self.sprite runAction:[CCSequence actions:_progressAction, actionScaleDone, nil]];
    
//    CCCallFunc *cbDecrFinished = [CCCallFunc actionWithTarget:self selector:@selector(decreaseProgressBarFinished:)];
//	CCProgressFromTo *progressToZero = [CCProgressFromTo actionWithDuration:duration from:0 to:100];
//	CCSequence *asequence = [CCSequence actions:progressToZero, actionScaleDone, nil];
//    
//	[_timeBar runAction:asequence];

}

-(void) resetBar {
    _sprite.scale = 1.0f;
}

-(void) dealloc {
    if (_sprite) {        
        [_sprite removeFromParentAndCleanup:YES];
        _sprite = nil;
    }
    
    if (_spriteBg) {
        [_spriteBg removeFromParentAndCleanup:YES];
        _spriteBg = nil;
    }
	[super dealloc];
}
@end
