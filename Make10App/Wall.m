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
    [tileRow replaceObjectAtIndex:col withObject:tile];
}

-(void) transitionUpWithTarget:(id)target callback:(SEL)callback {
//    NSLog(@"Wall.transitionUpWithTarget");
    /*
     * Figure out what tiles need to be moved and do them
     * all at once so we know when we get to the last one.
     */
    NSMutableArray* tiles = [NSMutableArray array];
    for (int i = 0; i < MAX_ROWS; i++) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:i];
        for (int j = 0; j < MAX_COLS; j++) {
            if ([tileRow objectAtIndex:j] != [NSNull null]) {
                
                Tile* tile = [tileRow objectAtIndex:j];
                tile.row++;// = i + 1;

                [tiles addObject:tile];
            }
        }
    }

    /*
     * Move all the tiles up except for the last one.
     * Do the last one with the callback at the end of the function
     */
    for (int index = 0, len = [tiles count]; index < len; index++) {
        Tile* tile = [tiles objectAtIndex:index];
        
        id actionMove = [CCMoveTo actionWithDuration:WALL_TRANS_TIME position:[self getPointInGrid:tile row:tile.row col:tile.col]];
        if (target && index == len - 1) {
            id actionMoveDone = [CCCallFuncN actionWithTarget:target selector:callback];
            [tile.sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
            
        } else {
            id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(snapAllToGrid)];
            [tile.sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
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
        NSMutableArray* extraTileRow = [_tiles objectAtIndex:MAX_ROWS];
        [extraTileRow release];
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
    [tile release];
    [tileRow replaceObjectAtIndex:col withObject:[NSNull null]];

//    NSLog(@"Wall.removeTile tileRow at row:%d = %@", row, tileRow);
    /*
     * Drop all the tiles in the column in rows above by height of 1 tile
     */
    for (int i = row + 1; i < MAX_ROWS; i++) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:i];
        if ([tileRow objectAtIndex:col] != [NSNull null]) {
            Tile* tile = [tileRow objectAtIndex:col];
            tile.row--;
                        
            NSMutableArray* tileRowBelow = [_tiles objectAtIndex:tile.row];
            [tileRowBelow replaceObjectAtIndex:col withObject:tile];
            
            /*
             * It would be nice to use moveBy negative 1 height of the tile,
             * but if the wall is transitioning up at the time, the it can end
             * up mis-aligned.  Let's use an exact move To
             */
            id actionMove = [CCMoveTo actionWithDuration:TILE_DROP_TIME position:[self getPointInGrid:tile row:tile.row col:tile.col]];
            id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(snapAllToGrid)];
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
    [self removeAdjacents:value row:row col:col];
    [self transitionDown];
    return self.removalCount;
}

-(BOOL) removeAdjacents:(int)value row:(int)row col:(int)col {
    /*
     * If this row and column has the same value, remove this tile
     * then check the rows above and below or the columns to the left and right
     * Increment the removal count and return YES.
     * Otherwise return no and stop recursion.
     */
    if (row < MAX_ROWS && col < MAX_COLS) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:row];
        Tile* tile = [tileRow objectAtIndex:row];
        if (tile && tile.value == value) {
            self.removalCount++;
            return [self removeAdjacents:value row:row + 1 col:col] ||
            [self removeAdjacents:value row:row - 1 col:col] ||
            [self removeAdjacents:value row:row col:col + 1] ||
            [self removeAdjacents:value row:row col:col - 1];
        }
    }
    return NO;
}

-(void) transitionDown {
    /*
     * Comb through and drop all tiles to fill any gaps
     */
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
//    NSLog(@"Wall.whichTileAtLocation");

    for (int i = 0; i < MAX_ROWS; i++) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:i];
        for (int j = 0; j < MAX_COLS; j++) {
            if ([tileRow objectAtIndex:j] != [NSNull null]) {
                Tile* tile = [tileRow objectAtIndex:j];
                
                float x = tile.sprite.position.x - tile.sprite.contentSize.width / 2;
                float y = tile.sprite.position.y - tile.sprite.contentSize.height / 2;
                
                CGRect touchArea = CGRectMake(x, y, tile.sprite.contentSize.width, tile.sprite.contentSize.height);
                if (CGRectContainsPoint(touchArea, location)) {
//                    NSLog(@"Found! returning tile with value %d", tile.value);
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

-(CGPoint) getPointAtopTile:(Tile*) tileToAdd referenceTile:(Tile*)refTile {
    int col = refTile.col;
    for (int i = refTile.row + 1; i < MAX_ROWS; i++) {
        if ([self isEmptyAtRow:i col:col]) {
            
            tileToAdd.row = i;
            tileToAdd.col = col;
            
            return [self getPointInGrid:tileToAdd row:tileToAdd.row col:tileToAdd.col];
        }
    }
    return ccp(0, 0);

}
-(CGPoint) getPointInEmptySpot:(Tile*) tileToAdd location:(CGPoint)location {
    /*
     * Find the column and row that the location is closest to
     */
    int col = 0;
    int width = tileToAdd.sprite.contentSize.width;
    int height = tileToAdd.sprite.contentSize.height;
    
    for (int j = 0; j < MAX_COLS; j++) {
        float minX = width * j + [Make10Util getMarginSide];
        float maxX = width * (j + 1) + [Make10Util getMarginSide];
        if (location.x >= minX && location.x <= maxX) {
            col = j;
            break;
        }
    }
    
    /*
     * If the column is empty (check row 1) and the location
     * was no higher than row 1
     */
    if ([self isEmptyAtRow:1 col:col] && location.y >= 0 && location.y < height) {
        tileToAdd.row = 1;
        tileToAdd.col = col;
        
        return [self getPointInGrid:tileToAdd row:1 col:col];
    }
    
    /*
     * If the column is empty at the row and the column directly below is not empty
     */
    for (int i = 2; i < MAX_ROWS; i++) {
        int minY = height * (i - 1);
        int maxY = height * i;
        if (location.y >= minY && location.y <= maxY &&
            ![self isEmptyAtRow:(i - 1) col:col]) {
            tileToAdd.row = i;
            tileToAdd.col = col;
            
            return [self getPointInGrid:tileToAdd row:tileToAdd.row col:tileToAdd.col];
            
        }
    }
    
    /*
     * Column wasn't empty so return 0, 0
     */
    return ccp(0, 0);

}

-(CGPoint) addTileAtopTile:(Tile*) tileToAdd referenceTile:(Tile*)refTile {
    int col = refTile.col;
    for (int i = refTile.row + 1; i < MAX_ROWS; i++) {
        if ([self isEmptyAtRow:i col:col]) {
            
            tileToAdd.row = i;
            tileToAdd.col = col;
            NSMutableArray* tileRow = [_tiles objectAtIndex:i];
            [tileRow replaceObjectAtIndex:col withObject:tileToAdd];
            
            float x = refTile.sprite.contentSize.width * (col + 0.5) + [Make10Util getMarginSide];
            float y = refTile.sprite.contentSize.height * (i - 0.5) + [Make10Util getMarginTop];
            
            return ccp(x, y);
        }
    }
    return ccp(0, 0);
}

-(CGPoint) addTileToEmptyColumn:(Tile *)tileToAdd location:(CGPoint)location {
    /*
     * Find the column and row that the location is closest to
     */
    int col = 0;
    int width = tileToAdd.sprite.contentSize.width;
    int height = tileToAdd.sprite.contentSize.height;
    
    for (int j = 0; j < MAX_COLS; j++) {
        float minX = width * j + [Make10Util getMarginSide];
        float maxX = width * (j + 1) + [Make10Util getMarginSide];
        if (location.x >= minX && location.x <= maxX) {
            col = j;
            break;
        }
    }

    /*
     * If the column is empty (check row 1) and the location
     * was no higher than row 1
     */
    if ([self isEmptyAtRow:1 col:col] && location.y >= 0 && location.y < height) {
        tileToAdd.row = 1;
        tileToAdd.col = col;
        NSMutableArray* tileRow = [_tiles objectAtIndex:1];
        [tileRow replaceObjectAtIndex:col withObject:tileToAdd];
        
        [self getPointInGrid:tileToAdd row:tileToAdd.row col:tileToAdd.col];
    }
    
    /*
     * If the column is empty at the row and the column directly below is not empty
     */
    for (int i = 2; i < MAX_ROWS; i++) {
        int minY = height * (i - 1);
        int maxY = height * i;
        if (location.y >= minY && location.y <= maxY &&
                ![self isEmptyAtRow:(i - 1) col:col]) {
            tileToAdd.row = i;
            tileToAdd.col = col;
            NSMutableArray* tileRow = [_tiles objectAtIndex:i];
            [tileRow replaceObjectAtIndex:col withObject:tileToAdd];
            
            [self getPointInGrid:tileToAdd row:tileToAdd.row col:tileToAdd.col];

        }
    }

    /*
     * Column wasn't empty so return 0, 0
     */
    return ccp(0, 0);
}

-(void) clearWall {
//    NSLog(@"Wall.clearWall");

    for (int i = 0; i < MAX_ROWS; i++) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:i];
        for (int j = 0; j < MAX_COLS; j++) {
            if ([tileRow objectAtIndex:j] != [NSNull null]) {
                Tile* tile = [tileRow objectAtIndex:j];
                [tile release]; 
                [tileRow replaceObjectAtIndex:j withObject:[NSNull null]];
            }
        }
    }

}

-(BOOL) isWallClear {
    
    for (int i = 0; i < MAX_ROWS; i++) {
        for (int j = 0; j < MAX_COLS; j++) {
            if (![self isEmptyAtRow:i col:j]) {
//                NSLog(@"Wall.isWallClear NO");
                return NO;
            }
        }
    }
//    NSLog(@"Wall.isWallClear YES");

    return YES;
}

-(CGPoint) getPointInGrid:(Tile*) tile row:(int)row col:(int)col {
    int width = tile.sprite.contentSize.width;
    int height = tile.sprite.contentSize.height;
    
    float x = width * (col + 0.5) + [Make10Util getMarginSide];
    float y = height * (row - 0.5) + [Make10Util getMarginTop];
    
    return ccp(x, y);
}

-(void) snapAllToGrid {
    
    for (int i = 0; i < MAX_ROWS; i++) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:i];
        
        for (int j = 0; j < MAX_COLS; j++) {
            if ([tileRow objectAtIndex:j] != [NSNull null]) {
                Tile* tile = [tileRow objectAtIndex:j];
                [self snapTileToGrid:tile row:tile.row col:tile.col];
            }
        }
    }
    
}

-(void) snapTileToGrid:(Tile*)tile row:(int)row col:(int)col {
    tile.sprite.position = [self getPointInGrid:tile row:row col:col];
}

-(void) dealloc {
    [self clearWall];
    
    //release each tileRow
    for (int i = 0; i < MAX_ROWS; i++) {
        NSMutableArray* tileRow = [_tiles objectAtIndex:i];
        [tileRow release];
    }

    [_tiles release];
    _tiles = nil;
	[super dealloc];
}
@end
