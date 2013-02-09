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

#import "Make10Util.h"

@implementation Make10Util

+(void) styleMenuButton:(CCMenuItemFont*)menuItem {
    
    menuItem.fontName = @"American Typewriter";
    menuItem.fontSize = 24;

}

+(void) styleToggle:(CCMenuItemFont*)menuItem {
    
    menuItem.fontName = @"American Typewriter";
    menuItem.fontSize = 32;
    
}

+(NSArray*) getMakeValuesArray {
    NSMutableArray* makeValuesArray = [[NSMutableArray alloc] init];
    for (int i = 5; i <= 20; i++) {
        [makeValuesArray addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 30; i <= 100; i += 10) {
        [makeValuesArray addObject:[NSNumber numberWithInt:i]];
    }
    return [NSArray arrayWithArray:makeValuesArray];
}

+(int) genRandomMakeValue:(int)currentMakeValue {
    NSArray* makeValuesArray = [self getMakeValuesArray];
    int randomIndex = arc4random() % [makeValuesArray count];
    int newMakeValue = [[makeValuesArray objectAtIndex:randomIndex] intValue];
    if (newMakeValue == currentMakeValue) {
        return [self genRandomMakeValue:currentMakeValue];
    }

    return newMakeValue;
}
@end
