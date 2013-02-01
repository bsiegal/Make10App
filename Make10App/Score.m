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
        self.level = 1; //starts at 1 but should be based on NSUserDefaults
        [self initializeProperties];
    }
    return self;
}

-(void) initializeProperties {
    self.pointValue = self.level * 10;
    /*
     * speed increases with every level if the challenge type is speed
     * up to max speed of 6 seconds
     */
    if (self.level < 4) {
        self.wallTime = 12 - 2 * (self.level - 1);
    } else {
        self.wallTime = 6;
    }
}
/**
 * Increase the level, point value and wall speed
 */
-(BOOL) levelUp {
    NSLog(@"Score.levelUp");
    if (self.score >= LEVEL_MARKER * pow(2, self.level - 1)) {
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
