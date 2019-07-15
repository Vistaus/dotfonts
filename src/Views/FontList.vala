/*
 *         _____
 *  ______ ___(_)______ ____________________________  ______  __
 *  _  __ `/_  /__  __ `__ \__  __ \_  ___/  __ \_  |/_/_  / / /
 *  / /_/ /_  / _  / / / / /_  /_/ /  /   / /_/ /_>  < _  /_/ /
 *  \__,_/ /_/  /_/ /_/ /_/_  .___//_/    \____//_/|_| _\__, /
 *                         /_/                         /____/
 *
 *                                                 Version 0.1.0
 *
 *           Micael Dias (@aimproxy) <diasmicaelandre@gmail.com>
 *
 *  ============================================================
 *
 *  Copyright (C) [2019] [Micael DIAS (@aimproxy)]
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *  ============================================================
 *
 */

using App.Services;
using App.Widgets;

namespace App.Views {
    public class FontList : Gtk.Paned {
        private Gtk.ListBox listbox;
        private Gapi gapi;

        public FontList () {
            Object (
                orientation: Gtk.Orientation.HORIZONTAL,
                position: 256
            );
        }

        construct {
            gapi = Gapi.get_instance();

            var font_view = new FontView ();

            listbox = new Gtk.ListBox ();
            listbox.activate_on_single_click = true;
            listbox.selection_mode = Gtk.SelectionMode.SINGLE;

            var scrolled_window = new Gtk.ScrolledWindow (null, null);
            scrolled_window.hscrollbar_policy = Gtk.PolicyType.NEVER;
            scrolled_window.vexpand = true;
            scrolled_window.add (listbox);

            pack1 (scrolled_window, true, false);
            pack2 (font_view, true, false);

            try {
                gapi.load_trending ();
            } catch (Error e) {
                warning ("Error getting fonts: %s", e.message);
            }

            gapi.request_page_success.connect((fonts) => {
                foreach (var font in fonts) {
                    listbox.add ( new FontListRow (font.family, font.category, font.variants));
                }

                listbox.show_all ();
            });


            listbox.row_selected.connect ((row) => {
                font_view.family = ((FontListRow) row).font_family;
                font_view.category = ((FontListRow) row).font_category;
                font_view.variants = ((FontListRow) row).font_variants;
            });

        }

    }

}
