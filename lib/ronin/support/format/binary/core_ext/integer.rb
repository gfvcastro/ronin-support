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

require 'ronin/support/binary/core_ext/integer'

class Integer

  #
  # Converts the integer into hex format.
  #
  # @return [String]
  #   The hex encoded version of the Integer.
  #
  # @example
  #   0x41.hex_encode
  #   # => "41"
  #
  # @since 0.6.0
  #
  def hex_encode
    "%.2x" % self
  end

  alias to_hex hex_encode

  #
  # Converts the integer into an escaped hex character.
  #
  # @return [String]
  #   The hex escaped version of the Integer.
  #
  # @example
  #   42.hex_char
  #   # => "\\x2a"
  #
  # @api public
  #
  def hex_escape
    "\\x%.2x" % self
  end

  alias hex_char hex_escape

  #
  # Encodes the number as a `0xXX` hex integer.
  #
  # @return [String]
  #   The hex encoded integer.
  #
  # @example
  #   42.hex_int
  #   # => "0x2e"
  #
  def hex_int
    "0x%.2x" % self
  end

  alias char chr

end
