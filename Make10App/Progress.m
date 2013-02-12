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

@implementation Progress

+(Progress*) create {
    return [[self alloc] init];
}


float _scaleX;

-(id) init {
    if (self = [super init]) {
        _sprite = [CCSprite spriteWithFile:@"progress.png" rect:CGRectMake(0, 0, 10, 10)];
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        /*
         * How big the progress must grow
         */
        _scaleX = 2 * winSize.width / _sprite.contentSize.width;
        
        /*
         * Scale the background as well
         */
        _spriteBg = [CCSprite spriteWithFile:@"progressBar.png" rect:CGRectMake(0, 0, 14, 14)];
        _spriteBg.scaleX = 2 * winSize.width / _spriteBg.contentSize.width;
        
    }
    return self;
}


-(void) startWithDuration:(int)duration target:(id)target callback:(SEL)callback {
    _progressAction = [CCScaleTo actionWithDuration:duration scaleX:_scaleX scaleY:1];
    id actionScaleDone = [CCCallFuncN actionWithTarget:target selector:callback];
    [self.sprite runAction:[CCSequence actions:_progressAction, actionScaleDone, nil]];

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
