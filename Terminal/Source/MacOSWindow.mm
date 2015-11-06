/*
* BearLibTerminal
* Copyright (C) 2013-2015 Cfyz
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
* of the Software, and to permit persons to whom the Software is furnished to do
* so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
* FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
* IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#ifdef __APPLE__

#include <map>
#include "MacOSWindow.h"
#include "Log.hpp"
#import <Cocoa/Cocoa.h>

namespace BearLibTerminal
{
    // I hate this so much. <3
    struct MacOSWindow::EventBox
    {
        EventBox(NSEvent *e);
        ~EventBox();
        __strong NSEvent *m_event;
    };

    MacOSWindow::EventBox::EventBox(NSEvent *e):
        m_event(e) { }

    MacOSWindow::EventBox::~EventBox()
    {
        m_event = nil;
    }
}

@interface BLTWindow : NSWindow <NSWindowDelegate>
{
@public
    __weak BearLibTerminal::MacOSWindow *bltWindow;
    BOOL resizeable, fullscreen;
}
@end
@implementation BLTWindow
- (void)mouseMoved:(NSEvent *)e         { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)scrollWheel:(NSEvent *)e        { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)mouseDown:(NSEvent *)e          { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)mouseUp:(NSEvent *)e            { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)mouseDragged:(NSEvent *)e       { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)rightMouseDown:(NSEvent *)e     { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)rightMouseUp:(NSEvent *)e       { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)rightMouseDragged:(NSEvent *)e  { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)otherMouseDown:(NSEvent *)e     { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)otherMouseUp:(NSEvent *)e       { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)otherMouseDragged:(NSEvent *)e  { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)keyDown:(NSEvent *)e            { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)keyUp:(NSEvent *)e              { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }
- (void)flagsChanged:(NSEvent *)e       { BearLibTerminal::MacOSWindow::EventBox box(e); bltWindow->HandleNSWindowEvent(box); }

- (BOOL)windowShouldZoom:(NSWindow *)window toFrame:(NSRect)newFrame { return resizeable; }
- (NSSize)windowWillResize:(NSWindow *)window toSize:(NSSize)frameSize
{
    if (resizeable)
        return frameSize;
    return self.frame.size;
}
- (void)windowDidEnterFullScreen:(NSNotification *)notification { fullscreen = YES; }
- (void)windowDidExitFullScreen:(NSNotification *)notification { fullscreen = NO; }

@end

namespace BearLibTerminal
{
    struct MacOSWindow::Private
    {
        Private();
        ~Private();
        int NSKeycodeToTerminal(unsigned short keycode);
        __strong BLTWindow *m_window;
        __strong NSOpenGLView *m_glview;
        __strong id m_event_monitor;
        __strong id m_resize_notifier;
        __strong id m_active_notifier;
        bool m_cursor_visible;
    };

    MacOSWindow::Private::Private():
        m_window(nil),
        m_glview(nil),
        m_event_monitor(nil),
        m_resize_notifier(nil),
        m_active_notifier(nil),
        m_cursor_visible(true)
    {
        LOG(Trace, "MacOSWindow::Private");
    }

    MacOSWindow::Private::~Private()
    {
        LOG(Trace, "~MacOSWindow::Private");
    }

    int MacOSWindow::Private::NSKeycodeToTerminal(unsigned short keycode)
    {
        static std::map<unsigned short, int> mapping =
        {
            {0x00, TK_A},
            {0x01, TK_S},
            {0x02, TK_D},
            {0x03, TK_F},
            {0x04, TK_H},
            {0x05, TK_G},
            {0x06, TK_Z},
            {0x07, TK_X},
            {0x08, TK_C},
            {0x09, TK_V},
            {0x0B, TK_B},
            {0x0C, TK_Q},
            {0x0D, TK_W},
            {0x0E, TK_E},
            {0x0F, TK_R},
            {0x10, TK_Y},
            {0x11, TK_T},
            {0x12, TK_1},
            {0x13, TK_2},
            {0x14, TK_3},
            {0x15, TK_4},
            {0x16, TK_6},
            {0x17, TK_5},
            {0x18, TK_EQUALS},
            {0x19, TK_9},
            {0x1A, TK_7},
            {0x1B, TK_MINUS},
            {0x1C, TK_8},
            {0x1D, TK_0},
            {0x1E, TK_RBRACKET},
            {0x1F, TK_O},
            {0x20, TK_U},
            {0x21, TK_LBRACKET},
            {0x22, TK_I},
            {0x23, TK_P},
            {0x25, TK_L},
            {0x26, TK_J},
            {0x27, TK_APOSTROPHE},
            {0x28, TK_K},
            {0x29, TK_SEMICOLON},
            {0x2A, TK_BACKSLASH},
            {0x2B, TK_COMMA},
            {0x2C, TK_SLASH},
            {0x2D, TK_N},
            {0x2E, TK_M},
            {0x2F, TK_PERIOD},
            {0x32, TK_GRAVE},
            {0x41, TK_KP_PERIOD},
            {0x43, TK_KP_MULTIPLY},
            {0x45, TK_KP_PLUS},
//          {0x47, kVK_ANSI_KeypadClear},
            {0x4B, TK_KP_DIVIDE},
            {0x4C, TK_KP_ENTER},
            {0x4E, TK_KP_MINUS},
//          {0x51, kVK_ANSI_KeypadEquals},
            {0x52, TK_KP_0},
            {0x53, TK_KP_1},
            {0x54, TK_KP_2},
            {0x55, TK_KP_3},
            {0x56, TK_KP_4},
            {0x57, TK_KP_5},
            {0x58, TK_KP_6},
            {0x59, TK_KP_7},
            {0x5B, TK_KP_8},
            {0x5C, TK_KP_9},
            {0x24, TK_RETURN},
            {0x30, TK_TAB},
            {0x31, TK_SPACE},
            {0x33, TK_BACKSPACE},
            {0x35, TK_ESCAPE},
//          {0x37, kVK_Command},
            {0x38, TK_SHIFT},
//          {0x39, kVK_CapsLock},
//          {0x3A, kVK_Option}, // This would be TK_ALT
            {0x3B, TK_CONTROL},
            {0x3C, TK_SHIFT},
//          {0x3D, kVK_RightOption},
            {0x3E, TK_CONTROL},
//          {0x3F, kVK_Function},
            {0x60, TK_F5},
            {0x61, TK_F6},
            {0x62, TK_F7},
            {0x63, TK_F3},
            {0x64, TK_F8},
            {0x65, TK_F9},
            {0x67, TK_F11},
            {0x6D, TK_F10},
            {0x6F, TK_F12},
            {0x73, TK_HOME},
            {0x74, TK_PAGEUP},
            {0x75, TK_DELETE},
            {0x76, TK_F4},
            {0x77, TK_END},
            {0x78, TK_F2},
            {0x79, TK_PAGEDOWN},
            {0x7A, TK_F1},
            {0x7B, TK_LEFT},
            {0x7C, TK_RIGHT},
            {0x7D, TK_DOWN},
            {0x7E, TK_UP}
        };

        return mapping[keycode];
    }       

    MacOSWindow::MacOSWindow():
        m_private(new Private())
    {
        LOG(Trace, "MacOSWindow");
    }

    MacOSWindow::~MacOSWindow()
    {
        LOG(Trace, "~MacOSWindow");
        StopEventMonitor();

        if (m_private->m_resize_notifier != nil)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:m_private->m_resize_notifier];
            m_private->m_resize_notifier = nil;
        }

        if (m_private->m_active_notifier != nil)
        {
            [[NSNotificationCenter defaultCenter] removeObserver:m_private->m_active_notifier];
            m_private->m_active_notifier = nil;
        }

        Stop();
    }

    bool MacOSWindow::ValidateIcon(const std::wstring& filename)
    {
        LOG(Trace, "ValidateIcon: " << [[NSThread currentThread] isMainThread]);
        return true;
    }

    void MacOSWindow::SetTitle(const std::wstring& title)
    {
        LOG(Trace, "SetTitle: " << [[NSThread currentThread] isMainThread]);

        Post([&, title] {
            NSString *nsTitle = [[NSString alloc] initWithBytes:title.data()
                                                         length:title.size() * sizeof(wchar_t)
                                                       encoding:NSUTF32LittleEndianStringEncoding];
            m_private->m_window.title = nsTitle;
        });
    }

    void MacOSWindow::SetIcon(const std::wstring& filename)
    {
        LOG(Trace, "SetIcon: " << [[NSThread currentThread] isMainThread]);

        // Mac OS doesn't really do icons
    }

    void MacOSWindow::SetClientSize(const Size& size)
    {
        LOG(Trace, "SetClientSize: " << [[NSThread currentThread] isMainThread]);

        Post([&, size] {
            NSRect oldContentRect = m_private->m_window.frame;
            NSRect newContentRect = NSMakeRect(oldContentRect.origin.x, oldContentRect.origin.y, size.width, size.height);
            NSRect frameRect = [m_private->m_window frameRectForContentRect:newContentRect];
            [m_private->m_window setFrame:frameRect display:YES];
            m_client_size = size;
            Handle({TK_RESIZED, {{TK_WIDTH, m_client_size.width}, {TK_HEIGHT, m_client_size.height}}});
        });
    }

    void MacOSWindow::SetResizeable(bool resizeable)
    {
        LOG(Trace, "SetResizeable: " << [[NSThread currentThread] isMainThread]);

        Post([&, resizeable] {
            m_private->m_window->resizeable = resizeable;
            [m_private->m_window standardWindowButton:NSWindowZoomButton].hidden = !resizeable;
            [m_private->m_window standardWindowButton:NSWindowFullScreenButton].hidden = !resizeable;
            m_resizeable = resizeable;

            if (!resizeable && m_private->m_window->fullscreen)
                ToggleFullscreen();
        });
    }

    void MacOSWindow::ToggleFullscreen()
    {
        LOG(Trace, "ToggleFullscreen: " << [[NSThread currentThread] isMainThread]);

        Post([&] {
            [m_private->m_window toggleFullScreen:nil];
        });
    }

    void MacOSWindow::SetCursorVisibility(bool visible)
    {
        LOG(Trace, "SetCursorVisibility: " << [[NSThread currentThread] isMainThread]);

        Post([&, visible] {
            if (visible != m_private->m_cursor_visible)
            {
                if (visible)
                    [NSCursor unhide];
                else
                    [NSCursor hide];

                m_private->m_cursor_visible = visible;
            }
        });
    }

    void MacOSWindow::Delay(int period)
    {
        LOG(Trace, "Delay: " << [[NSThread currentThread] isMainThread]);

        // period is in ms
        [NSThread sleepForTimeInterval:period/1000.0];
    }

    Size MacOSWindow::GetActualSize()
    {
        LOG(Trace, "GetActualSize: " << [[NSThread currentThread] isMainThread]);

        // This is probably unreliable.
        // We might be reading this information on a non-main thread.
        return Size(m_private->m_window.frame.size.width, m_private->m_window.frame.size.height);
    }

    void MacOSWindow::Show()
    {
        LOG(Trace, "Show: " << [[NSThread currentThread] isMainThread]);

        Post([&]{
            [NSApp unhide:nil];
            [m_private->m_window makeKeyAndOrderFront:nil];
        });
    }

    void MacOSWindow::Hide()
    {
        LOG(Trace, "Hide: " << [[NSThread currentThread] isMainThread]);

        Post([&]{
            [m_private->m_window resignKeyWindow];
            [NSApp hide:nil];
        });
    }

    std::future<void> MacOSWindow::Post(std::function<void()> func)
    {
        LOG(Trace, "Post: " << [[NSThread currentThread] isMainThread]);

        auto task = new std::packaged_task<void()>(std::move(func));
        auto future = task->get_future();

        NSEvent *postEvent = [NSEvent otherEventWithType:NSApplicationDefined
                                                location:NSZeroPoint
                                           modifierFlags:0
                                               timestamp:[[NSProcessInfo processInfo] systemUptime]
                                            windowNumber:m_private->m_window.windowNumber
                                                 context:nil
                                                 subtype:BLTPostEvent
                                                   data1:(NSInteger)task
                                                   data2:0];
        [NSApp postEvent:postEvent
                 atStart:NO];

        return std::move(future);
    }

    void MacOSWindow::StartEventMonitor()
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NSEvent addLocalMonitorForEventsMatchingMask:NSAnyEventMask handler:^NSEvent *(NSEvent *e) {
                switch (e.type) 
                {
                    case NSApplicationDefined:
                    {
                        auto task = (std::packaged_task<void()>*)e.data1;
                        (*task)();
                        delete task;
                        break;
                    }

                    default:
                    {
                        return e;
                    }
                }

                return nil;
            }];

            // Some events we have to access as notifications.
            void (^resizeBlock)(NSNotification *) = ^(NSNotification *note) {
                if (m_resizeable)
                {
                    m_client_size.width = m_private->m_window.frame.size.width;
                    m_client_size.height = m_private->m_window.frame.size.height;
                    Handle({TK_RESIZED, {{TK_WIDTH, m_client_size.width}, {TK_HEIGHT, m_client_size.height}}});
                    Handle(TK_INVALIDATE);
                    Redraw();
                }
            };
            m_private->m_resize_notifier =
            [[NSNotificationCenter defaultCenter] addObserverForName:NSWindowDidResizeNotification
                                                              object:m_private->m_window
                                                               queue:[NSOperationQueue mainQueue]
                                                          usingBlock:resizeBlock];

            void (^activeBlock)(NSNotification *) = ^(NSNotification *note) {
                if (!m_private->m_cursor_visible)
                {
                    [NSCursor unhide];
                    [NSCursor hide];
                }
            };
            m_private->m_active_notifier =
            [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationDidBecomeActiveNotification
                                                              object:NSApp
                                                               queue:[NSOperationQueue mainQueue]
                                                          usingBlock:activeBlock];
        });
    }

    void MacOSWindow::StopEventMonitor()
    {
        if (m_private->m_event_monitor != nil)
            [NSEvent removeMonitor:m_private->m_event_monitor];
    }

    void MacOSWindow::HandleNSWindowEvent(EventBox& box)
    {
        NSEvent *e = box.m_event;

        switch (e.type) 
        {
            case NSKeyDown:
            case NSKeyUp:
            {
                int key = m_private->NSKeycodeToTerminal(e.keyCode);
                if (key > 0)
                {
                    bool pressed = e.type == NSKeyDown;
                    int code = key|(pressed? 0: TK_KEY_RELEASED);

                    Event keyEvent(code);
                    keyEvent[key] = pressed? 1: 0;

                    bool printable = (key < TK_RETURN || key >= TK_SPACE) && key < TK_F1;

                    if (pressed && printable)
                    {
                        const char *c = e.characters.UTF8String;
                        if ((int)c[0] >= 32) // Ignore Ctrl+n codes
                            keyEvent[TK_WCHAR] = (wchar_t)c[0];
                    }

                    Handle(std::move(keyEvent));
                }
                break;
            }

            case NSFlagsChanged:
            {
                int key = m_private->NSKeycodeToTerminal(e.keyCode);
                if (key > 0)
                {
                    bool pressed = false;
                    switch (key) {
                        case TK_CONTROL:
                        {
                            pressed = e.modifierFlags & NSControlKeyMask;
                            break;
                        }

                        case TK_SHIFT:
                        {
                            pressed = e.modifierFlags & NSShiftKeyMask;
                            break;
                        }
                    }

                    int code = key|(pressed? 0: TK_KEY_RELEASED);

                    Event keyEvent(code);
                    keyEvent[key] = pressed? 1: 0;
                    Handle(std::move(keyEvent));
                }
                break;
            }

            case NSMouseMoved:
            case NSLeftMouseDragged:
            case NSRightMouseDragged:
            case NSOtherMouseDragged:
            {
                NSPoint loc = [m_private->m_window.contentView convertPoint:e.locationInWindow fromView:nil];
                Event mouseMovedEvent(TK_MOUSE_MOVE);
                mouseMovedEvent[TK_MOUSE_PIXEL_X] = loc.x;
                mouseMovedEvent[TK_MOUSE_PIXEL_Y] = m_private->m_window.frame.size.height - loc.y;
                Handle(std::move(mouseMovedEvent));
                break;
            }

            case NSLeftMouseDown:
            {
                Event event(TK_MOUSE_LEFT, {{TK_MOUSE_LEFT, 1}, {TK_MOUSE_CLICKS, e.clickCount}});
                Handle(std::move(event));
                break;
            }

            case NSRightMouseDown:
            {
                Event event(TK_MOUSE_RIGHT, {{TK_MOUSE_RIGHT, 1}, {TK_MOUSE_CLICKS, e.clickCount}});
                Handle(std::move(event));
                break;
            }

            case NSLeftMouseUp:
            {
                Event event(TK_MOUSE_LEFT|TK_KEY_RELEASED, {{TK_MOUSE_LEFT, 0}, {TK_MOUSE_CLICKS, e.clickCount}});
                Handle(std::move(event));
                break;                
            }

            case NSRightMouseUp:
            {
                Event event(TK_MOUSE_RIGHT|TK_KEY_RELEASED, {{TK_MOUSE_RIGHT, 0}, {TK_MOUSE_CLICKS, e.clickCount}});
                Handle(std::move(event));
                break;                
            }

            case NSScrollWheel:
            {
                // Macs use inertial scrolling, which probably doesn't mesh well with the BLT paradigm.
                // TODO: Map inertial scrolling to oldschool mousewheel scrolling.
                CGFloat delta = e.scrollingDeltaY;
                Handle(Event(TK_MOUSE_SCROLL, {{TK_MOUSE_WHEEL, (int)delta}}));
                break;
            }

            default:
            {
                NSLog(@"Unhandled NSWindow event: %@", e);
            }
        }        
    }

    bool MacOSWindow::PumpEvents()
    {
        // I guess we don't really have a need for this function.
        return false;
    }

    void MacOSWindow::ThreadFunction()
    {
        LOG(Trace, "ThreadFunction ENTER: " << [[NSThread currentThread] isMainThread]);

        while (m_proceed)
        {
            if (!PumpEvents())
                [NSThread sleepForTimeInterval:0.0005]; // 5µs
        }

        LOG(Trace, "ThreadFunction EXIT");
    }

    // This gets called on a non-main thread...
    bool MacOSWindow::Construct()
    {
        LOG(Trace, "Construct: " << [[NSThread currentThread] isMainThread]);

        dispatch_sync(dispatch_get_main_queue(), ^{
            NSUInteger styleMask = NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask;
            NSRect frame = NSMakeRect(0.0, 0.0, 100.0, 100.0);
            NSRect rect = [NSWindow contentRectForFrameRect:frame styleMask:styleMask];
            m_private->m_window = [[BLTWindow alloc] initWithContentRect:rect
                                                              styleMask:styleMask
                                                                backing:NSBackingStoreBuffered
                                                                  defer:NO];

            m_private->m_window.backgroundColor = [NSColor blueColor];
            m_private->m_window.acceptsMouseMovedEvents = YES;
            m_private->m_window->bltWindow = this;
            m_private->m_window.delegate = m_private->m_window;
            [m_private->m_window makeKeyAndOrderFront:nil];

            if (![m_private->m_window canBecomeMainWindow])
            {
                LOG(Fatal, "Window can't become main");
                return;
            }

            [m_private->m_window makeMainWindow];
            [m_private->m_window center];

            NSOpenGLPixelFormatAttribute attrs[] =
            {
                NSOpenGLPFADoubleBuffer,
                NSOpenGLPFAColorSize, 24,
                NSOpenGLPFAAlphaSize, 8,
                NSOpenGLPFADepthSize, 16,
                0
            };
            NSOpenGLPixelFormat *pixFmt = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
            if (pixFmt == nil)
            {
                LOG(Fatal, "Invalid OpenGL pixel format");
                return;
            }

            m_private->m_glview = [[NSOpenGLView alloc] initWithFrame:NSZeroRect
                                                          pixelFormat:pixFmt];
            if (m_private->m_glview == nil)
            {
                LOG(Fatal, "Couldn't init OpenGL view");
                return;
            }
            
            m_private->m_window.contentView = m_private->m_glview;
            [m_private->m_glview.openGLContext makeCurrentContext];

            StartEventMonitor();
            SetVSync(true);
            
            // window is not resizeable by default
            [m_private->m_window standardWindowButton:NSWindowZoomButton].hidden = YES;
            [m_private->m_window standardWindowButton:NSWindowFullScreenButton].hidden = YES;

            m_proceed = true;
        });
        
        // Ignored?
        return true;
    }

    // This gets called on a non-main thread...
    void MacOSWindow::Destroy()
    {
        LOG(Trace, "Destroy: " << [[NSThread currentThread] isMainThread]);

        if (m_private->m_glview != nil)
        {
            Invoke([&] {
                [NSOpenGLContext clearCurrentContext];
                [m_private->m_glview removeFromSuperview];
                m_private->m_glview = nil;
            });
        }

        if (m_private->m_window != nil)
        {
            Invoke([&] {
                [m_private->m_window resignMainWindow];
                m_private->m_window = nil;
            });
        }
    }

    void MacOSWindow::Redraw()
    {
        LOG(Trace, "Redraw: " << [[NSThread currentThread] isMainThread]);

        if (m_private->m_glview == nil)
            return;

        if (Handle(TK_REDRAW) > 0)
            SwapBuffers();
    }

    void MacOSWindow::SwapBuffers()
    {
        LOG(Trace, "SwapBuffers: " << [[NSThread currentThread] isMainThread]);

        if (m_private->m_glview == nil)
            return;

        [m_private->m_glview.openGLContext flushBuffer];
    }

    void MacOSWindow::SetVSync(bool enabled)
    {
        LOG(Trace, "SetVSync: " << [[NSThread currentThread] isMainThread]);

        if (m_private->m_glview == nil)
            return;        

        GLint swapInt = 1;
        if (!enabled)
            swapInt = 0;

        [m_private->m_glview.openGLContext setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
        LOG(Info, "SwapInterval set to " << swapInt);
    }
}

#endif
