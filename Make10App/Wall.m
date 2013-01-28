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


#import "Wall.h"

@implementation Wall

NSMutableArray *_tiles;

-(id) init {
    if (self = [super init]) {
        _tiles = [[NSMutableArray alloc] initWithCapacity:MAX_ROWS];
        for (int i = 0; i < MAX_ROWS; i++) {
            NSMutableArray *tileRow = [[NSMutableArray alloc] initWithCapacity:MAX_COLS];
            for (int j = 0; j < MAX_COLS; j++) {
                [tileRow addObject:[NSNull null]];
            }
            [_tiles addObject:tileRow];
        }
    }
    return self;
}

-(void) addTile: (Tile*)tile row:(int)row col:(int)col {
    NSMutableArray *tileRow = [_tiles objectAtIndex:row];
    [tileRow setObject:tile atIndexedSubscript:col];
}

-(void) spriteMoveFinished:(id)sender {
//    CCSprite *sprite = (CCSprite *)sender;
//    [self removeChild:sprite cleanup:YES];
//    
//    
//    if (sprite.tag == 1) {
//        [_targets removeObject:sprite];
//        GameOverScene *gameOverScene = [GameOverScene node];
//        [gameOverScene.layer.label setString:@"You lose :["];
//        [[CCDirector sharedDirector] replaceScene:gameOverScene];
//    } else if (sprite.tag == 2) {
//        [_projectiles removeObject:sprite];
//    }
}

-(void) transitionUp {
    NSLog(@"Wall.transitionUp");
    for (int i = 0; i < MAX_ROWS; i++) {
        NSMutableArray *tileRow = [_tiles objectAtIndex:i];
        for (int j = 0; j < MAX_COLS; j++) {
            if ([tileRow objectAtIndex:j] != [NSNull null]) {
                Tile *tile = [tileRow objectAtIndex:j];
                NSLog(@"Got Tile from row %d, col %d", i, j);
                tile.row++;
                int x = tile.sprite.contentSize.width * (j + 0.5);
                int y = tile.sprite.contentSize.height * (i + 0.5);
                
                id actionMove = [CCMoveTo actionWithDuration:2.0 position:ccp(x, y)];
                id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
                [tile.sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
                
            }
        }
    }
    
    /*
     * Unshift a new empty row
     */
    NSMutableArray *tileRow = [[NSMutableArray alloc] initWithCapacity:MAX_COLS];
    for (int j = 0; j < MAX_COLS; j++) {
        [tileRow addObject:[NSNull null]];
    }
    [_tiles insertObject:tileRow atIndex:0];
    
    /*
     * If too many rows, splice off
     */
    int size = [_tiles count];
    if (size > MAX_ROWS) {
        [_tiles removeObjectAtIndex:MAX_ROWS];
    }
}

-(void) removeTile {
    
}

-(void) removeAdjacentsWithValue:(int)value row:(int)row col:(int)col {
    
}

-(void) transitionDown {
    
}

-(BOOL)isMax {
    return false;
}

-(NSArray*) getPossibles {
    return [NSArray alloc];
}

- (void) dealloc
{
    [_tiles release];
    _tiles = nil;
	[super dealloc];
}
@end
