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

#import "AboutLayer.h"
#import "IntroLayer.h"
#import "SimpleAudioEngine.h"

@implementation AboutLayer

UIWebView* _webView;
CCSprite*  _home;

+(CCScene*) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	AboutLayer *layer = [AboutLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
    if (self = [super init]) {
        // ask director for the window size
        CGSize winSize = [[CCDirector sharedDirector] winSize];

        CCSprite* background = [Make10Util genLayerBackgroundWithName:@"boyBg"];
        [self addChild:background];

        CCSprite* score = [Make10Util createWhiteBoxSprite];
        [self addChild:score];

        CCLabelTTF* text = [CCLabelTTF labelWithString:@"About" fontName:@"American Typewriter" fontSize:[Make10Util getTitleFontSize]];
        text.color = ccc3(0, 0, 0);
        text.position = ccp(winSize.width / 2, winSize.height - [Make10Util getMarginTop] - [Make10Util getUpperLabelPadding] - [Make10Util getScoreLabelHeight] / 2);
        // add the label as a child to this Layer
        [self addChild:text];

        _home = [Make10Util createHomeSprite];
        [self addChild:_home];

        /*
         * UIView to which UIKit components can be added
         */
        UIView* view = [[CCDirector sharedDirector] view];
        view.frame = CGRectMake(0, 0, winSize.width, winSize.height);
        
        int aboutMargin = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 128 : 64;
        int h = _home.contentSize.height + [Make10Util getUpperLabelPadding] * 2 + [Make10Util getMarginTop];
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake([Make10Util getMarginSide], h, winSize.width - 2 * [Make10Util getMarginSide] - aboutMargin, winSize.height - h)];
        _webView.delegate = self;
        _webView.hidden = YES;

        /*
         * Add about
         */
        NSString *path = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:path];
        
//--does not work on iPad    NSURL *url = [[NSBundle mainBundle] URLForResource:@"about" withExtension:@".html"];
        [_webView loadRequest:[NSURLRequest requestWithURL:url]];

        [view addSubview:_webView];
        
        self.isTouchEnabled = YES;
        
    }
    return self;
}

#pragma mark Touches

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    if ([Make10Util isSpriteTouched:_home touches:touches]) {
        [Make10Util touchedSprite:_home target:self selector:@selector(homeAction)];
    }
}

-(void) homeAction {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:LAYER_TRANS_TIME scene:[IntroLayer scene]]];
}

#pragma mark UIWebViewDelegate

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    
//    NSLog(@"AboutLayer webView shouldStartLoadeWithRequest loading: %@", inRequest);
    /*
     * This will cause links to be opened in Safari instead of in the app
     */
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

-(void) backAction {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:LAYER_TRANS_TIME scene:[IntroLayer scene]]];
}

-(void) onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];

    /*
     * Since the UIKit components do not respond to cocos scene changes, just using this as a workaround
     */
    _webView.hidden = NO;

}

-(void) onExitTransitionDidStart {
    /*
     * Since the UIKit components do not respond to cocos transitions, just using this as a workaround,
     * plus it gives us a brief chance to see the full background
     */
    _webView.hidden = YES;
    [super onExitTransitionDidStart];
}

//-(void) onExit {
//    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"boyBg.plist"];
//    [super onExit];
//}

-(void) dealloc {
    self.isTouchEnabled = NO;
    
    _webView.delegate = nil;
    [_webView removeFromSuperview];
    [_webView release];
    _webView = nil;
    
    [_home removeFromParentAndCleanup:YES];
    _home = nil;
    
    [self removeFromParentAndCleanup:YES];
    [super dealloc];
}

@end
