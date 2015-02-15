#
# BearLibTerminal
# Copyright (C) 2013-2014 Cfyz
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Release date: 2014-11-10

import sys, ctypes, numbers

_version3 = sys.version_info >= (3, 0)
 
_library = None
_possible_library_names = [
	'BearLibTerminal.dll',     # Generic Windows DLL
	'./libBearLibTerminal.so', # Local Linux SO
	'./BearLibTerminal.so',    # Local Linux SO w/o prefix
	'libBearLibTerminal.so',   # System Linux SO
	'BearLibTerminal.so'       # System Linux SO w/o prefix 
]
for name in _possible_library_names:
	try:
		_library = ctypes.CDLL(name)
		break
	except OSError:
		continue

if _library is None:
	raise RuntimeError("BearLibTerminal library cannot be loaded.")

# wchar_t size may vary
if ctypes.sizeof(ctypes.c_wchar()) == 4:
	_wset = _library.terminal_set32
	_wprint = _library.terminal_print32
	_wmeasure = _library.terminal_measure32
	_read_wstr = _library.terminal_read_str32
	_color_from_wname = _library.color_from_name32
else:
	_wset = _library.terminal_set16
	_wprint = _library.terminal_print16
	_wmeasure = _library.terminal_measure16
	_read_wstr = _library.terminal_read_str16
	_color_from_wname = _library.color_from_name16

# color/bkcolor accept uint32, color_from_name returns uint32
_library.terminal_color.argtypes = [ctypes.c_uint32]
_library.terminal_bkcolor.argtypes = [ctypes.c_uint32]
_library.color_from_name8.restype = ctypes.c_uint32
_color_from_wname.restype = ctypes.c_uint32

def color_from_name(s):
	if _version3 or isinstance(s, unicode):
		return _color_from_wname(s)
	else:
		return _library.color_from_name8(s)

def open():
	if _library.terminal_open() == 0:
		return False
	_library.terminal_set8('terminal: encoding=ascii, encoding-affects-put=false')
	return True

close = _library.terminal_close

def set(s):
	if _version3 or isinstance(s, unicode):
		_wset(s)
	else:
		_library.terminal_set8(s)

def setf(s, *args):
	return set(s.format(*args))

refresh = _library.terminal_refresh

clear = _library.terminal_clear

clear_area = _library.terminal_clear_area

crop = _library.terminal_crop

layer = _library.terminal_layer

def color(v):
	if isinstance(v, numbers.Number):
		_library.terminal_color(v)
	else:
		_library.terminal_color(color_from_name(v))

def bkcolor(v):
	if isinstance(v, numbers.Number):
		_library.terminal_bkcolor(v)
	else:
		_library.terminal_bkcolor(color_from_name(v))

composition = _library.terminal_composition

def put(x, y, c):
	if not isinstance(c, numbers.Number):
		c = ord(c)
	_library.terminal_put(x, y, c)

def put_ext(x, y, dx, dy, c, corners=None):
	if not isinstance(c, numbers.Number):
		c = ord(c)
	if corners is None:
		_library.terminal_put_ext(x, y, dx, dy, c, None)
	else:
		for i in range(0, 4):
			put_ext.corners[i] = corners[i]
		_library.terminal_put_ext(x, y, dx, dy, c, ctypes.cast(put_ext.corners, ctypes.POINTER(ctypes.c_uint)))
put_ext.corners = (ctypes.c_uint32 * 4)()

def pick(x, y, z = 0):
	return _library.terminal_pick(x, y, z);

def pick_color(x, y, z = 0):
	return _library.terminal_pick_color(x, y, z);

pick_bkcolor = _library.terminal_pick_bkcolor

def print_(x, y, s):
	if _version3 or isinstance(s, unicode):
		return _wprint(x, y, s)
	else:
		return _library.terminal_print8(x, y, s)

def printf(x, y, s, *args):
	return print_(x, y, s.format(*args))

def measure(s):
	if _version3 or isinstance(s, unicode):
		return _wmeasure(s)
	else:
		return _library.terminal_measure8(s)

def measuref(s, *args):
	return measure(s.format(*args))

def has_input():
	return _library.terminal_has_input() == 1

state = _library.terminal_state

def check(state):
	return _library.terminal_state(state) == 1

read = _library.terminal_read

peek = _library.terminal_peek

def read_str(x, y, s, max):
	if _version3 or isinstance(s, unicode):
		p = ctypes.create_unicode_buffer(s, max+1)
		rc = _read_wstr(x, y, p, max)
		return rc, p.value
	else:
		p = ctypes.create_string_buffer(s, max+1)
		rc = _library.terminal_read_str8(x, y, p, max)
		return rc, p.value

delay = _library.terminal_delay

def color_from_argb(a, r, g, b):
	result = a
	result = result * 256 + r
	result = result * 256 + g
	result = result * 256 + b
	return result

# Keyboard scancodes for events/states.
TK_A                = 0x04
TK_B                = 0x05
TK_C                = 0x06
TK_D                = 0x07
TK_E                = 0x08
TK_F                = 0x09
TK_G                = 0x0A
TK_H                = 0x0B
TK_I                = 0x0C
TK_J                = 0x0D
TK_K                = 0x0E
TK_L                = 0x0F
TK_M                = 0x10
TK_N                = 0x11
TK_O                = 0x12
TK_P                = 0x13
TK_Q                = 0x14
TK_R                = 0x15
TK_S                = 0x16
TK_T                = 0x17
TK_U                = 0x18
TK_V                = 0x19
TK_W                = 0x1A
TK_X                = 0x1B
TK_Y                = 0x1C
TK_Z                = 0x1D
TK_1                = 0x1E
TK_2                = 0x1F
TK_3                = 0x20
TK_4                = 0x21
TK_5                = 0x22
TK_6                = 0x23
TK_7                = 0x24
TK_8                = 0x25
TK_9                = 0x26
TK_0                = 0x27
TK_RETURN           = 0x28
TK_ENTER            = 0x28
TK_ESCAPE           = 0x29
TK_BACKSPACE        = 0x2A
TK_TAB              = 0x2B
TK_SPACE            = 0x2C
TK_MINUS            = 0x2D
TK_EQUALS           = 0x2E
TK_LBRACKET         = 0x2F
TK_RBRACKET         = 0x30
TK_BACKSLASH        = 0x31
TK_SEMICOLON        = 0x33
TK_APOSTROPHE       = 0x34
TK_GRAVE            = 0x35
TK_COMMA            = 0x36
TK_PERIOD           = 0x37
TK_SLASH            = 0x38
TK_F1               = 0x3A
TK_F2               = 0x3B
TK_F3               = 0x3C
TK_F4               = 0x3D
TK_F5               = 0x3E
TK_F6               = 0x3F
TK_F7               = 0x40
TK_F8               = 0x41
TK_F9               = 0x42
TK_F10              = 0x43
TK_F11              = 0x44
TK_F12              = 0x45
TK_PAUSE            = 0x48
TK_INSERT           = 0x49
TK_HOME             = 0x4A
TK_PAGEUP           = 0x4B
TK_DELETE           = 0x4C
TK_END              = 0x4D
TK_PAGEDOWN         = 0x4E
TK_RIGHT            = 0x4F
TK_LEFT             = 0x50
TK_DOWN             = 0x51
TK_UP               = 0x52
TK_KP_DIVIDE        = 0x54
TK_KP_MULTIPLY      = 0x55
TK_KP_MINUS         = 0x56
TK_KP_PLUS          = 0x57
TK_KP_ENTER         = 0x58
TK_KP_1             = 0x59
TK_KP_2             = 0x5A
TK_KP_3             = 0x5B
TK_KP_4             = 0x5C
TK_KP_5             = 0x5D
TK_KP_6             = 0x5E
TK_KP_7             = 0x5F
TK_KP_8             = 0x60
TK_KP_9             = 0x61
TK_KP_0             = 0x62
TK_KP_PERIOD        = 0x63
TK_SHIFT            = 0x70
TK_CONTROL          = 0x71

# Mouse events/states.
TK_MOUSE_LEFT       = 0x80 # Buttons
TK_MOUSE_RIGHT      = 0x81
TK_MOUSE_MIDDLE     = 0x82
TK_MOUSE_X1         = 0x83
TK_MOUSE_X2         = 0x84
TK_MOUSE_MOVE       = 0x85 # Movement event
TK_MOUSE_SCROLL     = 0x86 # Mouse scroll event
TK_MOUSE_X          = 0x87 # Cusor position in cells
TK_MOUSE_Y          = 0x88
TK_MOUSE_PIXEL_X    = 0x89 # Cursor position in pixels
TK_MOUSE_PIXEL_Y    = 0x8A
TK_MOUSE_WHEEL      = 0x8B # Scroll direction and amount
TK_MOUSE_CLICKS     = 0x8C # Number of consecutive clicks

# If key was released instead of pressed, it's code will be OR'ed with VK_KEY_RELEASED.
TK_KEY_RELEASED     = 0x100

# Virtual key-codes for internal terminal states/variables.
# These can be accessed via terminal_state function.
TK_WIDTH            = 0xC0 # Terminal width in cells
TK_HEIGHT           = 0xC1 # Terminal height in cells
TK_CELL_WIDTH       = 0xC2 # Cell width in pixels
TK_CELL_HEIGHT      = 0xC3 # Cell height in pixels
TK_COLOR            = 0xC4 # Current foregroung color
TK_BKCOLOR          = 0xC5 # Current background color
TK_LAYER            = 0xC6 # Current layer
TK_COMPOSITION      = 0xC7 # Current composition state
TK_CHAR             = 0xC8 # Translated ANSI code of last produced character
TK_WCHAR            = 0xC9 # Unicode codepoint of last produced character
TK_EVENT            = 0xCA # Last dequeued event
TK_FULLSCREEN       = 0xCB # Fullscreen state

# Other events.
TK_CLOSE            = 0xE0
TK_RESIZED          = 0xE1

# Generic mode enum. Used in Terminal.composition call only.
TK_OFF              =    0
TK_ON               =    1

# Input result codes for terminal_read_str function.
TK_INPUT_NONE       =    0
TK_INPUT_CANCELLED  =   -1
