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
#import "GameOverScene.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "Tile.h"
#import "Wall.h"
#import "Score.h"
//#import <objc/runtime.h>

#pragma mark - Make10AppLayer

// Make10AppLayer implementation
@implementation Make10AppLayer

int         _makeValue;
Wall*       _wall;
Score*      _score;
Tile*       _nextTile;
Tile*       _currentTile;
Tile*       _knockedWallTile;
CCLabelTTF* _scoreLabel;
CCSprite*   _gain;
CCLabelTTF* _gainLabel;

NSTimer*    _wallTimer;

// Helper class method that creates a Scene with the Make10AppLayer as the only child.
+(CCScene*) scene
{
	// 'scene' is an autorelease object.
	CCScene* scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Make10AppLayer* layer = [Make10AppLayer node];
	
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
        Tile* wallTile = [[Tile alloc] initWithValueAndCol:value col:j];
        [self addChild:wallTile.sprite];
        
        [_wall addTile:wallTile row:0 col:j];
    }

    /*
     * Transition the wall up
     */
    [_wall transitionUp];
    
    /*
     * If the wall has reached the max, show the game over scene after a slight delay
     */
    if ([_wall isMax]) {
        [self scheduleOnce:@selector(endGame) delay:1];
    }
}

-(void) createNextTile {
    NSLog(@"createNextTile");
    NSMutableArray* possibles = [_wall getPossibles];
    int size = [possibles count];
    int value;
    if (size > 1) {
        int randIndex = (arc4random() % ([possibles count] - 1));
        value = _makeValue - [[possibles objectAtIndex:randIndex] integerValue];
    } else if (size == 1) {
        value = _makeValue - [[possibles objectAtIndex:0] integerValue];
    } else {
        value = [self genRandomValue];
    }
    _nextTile = [[Tile alloc] initWithValue:value];
    [self addChild:_nextTile.sprite];
}

-(void) createCurrentTile {
    NSLog(@"createCurrentTile");
    [_nextTile transitionToCurrent];
    _currentTile = _nextTile;
    _nextTile = nil;
    [self createNextTile];
}

-(void) placeScoreLabel {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite* bg = [CCSprite spriteWithFile:@"scoreLabelBg.png" rect:CGRectMake(0, 0, 308, 50)];
    bg.position = ccp(winSize.width / 2, winSize.height - 50 / 2 - 4);
    [self addChild:bg];
    
    _scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Make %d", _makeValue] fontName:@"Arial" fontSize:24];
    _scoreLabel.color = ccc3(0, 0, 0);
    _scoreLabel.position = ccp(bg.contentSize.width / 2, bg.contentSize.height / 2);
    [bg addChild:_scoreLabel];
    
}

-(void) createGain {
    NSLog(@"createGain");
    _gain = [CCSprite spriteWithFile:@"gain.png" rect:CGRectMake(0, 0, 40, 40)];
    _gain.position = ccp(100, 300);
    [self addChild:_gain];
    
    _gainLabel = [CCLabelTTF labelWithString:@"+10" fontName:@"Arial" fontSize:16];
    _gainLabel.color = ccc3(0, 0, 0);
    _gainLabel.position = ccp(_gain.contentSize.width / 2, _gain.contentSize.height / 2);
    [_gain addChild:_gainLabel];
    _gain.visible = NO;
}

-(void) startWallTimer {
    _wallTimer = [NSTimer scheduledTimerWithTimeInterval:_score.wallTime target:self selector:@selector(addWallRow) userInfo:nil repeats:YES];
}
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super initWithColor: ccc4(70, 130, 180, 255)]) {
        
        _makeValue = 10;
        _score = [[Score alloc] init];
        _wall = [[Wall alloc] init];
        
        [self placeScoreLabel];
        [self createGain];
        [self prepNewLevel];
        
        self.isTouchEnabled = YES;
        
        [self createNextTile];
        [self createCurrentTile];
        
//        [self schedule:@selector(addWallRow) interval:12];
        [self startWallTimer];
        
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

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    Tile* tile = [_wall whichTileAtLocation:location];
    
    if (tile.value + _currentTile.value == _makeValue) {
        [self valueMade:tile];
    } else {
        [self valueNotMade:tile touchPoint:location];
    }
}

-(void) valueMade:(Tile*) wallTile {
    NSLog(@"valueMade");
    /*
     * It's a match!
     * Move the current tile to the position of the wallTile
     */
    CGPoint point = wallTile.sprite.position;
    _knockedWallTile = wallTile;
    [_currentTile transitionToPoint:point target:self callback:@selector(wallTileKnockedDone:)];
}

-(void) wallTileKnockedDone:(id)sender {
    NSLog(@"wallTileKnockedDone");
    /*
     * Destroy both the current tile and the knockedWallTile
     * Create the next current tile
     */
    [_currentTile destroy];
    _currentTile = nil;

    _gain.position = _knockedWallTile.sprite.position;
    int tileCount = [_wall removeTile:_knockedWallTile];
    _knockedWallTile = nil;

    int pointGain = _score.pointValue * tileCount;
    [self updateScore:pointGain];
    [self levelUp];
    
    [self createCurrentTile];
}

-(void) updateScore:(int)pointGain {
    [_gainLabel setString:[NSString stringWithFormat:@"+%d", pointGain]];
    _gain.visible = YES;
    [_gain runAction:[CCFadeOut actionWithDuration:0.15]];
    [_gainLabel runAction:[CCFadeOut actionWithDuration:0.15]];
    
    _score.score += pointGain;
    [_scoreLabel setString:[NSString stringWithFormat:@"%d", _score.score]];
}

-(void) levelUp {
    /*
     * If the score is enough to advance to the next level,
     * stop the timer, 
     * clear the wall and prep for a new level,
     * show the level layer
     * then restart the timer
     */
    if (_score.score >= LEVEL_MARKER * pow(2, _score.level - 1)) {
        [_score levelUp];
        [_wallTimer invalidate];
        [_wall clearWall];
        //For now just a label that wil fade out
//        CCLayerColor* levelLayer = [[CCLayerColor node] initWithCo
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite* bg = [CCSprite spriteWithFile:@"scoreLabelBg.png" rect:CGRectMake(0, 0, 308, 50)];
        bg.position = ccp(winSize.width / 2, winSize.height - 50 / 2 - 4);
        [self addChild:bg];
        
        CCLabelTTF* levelLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Get ready for Level %d", _score.level] fontName:@"Arial" fontSize:24];
        levelLabel.color = ccc3(0, 0, 0);
        levelLabel.position = ccp(bg.contentSize.width / 2, bg.contentSize.height / 2);
        [bg addChild:levelLabel];
        //TODO NEED TO USE CALLBACK
        [bg runAction:[CCFadeOut actionWithDuration:2]];
        [self prepNewLevel];
        [self startWallTimer];
    }
}

-(void) valueNotMade:(Tile*) wallTile touchPoint:(CGPoint)point {
    NSLog(@"valueNotMade wallTile=%@", wallTile);
    /*
     * It's not a match
     * Move the current tile to the top of the column where the wallTile is
     * or if wallTile is nil, then stick it in the empty spot if it the column is empty
     * otherwise do nothing (ignore the touch)
     */
    if (wallTile) {
        CGPoint newPosition = [_wall addTileAtopTile:_currentTile referenceTile:wallTile];
        
        if (newPosition.x != 0 && newPosition.y != 0) {
            [_currentTile transitionToPoint:newPosition target:self callback:@selector(currentBecomesWallTileDone:)];
        } else {
            /*
             * No empty spot found (wall at max), so end game after slight delay
             */
            [self scheduleOnce:@selector(endGame) delay:1];
        }
        
    } else {
        CGPoint newPosition = [_wall addTileToEmptyColumn:_currentTile location:point];
        if (newPosition.x != 0 && newPosition.y != 0) {
            [_currentTile transitionToPoint:newPosition target:self callback:@selector(currentBecomesWallTileDone:)];
                        
        } 
        /*
         * else clicked too high, just ignore and do nothing
         */
    }

}

-(void) currentBecomesWallTileDone:(id)sender {
    NSLog(@"currentBecomesWallTileDone");
    /*
     * Create the next current tile
     */
    _currentTile = nil;
    [self createCurrentTile];
    
}

-(void) endGame {
    NSLog(@"endGame");
    GameOverScene* gameOverScene = [GameOverScene node];
    NSString* score = [NSString stringWithFormat:@"Your score: %d", _score.score];
    [gameOverScene.layer.label setString:score];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

// on "dealloc" you need to release all your retained objects
-(void) dealloc {
    [_nextTile release];
    _nextTile = nil;
    [_currentTile release];
    _currentTile = nil;
    [_wall release];
    _wall = nil;
    [_score release];
    _score = nil;
    [_scoreLabel removeFromParentAndCleanup:YES];
    _scoreLabel = nil;
    [_gainLabel removeFromParentAndCleanup:YES];
    _gainLabel = nil;
    [_gain removeFromParentAndCleanup:YES];
    _gain = nil;
    [_wallTimer invalidate];
    _wallTimer = nil;
    
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController*)viewController
{
	AppController* app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController*)viewController
{
	AppController* app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
