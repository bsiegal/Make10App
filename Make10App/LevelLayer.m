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


#import "LevelLayer.h"
#import "Make10Util.h"

@implementation LevelLayer

CCLabelTTF* _levelLabel;
CCLabelTTF* _makeValueLabel;

-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super initWithColor: ccc4(0, 128, 0, 75)]) {

        CCLabelTTF* getReady = [CCLabelTTF labelWithString:@"Get ready!" fontName:@"Arial" fontSize:[Make10Util getTitleFontSize]];
        getReady.color = ccc3(0, 0, 0);
        getReady.position = ccp(self.contentSize.width / 2, self.contentSize.height * 0.7);
        [self addChild:getReady];

        _levelLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:[Make10Util getTitleFontSize]];
        _levelLabel.color = ccc3(0, 0, 0);
        _levelLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height * 0.3);
        [self addChild:_levelLabel];

        _makeValueLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:[Make10Util getTitleFontSize]];
        _makeValueLabel.color = ccc3(0, 0, 0);
        _makeValueLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height * 0.5);
        [self addChild:_makeValueLabel];

    }
    return self;
}

-(void) setLevel:(int)level {
    [_levelLabel setString:[NSString stringWithFormat:@"Level %d", level]];
}

-(void) setMakeValue:(int)makeValue {
    [_makeValueLabel setString:[NSString stringWithFormat:@"Make %d", makeValue]];
}

-(void) onExit {
    [_levelLabel setString:@""];
    [_makeValueLabel setString:@""];
}
// on "dealloc" you need to release all your retained objects
-(void) dealloc {
    [_levelLabel removeFromParentAndCleanup:YES];
    _levelLabel = nil;
    
    [_makeValueLabel removeFromParentAndCleanup:YES];
    _makeValueLabel = nil;
    
	[super dealloc];
}

@end
