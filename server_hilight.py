# -*- coding: utf-8 -*-
#
# Copyright (c) 2019 by ToxicFrog <toxicfrog@ancilla.ca>
#
# Hilight channel buffers in the buflist based on the highest hilight value of
# their associated channels.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

try:
    import weechat,re

except Exception:
    print("This script must be run under WeeChat.")
    print("Get WeeChat now at: http://www.weechat.org/")
    quit()

SCRIPT_NAME     = "server_hilight"
SCRIPT_AUTHOR   = "toxicfrog <toxicfrog@ancilla.ca>"
SCRIPT_VERSION  = "0.1"
SCRIPT_LICENSE  = "GPL"
SCRIPT_DESC     = "hilight server buffers based on channel hilight status"

def colour_code(key):
    return weechat.string_eval_expression(
        weechat.config_string(weechat.config_get(key)),
        None, None, None)

levels = {
    -1: 'none',
    0: 'low',
    1: 'message',
    2: 'private',
    3: 'highlight'
}

colours = {}
def init_colours():
    for key in levels:
        colours[key] = colour_code('buflist.format.hotlist_' + levels[key])

server_priorities = {}
def refresh_server_priorities():
    global server_priorities
    server_priorities = {}
    hotlist = weechat.infolist_get('hotlist', '', '')
    while weechat.infolist_next(hotlist):
        buffer = weechat.infolist_pointer(hotlist, 'buffer_pointer')
        if 'server' == weechat.buffer_get_string(buffer, 'localvar_type'):
            continue
        server = weechat.buffer_get_string(buffer, 'localvar_server')
        server_priorities[server] = max(
            server_priorities.get(server, -1), weechat.infolist_integer(hotlist, 'priority'))

timer_hook = None
def refresh_server_timer_cb(unused1, unused2):
    global timer_hook
    timer_hook = None
    refresh_server_priorities()
    return weechat.WEECHAT_RC_OK

def on_hotlist_changed(buffer, signal, data):
    global timer_hook
    if timer_hook:
        weechat.unhook(timer_hook)
    timer_hook = weechat.hook_timer(1000, False, 1, 'refresh_server_timer_cb', '')
    return weechat.WEECHAT_RC_OK

def info_hotlist(pointer, name, arg):
    server_buffer = weechat.buffer_search('==', arg)
    # weechat.prnt("", "server: " + arg + " -> " + server_buffer)
    if not server_buffer:
        return 'ERROR'
    server = weechat.buffer_get_string(server_buffer, 'localvar_server')
    return colours[server_priorities.get(server, -1)]

if __name__ == "__main__":
    global version
    if weechat.register(SCRIPT_NAME, SCRIPT_AUTHOR, SCRIPT_VERSION, SCRIPT_LICENSE, SCRIPT_DESC, '', ''):
        init_colours()
        refresh_server_priorities()
        weechat.hook_signal('hotlist_changed', 'on_hotlist_changed', '')
        weechat.hook_info(
            'server_hotlist_color',
            'colour of the hottest channel in this server',
            'fully qualified server name',
            'info_hotlist',
            '')
