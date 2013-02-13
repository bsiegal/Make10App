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


#import "Tile.h"

@implementation Tile

-(void) createSprite:(int)value {
    
    CGRect rect = [Make10Util getTileRect];
    _sprite = [CCSprite spriteWithFile:@"tile.png" rect:rect];
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    int style = [[defaults objectForKey:PREF_TILE_STYLE] intValue];
    if (style == PREF_TILE_STYLE_DOTS && value < 10) {
        
        NSString* fileName = [NSString stringWithFormat:@"dot%d.png", value];
        CCSprite* dots = [CCSprite spriteWithFile:fileName rect:rect];
        
        dots.position = ccp(_sprite.contentSize.width / 2, _sprite.contentSize.height / 2);
        [_sprite addChild:dots];
        
    } else {
        
        NSString* text = [NSString stringWithFormat:@"%d", value];
        CCLabelTTF* label = [CCLabelTTF labelWithString:text fontName:@"Arial" fontSize:[Make10Util getTileFontSize]];
        label.position = ccp(_sprite.contentSize.width / 2, _sprite.contentSize.height / 2);
        label.color = ccBLACK;
        
        [_sprite addChild:label];
    }
}

-(id) initWithValueAndCol:(int)value col:(int)col  {
    
    if (self = [super init]) {

        _value = value;
        _col = col;
        
        [self createSprite:value];
        /*
         * The x position is the col * width of tile + half width of tile
         * The y position is -half * height of a tile so it starts below screen
         */
        _sprite.position = ccp(_sprite.contentSize.width * (col + 0.5), _sprite.contentSize.height * (-0.5));

    }
    return self;
    
}

-(id) initWithValue:(int)value {
    if (self = [super init]) {
        
        _value = value;
        
        [self createSprite:value];
        
        /*
         * NextTile The x position is the half width of tile
         * The y position is top of screen - half the height of a tile
         */
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _sprite.position = ccp(_sprite.contentSize.width / 2, winSize.height - _sprite.contentSize.height * (1.5));
    }
    return self;
}

-(void) spriteMoveFinished:(id)sender {
    NSLog(@"Tile.spriteMoveFinished");
    //    CCSprite *sprite = (CCSprite *)sender;
    //    [self removeChild:sprite cleanup:YES];
    //
    //
    //    if (sprite.tag == 1) {
    //        [_targets removeObject:sprite];
    //        GameOverScene *gameOverScene = [GameOverScene node];
    //        [gameOverScene.layer.label setString:@"You lose :["];
    //        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    //    } else if (sprite.tag == 2) {
    //        [_projectiles removeObject:sprite];
    //    }
}

-(void) transitionToCurrent {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    id actionMove = [CCMoveBy actionWithDuration:NEXT_TO_CURRENT_TRANS_TIME position:ccp(winSize.width / 2 - self.sprite.contentSize.width / 2, 0)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [self.sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void) transitionToPoint:(CGPoint)point target:(id)target callback:(SEL)callback {
    id actionMove = [CCMoveTo actionWithDuration:CURRENT_TO_WALL_TRANS_TIME position:point];
    id actionMoveDone = [CCCallFuncN actionWithTarget:target selector:callback];
    [self.sprite runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void) destroy {
    [_sprite removeFromParentAndCleanup:YES];
    _sprite = nil;
}

-(NSString*) description {
    return [NSString stringWithFormat:@"Tile row:%d col:%d value:%d",
            self.row, self.col, self.value];
}

-(void) dealloc {
    if (_sprite) {
        [self destroy];
    }
	[super dealloc];
}

@end
