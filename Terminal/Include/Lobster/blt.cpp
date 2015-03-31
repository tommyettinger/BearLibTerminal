// Copyright 2014 Tommy Ettinger. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//Until Lobster gets an FFI, this must be compiled into the Lobster engine.
//Copy the C include file into dev/include/BearLibTerminal/ and the
//.lib into dev/lib/ , and the .lobster file in this directory should go
//in lobster/include , since it isn't needed in the engine.

#include "stdafx.h"

#include "vmdata.h"
#include "natreg.h"

#include "BearLibTerminal/BearLibTerminal.h"

using namespace lobster;

void AddBLTOps()
{
	STARTDECL(blt_open) ()
	{
		return Value(terminal_open() == 0);
	}
	ENDDECL0(blt_open, "", "", "I",
		"opens the terminal. returns 1 on failure, to comply with lobster's fatal(). use blt_set to set options.");

	STARTDECL(blt_close) ()
	{
		terminal_close();
		return Value();
	}
	ENDDECL0(blt_close, "", "", "",
		"closes the terminal.");

	STARTDECL(blt_set) (Value &params)
	{
		params.DECRT();
		return Value(terminal_set8((int8_t*)(params.sval->str())));
	}
	ENDDECL1(blt_set, "params", "S", "I",
		"sets options. this is a truly massive function inside, and you should consult the docs.");

	STARTDECL(blt_get) (Value &key, Value& fallback)
	{
		key.DECRT();
		fallback.DECRT();
		char* cs = (char*)terminal_get8((int8_t*)(key.sval->str()), (int8_t*)(fallback.sval->str()));
		Value v = Value(g_vm->NewString(cs, strlen(cs)));
		return v;
	}
	ENDDECL2(blt_get, "key,fallback", "SS", "S",
		"gets options from the config file.");


	STARTDECL(blt_refresh) ()
	{
		terminal_refresh();
		return Value();
	}
	ENDDECL0(blt_refresh, "", "", "",
		"refreshes the display.");

	STARTDECL(blt_clear) ()
	{
		terminal_clear();
		return Value();
	}
	ENDDECL0(blt_clear, "", "", "",
		"clears all layers of the terminal, filling with the current background color.");

	STARTDECL(blt_clear_area) (Value& x, Value& y, Value& w, Value& h)
	{
		terminal_clear_area(x.ival, y.ival, w.ival, h.ival);
		return Value();
	}
	ENDDECL4(blt_clear_area, "x,y,w,h", "IIII", "",
		"closes the terminal.");

	STARTDECL(blt_crop) (Value& x, Value& y, Value& w, Value& h)
	{
		terminal_crop(x.ival, y.ival, w.ival, h.ival);
		return Value();
	}
	ENDDECL4(blt_crop, "x,y,w,h", "IIII", "",
		"closes the terminal.");

	STARTDECL(blt_layer) (Value& layer)
	{
		terminal_layer(layer.ival);
		return Value();
	}
	ENDDECL1(blt_layer, "layer", "I", "",
		"selects the current layer to draw upon.");


	STARTDECL(blt_color) (Value& rgba)
	{
		uint32_t clr = 0xff000000u;
		switch (rgba.vval->len)
		{
		case 3:
		{
			clr |= (((int)(rgba.vval->at(0).fval * 255)) & 255) << 16;
			clr |= (((int)(rgba.vval->at(1).fval * 255)) & 255) << 8;
			clr |= (((int)(rgba.vval->at(2).fval * 255)) & 255);
		}
		break;
		case 4:
		{
			clr = (((int)(rgba.vval->at(3).fval * 255)) & 255) << 24;

			clr |= (((int)(rgba.vval->at(0).fval * 255)) & 255) << 16;
			clr |= (((int)(rgba.vval->at(1).fval * 255)) & 255) << 8;
			clr |= (((int)(rgba.vval->at(2).fval * 255)) & 255);
		}
		break;
		default:
			break;
		}
		rgba.DECRT();
		terminal_color(clr);
		return Value();
	}
	ENDDECL1(blt_color, "rgba", "V", "",
		"sets the foreground color with a 3-element rgb vector of floats or a 4-element argb vector of floats.");

	STARTDECL(blt_bkcolor) (Value& rgba)
	{
		uint32_t clr = 0xff000000u;
		switch (rgba.vval->len)
		{
		case 3:
		{
			clr |= (((int)(rgba.vval->at(0).fval * 255)) & 255) << 16;
			clr |= (((int)(rgba.vval->at(1).fval * 255)) & 255) << 8;
			clr |= (((int)(rgba.vval->at(2).fval * 255)) & 255);
		}
		break;
		case 4:
		{
			clr  = (((int)(rgba.vval->at(3).fval * 255)) & 255) << 24;

			clr |= (((int)(rgba.vval->at(0).fval * 255)) & 255) << 16;
			clr |= (((int)(rgba.vval->at(1).fval * 255)) & 255) << 8;
			clr |= (((int)(rgba.vval->at(2).fval * 255)) & 255);
		}
		break;
		default:
			break;
		}
		rgba.DECRT();
		terminal_bkcolor(clr);
		return Value();
	}
	ENDDECL1(blt_bkcolor, "rgba", "V", "",
		"sets the background color with a 3-element rgb vector of floats or a 4-element rgba vector of floats.");

	STARTDECL(blt_composition) (Value& mode)
	{
		terminal_composition(mode.ival);
		return Value();
	}
	ENDDECL1(blt_composition, "mode", "I", "",
		"selects the current same-cell composition mode.");

	STARTDECL(blt_put) (Value& x, Value& y, Value& code)
	{
		terminal_put(x.ival, y.ival, code.ival);
		return Value();
	}
	ENDDECL3(blt_put, "x,y,code", "III", "",
		"puts a character with a given code at the specified x and y coordinates.");

	STARTDECL(blt_put_ext) (Value& x, Value& y, Value& dx, Value& dy, Value& code)
	{
		terminal_put_ext(x.ival, y.ival, dx.ival, dy.ival, code.ival);
		return Value();
	}
	ENDDECL5(blt_put_ext, "x,y,dx,dy,code", "IIIII", "",
		"puts a character with a given code at the specified x and y coordinates, with a difference in x and y position of dx and dy pixels.");


	STARTDECL(blt_pick) (Value& x, Value& y, Value& index)
	{
		return terminal_pick(x.ival, y.ival, index.ival);
	}
	ENDDECL3(blt_pick, "x,y,code", "III", "I",
		"finds what character is drawn in the current layer at the specified x and y coordinates, and at the specified index within that cell (0 if composition is disabled).");

	STARTDECL(blt_pick_color) (Value& x, Value& y, Value& index)
	{
		color_t clr = terminal_pick_color(x.ival, y.ival, index.ival);
		auto v = g_vm->NewVector(4, V_VECTOR);
		for (int i = 16; i >= 0; i -= 8)
		{
			v->push(Value(((clr >> i) & 255) / 255.0f));
		}
		v->push(Value(((clr >> 24) & 255) / 255.0f));
		return Value(v);
	}
	ENDDECL3(blt_pick_color, "x,y,code", "III", "F]",
		"finds what color is used (returns rgba as a 4-element float vector) for the foreground in the current layer at the specified x and y coordinates, and at the specified index within that cell (0 if composition is disabled).");

	STARTDECL(blt_pick_bkcolor) (Value& x, Value& y)
	{
		color_t clr = terminal_pick_bkcolor(x.ival, y.ival);
		auto v = g_vm->NewVector(4, V_VECTOR);
		for (int i = 16; i >= 0; i -= 8)
		{
			v->push(Value(((clr >> i) & 255) / 255.0f));
		}
		v->push(Value(((clr >> 24) & 255) / 255.0f));
		return Value(v);
	}
	ENDDECL2(blt_pick_bkcolor, "x,y", "II", "F]",
		"finds what color is drawn for the background at the specified x and y coordinates.");

	STARTDECL(blt_print) (Value& x, Value& y, Value &s)
	{
		s.DECRT();
		return Value(terminal_print8(x.ival, y.ival, (int8_t*)(s.sval->str())));
	}
	ENDDECL3(blt_print, "x,y,s", "IIS", "I",
		"prints a string at the given x and y coordinates.");

	STARTDECL(blt_measure) (Value &s)
	{
		s.DECRT();
		return Value(terminal_measure8((int8_t*)(s.sval->str())));
	}
	ENDDECL1(blt_measure, "s", "S", "I",
		"measures the width in pixels (or something) of a string.");

	STARTDECL(blt_has_input) ()
	{
		return Value(terminal_has_input());
	}
	ENDDECL0(blt_has_input, "", "", "I",
		"returns logical true if a call to blt_read will have input available to it, avoiding a blockage.");

	STARTDECL(blt_state) (Value& code)
	{
		return Value(terminal_state(code.ival));
	}
	ENDDECL1(blt_state, "code", "I", "I",
		"returns an aspect of the current input state, specified by a code (usually, you should use a predefined constant).");

	STARTDECL(blt_read) ()
	{
		return Value(terminal_read());
	}
	ENDDECL0(blt_read, "", "", "I",
		"returns the current input code if there is one, otherwise blocks(!) until some input is received.");

	STARTDECL(blt_read_str) (Value& x, Value& y, Value& max)
	{
		auto buf = new char[max.ival];
		memset(buf, 0, max.ival);
		auto r = terminal_read_str(x.ival, y.ival, buf, max.ival);
		g_vm->Push(Value(g_vm->NewString(buf, r)));
		delete[] buf;
		return Value(r);
	}
	ENDDECL3(blt_read_str, "x,y,max", "III", "SI",
	"This function does a simple blocking read of a string without any parsing. User input is displayed at specified coordinates "
		"and also limited to specified length so it can be used in game interface. The function displays user input within current "
		"layer and restores the scene before return. It is an application's responsibility to keep the result on screen. "
		"It returns a string and the length of that string, without the enter key that terminates it. IF INPUT WAS CANCELLED, THE "
		"STRING WILL BE ENTIRELY FILLED TO THE LENGTH GIVEN BY max WITH THE CHARACTER THAT HAS CODEPOINT 0.");

	STARTDECL(blt_peek) ()
	{
		return Value(terminal_peek());
	}
	ENDDECL0(blt_peek, "", "", "I",
		"peeks at input without blocking or consuming the input.");

	STARTDECL(blt_delay) (Value& period)
	{
		terminal_delay(period.ival);
		return Value();
	}
	ENDDECL1(blt_delay, "code", "I", "",
		"suspends the program for a number of milliseconds given by period.");


	STARTDECL(blt_color_from_name) (Value& name)
	{
		color_t clr = color_from_name8((int8_t*)(name.sval->str()));
		auto v = g_vm->NewVector(4, V_VECTOR);
		for (int i = 16; i >= 0; i -= 8)
		{
			v->push(Value(((clr >> i) & 255) / 255.0f));
		}
		v->push(Value(((clr >> 24) & 255) / 255.0f));
		return Value(v);
	}
	ENDDECL1(blt_color_from_name, "name", "S", "F]",
		"get a color by name, with similar names to libtcod's hue-and-brightness style.");

}

AutoRegister __ablt("blt", AddBLTOps);
