#import <Cocoa/Cocoa.h>

extern int entry();

@interface BLAppDelegate : NSObject <NSApplicationDelegate>
{
    dispatch_queue_t bearQueue;
    NSWindow *mainWindow;
}

+ (BLAppDelegate *)appDelegate;
@end

@implementation BLAppDelegate
+ (BLAppDelegate *)appDelegate
{
    return [[BLAppDelegate alloc] init];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        // We give bearlibterminal its own queue so it doesn't tie up the runloop.
        bearQueue = dispatch_queue_create("bearlibterminal", DISPATCH_QUEUE_SERIAL);
    }

    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    dispatch_async(bearQueue, ^{
        entry();
    });
}
@end

int main(int argc, char **argv)
{
    [NSApplication sharedApplication];

    NSMenu *menubar = [[NSMenu alloc] init];
    NSMenuItem *appMenuItem = [[NSMenuItem alloc] init];
    [menubar addItem:appMenuItem];
    NSMenu *appMenu = [[NSMenu alloc] init];
    NSString *appName = [[NSProcessInfo processInfo] processName];
    NSMenuItem *quitMenuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Quit %@", appName]
                                                          action:@selector(terminate:)
                                                   keyEquivalent:@"q"];
    [appMenu addItem:quitMenuItem];
    [appMenuItem setSubmenu:appMenu];

    [NSApp setMainMenu:menubar];
    NSApp.delegate = [BLAppDelegate appDelegate];
    NSApp.activationPolicy = NSApplicationActivationPolicyRegular;
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp run];

    return 0;
}