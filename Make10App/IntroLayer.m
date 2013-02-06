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
+(CCScene *) scene
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

// 
-(void) onEnter
{
	[super onEnter];

	// ask director for the window size
	CGSize winSize = [[CCDirector sharedDirector] winSize];

	CCLabelTTF* title = [CCLabelTTF labelWithString:@"Make 10" fontName:@"American Typewriter" fontSize:64];
    //title.color = ccc3(0, 0, 0);
    title.position = ccp(winSize.width / 2, winSize.height * 2 / 3);
	// add the label as a child to this Layer
	[self addChild: title];
	
    /*
     * Play button
     */
    CCMenuItemFont* play = [CCMenuItemFont itemWithString:@"Play" target:self selector:@selector(playAction)];
    play.fontName = @"American Typewriter";
    play.fontSize = 32;
    
    /*
     * Settings button
     */
    CCMenuItemFont* settings = [CCMenuItemFont itemWithString:@"Settings" target:self selector:@selector(settingsAction)];
    settings.fontName = @"American Typewriter";
    settings.fontSize = 24;
    
    /*
     * About button
     */
    CCMenuItemFont* about = [CCMenuItemFont itemWithString:@"About" target:self selector:@selector(aboutAction)];
    about.fontName = @"American Typewriter";
    about.fontSize = 24;
    
    /*
     * Create the menu
     */
    CCMenu* menu = [CCMenu menuWithItems:play, settings, about, nil];
    menu.position = ccp(winSize.width / 2, winSize.height / 3);
    [self addChild:menu];
    [menu alignItemsVerticallyWithPadding:20];
}

-(void) playAction {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:LAYER_TRANS_TIME scene:[Make10AppLayer scene] withColor:ccc3(70, 130, 180)]];
}

-(void) settingsAction {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:LAYER_TRANS_TIME scene:[SettingsLayer scene]]];
     //CCTransitionFade transitionWithDuration:1.0 scene:[SettingsLayer scene] withColor:ccWHITE]];
}

-(void) aboutAction {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:LAYER_TRANS_TIME scene:[AboutLayer scene]]];
     //[CCTransitionFade transitionWithDuration:1.0 scene:[AboutLayer scene] withColor:ccWHITE]];
}

@end
