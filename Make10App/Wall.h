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

#import <Foundation/Foundation.h>
#import "Tile.h"

/**
 * Max rows of tiles
 */
static int const MAX_ROWS = 7;
/**
 * Max columns in a row of tiles
 */
static int const MAX_COLS = 8;
/**
 * The duration for the wall to rise
 */
static float const WALL_TRANS_TIME = 0.5f;

static NSString* const PREF_LEVEL = @"LEVEL";

@interface Wall : NSObject

/**
 * How many tiles were removed
 */
@property int removalCount;

/**
 * Initialize
 */
-(id) init;
/**
 * Transition all the wall rows up
 * @param target where callback is located
 * @param callback selector of callback
 */
-(void) transitionUpWithTarget:(id)target callback:(SEL)callback;

/**
 * Set a tile into the wall
 * @param tile Tile to place
 * @param row int row placement
 * @param col int col placement
 */
-(void) addTile:(Tile*)tile row:(int)row col:(int)col;
/**
 * Remove the tile from the wall grid
 * @param tile to remove
 * @return the number of tiles to remove (1)
 */
-(int) removeTile:(Tile*)tile;
-(int) removeAdjacentsWithValue:(int)value row:(int)row col:(int)col;
-(void) transitionDown;
/** 
 * Return YES when any tile has reached max row
 */
-(BOOL)isMax;
/**
 * Get up to 2 * MAX_COLS of possible values 
 */
-(NSMutableArray*) getPossibles;
/**
 * Return the tile at the given location or nil if none
 */
-(Tile*) whichTileAtLocation:(CGPoint)location;
/**
 * Check if there is an empty spot the row, col
 * @param row int row
 * @param col int col
 * @param YES if empty at the row and column
 */
-(BOOL) isEmptyAtRow:(int)row col:(int)col;
/**
 * Add a tile to the top of the column where the reference tile is
 * @param tileToAdd Tile* the current tile to add
 * @param refTile Tile* the tile used to determine the column
 * @return CGPoint where to position the tile or 0,0 if no empty spots found
 */
-(CGPoint) addTileAtopTile:(Tile*) tileToAdd referenceTile:(Tile*)refTile;
/**
 * Add a tile to the top of the column where touch point is
 * @param tileToAdd Tile* the current tile to add
 * @param location CGPoint the point used to determine the column
 * @return CGPoint where to position the tile or 0,0 if no empty spots found
 */
-(CGPoint) addTileToEmptyColumn:(Tile*) tileToAdd location:(CGPoint)location;
/**
 * Remove all the tiles from the wall
 */
-(void) clearWall;
@end
