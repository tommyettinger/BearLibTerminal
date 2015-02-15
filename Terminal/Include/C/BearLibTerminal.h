/*
* BearLibTerminal
* Copyright (C) 2013-2014 Cfyz
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

#ifndef BEARLIBTERMINAL_H
#define BEARLIBTERMINAL_H

#if defined(_MSC_VER) && !defined(_CRT_SECURE_NO_WARNINGS)
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <stdarg.h>
#include <wchar.h>

/*
 * Keyboard scancodes for events/states
 */
#define TK_A                0x04
#define TK_B                0x05
#define TK_C                0x06
#define TK_D                0x07
#define TK_E                0x08
#define TK_F                0x09
#define TK_G                0x0A
#define TK_H                0x0B
#define TK_I                0x0C
#define TK_J                0x0D
#define TK_K                0x0E
#define TK_L                0x0F
#define TK_M                0x10
#define TK_N                0x11
#define TK_O                0x12
#define TK_P                0x13
#define TK_Q                0x14
#define TK_R                0x15
#define TK_S                0x16
#define TK_T                0x17
#define TK_U                0x18
#define TK_V                0x19
#define TK_W                0x1A
#define TK_X                0x1B
#define TK_Y                0x1C
#define TK_Z                0x1D
#define TK_1                0x1E
#define TK_2                0x1F
#define TK_3                0x20
#define TK_4                0x21
#define TK_5                0x22
#define TK_6                0x23
#define TK_7                0x24
#define TK_8                0x25
#define TK_9                0x26
#define TK_0                0x27
#define TK_RETURN           0x28
#define TK_ENTER            0x28
#define TK_ESCAPE           0x29
#define TK_BACKSPACE        0x2A
#define TK_TAB              0x2B
#define TK_SPACE            0x2C
#define TK_MINUS            0x2D /*  -  */
#define TK_EQUALS           0x2E /*  =  */
#define TK_LBRACKET         0x2F /*  [  */
#define TK_RBRACKET         0x30 /*  ]  */
#define TK_BACKSLASH        0x31 /*  \  */
#define TK_SEMICOLON        0x33 /*  ;  */
#define TK_APOSTROPHE       0x34 /*  '  */
#define TK_GRAVE            0x35 /*  `  */
#define TK_COMMA            0x36 /*  ,  */
#define TK_PERIOD           0x37 /*  .  */
#define TK_SLASH            0x38 /*  /  */
#define TK_F1               0x3A
#define TK_F2               0x3B
#define TK_F3               0x3C
#define TK_F4               0x3D
#define TK_F5               0x3E
#define TK_F6               0x3F
#define TK_F7               0x40
#define TK_F8               0x41
#define TK_F9               0x42
#define TK_F10              0x43
#define TK_F11              0x44
#define TK_F12              0x45
#define TK_PAUSE            0x48 /* Pause/Break */
#define TK_INSERT           0x49
#define TK_HOME             0x4A
#define TK_PAGEUP           0x4B
#define TK_DELETE           0x4C
#define TK_END              0x4D
#define TK_PAGEDOWN         0x4E
#define TK_RIGHT            0x4F /* Right arrow */
#define TK_LEFT             0x50 /* Left arrow */
#define TK_DOWN             0x51 /* Down arrow */
#define TK_UP               0x52 /* Up arrow */
#define TK_KP_DIVIDE        0x54 /* '/' on numpad */
#define TK_KP_MULTIPLY      0x55 /* '*' on numpad */
#define TK_KP_MINUS         0x56 /* '-' on numpad */
#define TK_KP_PLUS          0x57 /* '+' on numpad */
#define TK_KP_ENTER         0x58
#define TK_KP_1             0x59
#define TK_KP_2             0x5A
#define TK_KP_3             0x5B
#define TK_KP_4             0x5C
#define TK_KP_5             0x5D
#define TK_KP_6             0x5E
#define TK_KP_7             0x5F
#define TK_KP_8             0x60
#define TK_KP_9             0x61
#define TK_KP_0             0x62
#define TK_KP_PERIOD        0x63 /* '.' on numpad */
#define TK_SHIFT            0x70
#define TK_CONTROL          0x71

/*
 * Mouse events/states
 */
#define TK_MOUSE_LEFT       0x80 /* Buttons */
#define TK_MOUSE_RIGHT      0x81
#define TK_MOUSE_MIDDLE     0x82
#define TK_MOUSE_X1         0x83
#define TK_MOUSE_X2         0x84
#define TK_MOUSE_MOVE       0x85 /* Movement event */
#define TK_MOUSE_SCROLL     0x86 /* Mouse scroll event */
#define TK_MOUSE_X          0x87 /* Cusor position in cells */
#define TK_MOUSE_Y          0x88
#define TK_MOUSE_PIXEL_X    0x89 /* Cursor position in pixels */
#define TK_MOUSE_PIXEL_Y    0x8A
#define TK_MOUSE_WHEEL      0x8B /* Scroll direction and amount */
#define TK_MOUSE_CLICKS     0x8C /* Number of consecutive clicks */

/*
 * If key was released instead of pressed, it's code will be OR'ed with TK_KEY_RELEASED:
 * a) pressed 'A': 0x04
 * b) released 'A': 0x04|VK_KEY_RELEASED = 0x104
 */
#define TK_KEY_RELEASED     0x100

/*
 * Virtual key-codes for internal terminal states/variables.
 * These can be accessed via terminal_state function.
 */
#define TK_WIDTH            0xC0 /* Terminal window size in cells */
#define TK_HEIGHT           0xC1
#define TK_CELL_WIDTH       0xC2 /* Character cell size in pixels */
#define TK_CELL_HEIGHT      0xC3
#define TK_COLOR            0xC4 /* Current foregroung color */
#define TK_BKCOLOR          0xC5 /* Current background color */
#define TK_LAYER            0xC6 /* Current layer */
#define TK_COMPOSITION      0xC7 /* Current composition state */
#define TK_CHAR             0xC8 /* Translated ANSI code of last produced character */
#define TK_WCHAR            0xC9 /* Unicode codepoint of last produced character */
#define TK_EVENT            0xCA /* Last dequeued event */
#define TK_FULLSCREEN       0xCB /* Fullscreen state */

/*
 * Other events
 */
#define TK_CLOSE            0xE0
#define TK_RESIZED          0xE1

/*
 * Generic mode enum.
 * Right now it is used for composition option only.
 */
#define TK_OFF                 0
#define TK_ON                  1

/*
 * Input result codes for terminal_read function.
 */
#define TK_INPUT_NONE          0
#define TK_INPUT_CANCELLED    -1

/*
 * Terminal uses unsigned 32-bit value for color representation in ARGB order (0xAARRGGBB), e. g.
 * a) solid red is 0xFFFF0000
 * b) half-transparent green is 0x8000FF00
 */
typedef uint32_t color_t;

#if defined(_WIN32)
#  if defined(BEARLIBTERMINAL_BUILDING_LIBRARY)
#    define TERMINAL_API __declspec(dllexport)
#  else
#    define TERMINAL_API __declspec(dllimport)
#  endif
#else
#  if defined(BEARLIBTERMINAL_BUILDING_LIBRARY) && __GNUC__ >= 4
#    define TERMINAL_API __attribute__ ((visibility ("default")))
#  else
#    define TERMINAL_API
#  endif
#endif

#ifdef __cplusplus
extern "C" {
#endif

TERMINAL_API int terminal_open();
TERMINAL_API void terminal_close();
TERMINAL_API int terminal_set8(const int8_t* value);
TERMINAL_API int terminal_set16(const int16_t* value);
TERMINAL_API int terminal_set32(const int32_t* value);
TERMINAL_API void terminal_refresh();
TERMINAL_API void terminal_clear();
TERMINAL_API void terminal_clear_area(int x, int y, int w, int h);
TERMINAL_API void terminal_crop(int x, int y, int w, int h);
TERMINAL_API void terminal_layer(int index);
TERMINAL_API void terminal_color(color_t color);
TERMINAL_API void terminal_bkcolor(color_t color);
TERMINAL_API void terminal_composition(int mode);
TERMINAL_API void terminal_put(int x, int y, int code);
TERMINAL_API void terminal_put_ext(int x, int y, int dx, int dy, int code, color_t* corners);
TERMINAL_API int terminal_pick(int x, int y, int index);
TERMINAL_API color_t terminal_pick_color(int x, int y, int index);
TERMINAL_API color_t terminal_pick_bkcolor(int x, int y);
TERMINAL_API int terminal_print8(int x, int y, const int8_t* s);
TERMINAL_API int terminal_print16(int x, int y, const int16_t* s);
TERMINAL_API int terminal_print32(int x, int y, const int32_t* s);
TERMINAL_API int terminal_measure8(const int8_t* s);
TERMINAL_API int terminal_measure16(const int16_t* s);
TERMINAL_API int terminal_measure32(const int32_t* s);
TERMINAL_API int terminal_has_input();
TERMINAL_API int terminal_state(int code);
TERMINAL_API int terminal_read();
TERMINAL_API int terminal_read_str8(int x, int y, int8_t* buffer, int max);
TERMINAL_API int terminal_read_str16(int x, int y, int16_t* buffer, int max);
TERMINAL_API int terminal_read_str32(int x, int y, int32_t* buffer, int max);
TERMINAL_API int terminal_peek();
TERMINAL_API void terminal_delay(int period);
TERMINAL_API color_t color_from_name8(const int8_t* name);
TERMINAL_API color_t color_from_name16(const int16_t* name);
TERMINAL_API color_t color_from_name32(const int32_t* name);

#ifdef __cplusplus
} /* End of extern "C" */
#endif

/*
 * Utility macro trick which allows macro-in-macro expansion
 */
#define TERMINAL_CAT(a, b) TERMINAL_PRIMITIVE_CAT(a, b)
#define TERMINAL_PRIMITIVE_CAT(a, b) a ## b

/*
 * wchar_t has different sized depending on platform. Furthermore, it's size
 * can be changed for GCC compiler.
 */
#if !defined(__SIZEOF_WCHAR_T__)
#  if defined(_WIN32)
#    define __SIZEOF_WCHAR_T__ 2
#  else
#    define __SIZEOF_WCHAR_T__ 4
#  endif
#endif

#if __SIZEOF_WCHAR_T__ == 2
#define TERMINAL_WCHAR_SUFFIX 16
#define TERMINAL_WCHAR_TYPE int16_t
#else // 4
#define TERMINAL_WCHAR_SUFFIX 32
#define TERMINAL_WCHAR_TYPE int32_t
#endif

/*
 * This set of inline functions define basic name substitution + type cast:
 * terminal_[w]xxxx -> terminal_xxxx{8|16|32}
 */

#if defined(__cplusplus)
#define TERMINAL_INLINE inline
#else
#define TERMINAL_INLINE static inline
#endif

TERMINAL_INLINE int terminal_set(const char* value)
{
	return terminal_set8((const int8_t*)value);
}

TERMINAL_INLINE int terminal_wset(const wchar_t* value)
{
	return TERMINAL_CAT(terminal_set, TERMINAL_WCHAR_SUFFIX)((const TERMINAL_WCHAR_TYPE*)value);
}

TERMINAL_INLINE int terminal_print(int x, int y, const char* s)
{
	return terminal_print8(x, y, (const int8_t*)s);
}

TERMINAL_INLINE int terminal_wprint(int x, int y, const wchar_t* s)
{
	return TERMINAL_CAT(terminal_print, TERMINAL_WCHAR_SUFFIX)(x, y, (const TERMINAL_WCHAR_TYPE*)s);
}

TERMINAL_INLINE int terminal_measure(const char* s)
{
	return terminal_measure8((const int8_t*)s);
}

TERMINAL_INLINE int terminal_wmeasure(const wchar_t* s)
{
	return TERMINAL_CAT(terminal_measure, TERMINAL_WCHAR_SUFFIX)((const TERMINAL_WCHAR_TYPE*)s);
}

TERMINAL_INLINE int terminal_read_str(int x, int y, char* buffer, int max)
{
	return terminal_read_str8(x, y, (int8_t*)buffer, max);
}

TERMINAL_INLINE int terminal_read_wstr(int x, int y, wchar_t* buffer, int max)
{
	return TERMINAL_CAT(terminal_read_str, TERMINAL_WCHAR_SUFFIX)(x, y, (TERMINAL_WCHAR_TYPE*)buffer, max);
}

TERMINAL_INLINE color_t color_from_name(const char* name)
{
	return color_from_name8((const int8_t*)name);
}

TERMINAL_INLINE color_t color_from_wname(const wchar_t* name)
{
	return TERMINAL_CAT(color_from_name, TERMINAL_WCHAR_SUFFIX)((const TERMINAL_WCHAR_TYPE*)name);
}

/*
 * These inline functions provide formatted versions for textual API:
 * terminal_[w]setf and terminal_[w]printf
 *
 * Using static termporary buffer is okay because terminal API is not
 * required to be multiple-thread safe by design.
 */

#if !defined(TERMINAL_FORMAT_BUFFER_SIZE)
#define TERMINAL_FORMAT_BUFFER_SIZE 1024
#endif

#define TERMINAL_FORMATTED_VA(type, name, sign, func, call_sign)\
	TERMINAL_INLINE int terminal_v##name##f sign\
	{\
		static type buffer[TERMINAL_FORMAT_BUFFER_SIZE] = {0};\
		int rc = 0;\
		if (s == NULL) return 0;\
		rc = func(buffer, TERMINAL_FORMAT_BUFFER_SIZE-1, s, args);\
		if (rc > 0) rc = terminal_##name call_sign;\
		return rc;\
	}

#if defined(_WIN32)
#define TERMINAL_VSNWPRINTF _vsnwprintf
#else
#define TERMINAL_VSNWPRINTF vswprintf
#endif

TERMINAL_FORMATTED_VA(char, set, (const char* s, va_list args), vsnprintf, (buffer))
TERMINAL_FORMATTED_VA(wchar_t, wset, (const wchar_t* s, va_list args), TERMINAL_VSNWPRINTF, (buffer))
TERMINAL_FORMATTED_VA(char, print, (int x, int y, const char* s, va_list args), vsnprintf, (x, y, buffer))
TERMINAL_FORMATTED_VA(wchar_t, wprint, (int x, int y, const wchar_t* s, va_list args), TERMINAL_VSNWPRINTF, (x, y, buffer))
TERMINAL_FORMATTED_VA(char, measure, (const char* s, va_list args), vsnprintf, (buffer))
TERMINAL_FORMATTED_VA(wchar_t, wmeasure, (const wchar_t* s, va_list args), TERMINAL_VSNWPRINTF, (buffer))

#define TERMINAL_FORMATTED(outer, inner)\
	TERMINAL_INLINE int terminal_##outer\
	{\
		va_list args;\
		int rc = 0;\
		va_start(args, s);\
		rc = terminal_v##inner;\
		va_end(args);\
		return rc;\
	}

TERMINAL_FORMATTED(setf(const char* s, ...), setf(s, args))
TERMINAL_FORMATTED(wsetf(const wchar_t* s, ...), wsetf(s, args))
TERMINAL_FORMATTED(printf(int x, int y, const char* s, ...), printf(x, y, s, args))
TERMINAL_FORMATTED(wprintf(int x, int y, const wchar_t* s, ...), wprintf(x, y, s, args))
TERMINAL_FORMATTED(measuref(const char* s, ...), measuref(s, args))
TERMINAL_FORMATTED(wmeasuref(const wchar_t* s, ...), wmeasuref(s, args))

#ifdef __cplusplus
/*
 * C++ supports function overloading, should take advantage of it.
 */

TERMINAL_INLINE int terminal_set(const wchar_t* s)
{
	return terminal_wset(s);
}

TERMINAL_FORMATTED(setf(const wchar_t* s, ...), wsetf(s, args))

TERMINAL_INLINE void terminal_color(const char* name)
{
	terminal_color(color_from_name(name));
}

TERMINAL_INLINE void terminal_color(const wchar_t* name)
{
	terminal_color(color_from_wname(name));
}

TERMINAL_INLINE void terminal_bkcolor(const char* name)
{
	terminal_bkcolor(color_from_name(name));
}

TERMINAL_INLINE void terminal_bkcolor(const wchar_t* name)
{
	terminal_bkcolor(color_from_wname(name));
}

TERMINAL_INLINE void terminal_put_ext(int x, int y, int dx, int dy, int code)
{
	terminal_put_ext(x, y, dx, dy, code, 0);
}

TERMINAL_INLINE int terminal_print(int x, int y, const wchar_t* s)
{
	return terminal_wprint(x, y, s);
}

TERMINAL_FORMATTED(printf(int x, int y, const wchar_t* s, ...), wprintf(x, y, s, args))

TERMINAL_INLINE int terminal_measure(const wchar_t* s)
{
	return terminal_wmeasure(s);
}

TERMINAL_FORMATTED(measuref(const wchar_t* s, ...), wmeasuref(s, args))

TERMINAL_INLINE int terminal_read_str(int x, int y, wchar_t* buffer, int max)
{
	return terminal_read_wstr(x, y, buffer, max);
}

TERMINAL_INLINE color_t color_from_name(const wchar_t* name)
{
	return color_from_wname(name);
}

TERMINAL_INLINE int terminal_pick(int x, int y)
{
	return terminal_pick(x, y, 0);
}

TERMINAL_INLINE color_t terminal_pick_color(int x, int y)
{
	return terminal_pick_color(x, y, 0);
}

#endif /* __cplusplus */

/*
 * Color routines
 */
TERMINAL_INLINE color_t color_from_argb(uint8_t a, uint8_t r, uint8_t g, uint8_t b)
{
	return ((color_t)a << 24) | (r << 16) | (g << 8) | b;
}

/*
 * Other functional sugar
 */
TERMINAL_INLINE int terminal_check(int code)
{
	return terminal_state(code) > 0;
}

/*
 * WinMain entry point handling macro. This allows easier entry point definition.
 * The macro will expand to proper WinMain stub regardless of header include order.
 */
#if defined(_WIN32)

/*
 * WinMain probe macro. It will expand to either X or X_WINDOWS_ depending on
 * Windows.h header inclusion.
 */
#define TERMINAL_TAKE_CARE_OF_WINMAIN TERMINAL_WINMAIN_PROBE_IMPL(_WINDOWS_)
#define TERMINAL_WINMAIN_PROBE_IMPL(DEF) TERMINAL_PRIMITIVE_CAT(TERMINAL_WINMAIN_IMPL, DEF)

/*
 * Trivial no-arguments WinMain implementation. It just calls main.
 */
#define TERMINAL_WINMAIN_IMPL_BASE(INSTANCE_T, STRING_T)\
	extern "C" int main();\
	extern "C" int __stdcall WinMain(INSTANCE_T hInstance, INSTANCE_T hPrevInstance, STRING_T lpCmdLine, int nCmdShow)\
	{\
		return main();\
	}

/*
 * Macro expands to empty string. Windows.h is included thus code MUST use
 * predefined types or else MSVC will complain.
 */
#define TERMINAL_WINMAIN_IMPL TERMINAL_WINMAIN_IMPL_BASE(HINSTANCE, LPSTR)

/*
 * Macro expands to macro name. Windows.h wasn't included, so WinMain will be
 * defined with fundamental types (enough for linker to find it).
 */
#define TERMINAL_WINMAIN_IMPL_WINDOWS_ TERMINAL_WINMAIN_IMPL_BASE(void*, char*)

#else

/*
 * Only Windows has WinMain but macro still must be defined for cross-platform
 * applications.
 */
#define TERMINAL_TAKE_CARE_OF_WINMAIN

#endif

#endif // BEARLIBTERMINAL_H
