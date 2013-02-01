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
#import "cocos2d.h"

@interface Tile : NSObject

/**
 * The sprite of this tile
 */
@property (readonly) CCSprite *sprite;
/**
 * The value of this tile
 */
@property (readonly) int value;
/**
 * The column of this tile in the wall
 */
@property int col;
/**
 * The row of this tile in the wall
 */
@property int row;
/**
 * An init method with value and boolean for current tile
 * @param value int for the tile
 */
-(id) initWithValue:(int)value;
/**
 * An init method with value and column for placement
 * @param value int for the tile
 * @param col int column placement
 */
-(id) initWithValueAndCol:(int)value col:(int)col;
/**
 * Move the tile to the current tile position
 */
-(void) transitionToCurrent;
/**
 * Move the tile to the point
 */
-(void) transitionToPoint:(CGPoint)point target:(id)target callback:(SEL)callback;

@end
