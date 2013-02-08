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


UITextField* _makeValueTextField;
UIPickerView* _makeValuePicker;

NSMutableArray *arrayColors;

+(CCScene *) scene
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

-(id) init
{
    
	if (self = [super init]) {
        
    
        // ask director for the window size
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCLabelTTF* text = [CCLabelTTF labelWithString:@"Make 10 Settings" fontName:@"American Typewriter" fontSize:14];
        //title.color = ccc3(0, 0, 0);
        text.position = ccp(winSize.width / 2, winSize.height - 14);
        // add the label as a child to this Layer
        [self addChild:text];
        
        UIView* view = [[CCDirector sharedDirector] view];
        view.frame = CGRectMake(0, 0, winSize.width, winSize.height);
        
        _makeValueTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 65, 280, 20)];
        _makeValueTextField.font = [UIFont systemFontOfSize:12.0];
        
        _makeValueTextField.textColor = [UIColor blackColor];
        _makeValueTextField.backgroundColor = [UIColor whiteColor];
        _makeValueTextField.textAlignment = UITextAlignmentLeft;
        _makeValueTextField.keyboardType = UIKeyboardTypeNumberPad;
        _makeValueTextField.hidden = YES;
        _makeValueTextField.delegate = self;
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSNumber* makeValue = [defaults objectForKey:PREF_MAKE_VALUE]; //default set in IntroLayer
        _makeValueTextField.text = [NSString stringWithFormat:@"%d", [makeValue intValue]];
        
        [view addSubview:_makeValueTextField];

        arrayColors = [[NSMutableArray alloc] init];
        for (int i = 5; i <= 20; i++) {
            [arrayColors addObject:[NSString stringWithFormat:@"%d", i]];
        }
        for (int i = 30; i <= 100; i += 10) {
            [arrayColors addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        _makeValuePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(winSize.width / 2 - 35, 50, 70, 1)];
        _makeValuePicker.delegate = self;
        _makeValuePicker.showsSelectionIndicator = YES;
        _makeValuePicker.hidden = YES;
        
        [view addSubview:_makeValuePicker];
        
        //Tile Style
        
        //Starting level 1 2 3
        // Create on/off buttons to go in toggle group
        CCMenuItemFont *button1 = [CCMenuItemFont itemWithString:@"Level 1"];
        CCMenuItemFont *button2 = [CCMenuItemFont itemWithString:@"Level 2"];
        CCMenuItemFont *button3 = [CCMenuItemFont itemWithString:@"Level 3"];
        CCMenuItemFont *button4 = [CCMenuItemFont itemWithString:@"Level 4"];
        // Create toggle group that logs the active button - the group is then added to a menu same as any other menu item
        CCMenuItemToggle *toggleGroupLevel = [CCMenuItemToggle itemWithTarget:self
                                                                     selector:@selector(soundButtonTapped:)
                                                                        items:button1, button2, button3, button4, nil];
        
        // Create on/off buttons to go in toggle group
        CCMenuItemFont *buttonAdd = [CCMenuItemFont itemWithString:@"Addition"];
        CCMenuItemFont *buttonMult = [CCMenuItemFont itemWithString:@"Multiplication"];
        // Create toggle group that logs the active button - the group is then added to a menu same as any other menu item
        CCMenuItemToggle *toggleGroupChall = [CCMenuItemToggle itemWithTarget:self
                                                                selector:@selector(soundButtonTapped:)
                                                                   items:buttonAdd, buttonMult, nil];

        // Create on/off buttons to go in toggle group
        CCMenuItemFont *buttonThree = [CCMenuItemFont itemWithString:@"Speed"];
        CCMenuItemFont *buttonFour = [CCMenuItemFont itemWithString:@"Changing sums"];
        // Create toggle group that logs the active button - the group is then added to a menu same as any other menu item
        CCMenuItemToggle *toggleGroup = [CCMenuItemToggle itemWithTarget:self
                                                                    selector:@selector(soundButtonTapped:)
                                                                       items:buttonThree, buttonFour, nil];
        
        
        /*
         * Back button
         */
        CCMenuItemFont* back = [CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(backAction)];
        back.fontName = @"American Typewriter";
        back.fontSize = 32;
        
        /*
         * Create the menu
         */
        CCMenu* menu = [CCMenu menuWithItems:toggleGroupLevel, toggleGroupChall, toggleGroup, back, nil];
        menu.position = ccp(winSize.width / 2, winSize.height / 3);
        [menu alignItemsVerticallyWithPadding:20];
        [self addChild:menu];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void) soundButtonTapped: (id) sender
{
 	// do something… maybe even turn the sound on/off!
	NSLog(@"Sound button tapped! %@", sender);
    NSLog(@"Selected button: %i", [(CCMenuItemToggle *)sender selectedIndex]);

}

-(void) backAction {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:LAYER_TRANS_TIME scene:[IntroLayer scene]]];
}

-(void) onEnterTransitionDidFinish {
    _makeValueTextField.hidden = NO;
    _makeValuePicker.hidden = NO;
    [super onEnterTransitionDidFinish];
}

-(void) onExitTransitionDidStart {
    _makeValueTextField.hidden = YES;
    _makeValuePicker.hidden = YES;
    [super onExitTransitionDidStart];
}

#pragma mark Touches

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"SettingsLayer.touchesBegan");
    [_makeValueTextField resignFirstResponder];
}

#pragma mark Text delegate
-(BOOL) textFieldShouldReturn:(UITextField*)textField {
    //Terminate editing
    NSLog(@"textFieldShouldReturn");
    [_makeValueTextField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing: (UITextField*)textField {
    NSLog(@"textFieldDidEndEditing");
    if(textField == _makeValueTextField) {
        
        [_makeValueTextField endEditing:YES];
        
        NSString* textValue = _makeValueTextField.text;
        int makeValue = [textValue intValue];
        if (makeValue < 5 || makeValue > 100) {
            makeValue = 10;
            _makeValueTextField.text = [NSString stringWithFormat:@"%d", makeValue];
        }
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:makeValue forKey:PREF_MAKE_VALUE];
        
    } else {
        NSLog(@"textField did not match _makeValueTextField");
    }
}

#pragma mark UIPickerViewDelegate
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
//    // Handle the selection
//    NSLog(@"void pickerView");
//}
//
//// tell the picker how many rows are available for a given component
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    NSUInteger numRows = 5;
//    NSLog(@"NSInteger pickerView");
//    
//    return numRows;
//}
//
//// tell the picker how many components it will have
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
//    NSLog(@"numberOfComponentsInPickerView");
//
//    return 1;
//}
//
//// tell the picker the title for a given component
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSLog(@"NSString pickerView");
//    
//    NSString *title;
//    title = [@"" stringByAppendingFormat:@"%d",row];
//    
//    return title;
//}
//
//// tell the picker the width of each row for a given component
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    int sectionWidth = 300;
//    
//    NSLog(@"CGFloat pickerView");
//
//    return sectionWidth;
//}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
	return [arrayColors count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	return [arrayColors objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int makeValue = [[arrayColors objectAtIndex:row] intValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:makeValue forKey:PREF_MAKE_VALUE];

	NSLog(@"Selected Color: %@. Index of selected color: %i", [arrayColors objectAtIndex:row], row);
}

-(void) dealloc {
    [_makeValueTextField release];
    _makeValueTextField = nil;
    
    [_makeValuePicker release];
    _makeValuePicker = nil;
    
    [super dealloc];
}
@end
