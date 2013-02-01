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


#pragma mark - IntroLayer

// Make10AppLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the Make10AppLayer as the only child.
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
    title.position = ccp(winSize.width / 2, winSize.height / 2);
	// add the label as a child to this Layer
	[self addChild: title];
	
	// In one second transition to the new scene
	[self scheduleOnce:@selector(makeTransition:) delay:1];
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[Make10AppLayer scene] withColor:ccWHITE]];
}
@end
