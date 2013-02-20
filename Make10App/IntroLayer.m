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

#pragma mark - IntroLayer

@implementation IntroLayer


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
        CCSprite* background = [Make10Util genBackgroundWithColor:ccc4(93, 217, 4, 255)];
        [self addChild:background];
        /*
         * Set all defaults if there were none so else where can just grab values
         * instead of having to test existence
         */
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE];
        NSLog(@"IntroLayer makeValue = %d", [makeValue intValue]);
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

-(void) onEnter
{
	[super onEnter];

	// ask director for the window size
	CGSize winSize = [[CCDirector sharedDirector] winSize];

    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE];
    NSString* titleTxt = [NSString stringWithFormat:@"Make %d", [makeValue intValue]];
	CCLabelTTF* title = [CCLabelTTF labelWithString:titleTxt fontName:@"American Typewriter" fontSize:[Make10Util getIntroTitleFontSize]];
    //title.color = ccc3(0, 0, 0);
    title.position = ccp(winSize.width / 2, winSize.height * 2 / 3);
	// add the label as a child to this Layer
	[self addChild: title];
	
    /*
     * Play button
     */
    CCMenuItemImage* play = [Make10Util createPlayButtonWithText:@"Play" target:self selector:@selector(playAction)];
//    CCMenuItemFont* play = [CCMenuItemFont itemWithString:@"Play" target:self selector:@selector(playAction)];
//    [Make10Util stylePlayButton:play];
    /*
     * Settings button
     */
//    CCMenuItemFont* settings = [CCMenuItemFont itemWithString:@"Settings" target:self selector:@selector(settingsAction)];
//    [Make10Util styleMenuButton:settings];
    CCMenuItemImage* settings = [Make10Util createButtonWithText:@"Settings" target:self selector:@selector(settingsAction)];
    /*
     * About button
     */
//    CCMenuItemFont* about = [CCMenuItemFont itemWithString:@"About" target:self selector:@selector(aboutAction)];
//    [Make10Util styleMenuButton:about];
    CCMenuItemImage* about = [Make10Util createButtonWithText:@"About" target:self selector:@selector(aboutAction)];
    
    /*
     * Create the menu
     */
    CCMenu* menu = [CCMenu menuWithItems:play, settings, about, nil];
    menu.position = ccp(winSize.width / 2, winSize.height / 3);
    [self addChild:menu];
    [menu alignItemsVerticallyWithPadding:[Make10Util getMenuPadding]];
}

-(void) playAction {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:LAYER_TRANS_TIME scene:[Make10AppLayer scene] withColor:ccc3(70, 130, 180)]];
}

-(void) settingsAction {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:LAYER_TRANS_TIME scene:[SettingsLayer scene]]];
}

-(void) aboutAction {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:LAYER_TRANS_TIME scene:[AboutLayer scene]]];
}

-(void) dealloc {
    [self removeAllChildrenWithCleanup:YES];
    NSLog(@"IntroLayer dealloc");
    [super dealloc];
}
@end
