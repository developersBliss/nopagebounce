/*
 Copyright (C) 2014 developersBliss
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <UIKit/UIScrollView.h>
#include <UIKit/UIScrollView2.h>

%hook UIScrollView

//Setting some variables to keep track of things
BOOL _NPBLockBouncing = NO;
BOOL _NPBEnabledMaster = NO;
BOOL _NPBEnabledSpringBoard = NO;
BOOL _NPBEnabledOnlyForIcons = NO;
CGPoint _NPBStartOffsets;

-(void)_scrollViewDidEndDraggingWithDeceleration:(BOOL)_scrollView {
    %orig;
    
    //Note: In the case of this bug happening, _scrollViewDidEndDraggingWithDeceleration: is the last "DidEnd" function that actually gets called. I think.
    if (_NPBEnabledMaster && !self.bounces) {
        if (self.contentOffset.x == _NPBStartOffsets.x) {
            CGFloat scrollViewTopOffset =  0 - self.contentInset.top;
            CGFloat scrollViewBottomOffset = self.contentSize.height + self.contentInset.bottom - self.bounds.size.height;
            
            if ((self.contentOffset.y <= _NPBStartOffsets.y && self.contentOffset.y <= scrollViewTopOffset) || (self.contentOffset.y >= _NPBStartOffsets.y && self.contentOffset.y >= scrollViewBottomOffset)) {
                //Cancel the tracking
                [self cancelTouchTracking];
            }
        } else if (self.contentOffset.x == _NPBStartOffsets.x) {
            //Should probably do this for horizontal scrolling too, but I'm too lazy because no one ever scrolls horizontally. Hopefully Andrew never reads this...
        }
    }
}

-(void)_scrollViewWillBeginDragging {
    //Mark the starting offsets so we know if the scrollview is scrolling up or down
    _NPBStartOffsets = self.contentOffset;
    
    if (_NPBEnabledMaster) {
        //Get information about the class and bundle this scrollview belongs to
        NSString *className = NSStringFromClass([self class]);
        NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        
        if ([bundleIdentifier isEqualToString:@"com.apple.springboard"] && _NPBEnabledSpringBoard && _NPBEnabledOnlyForIcons && [className isEqualToString:@"SBIconScrollView"]) {
            [self setBounces:NO];
        }
    }
    
    %orig;
}

//Override init
-(id)initWithFrame:(CGRect)frame {
    id orig = %orig;
    
    //Get prefs
    NSMutableDictionary *prefs;
    if (![[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/Preferences/com.developersbliss.nopagebounce.plist"]) {
        //If the plist doesn't exist, make it with default values.
        prefs=[[NSMutableDictionary alloc] init];
        
        [prefs setObject:[NSNumber numberWithBool:YES] forKey:@"enabledMaster"];
        [prefs setObject:[NSNumber numberWithBool:YES] forKey:@"enableForSpringBoard"];
        [prefs setObject:[NSNumber numberWithBool:NO] forKey:@"enableOnlyForIcons"];
        
        //Disable for Mail, Twitter, and Facebook by default
        [prefs setObject:[NSNumber numberWithBool:NO] forKey:@"Apps-com.atebits.Tweetie2"];
        [prefs setObject:[NSNumber numberWithBool:NO] forKey:@"Apps-com.apple.mobilemail"];
        [prefs setObject:[NSNumber numberWithBool:NO] forKey:@"Apps-com.facebook.Facebook"];
        
        [prefs writeToFile:@"/var/mobile/Library/Preferences/com.developersbliss.nopagebounce.plist" atomically:YES];
    } else {
        prefs=[[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.developersbliss.nopagebounce.plist"];
    }
    
    
    
    //Get information about the class and bundle this scrollview belongs to
    NSString *className = NSStringFromClass([self class]);
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    _NPBEnabledMaster = [[prefs objectForKey:@"enabledMaster"] boolValue];
    _NPBEnabledSpringBoard = [[prefs objectForKey:@"enableForSpringBoard"] boolValue];
    _NPBEnabledOnlyForIcons = [[prefs objectForKey:@"enableOnlyForIcons"] boolValue];
    
    
    //Handle SpringBoard separately
    if ([bundleIdentifier isEqualToString:@"com.apple.springboard"]) {
        if (_NPBEnabledMaster) {
            if (_NPBEnabledSpringBoard) {
                if (_NPBEnabledOnlyForIcons) {
                    if ([className isEqualToString:@"SBIconScrollView"]) {
                        _NPBLockBouncing = YES;
                        [self setBounces:NO];
                    }
                } else {
                    _NPBLockBouncing = YES;
                    [self setBounces:NO];
                }
            }
        }
    } else { //Package is NOT SpringBoard
        
        //Set default values for bundle IDs that have never been seen before
        if ([prefs objectForKey:[NSString stringWithFormat:@"Apps-%@", bundleIdentifier]] == nil) {
            [prefs setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"Apps-%@", bundleIdentifier]];
            [prefs writeToFile:@"/var/mobile/Library/Preferences/com.developersbliss.nopagebounce.plist" atomically:YES];
        }
        
        if (_NPBEnabledMaster) {
            if ([[prefs objectForKey:[NSString stringWithFormat:@"Apps-%@", bundleIdentifier]] boolValue]) {
                _NPBLockBouncing = YES;
                [self setBounces:NO];
            }
        }
    }
    
    [prefs release];
    
    return orig;
}

//-(void)touchesBegan:(id)began withEvent:(id)event {
//    if ([NSStringFromClass([self class]) isEqualToString:@"SBIconScrollView"]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Testing" message:NSStringFromClass([self class]) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    }
//    
//    %orig;
//}
//
//-(void)_touchesEnded:(id)ended withEvent:(id)event wasCancelled:(BOOL)cancelled {
//    if ([NSStringFromClass([self class]) isEqualToString:@"SBIconScrollView"]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Testing" message:[NSString stringWithFormat:@"%@", (cancelled?@"YES":@"NO")] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    }
//}

-(void)setBounces:(BOOL)bounces {
    //A very forceful way of locking this property
    if (_NPBEnabledMaster && _NPBLockBouncing) {
        if (bounces) {
            [self setBounces:NO];
        } else {
            %orig;
        }
    } else {
        %orig;
    }
}
%end