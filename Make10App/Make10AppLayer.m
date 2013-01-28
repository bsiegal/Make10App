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
#import "Make10AppLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "Tile.h"
#import "Wall.h"

#pragma mark - Make10AppLayer

// Make10AppLayer implementation
@implementation Make10AppLayer

int _makeValue;
Wall *_wall;
Tile *_nextTile;
Tile *_currentTile;

// Helper class method that creates a Scene with the Make10AppLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Make10AppLayer *layer = [Make10AppLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

/**
 * Generate a random value between 1 and the makeValue
 */
-(int) genRandomValue {
    return (arc4random() % (_makeValue - 1)) + 1;
}

/**
 * Prepare a new level by clearing wall and then adding 2 rows
 */
-(void) prepNewLevel {
    [self addWallRow];
    [self addWallRow];
}

/**
 * Add a row to the wall
 */
-(void) addWallRow {
    NSLog(@"addWallRow");
    /*
     * Create wall row of tiles
     */
    for (int j = 0; j < MAX_COLS; j++) {
        int value = [self genRandomValue];
        Tile *wallTile = [[Tile alloc] initWithValueAndCol:value col:j];
        [self addChild: wallTile.sprite];
        
        [_wall addTile: wallTile row:0 col:j];
    }

    /*
     * Transition the wall up
     */
    [_wall transitionUp];
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super initWithColor: ccc4(70, 130, 180, 255)]) {
        
        _makeValue = 10;
        
        _wall = [[Wall alloc] init];
        
        [self prepNewLevel];
        
        /*
          Create next tile
         */
        
        _nextTile = [[Tile alloc] initWithValue:[self genRandomValue]];
        [self addChild: _nextTile.sprite];
//		
//		//
//		// Leaderboards and Achievements
//		//
//		
//		// Default font size will be 28 points.
//		[CCMenuItemFont setFontSize:28];
//		
//		// Achievement Menu Item using blocks
//		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
//			
//			
//			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
//			achivementViewController.achievementDelegate = self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:achivementViewController animated:YES];
//			
//			[achivementViewController release];
//		}
//									   ];
//
//		// Leaderboard Menu Item using blocks
//		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
//			
//			
//			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
//			leaderboardViewController.leaderboardDelegate = self;
//			
//			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
//			
//			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
//			
//			[leaderboardViewController release];
//		}
//									   ];
//		
//		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
//		
//		[menu alignItemsHorizontallyWithPadding:20];
//		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
//		
//		// Add the menu to the layer
//		[self addChild:menu];
//
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [_nextTile release];
    _nextTile = nil;
    [_currentTile release];
    _currentTile = nil;
    [_wall release];
    _wall = nil;
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
