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


#import "LevelLayer.h"


@implementation LevelLayer

-(id) init {
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if (self = [super initWithColor: ccc4(0, 128, 0, 75)]) {
        self.label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:24];
        self.label.color = ccc3(0, 0, 0);
        self.label.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2);
        [self addChild:self.label];

    }
    return self;
}

-(void) setLevel:(int)level {
    [self.label setString:[NSString stringWithFormat:@"Get ready for Level %d", level]];
}

// on "dealloc" you need to release all your retained objects
-(void) dealloc {
    [self.label removeFromParentAndCleanup:YES];
    self.label = nil;
    
	[super dealloc];
}

@end
