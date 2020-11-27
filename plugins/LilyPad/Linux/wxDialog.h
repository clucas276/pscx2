/*  LilyPad - Pad plugin for PS2 Emulator
 *  Copyright (C) 2002-2020  PCSX2 Dev Team/ChickenLiver
 *
 *  PCSX2 is free software: you can redistribute it and/or modify it under the
 *  terms of the GNU Lesser General Public License as published by the Free
 *  Software Found- ation, either version 3 of the License, or (at your option)
 *  any later version.
 *
 *  PCSX2 is distributed in the hope that it will be useful, but WITHOUT ANY
 *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 *  details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with PCSX2.  If not, see <http://www.gnu.org/licenses/>.
 */

#pragma once

#include <wx/wx.h>
#include <wx/notebook.h>

class GeneralTab : public wxPanel
{
public:

	GeneralTab(wxWindow* parent);
	void Update();
	void CallUpdate(wxCommandEvent& event);
};

class PadTab : public wxPanel
{
public:

	PadTab(wxWindow* parent, unsigned int port, unsigned int slot);
	void Update();
	void CallUpdate(wxCommandEvent& event);
};

class Dialog : public wxDialog
{
private:
	wxBoxSizer* m_top_box;

public:
	Dialog();
	~Dialog();
	void Update();
	void CallUpdate(wxCommandEvent& event);
};
