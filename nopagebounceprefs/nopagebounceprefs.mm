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

#import <Preferences/Preferences.h>

@interface nopagebounceprefsListController: PSListController {
    id _specifier2;
    id _specifier3;
    id _specifier4;
    id _specifier5;
    id _specifier6;
}
@end

@implementation nopagebounceprefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"nopagebounceprefs" target:self] retain];
	}
    
    _specifier2 = [_specifiers objectAtIndex:2];
    _specifier3 = [_specifiers objectAtIndex:3];
    _specifier4 = [_specifiers objectAtIndex:4];
    _specifier5 = [_specifiers objectAtIndex:5];
    _specifier6 = [_specifiers objectAtIndex:6];
    
    if (![[self readPreferenceValue:[_specifiers objectAtIndex:3]] boolValue]) {
        [self removeSpecifier:[_specifier4 retain] animated:NO];
    }
    if (![[self readPreferenceValue:[_specifiers objectAtIndex:1]] boolValue]) {
        [self removeSpecifier:[_specifier2 retain] animated:NO];
        [self removeSpecifier:[_specifier3 retain] animated:NO];
        if ([[self readPreferenceValue:_specifier3] boolValue]) {
            [self removeSpecifier:[_specifier4 retain] animated:NO];
        }
        [self removeSpecifier:[_specifier5 retain] animated:NO];
        [self removeSpecifier:[_specifier6 retain] animated:NO];
    }
    
	return _specifiers;
}

- (void)followOnTwitter {
	if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetbot:"]]) {
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tweetbot:///user_profile/developersBliss"]];
	} else if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"tweetings:"]]) {
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=developersBliss"]];
	} else if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"twitter:"]]) {
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"twitter://user?screen_name=developersBliss"]];
	} else {
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://twitter.com/intent/follow?screen_name=developersBliss"]];
	}
}

-(void)setEnableForSpringBoard:(id)value specifier:(id)specifier {
	[self setPreferenceValue:value specifier:specifier];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
	if((__CFBoolean*)value != kCFBooleanTrue){
        [self removeSpecifier:[_specifier4 retain] animated:YES];
	} else {
        [self insertSpecifier:_specifier4 afterSpecifier:specifier animated:YES];
    }
}

-(void)setEnableMaster:(id)value specifier:(id)specifier {
	[self setPreferenceValue:value specifier:specifier];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
	if((__CFBoolean*)value != kCFBooleanTrue){
        [self removeSpecifier:[_specifier2 retain] animated:YES];
        [self removeSpecifier:[_specifier3 retain] animated:YES];
        if ([[self readPreferenceValue:_specifier3] boolValue]) {
            [self removeSpecifier:[_specifier4 retain] animated:YES];
        }
        [self removeSpecifier:[_specifier5 retain] animated:YES];
        [self removeSpecifier:[_specifier6 retain] animated:YES];
	} else {
        [self insertSpecifier:_specifier2 afterSpecifier:specifier animated:YES];
        [self insertSpecifier:_specifier3 afterSpecifier:_specifier2 animated:YES];
        if ([[self readPreferenceValue:_specifier3] boolValue]) {
            [self insertSpecifier:_specifier4 afterSpecifier:_specifier3 animated:YES];
            [self insertSpecifier:_specifier5 afterSpecifier:_specifier4 animated:YES];
            [self insertSpecifier:_specifier6 afterSpecifier:_specifier5 animated:YES];
        } else {
            [self insertSpecifier:_specifier5 afterSpecifier:_specifier3 animated:YES];
            [self insertSpecifier:_specifier6 afterSpecifier:_specifier5 animated:YES];
        }
    }
    
    [self reload];
}

@end

// vim:ft=objc
