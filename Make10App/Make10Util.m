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

/******
  TODOs
 o level layer style?
 o pause layer style
 o remove tile when wall transitioning up -- orphaned tile
 o Adv features in later paid edition
 ******/

static float _marginTop = 0;
static float _marginSide = 0;
static int   _tileFontSize = 28;
static int   _upperLevelPadding = 5;
static int   _introTitleFontSize = 64;
static int   _titleFontSize = 32;
static int   _playFontSize = 40;
static int   _menuItemFontSize = 24;
static int   _toggleFontSize = 32;
static int   _menuPadding = 20;

+(void)initialize {
    if ([self class] == [super class]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _marginTop = 32;
            _marginSide = 64;
            _tileFontSize = 56;
            _upperLevelPadding = 10;
            _introTitleFontSize = 128;
            _titleFontSize = 64;
            _playFontSize = 80;
            _menuItemFontSize = 48;
            _toggleFontSize = 64;
            _menuPadding = 65;
        }
    }
}

+(CCSprite*) genBackgroundWithColor:(ccColor4B)color {
    CCSprite* noise = [CCSprite spriteWithFile:@"noise.png"];
    NSLog(@"genBackgroundWithColor noise size = width:%f, height:%f", noise.contentSize.width, noise.contentSize.height);
    float textureWidth = noise.contentSize.width;
    float textureHeight = noise.contentSize.height;
    
    //1: Create new CCRenderTexture
    CCRenderTexture* rt = [CCRenderTexture renderTextureWithWidth:textureWidth height:textureHeight];
    
    //2: Call CCRenderTexture:begin
    ccColor4F bgColor = ccc4FFromccc4B(color);
    [rt beginWithClear:bgColor.r g:bgColor.g b:bgColor.b a:bgColor.a];
    
    //3: Draw into the texture
    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
    noise.position = ccp(textureWidth / 2, textureHeight / 2);
    [noise visit];
    
    //4: Call CCRenderTexture:end
    [rt end];
    
    //5: Create a new Sprite from the texture
    CCSprite* background = [CCSprite spriteWithTexture:rt.sprite.texture];

    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    background.position = ccp(winSize.width / 2, winSize.height / 2);
    
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE};
    [background.texture setTexParameters:&tp];
    
    return background;
}

+(float) getMarginTop {
    return _marginTop;
}

+(float) getMarginSide {
    return _marginSide;
}

+(int) getTileFontSize {
    return _tileFontSize;
}

+(CCSprite*) createHomeSprite {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite* home = [CCSprite spriteWithFile:@"home.png"];
    home.position = ccp(winSize.width - _marginSide - home.contentSize.width / 2 - _upperLevelPadding, winSize.height - _marginTop - home.contentSize.height / 2 - _upperLevelPadding);
    return home;
}

+(BOOL) isSpriteTouched:(CCSprite*)sprite touches:(NSSet*)touches {
    UITouch* touch = [touches anyObject];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];

    float x = sprite.position.x - sprite.contentSize.width / 2;
    float y = sprite.position.y - sprite.contentSize.height / 2;
    
    CGRect touchArea = CGRectMake(x, y, sprite.contentSize.width, sprite.contentSize.height);
    if (CGRectContainsPoint(touchArea, location)) {
        return YES;
    }
    return FALSE;
}

+(int) getUpperLabelPadding {
    return _upperLevelPadding;
}

+(int) getIntroTitleFontSize {
    return _introTitleFontSize;
}

+(int) getTitleFontSize {
    return _titleFontSize;
}

+(void) stylePlayButton:(CCMenuItemFont*)menuItem {
    
    menuItem.fontName = @"American Typewriter";
    menuItem.fontSize = _playFontSize;
}

+(void) styleMenuButton:(CCMenuItemFont*)menuItem {
    
    menuItem.fontName = @"American Typewriter";
    menuItem.fontSize = _menuItemFontSize;

}

+(void) styleToggle:(CCMenuItemFont*)menuItem {
    
    menuItem.fontName = @"American Typewriter";
    menuItem.fontSize = _toggleFontSize;
}

+(int) getMenuPadding {
    return _menuPadding;
}

+(NSArray*) getMakeValuesArray {
    NSArray* makeValues = nil;
    NSLog(@"Make10Util getMakeValuesArray top makeValues=%@", makeValues);
    if (makeValues == nil) {
        /*
         * 5 - 20
         */
        NSMutableArray* makeValuesArray = [[NSMutableArray alloc] init];

        for (int i = 5; i <= 20; i++) {
            [makeValuesArray addObject:[NSNumber numberWithInt:i]];
        }
        /*
         * 60
         */
        [makeValuesArray addObject:[NSNumber numberWithInt:60]];
        /*
         * 100
         */
        [makeValuesArray addObject:[NSNumber numberWithInt:100]];
        makeValues = [NSArray arrayWithArray:makeValuesArray];
    }
    NSLog(@"Make10Util getMakeValuesArray bottom makeValues=%@", makeValues);
    return makeValues;
}

+(NSArray*) getMultMakeValuesArray {
    static NSArray* multMakeValues;
    if (multMakeValues == nil) {
        /*
         * 12, 15, 16, 18, 20, 24, 30, 36, 60, 75, 100, 120, 180, 360
         */
        NSMutableArray* makeValuesArray = [[NSMutableArray alloc] init];
        [makeValuesArray addObject:[NSNumber numberWithInt:12]];
        [makeValuesArray addObject:[NSNumber numberWithInt:15]];
        [makeValuesArray addObject:[NSNumber numberWithInt:16]];
        [makeValuesArray addObject:[NSNumber numberWithInt:18]];
        [makeValuesArray addObject:[NSNumber numberWithInt:20]];
        [makeValuesArray addObject:[NSNumber numberWithInt:24]];
        [makeValuesArray addObject:[NSNumber numberWithInt:30]];
        [makeValuesArray addObject:[NSNumber numberWithInt:36]];
        [makeValuesArray addObject:[NSNumber numberWithInt:60]];
        [makeValuesArray addObject:[NSNumber numberWithInt:75]];
        [makeValuesArray addObject:[NSNumber numberWithInt:100]];
        [makeValuesArray addObject:[NSNumber numberWithInt:120]];
        [makeValuesArray addObject:[NSNumber numberWithInt:180]];
        [makeValuesArray addObject:[NSNumber numberWithInt:360]];
        multMakeValues =[NSArray arrayWithArray:makeValuesArray];
    }
    return multMakeValues;
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
