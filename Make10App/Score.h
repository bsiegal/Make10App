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
#import "Make10Util.h"


@interface Score : NSObject

/**
 * Allocate and initialize
 */
+(Score*) create;
/**
 * The running score
 */
@property int score;
/**
 * The current point value
 */
@property int pointValue;
/**
 * The current level
 */
@property int level;
/**
 * The time in seconds a wall row is added
 */
@property int wallTime;

/**
 * Increase the level, point value and wall speed
 * if the score passes the bench mark
 * @return YES if level increases, NO if it stays as is
 */
-(BOOL) levelUp;
@end
