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

static int const MAX_ROWS = 7;
static int const MAX_COLS = 7;

@interface Wall : NSObject

/**
 * Initialize
 */
-(id) init;
/**
 * Transition all the wall rows up
 */
-(void) transitionUp;
/** 
 * Set a tile into the wall
 * @param tile Tile to place
 * @param row int row placement
 * @param col int col placement
 */
-(void) addTile:(Tile*)tile row:(int)row col:(int)col;
-(void) removeTile;
-(void) removeAdjacentsWithValue:(int)value row:(int)row col:(int)col;
-(void) transitionDown;
-(BOOL)isMax;
-(NSArray*) getPossibles;

@end
