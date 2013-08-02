//
//  TextOverride.m
//  CustomFonts
//
//  Created by zerox on 13-8-1.
//  Copyright (c) 2013年 zerox. All rights reserved.
//

#import "TextOverride.h"
#import "ArabicConverter.h"
#import <objc/runtime.h>

@implementation UILabel (ArabicSupported)

- (void)setTextWithArabicSupported:(NSString *)text
{
    [self setTextWithArabicSupported:[ArabicConverter convertArabic:text]];
}

@end

@implementation UITextView (ArabicSupported)

- (void)setTextWithArabicSupported:(NSString *)text
{
    [self setTextWithArabicSupported:[ArabicConverter convertArabic:text]];
}

@end

@implementation UITextField (ArabicSupported)

- (void)setTextWithArabicSupported:(NSString *)text
{
    [self setTextWithArabicSupported:[ArabicConverter convertArabic:text]];
}

@end

@implementation TextOverride

+ (void)overrideSetText
{
    Swizzle([UILabel class], @selector(setText:), @selector(setTextWithArabicSupported:));
    Swizzle([UITextView class], @selector(setText:), @selector(setTextWithArabicSupported:));
    Swizzle([UITextField class], @selector(setText:), @selector(setTextWithArabicSupported:));
}

void Swizzle(Class c, SEL orig, SEL newClassName)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, newClassName);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
		class_replaceMethod(c, newClassName, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
	else
		method_exchangeImplementations(origMethod, newMethod);
}

@end
