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


// Import the interfaces
#import "IntroLayer.h"
#import "Make10AppLayer.h"
#import "SettingsLayer.h"
#import "AboutLayer.h"
#import "SimpleAudioEngine.h"

#pragma mark - IntroLayer

@implementation IntroLayer

CCSprite* _settings;
CCSprite* _about;

// Helper class method that creates a Scene with the IntroLayer as the only child.
+(CCScene*) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    if (self = [super init]) {
        
        
        CCSprite* background = [Make10Util genLayerBackgroundWithName:@"introBg"];

        [self addChild:background];
        
        /*
         * Set all defaults if there were none so else where can just grab values
         * instead of having to test existence
         */
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE];

        if (!makeValue) {
            [defaults setInteger:MAKE_VALUE_DEFAULT forKey:PREF_MAKE_VALUE];
        }
        
        NSNumber* startingLevel = [defaults objectForKey:PREF_START_LEVEL];
        if (!startingLevel) {
            [defaults setInteger:1 forKey:PREF_START_LEVEL];
        }
        
        NSNumber* challenge = [defaults objectForKey:PREF_CHALLENGE_TYPE];
        if (!challenge) {
            [defaults setInteger:PREF_CHALLENGE_TYPE_SPEED forKey:PREF_CHALLENGE_TYPE];
        }
        
        NSNumber* op = [defaults objectForKey:PREF_OPERATION];
        if (!op) {
            [defaults setInteger:PREF_OPERATION_ADDITION forKey:PREF_OPERATION];
        }
        
        NSNumber* style = [defaults objectForKey:PREF_TILE_STYLE];
        if (!style) {
            [defaults setInteger:PREF_TILE_STYLE_NUMBERS forKey:PREF_TILE_STYLE];
        }
        
    }
    return self;
}


-(void) addSettings {
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    /*
     * Re-add to the sprite frame cache in case there was a memory warning and it got cleared
     */
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Make10Sprites.plist"];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    _settings = [CCSprite spriteWithSpriteFrameName:@"sprocket.png"];
    _settings.position = ccp(winSize.width - [Make10Util getMarginSide] - _settings.contentSize.width / 2 - [Make10Util getUpperLabelPadding], winSize.height - [Make10Util getMarginTop] - _settings.contentSize.height / 2 - [Make10Util getUpperLabelPadding]);
    
    [self addChild:_settings];
}

-(void) addAbout {
        
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    _about = [CCSprite spriteWithSpriteFrameName:@"about.png"];
    _about.position = ccp([Make10Util getMarginSide] + _about.contentSize.width / 2 + [Make10Util getUpperLabelPadding], winSize.height - [Make10Util getMarginTop] - _settings.contentSize.height / 2 - [Make10Util getUpperLabelPadding]);
    
    [self addChild:_about];
}

-(void) onEnter {
	[super onEnter];
//    NSLog(@"IntroLayer onEnter");
    
	// ask director for the window size
	CGSize winSize = [[CCDirector sharedDirector] winSize];

    CCSprite* score = [Make10Util createWhiteBoxSprite];
    [self addChild:score];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE];
    NSString* titleTxt = [NSString stringWithFormat:@"Make %d", [makeValue intValue]];
	CCLabelTTF* title = [CCLabelTTF labelWithString:titleTxt fontName:@"American Typewriter" fontSize:[Make10Util getTitleFontSize]];
    title.color = ccc3(0, 0, 0);
    title.position = ccp(winSize.width / 2, winSize.height - [Make10Util getMarginTop] - [Make10Util getUpperLabelPadding] - [Make10Util getScoreLabelHeight] / 2);
	// add the label as a child to this Layer
	[self addChild: title];
	
    /*
     * Play button
     */
    CCMenuItemSprite* play = [Make10Util createPlayButtonWithText:@"Play" target:self selector:@selector(playAction)];
//    /*
//     * Settings button
//     */
//    CCMenuItemSprite* settings = [Make10Util createButtonWithText:@"Settings" target:self selector:@selector(settingsAction)];
//    /*
//     * About button
//     */
//    CCMenuItemSprite* about = [Make10Util createButtonWithText:@"About" target:self selector:@selector(aboutAction)];
    
    /*
     * Create the menu
     */
    CCMenu* menu = [CCMenu menuWithItems:play, nil];//settings, about, nil];
    menu.position = ccp(winSize.width / 2, winSize.height * .75);
    [self addChild:menu];
    [menu alignItemsVerticallyWithPadding:[Make10Util getMenuPadding]];
    
    
    [self addSettings];
    [self addAbout];
    
    self.isTouchEnabled = YES;
    
}

-(void) playAction {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.m4a"];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:LAYER_TRANS_TIME scene:[Make10AppLayer scene]]];

}

#pragma mark Touches

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
        
    if ([Make10Util isSpriteTouched:_settings touches:touches]) {
        [self settingsAction];
    } else if ([Make10Util isSpriteTouched:_about touches:touches]) {
        [self aboutAction];
    }
}

-(void) settingsAction {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.m4a"];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:LAYER_TRANS_TIME scene:[SettingsLayer scene]]];
}

-(void) aboutAction {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click.m4a"];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:LAYER_TRANS_TIME scene:[AboutLayer scene]]];
}
//
//-(void) onExit {
//    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"introBg.plist"];
//    [super onExit];
//}

-(void) dealloc {
    
    self.isTouchEnabled = NO;
    
    [_settings removeFromParentAndCleanup:YES];
    _settings = nil;
    
    [_about removeFromParentAndCleanup:YES];
    _about = nil;
    
    [self removeFromParentAndCleanup:YES];
    [super dealloc];
}
@end
