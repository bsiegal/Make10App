//
//  Make10Util.h
//  Make10App
//
//  Created by James Siegal on 2/8/13.
//
//

#import <Foundation/Foundation.h>


/**
 * Default make value
 */
static int const MAKE_VALUE_DEFAULT = 10;

/**
 * Points needed to advance to next level
 */
static int const LEVEL_MARKER = 50;

/**
 * The duration scenes to change
 */
static float const LAYER_TRANS_TIME = 0.5f;

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
 * Preference for the local high score
 */
static NSString* const PREF_HIGH_SCORE = @"HIGH_SCORE";

@interface Make10Util : NSObject

@end
