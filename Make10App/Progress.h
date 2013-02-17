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

@interface Progress : NSObject

/**
 * Allocate and initialize
 */
+(Progress*) create;

@property (readonly) CCProgressTimer* timeBar;

/**
 * The sprite of the background bar
 */
@property (readonly) CCSprite* spriteBg;

/**
 * The action of the progress bar running
 */
@property (readonly) CCFiniteTimeAction* progressAction;
/**
 * Start the progress bar
 * @param duration of progress
 * @param target where callback is located
 * @param callback selector of callback
 */
-(void) startWithDuration:(int)duration target:(id)target callback:(SEL)callback;

/**
 * Reset the progress bar
 */
-(void) resetBar;

@end
