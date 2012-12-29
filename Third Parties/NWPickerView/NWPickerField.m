//
//  NWPickerField.m
//  NWFieldPicker
//
//  Created by Scott Andrew on 9/25/09.
//  Copyright 2009 NewWaveDigitalMedia. All rights reserved.
//
//  This source code is provided under BSD license, the conditions of which are listed below. 
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted 
//  provided that the following conditions are met:
//
//  • Redistributions of source code must retain the above copyright notice, this list of 
//   conditions and the following disclaimer.
//  • Redistributions in binary form must reproduce the above copyright notice, this list of conditions
//   and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  • Neither the name of Positive Spin Media nor the names of its contributors may be used to endorse or 
//   promote products derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED 
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
//  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY 
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
//  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
//  DAMAGE.

#import "NWPickerField.h"
#import "NSString+NSArrayExtension.h"
#import "NWPickerView.h"


NSString* UIPickerViewBoundsUserInfoKey = @"UIPickerViewBoundsUserInfoKey";
NSString* UIPickerViewWillShownNotification = @"UIPickerViewWillShownNotification";
NSString* UIPickerViewDidShowNotification = @"UIPickerViewDidShowNotification";
NSString* UIPickerViewWillHideNotification = @"UIPickerViewWillHideNotification";
NSString* UIPickerViewDidHideNotification = @"UIPickerViewDidHideNotification";



@implementation NWPickerField

@synthesize NWDelegate;
@synthesize formatString;
@synthesize pickerView;
@synthesize componentStrings;
@synthesize toolBar;
@synthesize btn;

- (BOOL)canBecomeFirstResponder {
	return YES;	
}

-(void)doneBtnTouched
{
    [pickerView toggle];
    [UIView animateWithDuration:1.0 animations:^{
        toolBar.hidden = YES;
    }];
}


-(BOOL) becomeFirstResponder {
	// we will toggle our view here. This allows us to react properly 
    // when in a table cell.
    if (pickerView.hidden == YES) {
        [pickerView toggle];
        toolBar.frame = CGRectMake(0, pickerView.frame.origin.y - 44, pickerView.frame.size.width, 44);
        toolBar.hidden = NO;
        if ([pickerView numberOfRowsInComponent:0] > 0) {
            [self selectRow:0 inComponent:0 animated:NO];
        }
    }
    return YES;
}

-(void) dealloc {
	delegate = nil;
	
    // clean up..
	[pickerView release];
	[componentStrings release];
	[formatString release];
	[indicator release];
	
	[super dealloc];
}

-(void)releaseMe {
    [self dealloc];
}

-(void) didMoveToSuperview {
	// lets create a hidden picker view.
    //if (pickerView==nil) {
    if (count == 0) {
        pickerView = [[NWPickerView alloc] initWithFrame:CGRectZero];
        pickerView.hidden = YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;
        pickerView.showsSelectionIndicator = YES;
        pickerView.field = self;
        count++;
    }
    else
    {
        [pickerView removeFromSuperview];
       // pickerView.field=nil;
        //[pickerView release];
        //pickerView=nil;
    }
    //}
	
	// lets load our indecicator image and get its size.
	//CGRect bounds = self.bounds;
	//uncomment
	/*UIImage* image = [UIImage imageNamed:@"downArrow.png"];
	CGSize imageSize = image.size;
	
	// create our indicator imageview and add it as a subview of our textview.
	CGRect imageViewRect = CGRectMake((bounds.origin.x + bounds.size.width) - imageSize.width - 5, (bounds.size.height/2) - (imageSize.height/2), imageSize.width, imageSize.height);
	indicator = [[UIImageView alloc] initWithFrame:imageViewRect];
	[self addSubview:indicator];
	indicator.image = image;
	indicator.hidden = YES;*/
	
    // set our default format string.
	self.formatString = @"%@";
}

-(void) didMoveToWindow {
	UIWindow* appWindow = [self window];
    
    // the app window can be null when being popped off 
    // the controller stack.
	if (appWindow != nil) {
        
        
        CGRect windowBounds = [appWindow bounds];
	
        // caluclate our hidden rect.
        CGRect pickerHiddenFrame = windowBounds;
        pickerHiddenFrame.origin.y = pickerHiddenFrame.size.height+256;
        pickerHiddenFrame.size.height = 216;
	
        // calucate our visible rect
       CGRect pickerVisibleFrame = windowBounds;
        pickerVisibleFrame.origin.y = windowBounds.size.height - 216;
        pickerVisibleFrame.size.height = 216;
	
        CGRect toolBarFrame = CGRectMake(0, (pickerVisibleFrame.origin.y - 40), windowBounds.size.width, 40);
        NSLog(@"ToolBarFrame:\nX: %g\nY: %g\nW: %g\nH: %g\n\n\n", toolBarFrame.origin.x, toolBarFrame.origin.y, toolBarFrame.size.width, toolBarFrame.size.height);
        self.toolBar = [[UIToolbar alloc] initWithFrame:toolBarFrame];
        self.toolBar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        self.toolBar.items = [NSArray arrayWithObjects:space, self.btn, nil];
        self.toolBar.tag = 1000;
        
        // tell the picker view the frames.
       
        pickerView.hiddenFrame = pickerHiddenFrame;
        pickerView.visibleFrame = pickerVisibleFrame;
	
        // set the initial frame so its hidden.
        pickerView.frame = pickerHiddenFrame;
        
        toolBar.hidden = pickerView.hidden;
        
        // add the picker view to our window so its top most like a keyboard.
        [appWindow addSubview:toolBar];
        [appWindow addSubview:pickerView];

        // select the first items in each component by default.
//        for (component = 0; component < [pickerView numberOfComponents]; component++) 
//            [self selectRow:0 inComponent:component animated:NO];
    }
  }


-(void) pickerViewHidden:(BOOL)wasHidden {
	// hide our show our indicator when notified by the picker.
	indicator.hidden = wasHidden;
	pickerView.hidden=wasHidden;
}


#pragma mark -
#pragma mark UIPickerView wrappers
#pragma mark -

-(void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
	
	// when selection is given then make sure we update our edit control and the picker.
	[pickerView selectRow:row inComponent:component animated:animated];
	[self pickerView:pickerView didSelectRow:row inComponent:component];
}

-(NSInteger) selectedRowInComponent:(NSInteger)component {
    return [pickerView selectedRowInComponent:component];
}

#pragma mark -
#pragma mark UIPickerViewDataSource handlers
#pragma mark -

// returns the number of 'columns' to display.
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	// we always have 1..
	NSInteger componentscount = [NWDelegate numberOfComponentsInPickerField:self];
	NSInteger item = 0;
	
    // if we have component strings release them.
    if (componentStrings != nil)
        [componentStrings release];
    
	componentStrings = [[NSMutableArray alloc] init];
	
    // put a blank place holder in here for nothing.
	for (item = 0; item < componentscount; item++) {
		[componentStrings addObject:@""];
	}
		
	return componentscount;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {	
	return [NWDelegate pickerField:self numberOfRowsInComponent:component];
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [NWDelegate pickerField:self titleForRow:row forComponent:component];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSString* string = [NWDelegate pickerField:self titleForRow:row forComponent:component];
	[componentStrings replaceObjectAtIndex:component withObject:string];
	
    // format our text representing the change in the selection.
	self.text = [NSString stringWithFormat:formatString array:componentStrings];
    
    return [NWDelegate pickerField:self didSelectRow:row forComponent:component];
}

-(UIBarButtonItem *)btn {
    if (!btn) {
        btn = [[UIBarButtonItem alloc] initWithTitle:@"تم" style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnTouched)];
    }
    return btn;
}
@end
