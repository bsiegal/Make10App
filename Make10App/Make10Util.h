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

/**
 * Default make value
 */
static int const MAKE_VALUE_DEFAULT = 10;

/**
 * Tiles needed to remove advance to next level
 * (MAX_COLS x MAX_ROWS)
 */
static int const LEVEL_MARKER = 5;//56;

/**
 * The duration scenes to change
 */
static float const LAYER_TRANS_TIME = 0.5f;

/**
 * The duration between wall risings for level 1
 */
static float const SLOWEST_WALL_SPEED = 12;//28;

/**
 * The wall will never be faster than 8 no matter the level
 */
static float const FASTEST_WALL_SPEED = 8;

/**
 * The delay before showing the game over scene
 */
static float const GAME_OVER_DELAY = 1;
/**
 * Preference for the make value
 */
static NSString* const PREF_MAKE_VALUE = @"MAKE_VALUE";

/**
 * Preference for the starting level
 */
static NSString* const PREF_START_LEVEL = @"START_LEVEL";

/**
 * Preference for the operation
 */
static NSString* const PREF_OPERATION = @"OPERATION";

/**
 * Preference for the operation addition
 */
static int const PREF_OPERATION_ADDITION = 0;

/**
 * Preference for the operation multiplication
 */
static int const PREF_OPERATION_MULTIPLICATION = 1;

/**
 * Preference for the challenge type
 */
static NSString* const PREF_CHALLENGE_TYPE = @"CHALLENGE_TYPE";

/**
 * Preference for the challenge type of increasing speed
 */
static int const PREF_CHALLENGE_TYPE_SPEED = 0;

/**
 * Preference for the challenge type of changing sums or products
 */
static int const PREF_CHALLENGE_TYPE_CHANGING = 1;

/**
 * Preference for tile style
 */
static NSString* const PREF_TILE_STYLE = @"TILE_STYLE";

/**
 * Preference for tile style of numbers
 */
static int const PREF_TILE_STYLE_NUMBERS = 0;

/**
 * Preference for tile style of mahjong dots
 */
static int const PREF_TILE_STYLE_DOTS = 1;

/**
 * Preference for the local high score
 */
static NSString* const PREF_HIGH_SCORE = @"HIGH_SCORE";

@interface Make10Util : NSObject

/**
 * Generate a textured background sprite with color
 */
+(CCSprite*) genBackgroundWithColor:(ccColor4B)color;

/**
 * Get the margin on the top of the background (which is the same as the bottom)
 */
+(float) getMarginTop;

/**
 * Get the margin on the left and right side of the background
 */
+(float) getMarginSide;

/**
 * Get tile font size
 */
+(int) getTileFontSize;

/**
 * Create and place the home sprite
 */
+(CCSprite*) createHomeSprite;

/**
 * Create a play-sized button with text
 * @param text for the button
 */
+(CCMenuItemSprite*) createPlayButtonWithText:(NSString*)text target:(id)target selector:(SEL)selector;

/**
 * Create a button with text
 * @param text for the button
 */
+(CCMenuItemSprite*) createButtonWithText:(NSString*)text target:(id)target selector:(SEL)selector;

/**
 * Create a toggle with text
 * @param text for the button
 */
+(CCMenuItemSprite*) createToggleWithText:(NSString*)text;

/**
 * Return YES if the touch is within the sprite
 */
+(BOOL) isSpriteTouched:(CCSprite*)sprite touches:(NSSet*)touches;

/**
 * Get padding for the home, progress bar, score label, etc
 */
+(int) getUpperLabelPadding;

/**
 * Get the font size for the IntroLayer's title label by device
 */
+(int) getIntroTitleFontSize;

/**
 * Get the font size for a title label by device
 */
+(int) getTitleFontSize;

/**
 * Style the Play menu item
 * @param menuItem the CCMenuItemFont to style
 */
+(void) stylePlayButton:(CCMenuItemFont*)menuItem;

/**
 * Style a button menu item
 * @param menuItem the CCMenuItemFont to style
 */
+(void) styleMenuButton:(CCMenuItemFont*)menuItem;

/**
 * Style a toggle buttons
 * @param menuItem the CCMenuItemFont to style
 */
+(void) styleToggle:(CCMenuItemFont*)menuItem;

/**
 * Get the padding between menu items
 */
+(int) getMenuPadding;

/**
 * Return an array of all possible make values
 */
+(NSArray*) getMakeValuesArray;
//
///**
// * Return an array of all possible make values
// * for multiplication
// */
//+(NSArray*) getMultMakeValuesArray;

/**
 * Based on the possible make values, return one
 * of them randomly that is not the same as
 * the current make value
 * @param currentMakeValue int
 */
+(int) genRandomMakeValue:(int)currentMakeValue;
@end
