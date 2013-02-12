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
#import "IntroLayer.h"
#import "GameOverScene.h"
#import "LevelLayer.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "Tile.h"
#import "Wall.h"
#import "Score.h"
#import "Progress.h"
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
LevelLayer* _levelLayer;
Progress*   _progressBar;
CCSprite*   _home;

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
 * Create tiles for a row and stick them in row 0
 * (which are below the visible screen and will need to be transitioned up)
 */
-(void) createNewTilesForRow {
    for (int j = 0; j < MAX_COLS; j++) {
        int value = [self genRandomValue];
        Tile* wallTile = [[Tile alloc] initWithValueAndCol:value col:j];
        [self addChild:wallTile.sprite];
        
        [_wall addTile:wallTile row:0 col:j];
    }
    
}
/**
 * Prepare a new level by adding 2 rows (to a cleared wall)
 */
-(void) prepNewLevel {
    NSLog(@"prepNewLevel");
    /*
     * Create 2 full row of tiles
     */
    [self createNewTilesForRow];
    [_wall transitionUpWithTarget:self callback:@selector(addWallRow)];
}

/**
 * Add a row to the wall.
 * Disable touch so there's no bad behavior when the wall is moving
 */
-(void) addWallRow {
    NSLog(@"addWallRow");
    /*
     * Create full row of tiles
     */
    [self createNewTilesForRow];

    self.isTouchEnabled = NO;
    
    /*
     * Delay the transition if the currentTile is in flight
     */
    if ([_currentTile.sprite numberOfRunningActions] > 0) {
        
        [self scheduleOnce:@selector(addWallRow) delay:CURRENT_TO_WALL_TRANS_TIME];
        
    } else {
        /*
         * Transition the wall up
         */
        [_wall transitionUpWithTarget:self callback:@selector(startProgressBar)];
        
        /*
         * If the wall has reached the max, show the game over scene after a slight delay
         */
        if ([_wall isMax]) {
            [self scheduleOnce:@selector(endGame) delay:1];
        }
    
    }
}


/**
 * Create and place the next tile
 */
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

/**
 * Move the next tile to the current position
 * and create a new next tile
 */
-(void) createCurrentTile {
    NSLog(@"createCurrentTile");
    [_nextTile transitionToCurrent];
    _currentTile = _nextTile;
    _nextTile = nil;
    [self createNextTile];
}

/**
 * Create the score label and progress bar
 */
-(void) placeScoreLabel {
    NSLog(@"placeScoreLabel");
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGRect rect = [Make10Util getScoreRect];
    CCSprite* bg = [CCSprite spriteWithFile:@"scoreLabelBg.png" rect:rect];
    bg.position = ccp(winSize.width / 2, winSize.height - rect.size.height / 2 - [Make10Util getUpperLabelPadding]);
    [self addChild:bg];
    
    _scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Make %d", _makeValue] fontName:@"American Typewriter" fontSize:24];
    _scoreLabel.color = ccc3(0, 0, 0);
    _scoreLabel.position = ccp(bg.contentSize.width / 2, bg.contentSize.height / 2);
    [bg addChild:_scoreLabel];
}

-(void) createProgressBar {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    _progressBar = [Progress create];
    _progressBar.sprite.position = ccp(0, winSize.height - [Make10Util getTileRect].size.height + _progressBar.sprite.contentSize.height / 2 + [Make10Util getUpperLabelPadding]);
    [self addChild:_progressBar.sprite];
}
/**
 * Create the sprite to show for earned points
 */
-(void) createGain {
    NSLog(@"createGain");
    _gain = [CCSprite spriteWithFile:@"gain.png" rect:CGRectMake(0, 0, 40, 40)];
    _gain.position = ccp(100, 300);
    [self addChild:_gain];
    
    _gainLabel = [CCLabelTTF labelWithString:@"+10" fontName:@"American Typewriter" fontSize:16];
    _gainLabel.color = ccc3(0, 0, 0);
    _gainLabel.position = ccp(_gain.contentSize.width / 2, _gain.contentSize.height / 2);
    [_gain addChild:_gainLabel];
    _gain.visible = NO;
}

/**
 * Start the progress bar and enable touch
 */
-(void) startProgressBar {
    [_progressBar resetBar];
    [_progressBar startWithDuration:_score.wallTime target:self callback:@selector(addWallRow)];
    self.isTouchEnabled = YES;
}

// on "init" you need to initialize your instance
-(id) init {
    NSLog(@"Make10AppLayer.init");
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super initWithColor: ccc4(70, 130, 180, 255)]) {
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE];
        _makeValue = [makeValue intValue];
        
        _score = [Score create];
        _wall = [[Wall alloc] init];
        
        [self placeScoreLabel];
        [self createProgressBar];
        
        _home = [Make10Util createHomeSprite];
        [self addChild:_home];
        
        [self createGain];
        [self prepNewLevel];
        
        [self createNextTile];
        [self createCurrentTile];
                
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

#pragma mark Touches

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    /*
     * Check if it was the home
     */
    if ([Make10Util isSpriteTouched:_home touches:touches]) {
        [self backToHome];
        return;
    }
    
    UITouch* touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];

    
    /*
     * Find out where in the wall was touched
     */
    Tile* tile = [_wall whichTileAtLocation:location];
    
    if (tile.value + _currentTile.value == _makeValue) {
        [self valueMade:tile];
    } else {
        [self valueNotMade:tile touchPoint:location];
    }
}

#pragma mark handle touch results
/**
 * Back to the home scene
 */
-(void) backToHome {
    NSLog(@"backToHome");
    
    [self stopAllActions];
    [_progressBar.sprite stopAllActions];
    
    [[CCDirector sharedDirector] replaceScene:[IntroLayer node]];
}
/**
 * Handle when the value is made
 * @param wallTile the tile touched to make the value
 */
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

/**
 * Callback when the value made wall tile is done
 */
-(void) wallTileKnockedDone:(id)sender {
    NSLog(@"wallTileKnockedDone");
    /*
     * Destroy both the current tile and the knockedWallTile
     * Create the next current tile
     */
    [_currentTile release];
    _currentTile = nil;

    _gain.position = _knockedWallTile.sprite.position;
    int tileCount = [_wall removeTile:_knockedWallTile];
    _knockedWallTile = nil;

    int pointGain = _score.pointValue * tileCount;
    [self updateScore:pointGain];
    [self levelUp];
    
    [self createCurrentTile];
}

/**
 * Update the score and gain labels 
 * @param pointGain int increase in points
 */
-(void) updateScore:(int)pointGain {
    [_gainLabel setString:[NSString stringWithFormat:@"+%d", pointGain]];
    _gain.visible = YES;
    [_gain runAction:[CCFadeOut actionWithDuration:0.15]];
    [_gainLabel runAction:[CCFadeOut actionWithDuration:0.15]];
    
    _score.score += pointGain;
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    [_scoreLabel setString:[formatter stringFromNumber:[NSNumber numberWithInt:_score.score]]];

    [formatter release];
}

/**
 * Check if the next level point benchmark has been reached
 * and if so show the level layer with the new level
 */
-(void) levelUp {
    /*
     * If the score is enough to advance to the next level,
     * stop the timer, 
     * clear the wall and prep for a new level,
     * show the level layer
     * then restart the timer
     */
    if ([_score levelUp]) {
        self.isTouchEnabled = NO;
        [self stopAllActions];
        [_progressBar resetBar];
        [_progressBar.sprite stopAllActions];

        [_wall clearWall];
        
        /*
         * If the challenge type was changing sum/product,
         * generate a new make value
         */
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSNumber* challengeType = [defaults objectForKey:PREF_CHALLENGE_TYPE]; //default set in IntroLayer
        
        if (PREF_CHALLENGE_TYPE_CHANGING == [challengeType intValue]) {
            _makeValue = [Make10Util genRandomMakeValue:_makeValue];
        }
        
        _levelLayer = [LevelLayer node];
        [_levelLayer setLevel:_score.level];
        [_levelLayer setMakeValue:_makeValue];
        [self addChild:_levelLayer];
        
        [self startLevelLayerProgress];
        
    }
}

/**
 * Starts the progress bar indicating how long before you have to be ready to play next level
 */
-(void) startLevelLayerProgress {
    [_progressBar resetBar];
    [_progressBar startWithDuration:5 target:self callback:@selector(startLevelFadeOut)];
}

/**
 * Fade out the level layer
 */
-(void) startLevelFadeOut {
    id actionFadeOut = [CCFadeOut actionWithDuration:LAYER_TRANS_TIME];
    id actionFadeOutDone = [CCCallFuncN actionWithTarget:self selector:@selector(levelFadeOutDone)];
    [_levelLayer runAction:[CCSequence actions:actionFadeOut, actionFadeOutDone, nil]];
    
}
/**
 * Callback when the level layer fades out
 */
-(void) levelFadeOutDone {
    if (_levelLayer) {
        [_levelLayer removeFromParentAndCleanup:YES];
        _levelLayer = nil;
    }
    [self prepNewLevel];
    
}

/**
 * Handle when the value is not made
 * @param wallTile Tile that was touched
 * @param touchPoint CGPoint that was touched in case there was no wallTile touched
 */
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

/**
 * Callback after the current tile becomes a part of the wall
 */
-(void) currentBecomesWallTileDone:(id)sender {
    NSLog(@"currentBecomesWallTileDone");
    /*
     * Create the next current tile
     */
    _currentTile = nil;
    [self createCurrentTile];
    
}

/**
 * Show the game over scene
 */
-(void) endGame {
    NSLog(@"endGame");

    self.isTouchEnabled = NO;
    [self stopAllActions];
    [_progressBar.sprite stopAllActions];
    
    GameOverScene* gameOverScene = [GameOverScene node];
    [gameOverScene.layer setScore:_score.score];
    [[CCDirector sharedDirector] replaceScene:gameOverScene];
}

// on "dealloc" you need to release all your retained objects
-(void) dealloc {
    [self stopAllActions];
    
    [_home removeFromParentAndCleanup:YES];
    _home = nil;
    
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
    
    if (_levelLayer) {
        [_levelLayer removeFromParentAndCleanup:YES];
    }
    _levelLayer = nil;
    
    [_progressBar release];
    _progressBar = nil;
    
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
