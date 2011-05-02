#
# Copyright (c) 2006-2011 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of Ronin Support.
#
# Ronin Support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ronin Support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Ronin Support.  If not, see <http://www.gnu.org/licenses/>.
#

require 'cgi/util'

class Integer

  # Special JavaScript bytes and their escaped Strings.
  JS_ESCAPE_BYTES = {
    0x00 => '%u0000',
    0x01 => '%u0001',
    0x02 => '%u0002',
    0x03 => '%u0003',
    0x04 => '%u0004',
    0x05 => '%u0005',
    0x06 => '%u0006',
    0x07 => '%u0007',
    0x08 =>  '\b',
    0x09 =>  '\t',
    0x0a =>  '\n',
    0x0b => '%u000b',
    0x0c =>  '\f',
    0x0d =>  '\r',
    0x0e => '%u000e',
    0x0f => '%u000f',
    0x10 => '%u0010',
    0x11 => '%u0011',
    0x12 => '%u0012',
    0x13 => '%u0013',
    0x14 => '%u0014',
    0x15 => '%u0015',
    0x16 => '%u0016',
    0x17 => '%u0017',
    0x18 => '%u0018',
    0x19 => '%u0019',
    0x1a => '%u001a',
    0x1b => '%u001b',
    0x1c => '%u001c',
    0x1d => '%u001d',
    0x1e => '%u001e',
    0x1f => '%u001f',
    0x22 =>  '\"',
    0x5c =>  '\\\\',
  }

  #
  # Escapes the Integer as an HTML String.
  #
  # @return [String]
  #   The escaped HTML String.
  #
  # @since 0.2.0
  #
  # @api public
  #
  def html_escape
    CGI.escapeHTML(self.chr)
  end

  #
  # Formats the Integer as a HTML String.
  #
  # @return [String]
  #   The HTML String.
  #
  # @since 0.2.0
  #
  # @api public
  #
  def format_html
    "&#%d;" % self
  end

  #
  # Escapes the Integer as a JavaScript String.
  #
  # @return [String]
  #   The escaped JavaScript String.
  #
  # @since 0.2.0
  #
  # @api public
  #
  def js_escape
    JS_ESCAPE_BYTES[self] || format_js
  end

  #
  # Formats the Integer as a JavaScript escaped String.
  #
  # @return [String]
  #   The escaped JavaScript String.
  #
  # @since 0.2.0
  #
  # @api public
  #
  def format_js
    if self > 0xff
      "%%u%.2X%.2X" % [(self & 0xff00) >> 8, (self & 0xff)]
    else
      "%%%.2X" % self
    end
  end

end
