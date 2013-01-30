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


#import "GameOverScene.h"
#import "Make10AppLayer.h"

@implementation GameOverScene
@synthesize layer = _layer;

-(id) init {
    if ((self = [super init])) {
        self.layer = [GameOverLayer node];
        [self addChild:_layer];
    }
    return self;
}

-(void) dealloc {
    [_layer release];
    _layer = nil;
    [super dealloc];
}
@end


@implementation GameOverLayer
@synthesize label = _label;

-(id) init {
    if ((self = [super initWithColor:ccc4(255, 255, 255, 255)])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF* gameOver = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Arial" fontSize:32];
        gameOver.color = ccc3(0, 0, 0);
        gameOver.position = ccp(winSize.width / 2, winSize.height * (0.75));
        [self addChild:gameOver];
        
        self.label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:32];
        _label.color = ccc3(0, 0, 0);
        _label.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:_label];
        
        
        [self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:5],
                         [CCCallFunc actionWithTarget:self selector:@selector(gameOverDone)], nil]];
    }
    return self;
}

-(void) gameOverDone {
    NSLog(@"GameOverLayer.gameOverDone");
    [[CCDirector sharedDirector] replaceScene:[Make10AppLayer scene]];

}

-(void) dealloc {
    [_label release];
    _label = nil;
    [super dealloc];
}
@end
