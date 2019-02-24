//
//  Networker.m
//
// Some code adapted from
// https://www.itworld.com/article/2702129/development/how-to-upload-photos-from-ios-to-a-rest-api.html


#import "Networker.h"
@import MobileCoreServices;    // only needed in iOS

@implementation Networker
@synthesize baseURL;

-(void)network:(NSString *)url message:(NSString *)message completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSLog(@"Sending a message to URL %@, message:%@", url, message);
    
    NSURL *aUrl;
    if (!url)
        aUrl = [NSURL URLWithString:url];
    else
        aUrl = [NSURL URLWithString:baseURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:5.0];
    
    [request setHTTPMethod:@"POST"];

    NSData *postData = [message dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:completionHandler] resume];
    
}

- (NSString *)mimeTypeForPath:(NSString *)path {
    // get a mime type for an extension using MobileCoreServices.framework
    
    CFStringRef extension = (__bridge CFStringRef)[path pathExtension];
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, extension, NULL);
    assert(UTI != NULL);
    
    NSString *mimetype = CFBridgingRelease(UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType));
    
    if (mimetype == NULL)
        mimetype = @"application/x-binary";
    
    assert(mimetype != NULL);
    
    CFRelease(UTI);
    
    return mimetype;
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             paths:(NSArray *)paths
                         fieldName:(NSString *)fieldName {
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    for (NSString *parameterKey in parameters) {
        NSString *parameterValue = parameters[parameterKey];
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add content data for attached files
    for (NSString *path in paths) {
        NSString *filename  = [path lastPathComponent];
        NSData   *data      = [NSData dataWithContentsOfFile:path];
        NSString *mimetype  = [self mimeTypeForPath:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldName, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimetype] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}

// Some hints from here
// https://stackoverflow.com/questions/24250475/post-multipart-form-data-with-objective-c

-(void)showBody:(NSData *)body
{
    NSLog(@"Body size: %d", (int)[body length]);
#if 0
    const char *bytes = [body bytes];
    char buffer[[body length] + 1];
    for (int index = 0; index < [body length]; ++index)
    {
        char aByte = bytes[index];
        buffer[index] = '.';
        if ((aByte < 125) && (aByte > 3))
            buffer[index] = aByte;
    }
    buffer[[body length]] = '\0';
    NSLog(@"%s", buffer);
#endif
}

-(void)push:(NSString *)url keys:(NSDictionary *)keys file:(NSString *)file completionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
    NSLog(@"Push file %@ to URL:%@", file, url);
        NSURL *aUrl;
    if (url)
        aUrl = [NSURL URLWithString:url];
    else
        aUrl = [NSURL URLWithString:baseURL];
    NSLog(@"Actual URL is %@", aUrl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:5.0];
    NSArray *paths;
    if (file)
        paths = [NSArray arrayWithObject:file];
    else
        paths = nil;
    
    // Note that we're using a fixed semi-random string for the boundaries between
    // sections of the post.  In a more perfect world, we'd randomly generate
    // the boundary strings.
    NSData *httpBody = [self createBodyWithBoundary:@"8xqIf38j.L2942jenny8675309" parameters:keys paths:paths fieldName:@"file"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:httpBody];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"8xqIf38j.L2942jenny8675309"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *bod = [[NSString alloc] initWithData:httpBody encoding:NSUTF8StringEncoding];
    [self showBody:httpBody];
    NSLog(@">>> POST BODY\n%@\n>>>\n", bod);
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:completionHandler] resume];
    
}

@end
