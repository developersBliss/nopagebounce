/*
Copyright (C) 2013 developersBliss

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

%hook UIScrollView
-(void)handlePan:(id)pan {
    [self setBounces:NO];
    %orig;
}
-(void)setBounces:(BOOL)bounces {
    if (bounces) {
        [self setBounces:NO];
    } else {
        %orig;
    }
}
%end