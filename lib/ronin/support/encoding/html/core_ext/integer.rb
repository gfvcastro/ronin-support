#
# Copyright (c) 2006-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-support.
#
# ronin-support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-support.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/support/encoding/xml/core_ext/integer'
require 'ronin/support/encoding/js/core_ext/integer'

require 'cgi'

class Integer

  #
  # Escapes the Integer as an HTML String.
  #
  # @return [String]
  #   The escaped HTML String.
  #
  # @example
  #   0x26.html_escape
  #   # => "&amp;"
  #
  # @since 0.2.0
  #
  # @see #xml_escape
  #
  # @api public
  #
  def html_escape
    xml_escape
  end

  #
  # Formats the Integer as a HTML String.
  #
  # @return [String]
  #   The HTML String.
  #
  # @example
  #   0x41.format_html
  #   # => "&#65;"
  #
  # @since 0.2.0
  #
  # @see #xml_encode
  #
  # @api public
  #
  def html_encode
    xml_encode
  end

end
