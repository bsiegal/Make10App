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

#import "SettingsLayer.h"
#import "IntroLayer.h"
#import <UIKit/UIKit.h>
@implementation SettingsLayer

UIPickerView*      _makeValuePicker;
NSMutableArray*    _makeValueArray;
CCMenuItemSprite*   _makeValueToggle;
CCMenuItemToggle*  _levelToggle;
//CCMenuItemToggle*  _operationToggle;
CCMenuItemToggle*  _challengeToggle;
CCMenuItemToggle*  _styleToggle;
CCSprite*          _home;

+(CCScene*) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SettingsLayer *layer = [SettingsLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    
	if (self = [super init]) {
        CCSprite* background = [Make10Util genBackgroundWithColor:ccc4(5, 151, 242, 255)];
        [self addChild:background];
        
        // ask director for the window size
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF* text = [CCLabelTTF labelWithString:@"Settings" fontName:@"American Typewriter" fontSize:[Make10Util getTitleFontSize]];
        //title.color = ccc3(0, 0, 0);
        text.position = ccp(winSize.width / 2, winSize.height - [Make10Util getMarginTop] - [Make10Util getUpperLabelPadding] - [Make10Util getTitleFontSize] / 2);
        // add the label as a child to this Layer
        [self addChild:text];
        
        /*
         * UIView to which UIKit components can be added
         */
        UIView* view = [[CCDirector sharedDirector] view];
        view.frame = CGRectMake(0, 0, winSize.width, winSize.height);
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        /*
         * makeValue as a UIPickerView
         */
        NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE]; //default set in IntroLayer

        //This will be the row to select
        int makeValueRow = 0;

        //This will be an NSString array copy of getMakeValuesArray (which contains NSNumber)
        NSArray* makeValuesNumbers = [Make10Util getMakeValuesArray];
        _makeValueArray = [[NSMutableArray alloc] initWithCapacity:[makeValuesNumbers count]];

        for (int i = 0, len = [makeValuesNumbers count]; i < len; i++) {
            
            int value = [(NSNumber*) [makeValuesNumbers objectAtIndex:i] intValue];
            [_makeValueArray addObject:[NSString stringWithFormat:@"%d", value]];
            if ([makeValue intValue] == value) {
                makeValueRow = i;
            }
        }
        
        int pickerWidth = 100;
        _makeValuePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(winSize.width / 2 - pickerWidth / 2, winSize.height / 2 - 100, pickerWidth, winSize.height)];
        _makeValuePicker.delegate = self;
        _makeValuePicker.showsSelectionIndicator = YES;
        _makeValuePicker.hidden = YES;

        [_makeValuePicker selectRow:makeValueRow inComponent:0 animated:NO];

        [view addSubview:_makeValuePicker];
        
        /*
         * Make value as a button that will show the picker view
         */
        NSString* makeString = [NSString stringWithFormat:@"Make %d", [makeValue intValue]];
        _makeValueToggle = [Make10Util createButtonWithText:makeString target:self selector:@selector(makeValueAction)];
        
        /*
         * Starting level as a toggle
         */
        CCMenuItemSprite* level1 = [Make10Util createToggleWithText:@"Level 1"];
        CCMenuItemSprite* level2 = [Make10Util createToggleWithText:@"Level 2"];
        CCMenuItemSprite* level3 = [Make10Util createToggleWithText:@"Level 3"];
        
        _levelToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggled:) items:level1, level2, level3, nil];
        NSNumber* level = [defaults objectForKey:PREF_START_LEVEL];
        [_levelToggle setSelectedIndex:[level intValue] - 1];
        
        /*
         * Operation as a toggle
         */
//        CCMenuItemImage* buttonAdd = [Make10Util createToggleWithText:@"Addition"];
//        CCMenuItemImage* buttonMult = [Make10Util createToggleWithText:@"Multiplication"];
//
//        _operationToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggled:) items:buttonAdd, buttonMult, nil];
//
//        NSNumber* operation = [defaults objectForKey:PREF_OPERATION];
//        [_operationToggle setSelectedIndex:[operation intValue]];
        
        /*
         * Challenge type as a toggle 
         */
        CCMenuItemSprite* buttonSpeed = [Make10Util createToggleWithText:@"Speed challenge"];
        CCMenuItemSprite* buttonTotal = [Make10Util createToggleWithText:@"Changing total"];

        _challengeToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggled:) items:buttonSpeed, buttonTotal, nil];
        
        NSNumber* challenge = [defaults objectForKey:PREF_CHALLENGE_TYPE];
        [_challengeToggle setSelectedIndex:[challenge intValue]];
        
        /*
         * Tile style as a toggle
         */
        CCMenuItemSprite* buttonNumber = [Make10Util createToggleWithText:@"Numbers"];
        CCMenuItemSprite* buttonDots = [Make10Util createToggleWithText:@"Mahjong dots"];
        
        _styleToggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggled:) items:buttonNumber, buttonDots, nil];
        
        NSNumber* style = [defaults objectForKey:PREF_TILE_STYLE];
        [_styleToggle setSelectedIndex:[style intValue]];
        
        /*
         * Create the menu
         */
        CCMenu* menu = [CCMenu menuWithItems:
                        _makeValueToggle,
                        _levelToggle,
//                        _operationToggle,
                        _challengeToggle,
                        _styleToggle,
                        nil];
        menu.position = ccp(winSize.width / 2, winSize.height / 2);
        [menu alignItemsVerticallyWithPadding:[Make10Util getMenuPadding]];
        [self addChild:menu];
        
        _home = [Make10Util createHomeSprite];
        [self addChild:_home];
        
        self.isTouchEnabled = YES;
        
    }
    return self;
}

-(void) toggled: (id) sender
{
    CCMenuItemToggle* toggle = (CCMenuItemToggle*) sender;
    
    /*
     * Save toggle settings
     */
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    if (toggle == _challengeToggle) {
        [defaults setInteger:[_challengeToggle selectedIndex] forKey:PREF_CHALLENGE_TYPE];
    } else if (toggle == _levelToggle) {
        [defaults setInteger:[_levelToggle selectedIndex] + 1 forKey:PREF_START_LEVEL];
//    } else if (toggle == _operationToggle) {
//        [defaults setInteger:[_operationToggle selectedIndex] forKey:PREF_OPERATION];
    } else if (toggle == _styleToggle) {
        [defaults setInteger:[_styleToggle selectedIndex] forKey:PREF_TILE_STYLE];
    }

}

-(void) makeValueAction {
    _makeValuePicker.hidden = NO;
}

#pragma mark UIPickerViewDelegate


-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

-(NSInteger) pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	return [_makeValueArray count];
}

-(NSString*) pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	return [_makeValueArray objectAtIndex:row];
}

-(void) pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    /*
     * Save make value setting
     */
    int makeValue = [[_makeValueArray objectAtIndex:row] intValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:makeValue forKey:PREF_MAKE_VALUE];

    NSString* makeString = [NSString stringWithFormat:@"Make %d", makeValue];
    CCLabelTTF* label = (CCLabelTTF*) [_makeValueToggle getChildByTag:1];
    [label setString:makeString];
    
}

#pragma mark Touches

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    
    _makeValuePicker.hidden = YES;

    if ([Make10Util isSpriteTouched:_home touches:touches]) {
        /*
         * write to disk to free up memory
         */
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults synchronize];
        
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:LAYER_TRANS_TIME scene:[IntroLayer scene]]];
    }
}

-(void) onExit {
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"homeBg.plist"];
    [super onExit];
}


-(void) dealloc {
//    NSLog(@"Settings dealloc");

    self.isTouchEnabled = NO;
    
    _makeValuePicker.delegate = nil;
    [_makeValuePicker removeFromSuperview];
    [_makeValuePicker release];
    _makeValuePicker = nil;
    
    [_makeValueArray release];
    _makeValueArray = nil;

    [_home removeFromParentAndCleanup:YES];
    _home = nil;
    
    [_makeValueToggle removeFromParentAndCleanup:YES];
    _makeValueToggle = nil;
    
    [_levelToggle removeFromParentAndCleanup:YES];
    _levelToggle = nil;

//    [_operationToggle removeFromParentAndCleanup:YES];
//    _operationToggle = nil;

    [_challengeToggle removeFromParentAndCleanup:YES];
    _challengeToggle = nil;

    [_styleToggle removeFromParentAndCleanup:YES];
    _styleToggle = nil;

    [self removeFromParentAndCleanup:YES];
    [super dealloc];
}
@end
