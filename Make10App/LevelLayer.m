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
#import "IntroLayer.h"

@implementation LevelLayer

CCLabelTTF* _getReady;
CCLabelTTF* _levelLabel;
CCLabelTTF* _makeValueLabel;
CCMenu*     _menu;

-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super initWithColor: ccc4(93, 217, 4, 180)]) {

        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        /*
         * Play button
         */
        CCMenuItemSprite* play = [Make10Util createPlayButtonWithText:@"Resume" target:self selector:@selector(playAction)];
//        CCMenuItemFont* play = [CCMenuItemFont itemWithString:@"Resume" target:self selector:@selector(playAction)];
//        [Make10Util stylePlayButton:play];
        
        /*
         * Home button
         */
//        CCMenuItemFont* home = [CCMenuItemFont itemWithString:@"New game" target:self selector:@selector(homeAction)];
//        [Make10Util styleMenuButton:home];
        CCMenuItemSprite* home = [Make10Util createButtonWithText:@"New game" target:self selector:@selector(homeAction)];
        
        /*
         * Create the menu
         */
        _menu = [CCMenu menuWithItems:play, home, nil];
        _menu.position = ccp(winSize.width / 2, winSize.height * 0.25);
        [self addChild:_menu];
        [_menu alignItemsVerticallyWithPadding:[Make10Util getMenuPadding]];
        
        _getReady = [CCLabelTTF labelWithString:@"Get ready!" fontName:@"American Typewriter" fontSize:[Make10Util getTitleFontSize]];
//        _getReady.color = ccc3(0, 0, 0);
        _getReady.position = ccp(self.contentSize.width / 2, self.contentSize.height * 0.3);
        [self addChild:_getReady];

        _levelLabel = [CCLabelTTF labelWithString:@"" fontName:@"American Typewriter" fontSize:[Make10Util getTitleFontSize]];
//        _levelLabel.color = ccc3(0, 0, 0);
        _levelLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height * 0.5);
        [self addChild:_levelLabel];

        _makeValueLabel = [CCLabelTTF labelWithString:@"" fontName:@"American Typewriter" fontSize:[Make10Util getIntroTitleFontSize]];
//        _makeValueLabel.color = ccc3(0, 0, 0);
        _makeValueLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height * 0.7);
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

-(void) setPause:(BOOL)pause {
    _menu.visible = pause;
    _getReady.visible = !pause;
}



-(void) playAction {
    [[CCDirector sharedDirector] resume];
    [self startPauseFadeOut];
}

/**
 * Fade out the pause layer
 */
-(void) startPauseFadeOut {
    id actionFadeOut = [CCFadeOut actionWithDuration:LAYER_TRANS_TIME];
    id actionFadeOutDone = [CCCallFuncN actionWithTarget:self selector:@selector(pauseFadeOutDone)];
    [self runAction:[CCSequence actions:actionFadeOut, actionFadeOutDone, nil]];
    
}
/**
 * Callback when the level layer fades out
 */
-(void) pauseFadeOutDone {
    [self removeFromParentAndCleanup:YES];
    [[CCDirector sharedDirector] resume];
    if ([[self delegate] respondsToSelector:@selector(layerFadeOutDone)]) {
        [[self delegate] layerFadeOutDone];
    }
}


-(void) homeAction {
//    NSLog(@"LevelLayer homeAction");
    [[CCDirector sharedDirector] resume];
    
    if ([[self delegate] respondsToSelector:@selector(layerFadeOutDone)]) {
        [[self delegate] layerFadeOutDone];
    }

	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:LAYER_TRANS_TIME scene:[IntroLayer scene]]];
}

-(void) onExit {
    [super onExit];
    [_levelLabel setString:@""];
    [_makeValueLabel setString:@""];
}

// on "dealloc" you need to release all your retained objects
-(void) dealloc {
    self.delegate = nil;
    
    [_levelLabel removeFromParentAndCleanup:YES];
    _levelLabel = nil;
    
    [_makeValueLabel removeFromParentAndCleanup:YES];
    _makeValueLabel = nil;
    
    [_getReady removeFromParentAndCleanup:YES];
    _getReady = nil;
    
    [_menu removeFromParentAndCleanup:YES];
    _menu = nil;
    
    [self removeFromParentAndCleanup:YES];
	[super dealloc];
}

@end
