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

#import "SettingsLayer.h"
#import "IntroLayer.h"

@implementation SettingsLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SettingsLayer *layer = [SettingsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if (self = [super init]) {
    
        // ask director for the window size
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF* text = [CCLabelTTF labelWithString:@"Make 10 Settings" fontName:@"American Typewriter" fontSize:14];
        //title.color = ccc3(0, 0, 0);
        text.position = ccp(winSize.width / 2, winSize.height - 14);
        // add the label as a child to this Layer
        [self addChild: text];
        
        /*
         * Back button
         */
        CCMenuItemFont* back = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(backAction)];
        back.fontName = @"American Typewriter";
        back.fontSize = 32;
        
        /*
         * Create the menu
         */
        CCMenu* menu = [CCMenu menuWithItems:back, nil];
        menu.position = ccp(winSize.width / 2, winSize.height / 3);
        [self addChild:menu];
    }
    return self;
}

-(void) backAction {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:LAYER_TRANS_TIME scene:[IntroLayer scene]]];
}


@end
