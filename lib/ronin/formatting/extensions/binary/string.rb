#
# Copyright (c) 2006-2012 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/formatting/extensions/binary/base64'
require 'ronin/formatting/extensions/binary/integer'
require 'ronin/formatting/extensions/text'
require 'ronin/binary/hexdump/parser'
require 'ronin/binary/template'

begin
  require 'zlib'
rescue Gem::LoadError => e
  raise(e)
rescue ::LoadError
end

class String

  alias unpack_original unpack

  #
  # Unpacks the String.
  #
  # @param [String, Array<Symbol>] arguments
  #   The `String#unpack` template or a list of {Ronin::Binary::Template} types.
  #
  # @param [Integer] address_length
  #   The number of bytes to depack.
  #
  # @return [Array]
  #   The values unpacked from the String.
  #
  # @raise [ArgumentError]
  #   The arguments were not a String or a list of Symbols.
  #
  # @example using {Ronin::Binary::Template} types:
  #   "A\0\0\0hello\0".unpack(:uint32_le, :string)
  #   # => [10, "hello"]
  #
  # @example using a `String#unpack` template:
  #   "A\0\0\0".unpack('V')
  #   # => 65
  #
  # @see http://rubydoc.info/stdlib/core/String:unpack
  #
  # @since 0.5.0
  #
  # @api public
  #
  def unpack(*arguments)
    case arguments[0]
    when String
      unpack_original(arguments[0])
    when Symbol
      unpack_original(Ronin::Binary::Template.compile(arguments))
    else
      raise(ArgumentError,"first argument to String#unpack must be a String or Symbol")
    end
  end

  #
  # Unpacks the String into an Integer.
  #
  # @param [Ronin::Arch, #endian, #address_length, String] arch
  #   The architecture that the Integer was originally packed with.
  #
  # @param [Integer] address_length
  #   The number of bytes to depack.
  #
  # @return [Integer]
  #   The depacked Integer.
  #
  # @raise [ArgumentError]
  #   The given `arch` does not respond to the `endian` or `address_length`
  #   methods.
  #
  # @example using archs other than `Ronin::Arch`:
  #   arch = OpenStruct.new(:endian => :little, :address_length => 4)
  #   
  #   "A\0\0\0".depack(arch)
  #   # => 65
  #
  # @example using a `Ronin::Arch` arch:
  #   "A\0\0\0".depack(Arch.i386)
  #   # => 65
  #
  # @example specifying a custom address-length:
  #   "A\0".depack(Arch.ppc,2)
  #   # => 65
  #
  # @example using a `String#unpack` template:
  #   "A\0\0\0".depack('V')
  #   # => 65
  #
  # @deprecated
  #   Deprecated as of 0.5.0, use {#unpack} instead.
  #
  # @api public
  #   
  def depack(arch,address_length=nil)
    if arch.kind_of?(String)
      return unpack(arch)
    end

    unless arch.respond_to?(:address_length)
      raise(ArgumentError,"first argument to Ineger#pack must respond to address_length")
    end

    unless arch.respond_to?(:endian)
      raise(ArgumentError,"first argument to Ineger#pack must respond to endian")
    end

    endian           = arch.endian.to_sym
    address_length ||= arch.address_length

    integer    = 0x0
    byte_index = 0

    case endian
    when :little
      mask = lambda { |b| b << (byte_index * 8) }
    when :big
      mask = lambda { |b|
        b << ((address_length - byte_index - 1) * 8)
      }
    else
      raise(ArgumentError,"invalid endian #{arch.endian.inspect}")
    end

    each_byte do |b|
      break if byte_index >= address_length

      integer |= mask.call(b)
      byte_index += 1
    end

    return integer
  end

  #
  # Hex-escapes characters in the String.
  #
  # @return [String]
  #   The hex escaped version of the String.
  #
  # @example
  #   "hello".hex_escape
  #   # => "\\x68\\x65\\x6c\\x6c\\x6f"
  #
  # @see String#format_bytes
  #
  # @api public
  #
  def hex_escape(options={})
    format_bytes(options) { |b| b.hex_escape }
  end

  # Common escaped characters.
  UNESCAPE_CHARS = Hash.new do |hash,char|
    if char[0,1] == '\\'
      char[1,1]
    else
      char
    end
  end
  UNESCAPE_CHARS['\0'] = "\0"
  UNESCAPE_CHARS['\a'] = "\a"
  UNESCAPE_CHARS['\b'] = "\b"
  UNESCAPE_CHARS['\t'] = "\t"
  UNESCAPE_CHARS['\n'] = "\n"
  UNESCAPE_CHARS['\v'] = "\v"
  UNESCAPE_CHARS['\f'] = "\f"
  UNESCAPE_CHARS['\r'] = "\r"

  #
  # Unescapes the hex-escaped String.
  #
  # @return [String]
  #   The unescaped version of the hex escaped String.
  #
  # @example
  #   "\\x68\\x65\\x6c\\x6c\\x6f".hex_unescape
  #   # => "hello"
  #
  # @api public
  #
  def hex_unescape
    buffer = ''
    hex_index = 0
    hex_length = length

    while (hex_index < hex_length)
      hex_substring = self[hex_index..-1]

      if hex_substring =~ /^\\[0-7]{3}/
        buffer << hex_substring[0,4].to_i(8)
        hex_index += 3
      elsif hex_substring =~ /^\\x[0-9a-fA-F]{1,2}/
        hex_substring[2..-1].scan(/^[0-9a-fA-F]{1,2}/) do |hex_byte|
          buffer << hex_byte.to_i(16)
          hex_index += (2 + hex_byte.length)
        end
      elsif hex_substring =~ /^\\./
        buffer << UNESCAPE_CHARS[hex_substring[0,2]]
        hex_index += 2
      else
        buffer << hex_substring[0,1]
        hex_index += 1
      end
    end

    return buffer
  end

  #
  # XOR encodes the String.
  #
  # @param [Enumerable, Integer] key
  #   The byte to XOR against each byte in the String.
  #
  # @return [String]
  #   The XOR encoded String.
  #
  # @example
  #   "hello".xor(0x41)
  #   # => ")$--."
  #
  # @example
  #   "hello again".xor([0x55, 0x41, 0xe1])
  #   # => "=$\x8d9.\xc14&\x80</"
  #
  # @api public
  #
  def xor(key)
    key = case key
          when Integer
            [key]
          when String
            key.bytes
          else
            key
          end

    key    = key.cycle
    result = ''

    bytes.each do |b|
      result << (b ^ key.next).chr
    end

    return result
  end

  #
  # Base64 encodes a string.
  #
  # @param [Symbol, nil] mode
  #   The base64 mode to use. May be either:
  #
  #   * `:normal`
  #   * `:strict`
  #   * `:url` / `:urlsafe`
  #
  # @return [String]
  #   The base64 encoded form of the string.
  #
  # @example
  #   "hello".base64_encode
  #   # => "aGVsbG8=\n"
  #
  # @api public
  #
  def base64_encode(mode=nil)
    case mode
    when :strict
      Base64.strict_encode64(self)
    when :url, :urlsafe
      Base64.urlsafe_encode64(self)
    else
      Base64.encode64(self)
    end
  end

  #
  # Base64 decodes a string.
  #
  # @param [Symbol, nil] mode
  #   The base64 mode to use. May be either:
  #
  #   * `nil`
  #   * `:strict`
  #   * `:url` / `:urlsafe`
  #
  # @return [String]
  #   The base64 decoded form of the string.
  #
  # @note
  #   `mode` argument is only available on Ruby >= 1.9.
  #
  # @example
  #   "aGVsbG8=\n".base64_decode
  #   # => "hello"
  #
  # @api public
  #
  def base64_decode(mode=nil)
    case mode
    when :strict
      Base64.strict_decode64(self)
    when :url, :urlsafe
      Base64.urlsafe_decode64(self)
    else
      Base64.decode64(self)
    end
  end

  #
  # Zlib inflate a string.
  #
  # @return [String]
  #   The Zlib inflated form of the string.
  #
  # @example
  #   "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15".zlib_inflate
  #   # => "hello"
  #
  # @api public
  #
  def zlib_inflate
    Zlib::Inflate.inflate(self)
  end

  #
  # Zlib deflate a string.
  #
  # @return [String]
  #   The Zlib deflated form of the string.
  #
  # @example
  #   "hello".zlib_deflate
  #   # => "x\x9C\xCBH\xCD\xC9\xC9\a\x00\x06,\x02\x15"
  #
  # @api public
  #
  def zlib_deflate
    Zlib::Deflate.deflate(self)
  end

  #
  # Converts a multitude of hexdump formats back into raw-data.
  #
  # @param [Hash] options
  #   Additional options.
  #
  # @option options [Symbol] :format
  #   The expected format of the hexdump. Must be either `:od` or
  #   `:hexdump`.
  #
  # @option options [Symbol] :encoding
  #   Denotes the encoding used for the bytes within the hexdump.
  #   Must be one of the following:
  #
  #   * `:binary`
  #   * `:octal`
  #   * `:octal_bytes`
  #   * `:octal_shorts`
  #   * `:octal_ints`
  #   * `:octal_quads` (Ruby 1.9 only)
  #   * `:decimal`
  #   * `:decimal_bytes`
  #   * `:decimal_shorts`
  #   * `:decimal_ints`
  #   * `:decimal_quads` (Ruby 1.9 only)
  #   * `:hex`
  #   * `:hex_chars`
  #   * `:hex_bytes`
  #   * `:hex_shorts`
  #   * `:hex_ints`
  #   * `:hex_quads`
  #   * `:named_chars` (Ruby 1.9 only)
  #   * `:floats`
  #   * `:doubles`
  #
  # @option options [:little, :big, :network] :endian (:little)
  #   The endianness of the words.
  #
  # @option options [Integer] :segment (16)
  #   The length in bytes of each segment in the hexdump.
  #
  # @return [String]
  #   The raw-data from the hexdump.
  #
  # @api public
  #
  def unhexdump(options={})
    Ronin::Binary::Hexdump::Parser.new(options).parse(self)
  end

end
