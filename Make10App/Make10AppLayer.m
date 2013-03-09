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
#import "SimpleAudioEngine.h"
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
    layer.tag = TAG_MAKE10_APP_LAYER;
	
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
//    NSLog(@"prepNewLevel");
    /*
     * Create 2 full row of tiles
     */
    [self createNewTilesForRow];
    [_wall transitionUpWithTarget:self callback:@selector(addWallRow)];
    
    [self createNextTile];
    [self createCurrentTile];
}

/**
 * Add a row to the wall.
 * Disable touch so there's no bad behavior when the wall is moving
 */
-(void) addWallRow {
    NSLog(@"addWallRow");
    
    self.isTouchEnabled = NO;

    int currentTileSpriteRunningActions = [_currentTile.sprite numberOfRunningActions];
    NSLog(@"addWallRow currentTile.sprite numberOfRunningActions = %d, currentTile.row = %d, currentTile.col = %d", currentTileSpriteRunningActions, _currentTile.row, _currentTile.col);
    
    if (currentTileSpriteRunningActions > 0 && _currentTile.row > 0) {
        _currentTile.row++;
        /*
         * If the current tile has a row (meaning valueNotMade so it's going to join the wall soon) and is in flight, increment its
         * row because it is not yet a part of the wall and the wall will be transitioning up.
         * Stop the action then "resume" after delay.
         */
        
        [_currentTile.sprite stopActionByTag:ACTION_TAG_ADD_TO_WALL];
        NSLog(@"addWallRow stoppedActionByTag for ACTION_TAG_ADD_TO_WALL");
        
        [self scheduleOnce:@selector(moveToAddToWall) delay:WALL_TRANS_TIME];
        
    } else if (currentTileSpriteRunningActions > 0 && _knockedWallTile) {
        /*
         * If the current tile is in flight and there is a _knockedWallTile (meaning
         * (valueMade so it might remove a tile right when the tiles need to transition up
         * This is a problem when it is the last tile moving up, the CCSequence will be gone
         * and then we'll never call the selector to restart the progressBar.
         * Solution to this is "pause" then "resume" after delay.
         */
        [_currentTile.sprite stopActionByTag:ACTION_TAG_KNOCK];
        NSLog(@"addWallRow stoppedActionByTag for ACTION_TAG_KNOCK");
        
        [self scheduleOnce:@selector(knockWallTile) delay:WALL_TRANS_TIME];
        
    }

    /*
     * Create full row of tiles
     */
    [self createNewTilesForRow];
    /*
     * Transition the wall up
     */
    [_wall transitionUpWithTarget:self callback:@selector(startProgressBar)];
    
}


/**
 * Create and place the next tile
 */
-(void) createNextTile {
//    NSLog(@"createNextTile");
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
//    NSLog(@"createCurrentTile");
    [_nextTile transitionToCurrentWithTarget:self callback:@selector(nextMovedToCurrentPosition)];
    _currentTile = _nextTile;
    _nextTile = nil;
}

/**
 * Callback of createCurrentTile
 */
-(void) nextMovedToCurrentPosition {
    /*
     * Create the next tile
     */
    [self createNextTile];
}

/**
 * Create the score label
 */
-(void) createScoreLabelAndProgress {
//    NSLog(@"placeScoreLabel");
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite* score = [Make10Util createWhiteBoxSprite];
    [self addChild:score];
    
    _scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Make %d", _makeValue] fontName:@"American Typewriter" fontSize:[Make10Util getTitleFontSize]];
    _scoreLabel.color = ccc3(0, 0, 0);
    _scoreLabel.position = ccp(winSize.width / 2, winSize.height - [Make10Util getMarginTop] - [Make10Util getUpperLabelPadding] - [Make10Util getScoreLabelHeight] / 2);
    [self addChild:_scoreLabel];


    /*
     * Create the progress bar
     */
    _progressBar = [[Progress alloc] init];
    
    float progressY = _scoreLabel.position.y - [Make10Util getScoreLabelHeight] / 2 - [Make10Util getUpperLabelPadding] - _progressBar.spriteBg.contentSize.height / 2;
    _progressBar.spriteBg.position = ccp(winSize.width / 2, progressY);
    
    [self addChild:_progressBar.spriteBg];
//    [self addChild:_progressBar.sprite];
}
/**
 * Create the sprite to show for earned points
 */
-(void) createGain {
//    NSLog(@"createGain");
    _gain = [CCSprite spriteWithSpriteFrameName:@"gain.png"];
    _gain.position = ccp(100, 300);
    [self addChild:_gain];
    
    _gainLabel = [CCLabelTTF labelWithString:@"+10" fontName:@"American Typewriter" fontSize:[Make10Util getGainFontSize]];
    _gainLabel.color = ccc3(0, 0, 0);
    _gainLabel.position = ccp(_gain.contentSize.width / 2, _gain.contentSize.height / 2);
    [_gain addChild:_gainLabel];
    _gain.visible = NO;
}

/**
 * Start the progress bar and enable touch
 */
-(void) startProgressBar {
    NSLog(@"startProgressBar");
    
    [_progressBar resetBar];
    [_progressBar startWithDuration:_score.wallTime target:self callback:@selector(addWallRow)];
    self.isTouchEnabled = YES;
    
    /*
     * If the wall has reached the max, show the game over scene after a slight delay
     */
    if ([_wall isMax]) {
        [self endGame];
        return;
    }
    


}

#pragma mark init

// on "init" you need to initialize your instance
-(id) init {
//    NSLog(@"Make10AppLayer.init");
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super init]) {
        
        CCSprite* background = [Make10Util genLayerBackgroundWithName:@"playBg"];
        [self addChild:background];
        
        _home = [Make10Util createHomeSprite];
        [self addChild:_home];
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE];
        _makeValue = [makeValue intValue];
        
        _score = [[Score alloc] init];
        _wall = [[Wall alloc] init];
        
        [self createScoreLabelAndProgress];
        
        
        [self createGain];
        [self prepNewLevel];

	}
	return self;
}

#pragma mark Touches

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    /*
     * Check if it was the home
     * (and there's no levelLayer showing)
     */
    if (!_levelLayer && [Make10Util isSpriteTouched:_home touches:touches]) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"click.m4a"];
        [[CCDirector sharedDirector] pause];
        [self showLevelLayerWithPause:YES];
        return;
    }
    
    /*
     * If the current tile is in flight
     * do not respond to touches
     */
    if ([_currentTile.sprite numberOfRunningActions] > 0) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"click.m4a"];
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

#pragma mark value made
///**
// * Back to the home scene
// */
//-(void) backToHome {
//    
//    [self stopAllActions];
//    [_progressBar.timeBar stopAllActions];
//    
//    [[CCDirector sharedDirector] replaceScene:[IntroLayer node]];
//}
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
    _knockedWallTile = wallTile;
    
    [self knockWallTile];
}

-(void) knockWallTile {
    CGPoint point = _knockedWallTile.sprite.position;
    [_currentTile transitionToPoint:point target:self callback:@selector(wallTileKnockedDone:) actionTag:ACTION_TAG_KNOCK];
    
}

/**
 * Callback when the value made wall tile is done
 */
-(void) wallTileKnockedDone:(id)sender {
    NSLog(@"wallTileKnockedDone");
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"knock.m4a"];
    

    /*
     * Destroy both the current tile and the knockedWallTile
     * Create the next current tile
     */
    [_currentTile release];
    _currentTile = nil;

    _gain.position = _knockedWallTile.sprite.position;
    int tileCount = [_wall removeTile:_knockedWallTile];
    _knockedWallTile = nil;

    _score.tilesRemoved += tileCount;
    int pointGain = _score.pointValue * tileCount;
    _gain.scale = 1.0f;
    
    [self updateScore:pointGain];
    [self levelUp];
    
    [self createCurrentTile];
//    NSLog(@"wallTileKnockedDone before createCurrentTile isTouchEnabled = %d, \n_progressBar.timeBar.numberOfRunningActions = %d,\nwall.needToMoveUpCount = %d", self.isTouchEnabled, _progressBar.timeBar.numberOfRunningActions, _wall.needToMoveUpCount);
}

/**
 * Update the score and gain labels 
 * @param pointGain int increase in points
 */
-(void) updateScore:(int)pointGain {
    [_gainLabel setString:[NSString stringWithFormat:@"+%d", pointGain]];
    _gain.visible = YES;
    [_gain runAction:[CCScaleTo actionWithDuration:TILE_DROP_TIME scale:1.50]];
    [_gain runAction:[CCFadeOut actionWithDuration:TILE_DROP_TIME]];
    [_gainLabel runAction:[CCFadeOut actionWithDuration:TILE_DROP_TIME]];
    
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
 * Check if the next level benchmark has been reached
 * and if so show the level layer with the new level
 */
-(void) levelUp {
    /*
     * If the wall was completely cleared, push score above benchmark
     */
    if ([_wall isWallClear]) {
        _score.tilesRemoved = LEVEL_MARKER;
    }
    /*
     * If enough to advance to the next level,
     * stop the timer, 
     * clear the wall and prep for a new level,
     * show the level layer
     * then restart the timer
     */
    if ([_score levelUp]) {
        self.isTouchEnabled = NO;
        
        [self stopAllActions];
        [_progressBar resetBar];
        [_progressBar.timeBar stopAllActions];

        [_wall clearWall];
        [_nextTile release];
        _nextTile = nil;
        [_currentTile release];
        _currentTile = nil;
        
        /*
         * If the challenge type was changing sum/product,
         * generate a new make value
         */
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSNumber* challengeType = [defaults objectForKey:PREF_CHALLENGE_TYPE]; //default set in IntroLayer
        
        if (PREF_CHALLENGE_TYPE_CHANGING == [challengeType intValue]) {
            _makeValue = [Make10Util genRandomMakeValue:_makeValue];
        }
        
        [self showLevelLayerWithPause:NO];
        [self startLevelLayerProgress];
        
    }
}
/**
 * Show the level layer
 * @param pause YES if it is pause mode
 */
-(void) showLevelLayerWithPause:(BOOL)pause {
    LevelLayer* pauseLayer = [LevelLayer node];
    [pauseLayer setLevel:_score.level];
    [pauseLayer setMakeValue:_makeValue];
    [pauseLayer setPause:pause];

    if (pause) {
        pauseLayer.delegate = self;
        self.pauseLayerShowing = YES;
    }
    [self addChild:pauseLayer];
    _levelLayer = pauseLayer;

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

    [_levelLayer removeFromParentAndCleanup:YES];
    _levelLayer = nil;
    
    [self prepNewLevel];
    
}

#pragma mark LevelLayerDelegate
/**
 * Callback when the pause layer fades out
 */
-(void) layerFadeOutDone {

    [_levelLayer removeFromParentAndCleanup:YES];
    _levelLayer = nil;
    
    self.pauseLayerShowing = NO;
    
}

#pragma mark value not made
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
        CGPoint newPosition = [_wall getPointAtopTile: _currentTile referenceTile:wallTile];
        
        if (newPosition.x != 0 && newPosition.y != 0) {
            
            [_currentTile transitionToPoint:newPosition target:self callback:@selector(currentBecomesWallTileDone:) actionTag:ACTION_TAG_ADD_TO_WALL];
//            NSLog(@"valueNotMade wallTile !nil, currentTile.row = %d, currentTile.col = %d", _currentTile.row, _currentTile.col);
            
        } else {
            /*
             * No empty spot found (wall at max), so end game
             */
            [self endGame];
        }
        
    } else {
        CGPoint newPosition = [_wall getPointInEmptySpot:_currentTile location:point];
        if (newPosition.x != 0 && newPosition.y != 0) {
            
            [_currentTile transitionToPoint:newPosition target:self callback:@selector(currentBecomesWallTileDone:) actionTag:ACTION_TAG_ADD_TO_WALL];
            
//            NSLog(@"valueNotMade wallTile nil, currentTile.row = %d, currentTile.col = %d", _currentTile.row, _currentTile.col);

        }
        /*
         * else clicked too high or in margin, just ignore and do nothing
         */
    }
}

-(void) moveToAddToWall {
    CGPoint newPosition = [_wall getPointInGrid:_currentTile row:_currentTile.row col:_currentTile.col];
    [_currentTile transitionToPoint:newPosition target:self callback:@selector(currentBecomesWallTileDone:) actionTag:ACTION_TAG_ADD_TO_WALL];
}

/**
 * Callback after the current tile becomes a part of the wall
 */
-(void) currentBecomesWallTileDone:(id)sender {
    NSLog(@"currentBecomesWallTileDone");

    /*
     * If the current tile transitioned to a point when the
     * when the wall was moving, we still need to position it
     * so it is in the exact grid location
     */
    int row = _currentTile.row;
    int col = _currentTile.col;
    [_wall snapTileToGrid:_currentTile row:row col:col];
    [_wall addTile:_currentTile row:row col:col];
    
    /*
     * Create the next current tile
     */
    _currentTile = nil;
    [self createCurrentTile];

    /*
     * If the wall has reached the max, show the game over scene after a slight delay
     */
    if ([_wall isMax]) {
        [self endGame];
        return;
    }
    
}

/**
 * End the game
 */
-(void) endGame {
//    NSLog(@"endGame");
    
    int randSuffix = arc4random() % 3 + 1;
    NSString* fileName = [NSString stringWithFormat:@"gameOver%d.m4a", randSuffix];
    [[SimpleAudioEngine sharedEngine] playEffect:fileName];
    
    self.isTouchEnabled = NO;
//    NSLog(@"isTouchEnabled is set to NO (endGame)");
    [self stopAllActions];
    [_progressBar.timeBar  stopAllActions];
    
    [self scheduleOnce:@selector(showGameOver) delay:GAME_OVER_DELAY];
    
}

/**
 * Switch to the game over scene
 */
-(void) showGameOver {

    GameOverScene* gameOverScene = [GameOverScene node];
    [gameOverScene.layer setScore:_score.score];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:LAYER_TRANS_TIME scene:gameOverScene]];
}

//-(void) onExit {
//    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"playBg.plist"];
//    [super onExit];
//}


// on "dealloc" you need to release all your retained objects
-(void) dealloc {
//    NSLog(@"Make10AppLayer dealloc");
    self.isTouchEnabled = NO;
    
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
    
    [_levelLayer removeFromParentAndCleanup:YES];
    _levelLayer = nil;
    
    [_progressBar release];
    _progressBar = nil;
    
    [self removeFromParentAndCleanup:YES];
	[super dealloc];
}

@end
