#!/usr/bin/env ruby
# coding: utf-8
require 'nkf'

class Pokebell
  def initialize(str)
    @str = str.gsub(/\\/, "")
    @pokebell = pick_hankaku_code(zenkaku2hankaku(@str)).map{ |code| encode(code) }.join
  end
  
  attr_reader :pokebell, :str
  alias :to_a :str
  
  private
  def zenkaku2hankaku(str)
    NKF.nkf('-j -Z4', NKF.nkf('-w -h2', str))
  end
  
  def escape_char?(char)
    char.unpack("C") == "\e".unpack("C")
  end
  
  def detect_char_encoding(char_ary_after_escape_char)
    if unescape?(char_ary_after_escape_char)
      :ascii
    elsif escape_to_hankaku?(char_ary_after_escape_char)
      :hankaku
    elsif escape_to_jis?(char_ary_after_escape_char)
      :jis
    else
      raise "escape error"
    end
  end
  
  def jis_char(char, jis_array)
    second_char = jis_array.shift
    if char.unpack("C") == "\x21".unpack("C")
      case second_char.unpack("C")
      when "\x6F".unpack("C") # ￥
        92
      when "\x21".unpack("C") # 全角スペース
        32
      else
        raise "out of aiming JIS charactor area"
      end
    else
      raise "out of aiming JIS charactor area"
    end
  end
  
  def pick_hankaku_code(jis_str)
    char_status = :ascii
    code_array = []
    jis_array = jis_str.each_char.map { |char| char }
    loop do
      char = jis_array.shift
      break unless char
      
      if escape_char?(char)
        char_ary_after_escape_char = jis_array.shift(2)
        char_status = detect_char_encoding(char_ary_after_escape_char)
      else
        code = case char_status
        when :ascii
          char.unpack("C").first
        when :hankaku
          char.unpack("C").first + 128
        when :jis
          jis_char(char, jis_array)
        end
        code_array << code
      end
    end
    code_array
  end
  
  def char_check(array, check_array)
    array.each_with_index.all? { |char, i|char.unpack("C") == check_array[i].unpack("C") }
  end
  
  def escape_to_hankaku?(char_ary_after_escape_char)
    char_check(char_ary_after_escape_char, ["\x28", "\x49"])
  end
  
  def escape_to_jis?(char_ary_after_escape_char)
    char_check(char_ary_after_escape_char, ["\x24", "\x42"])
  end
  
  def unescape?(char_ary_after_escape_char)
    char_check(char_ary_after_escape_char, ["\x28", "\x42"])
  end
  
  def digit(code, base, first_digit_base, second_digit_base)
    second_digit, first_digit = (code - base).divmod(5)
    "#{(second_digit + first_digit_base) % 10}#{(first_digit + second_digit_base) % 10}"
  end
  
  def encode(code)
    code2pokebell_hash = {
      63 => "67", # ？
      33 => "68", # ！
      45 => "69", # −
      304 => "69", # ー
      47 => "60", # ／
      92 => "76", # ￥
      38 => "77", # ＆
      40 => "82", # （
      41 => "84", # ）
      42 => "86", # ＊
      35 => "87", # ＃
      32 => "88", # 全角スペース
      350 => "04", # ゛
      351 => "05", # ゜
    }

    case code
    when 167..171 # ぁ-ぉ
      code = code + 10
    when 172..174 # ゃ-ょ
      code = code + 40
    when 175 # っ
      code = code + 19
    when 97..122 # a-z
      code = code - 32
    end
    
    case code
    when 177..211 # あ-も
      digit(code, 177, 1, 1)
    when 215..220 # ら-わ
      digit(code, 215, 9, 1)
    when 221..223 # ん゛゜
      digit(code, 220, 0, 2)
    when 212..214 # や-よ
      second_digit, first_digit = (code - 212).divmod(3)
      "#{(second_digit + 8) % 10}#{first_digit * 2 + 1}"
    when 65..90 # A-Z
      digit(code, 65, 1, 6)
    when 49..57 # 1-9
      digit(code, 49, 9, 6)
    when 48 # 0
      "00"
    when *code2pokebell_hash.keys
      code2pokebell_hash[code]
    else
      raise "out of aiming charactor area"
    end
  end
end
