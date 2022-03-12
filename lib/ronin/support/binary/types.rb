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

require 'ronin/support/binary/types/native'
require 'ronin/support/binary/types/little_endian'
require 'ronin/support/binary/types/big_endian'
require 'ronin/support/binary/types/network'

module Ronin
  module Support
    module Binary
      module Types
        # All types (native, little-endian, big-endian, and network byte-order).
        TYPES = {
          int8:  Native::Int8,
          int16: Native::Int16,
          int32: Native::Int32,
          int64: Native::Int64,

          short:     Native::Int16,
          int:       Native::Int32,
          long:      Native::Int32,
          long_long: Native::Int64,

          uint8:  Native::UInt8,
          uint16: Native::UInt16,
          uint32: Native::UInt32,
          uint64: Native::UInt64,

          byte:       Native::UInt8,
          ushort:     Native::UInt16,
          uint:       Native::UInt32,
          ulong:      Native::UInt32,
          ulong_long: Native::UInt64,

          char:  Native::Char,
          uchar: Native::UChar,

          cstring: Native::CString,
          string:  Native::CString,

          float32: Native::Float32,
          float64: Native::Float64,

          float:   Native::Float32,
          double:  Native::Float64,

          # little-endian types
          int16_le: LittleEndian::Int16,
          int32_le: LittleEndian::Int32,
          int64_le: LittleEndian::Int64,

          short_le:     LittleEndian::Int16,
          int_le:       LittleEndian::Int32,
          long_le:      LittleEndian::Int32,
          long_long_le: LittleEndian::Int64,

          uint16_le: LittleEndian::UInt16,
          uint32_le: LittleEndian::UInt32,
          uint64_le: LittleEndian::UInt64,

          ushort_le:     LittleEndian::UInt16,
          uint_le:       LittleEndian::UInt32,
          ulong_le:      LittleEndian::UInt32,
          ulong_long_le: LittleEndian::UInt64,

          float32_le: LittleEndian::Float32,
          float64_le: LittleEndian::Float64,

          float_le:   LittleEndian::Float32,
          double_le:  LittleEndian::Float64,

          # big-endian types
          int16_be: BigEndian::Int16,
          int32_be: BigEndian::Int32,
          int64_be: BigEndian::Int64,

          short_be:     BigEndian::Int16,
          int_be:       BigEndian::Int32,
          long_be:      BigEndian::Int32,
          long_long_be: BigEndian::Int64,

          uint16_be: BigEndian::UInt16,
          uint32_be: BigEndian::UInt32,
          uint64_be: BigEndian::UInt64,

          ushort_be:     BigEndian::UInt16,
          uint_be:       BigEndian::UInt32,
          ulong_be:      BigEndian::UInt32,
          ulong_long_be: BigEndian::UInt64,

          float32_be: BigEndian::Float32,
          float64_be: BigEndian::Float64,

          float_be:   BigEndian::Float32,
          double_be:  BigEndian::Float64,

          # network byte-order types
          int16_ne: Network::Int16,
          int32_ne: Network::Int32,
          int64_ne: Network::Int64,

          short_ne:     Network::Int16,
          int_ne:       Network::Int32,
          long_ne:      Network::Int32,
          long_long_ne: Network::Int64,

          uint16_ne: Network::UInt16,
          uint32_ne: Network::UInt32,
          uint64_ne: Network::UInt64,

          ushort_ne:     Network::UInt16,
          uint_ne:       Network::UInt32,
          ulong_ne:      Network::UInt32,
          ulong_long_ne: Network::UInt64,

          float32_ne: Network::Float32,
          float64_ne: Network::Float64,

          float_ne:   Network::Float32,
          double_ne:  Network::Float64
        }

        #
        # Fetches the type from {TYPES}.
        #
        # @param [Symbol] name
        #   The type name to lookup.
        #
        # @return [Type]
        #   The type object from {TYPES}.
        #
        # @raise [ArgumentError]
        #   The type name was unknown.
        #
        def self.[](name)
          TYPES.fetch(name) do
            raise(ArgumentError,"unknown type: #{name.inspect}")
          end
        end
      end
    end
  end
end
