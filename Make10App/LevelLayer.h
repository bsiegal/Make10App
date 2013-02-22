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
#import "LevelLayerDelegate.h"

@interface LevelLayer : CCLayerColor


/**
 * Set the level
 * @param level to show
 */
-(void) setLevel:(int)level;

/**
 * Set the make value
 * @param makeValue to show
 */
-(void) setMakeValue:(int)makeValue;

/**
 * Set the mode as pause
 * @param pause YES to show Resume and New game buttons
 */
-(void) setPause:(BOOL)pause;

@property id <LevelLayerDelegate> delegate;
@end
