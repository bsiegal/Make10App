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
 o Adv features for in-app purchases - multiplication, gamekit leaderboard etc
 ******/

static float _marginTop = 0;
static float _marginSide = 0;
static int   _tileFontSize = 28;
static int   _upperLevelPadding = 5;
static int   _introTitleFontSize = 24;
static int   _titleFontSize = 32;
static int   _playFontSize = 40;
static int   _menuItemFontSize = 20;
static int   _toggleFontSize = 32;
static int   _menuPadding = 20;
static int   _gainFontSize = 14;
static int   _scoreLabelHeight = 32;
static int   _resumeMenuPadding = 42;
static int   _levelLabelPosition = 186;

+(void)initialize {
    if ([self class] == [super class]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            _marginTop = 32;
            _marginSide = 64;
            _tileFontSize = 56;
            _upperLevelPadding = 10;
            _introTitleFontSize = 48;
            _titleFontSize = 64;
            _playFontSize = 80;
            _menuItemFontSize = 40;
            _toggleFontSize = 64;
            _menuPadding = 65;
            _gainFontSize = 28;
            _scoreLabelHeight = 64;
            _resumeMenuPadding = 84;
            _levelLabelPosition = 372;
            
        } else {
            /*
             * It is a iPhone, but for retina 4 inch
             * we still need to set a marginTop
             */
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            if (winSize.height > 480) {
                _marginTop = (winSize.height - 480) / 2;
            }
        }
    }
}

+(CCSprite*) genBackgroundWithColor:(ccColor4B)color {
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"homeBg.plist"];
    [CCSpriteBatchNode batchNodeWithFile:@"homeBg.pvr.ccz"];

//    /*
//     * Re-add to the sprite frame cache in case there was a memory warning and it got cleared
//     */
//    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Make10Sprites.plist"];
//    
    CCSprite* background = [CCSprite spriteWithSpriteFrameName:@"noise.png"];

//    CCSprite* noise = [CCSprite spriteWithSpriteFrameName:@"noise.png"];
//    
//    float textureWidth = noise.contentSize.width;
//    float textureHeight = noise.contentSize.height;
//    
//    //1: Create new CCRenderTexture
//    CCRenderTexture* rt = [CCRenderTexture renderTextureWithWidth:textureWidth height:textureHeight];
//    
//    //2: Call CCRenderTexture:begin
//    ccColor4F bgColor = ccc4FFromccc4B(color);
//    [rt beginWithClear:bgColor.r g:bgColor.g b:bgColor.b a:bgColor.a];
//    
//    //3: Draw into the texture
//    [noise setBlendFunc:(ccBlendFunc){GL_DST_COLOR, GL_ZERO}];
//    noise.position = ccp(textureWidth / 2, textureHeight / 2);
//    [noise visit];
//    
//    //4: Call CCRenderTexture:end
//    [rt end];
//    
//    //5: Create a new Sprite from the texture
//    CCSprite* background = [CCSprite spriteWithTexture:rt.sprite.texture];

    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    background.position = ccp(winSize.width / 2, winSize.height / 2);
    
    ccTexParams tp = {GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE};
    [background.texture setTexParameters:&tp];

    
    
    return background;
}

+(CCSprite*) genLayerBackgroundWithName:(NSString*)name {
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Backgrounds.plist"];
    [CCSpriteBatchNode batchNodeWithFile:@"Backgrounds.pvr.ccz"];
    
    NSString* png = [NSString stringWithFormat:@"%@.png", name];
    CCSprite* background = [CCSprite spriteWithSpriteFrameName:png];
    
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    background.position = ccp(winSize.width / 2, winSize.height / 2);
    
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

+(int) getResumeMenuPadding {
    return _resumeMenuPadding;
}

+(int) getLevelLabelPosition {
    return _levelLabelPosition + _marginTop;
}

+(CCSprite*) createWhiteBoxSprite {
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
    
    /*
     * Re-add to the sprite frame cache in case there was a memory warning and it got cleared
     */
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Make10Sprites.plist"];
    
    CCSprite* score = [CCSprite spriteWithSpriteFrameName:@"scoreLabelBg.png"];

    CGSize winSize = [[CCDirector sharedDirector] winSize];

    float y = winSize.height - [Make10Util getMarginTop] - [Make10Util getUpperLabelPadding] - score.contentSize.height / 2;
    score.position = ccp(winSize.width / 2, y);
    return score;
}

+(CCSprite*) createHomeSprite {
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];

    /*
     * Re-add to the sprite frame cache in case there was a memory warning and it got cleared
     */
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Make10Sprites.plist"];

    CGSize winSize = [[CCDirector sharedDirector] winSize];

    CCSprite* home = [CCSprite spriteWithSpriteFrameName:@"home.png"];
    home.position = ccp(winSize.width - _marginSide - home.contentSize.width / 2 - _upperLevelPadding, winSize.height - _marginTop - home.contentSize.height / 2 - _upperLevelPadding);
    return home;
}

+(CCMenuItemSprite*) createPlayButtonWithText:(NSString *)text target:(id)target selector:(SEL)selector {

    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];

    /*
     * Re-add to the sprite frame cache in case there was a memory warning and it got cleared
     */
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Make10Sprites.plist"];

    CCMenuItemSprite *play = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"buttonPressed.png"] target:target selector:selector];
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:text fontName:@"American Typewriter" fontSize:[Make10Util getTitleFontSize]];
    label.position = ccp(play.contentSize.width / 2, play.contentSize.height / 2);
    label.color = ccc3(0, 0, 0);
    label.tag = TAG_LABEL;
    
    [play addChild:label];
    
    return play;
}

+(CCMenuItemSprite*) createButtonWithText:(NSString *)text target:(id)target selector:(SEL)selector {

    CCMenuItemSprite* button = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-short.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"buttonPressed-short.png"] target:target selector:selector];

//    CCMenuItemImage* button = [CCMenuItemImage itemWithNormalImage:@"button-short.png" selectedImage:@"buttonPressed-short.png" target:target selector:selector];
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:text fontName:@"American Typewriter" fontSize:_menuItemFontSize];
    label.position = ccp(button.contentSize.width / 2, button.contentSize.height / 2);
    label.color = ccc3(0, 0, 0);
    label.tag = TAG_LABEL;
    [button addChild:label];
    return button;
}

+(CCMenuItemSprite*) createToggleWithText:(NSString *)text {
    CCMenuItemSprite* button = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"button-short.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"buttonPressed-short.png"]];
    CCLabelTTF* label = [CCLabelTTF labelWithString:text fontName:@"American Typewriter" fontSize:_menuItemFontSize];
    label.position = ccp(button.contentSize.width / 2, button.contentSize.height / 2);
    label.color = ccc3(0, 0, 0);
    label.tag = TAG_LABEL; //use this to change label
    [button addChild:label];
    return button;
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

+(int) getScoreLabelHeight {
    return _scoreLabelHeight;
}

+(int) getUpperLabelPadding {
    return _upperLevelPadding;
}

+(int) getTitleFontSize {
    return _titleFontSize;
}

+(int) getGainFontSize {
    return _gainFontSize;
}

+(int) getMenuPadding {
    return _menuPadding;
}

+(NSArray*) getMakeValuesArray {
    NSArray* makeValues = nil;
//    NSLog(@"Make10Util getMakeValuesArray top makeValues=%@", makeValues);
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
        
        [makeValuesArray release];
        
    }
//    NSLog(@"Make10Util getMakeValuesArray bottom makeValues=%@", makeValues);
    return makeValues;
}

//+(NSArray*) getMultMakeValuesArray {
//    static NSArray* multMakeValues;
//    if (multMakeValues == nil) {
//        /*
//         * 12, 15, 16, 18, 20, 24, 30, 36, 60, 75, 100, 120, 180, 360
//         */
//        NSMutableArray* makeValuesArray = [[NSMutableArray alloc] init];
//        [makeValuesArray addObject:[NSNumber numberWithInt:12]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:15]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:16]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:18]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:20]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:24]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:30]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:36]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:60]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:75]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:100]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:120]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:180]];
//        [makeValuesArray addObject:[NSNumber numberWithInt:360]];
//        multMakeValues =[NSArray arrayWithArray:makeValuesArray];
//    }
//    return multMakeValues;
//}

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
