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


#import "Score.h"

@implementation Score

-(id) init {
    if (self = [super init]) {
        self.score = 0;

        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSNumber* startLevel = [defaults objectForKey:PREF_START_LEVEL]; //default set in IntroLayer
        self.level = [startLevel intValue];
        
        [self initializeProperties];
    }
    return self;
}

-(void) initializeProperties {
    self.tilesRemoved = 0;
    self.pointValue = self.level * 10;
    /*
     * If speed challenge, then
     * speed increases with every level if the challenge type is speed
     * up to max speed of 6 seconds
     */
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSNumber* challengeType = [defaults objectForKey:PREF_CHALLENGE_TYPE]; //default set in IntroLayer
    
    if (PREF_CHALLENGE_TYPE_SPEED == [challengeType intValue] || self.level > 5) {
        
        self.wallTime = SLOWEST_WALL_SPEED - 2 * (self.level - 1);
        
        if (self.wallTime < FASTEST_WALL_SPEED) {
            self.wallTime = FASTEST_WALL_SPEED;
        }
        
    } else {
        
        NSNumber* startLevel = [defaults objectForKey:PREF_START_LEVEL]; //default set in IntroLayer

        self.wallTime = SLOWEST_WALL_SPEED - 2 * ([startLevel intValue] - 1);
        /*
         * Make value will be changed in Make10AppLayer
         */
        
    }
}
/**
 * Increase the level, point value and wall speed
 */
-(BOOL) levelUp {

    if (self.tilesRemoved >= LEVEL_MARKER) {
        self.level++;
        [self initializeProperties];
        return YES;
    }
    return NO;
}

-(void) dealloc {
	[super dealloc];
}
@end
