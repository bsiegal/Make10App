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

NSMutableArray* _tiles;

-(id) init {
    if (self = [super init]) {
        _tiles = [[NSMutableArray alloc] initWithCapacity:MAX_ROWS];
        for (int i = 0; i < MAX_ROWS; i++) {
            NSMutableArray* tileRow = [[NSMutableArray alloc] initWithCapacity:MAX_COLS];
            for (int j = 0; j < MAX_COLS; j++) {
                [tileRow addObject:[NSNull null]];
            }
            [_tiles addObject:tileRow];
        }
    }
    return self;
}

-(void) addTile: (Tile*)tile row:(int)row col:(int)col {
    NSMutableArray* tileRow = [_tiles objectAtIndex:row];
    [tileRow setObject:tile atIndexedSubscript:col];
}

-(void) spriteMoveFinished:(id)sender {
//    CCSprite* sprite = (CCSprite* )sender;
//    [self removeChild:sprite cleanup:YES];
//    
//    
//    if (sprite.tag == 1) {
//        [_targets removeObject:sprite];
//        GameOverScene* gameOverScene = [GameOverScene node];
//        [gameOverScene.layer.label setString:@"You lose :["];
//        [[CCDirector sharedDirector] replaceScene:gameOverScene];
//    } else if (sprite.tag == 2) {
//        [_projectiles removeObject:sprite];
//    }
}

-(void) transitionUp {
    NSLog(@"Wall.transitionUp");
    for (int i = 0; i < MAX_ROWS; i++) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:i];
        for (int j = 0; j < MAX_COLS; j++) {
            if ([tileRow objectAtIndex:j] != [NSNull null]) {
                Tile* tile = [tileRow objectAtIndex:j];
//                NSLog(@"Got (%@) from row %d, col %d", tile, i, j);
                tile.row++;// = i + 1;
                int x = tile.sprite.contentSize.width * (j + 0.5);
                int y = tile.sprite.contentSize.height * (i + 0.5);
                
                id actionMove = [CCMoveTo actionWithDuration:0.5 position:ccp(x, y)];
                id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
                [tile.sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
                
            }
        }
    }
    
    /*
     * Unshift a new empty row
     */
    NSMutableArray* tileRow = [[NSMutableArray alloc] initWithCapacity:MAX_COLS];
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

-(int) removeTile:(Tile*)tile {
    int row = tile.row;
    int col = tile.col;
    
    /*
     * Destroy the tile and nullify the grid at the row, col
     */
    NSMutableArray* tileRow = [_tiles objectAtIndex:row];
    [tile destroy];
    [tileRow replaceObjectAtIndex:col withObject:[NSNull null]];

    NSLog(@"Wall.removeTile tileRow at row:%d = %@", row, tileRow);
    /*
     * Move all the ones above in the same col down one row
     */
    for (int i = row + 1; i < MAX_ROWS; i++) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:i];
        if ([tileRow objectAtIndex:col] != [NSNull null]) {
            Tile* tile = [tileRow objectAtIndex:col];
            tile.row--;
            
            NSMutableArray* tileRowBelow = [_tiles objectAtIndex:tile.row];
            [tileRowBelow replaceObjectAtIndex:col withObject:tile];

            int y = tile.sprite.contentSize.height;
                
            id actionMove = [CCMoveBy actionWithDuration:0.25 position:ccp(0, -y)];
            id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
            [tile.sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
            
            /*
             * Nullify the spot from where it dropped
             */
            [tileRow replaceObjectAtIndex:col withObject:[NSNull null]];
        }
        
    }
    
    return 1;
}

-(int) removeAdjacentsWithValue:(int)value row:(int)row col:(int)col {
    self.removalCount = 0;
    [self removeAdjacentsWithValue:value row:row col:col];
    return self.removalCount;
}

-(BOOL) removeAdjacents:(int)value row:(int)row col:(int)col {
    self.removalCount++;
    return YES;
}

-(void) transitionDown {
    
}

-(BOOL)isMax {
    NSMutableArray* topRow = [_tiles objectAtIndex:MAX_ROWS - 1];
    for (int j = 0; j < MAX_COLS; j++) {
        if ([topRow objectAtIndex:j] != [NSNull null]) {
            return YES;
        }
        
    }
    return NO;
}

-(NSMutableArray*) getPossibles {
    NSMutableArray* possibles = [NSMutableArray array];
    for (int i = MAX_ROWS - 1; i >= 0; i--) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:i];
        for (int j = 0; j < MAX_COLS; j++) {
            if ([tileRow objectAtIndex:j] != [NSNull null]) {
                Tile* tile = [tileRow objectAtIndex:j];
                
                [possibles addObject:[NSNumber numberWithInt:tile.value]];
                if ([possibles count] > MAX_COLS * 2) {
                    return possibles;
                }
            }
        }
    }
    return possibles;
}

-(Tile*) whichTileAtLocation:(CGPoint)location {
    NSLog(@"Wall.whichTileAtLocation");
    
    for (int i = 0; i < MAX_ROWS; i++) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:i];
        for (int j = 0; j < MAX_COLS; j++) {
            if ([tileRow objectAtIndex:j] != [NSNull null]) {
                Tile* tile = [tileRow objectAtIndex:j];
                
                float x = tile.sprite.position.x - tile.sprite.contentSize.width / 2;
                float y = tile.sprite.position.y - tile.sprite.contentSize.height / 2;
                
                CGRect touchArea = CGRectMake(x, y, tile.sprite.contentSize.width, tile.sprite.contentSize.height);
                if (CGRectContainsPoint(touchArea, location)) {
                    NSLog(@"Found! returning tile with value %d", tile.value);
                    return tile;
                }
            }
        }
    }
    return nil;
}

-(BOOL) isEmptyAtRow:(int)row col:(int)col {
    NSMutableArray* tileRow = [_tiles objectAtIndex:row];
    if ([tileRow objectAtIndex:col] != [NSNull null]) {
        return NO;
    }
    return YES;
}

-(CGPoint) addTileAtopTile:(Tile*) tileToAdd referenceTile:(Tile*)refTile {
    int col = refTile.col;
    for (int i = refTile.row + 1; i < MAX_ROWS; i++) {
        if ([self isEmptyAtRow:i col:col]) {
            
            tileToAdd.row = i;
            tileToAdd.col = col;
            NSMutableArray* tileRow = [_tiles objectAtIndex:i];
            [tileRow replaceObjectAtIndex:col withObject:tileToAdd];
            
            int x = refTile.sprite.contentSize.width * (col + 0.5);
            int y = refTile.sprite.contentSize.height * (i - 0.5);
            
            return ccp(x, y);
        }
    }
    return ccp(0, 0);
}

-(CGPoint) addTileToEmptyColumn:(Tile *)tileToAdd location:(CGPoint)location {
    /*
     * Find the column that the location is closest to by checking the x
     */
    int col = 0;
    int width = tileToAdd.sprite.contentSize.width;
    int height = tileToAdd.sprite.contentSize.height;
    
    for (int j = 0; j < MAX_COLS; j++) {
        int minX = width * j;
        int maxX = width * (j + 1);
        if (location.x >= minX && location.x <= maxX) {
            col = j;
            break;
        }
    }
    
    /*
     * If the column is empty (check row 1) and the 
     * location was no higher than row 1
     */
    if ([self isEmptyAtRow:1 col:col] && location.y >= 0 && location.y < height) {
            
        tileToAdd.row = 1;
        tileToAdd.col = col;
        NSMutableArray* tileRow = [_tiles objectAtIndex:1];
        [tileRow replaceObjectAtIndex:col withObject:tileToAdd];
            
        int x = width * (col + 0.5);
        int y = height * 0.5;
            
        return ccp(x, y);
    }
    
    /*
     * Column wasn't empty so return 0, 0
     */
    return ccp(0, 0);
}

-(void) clearWall {
    NSLog(@"Wall.clearWall");
    for (int i = 0; i < MAX_ROWS; i++) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:i];
        for (int j = 0; j < MAX_COLS; j++) {
            if ([tileRow objectAtIndex:j] != [NSNull null]) {
                Tile* tile = [tileRow objectAtIndex:j];
                [tile destroy];
                [tileRow replaceObjectAtIndex:j withObject:[NSNull null]];
            }
        }
    }

}

-(void) dealloc {
    [_tiles release];
    _tiles = nil;
	[super dealloc];
}
@end
