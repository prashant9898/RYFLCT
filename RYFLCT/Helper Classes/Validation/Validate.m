//
//  Validate.m
//  ValidationCode
//
//  Created by Triforce consultancy on 21/01/12.
//  Copyright 2012 Triforce consultancy . All rights reserved.
//

#import "Validate.h"

#define kMagicSubtractionNumber 48

@implementation Validate

+ (BOOL) isEmpty:(NSString *) candidate
{
	return [[candidate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqual:@""];
}

+ (BOOL) isPasswordValid:(NSString *)pwd
{
   
    if ( [pwd length] < 6 || [pwd length]> 32 )
    return NO;
    NSRange rang;
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length ) return NO;  // no letter
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )  return NO;  // no number;
    return YES;
}

+ (BOOL) isValidEmailAddress:(NSString *) candidate
{
    
	if (![self isEmpty:candidate])
    {
		NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
		NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
		return [emailTest evaluateWithObject:candidate];
	}
	return NO;
}
+ (BOOL) isValidzip:(NSString *) candidate
{
    
	if (![self isEmpty:candidate])
    {
		NSString *emailRegex1 = @"[0-9]";
		NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex1];
		return [emailTest evaluateWithObject:candidate];
	}
	return NO;
}

+ (BOOL) isValidPattern:(NSString *) candidate
{
	if (![self isEmpty:candidate])
    {
		NSString *emailRegex = @"[A-Z0-9a-z]{8}+\\-[A-Z0-9a-z]{4}+\\-[A-Z0-9a-z]{4}+\\-[A-Z0-9a-z]{4}+\\-[A-Z0-9a-z]{12}"; 
		NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
		
		return [emailTest evaluateWithObject:candidate];
	}
	return NO;
}


+ (BOOL) isAlphabetsOnly:(NSString *) candidate
{
	if (![self isEmpty:candidate])
    {
		NSString *alphaRegex =  @"^\\s*([A-Za-z ]*)\\s*$"; //@"^\\s*([\\p{L}\\s]*)\\s*$";
		NSPredicate *alphaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphaRegex]; 
		
		return [alphaTest evaluateWithObject:candidate];
	}
	return NO;
}
+ (BOOL) isValidcom:(NSString *) candidate
{
    if (![self isEmpty:candidate])
    {
		NSString *alphaRegex =  @"^\\s*([A-Za-z0-9_-&$ ]*)\\s*$"; //@"^\\s*([\\p{L}\\s]*)\\s*$";
		NSPredicate *alphaTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphaRegex];
		
		return [alphaTest evaluateWithObject:candidate];
	}
	return NO;
}
+ (BOOL) isNumbersOnly:(NSString *) candidate
{
	if (![self isEmpty:candidate])
    {
		NSString *numberRegex = @"^\\s*([0-9]*)\\s*$"; 
		NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex]; 
		
		return [numberTest evaluateWithObject:candidate];
	}
	return NO;
}

+ (BOOL) isAlphaNumeric:(NSString *) candidate
{
	if (![self isEmpty:candidate])
    {
		NSString *alphaNumberRegex = @"^\\s*([A-Z0-9a-z ]*)\\s*$"; 
		NSPredicate *alphaNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", alphaNumberRegex]; 
		
		return [alphaNumberTest evaluateWithObject:candidate];
	}
	return NO;
}

+ (BOOL) lenghtVaidation:(NSString *) candidate withMinSize:(NSInteger)minSize andMaxSize:(NSInteger)maxSize
{
	if (![self isEmpty:candidate])
    {
		if ([candidate length] >= minSize && [candidate length] <= maxSize)
        {
			return YES;
		}
	}
	return NO;
}

+ (BOOL) isValidURL:(NSString *) candidate
{
	
	if (![self isEmpty:candidate])
    {
		NSString *urlRegEx = @"((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?";
							 //((?:http|https)://(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}/?(?<=/)(?:[\\w\\d\\-./_]+)?)";
		NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
		return [urlTest evaluateWithObject:candidate];
	}
	
	return NO;
}

+ (BOOL) isValidPhoneNumber:(NSString *) candidate {
	if (![self isEmpty:candidate])
    {
		NSString *phoneRegex = @"^\\s*([0-9-+ ]*)\\s*$";
        
		NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex]; 
		
		return [phoneTest evaluateWithObject:candidate];
	}
	return NO;
}

/* validateCard
 Counting from the check digit, which is the rightmost, and moving left, double the value of every second digit.
 Sum the digits of the products (e.g., 10 = 1 + 0 = 1, 14 = 1 + 4 = 5) together with the undoubled digits from the original number.
 If the total modulo 10 is equal to 0 (if the total ends in zero) then the number is valid according to the Luhn formula; else it is not valid.
 http://en.wikipedia.org/wiki/Luhn_algorithm
 */

+ (BOOL) isValidCard:(NSString *) candidate
{
	if (![self isEmpty:candidate])
    {
		
		int Luhn = 0;
		
		// I'm running through my string backwards
		for (int i=0;i<[candidate length];i++)
        {
            NSUInteger count = [candidate length]-1; // Prevents Bounds Error and makes characterAtIndex easier to read
			int doubled = [[NSNumber numberWithUnsignedChar:[candidate characterAtIndex:count-i]] intValue] - kMagicSubtractionNumber;
            if (i % 2)
            {doubled = doubled*2;}
            
			NSString *double_digit = [NSString stringWithFormat:@"%d",doubled];
			
            if ([[NSString stringWithFormat:@"%d",doubled] length] > 1)
			{   Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:0]] intValue]-kMagicSubtractionNumber;
                Luhn = Luhn + [[NSNumber numberWithUnsignedChar:[double_digit characterAtIndex:1]] intValue]-kMagicSubtractionNumber;
            }
            else
			{
                Luhn = Luhn + doubled;
            }
        }
		
		if (Luhn%10 == 0) // If Luhn/10's Remainder is Equal to Zero, the number is valid
            return true;
		else
			return false;
		
	}
	return NO;
}

@end
