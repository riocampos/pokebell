#!/usr/bin/env ruby
# coding: utf-8

require 'moji'

require 'nkf'

class Pokebell
  # Set message and make Pokebell codes.
  # @param str [String] message (contains Hiragana / Katakana / alphabet / digit)
  # @return [Pokebell]
  def initialize(str)
    @str = Moji.han_to_zen(hiragana2katakana(str.upcase.gsub(/\\/, "")))
    @pokebell = pick_hankaku_code(zenkaku2hankaku(@str)).map{ |code| encode(code) }.join
  end
  
  # Set Pokebell code and make message string.
  # @param num [String] Pokebell code (length must be even)
  # @raise [ArgumentError] if param does not makes digit or its length is not even
  # @return [Pokebell]
  # @since 0.1.0
  def self.number(num)
    num_str = num.to_s
    unless num_str == num_str[/(\d\d)+/]
      raise ArgumentError, "wrong digit length (must be even digits)"
    end
    two_digits_array = num_str.scan(/\d\d/)
    str_array_with_daku_handaku = make_str_array(two_digits_array)
    str_array = []
    loop do
      follow_char = nil
      char = str_array_with_daku_handaku.shift
      break unless char
      follow_char_test = str_array_with_daku_handaku.first
      unless follow_char_test
        str_array << char
        break
      end
      if follow_char_test[/[゛゜]/]
        follow_char = str_array_with_daku_handaku.shift 
        char = merge_daku_handaku(char, follow_char)
      end
      str_array << char
    end
    str = str_array.join
    Pokebell.new(str)
  end
  
  # @return [String] 
  # @since 0.1.0
  def inspect
    %[#<str="#{@str}", pokebell="#{@pokebell}">]
  end
  
  # @!method pokebell
  # @return [String] Pokebell codes (2-digit string)
  attr_reader :pokebell
  alias :code :pokebell
  alias :num :pokebell
  
  # @!method str
  # @return [String] message (convert to Zenkaku charactors, especially from Hiragana to Katakana)
  attr_reader :str
  alias :to_s :str
  alias :text :str
  
  private
  TABLE = [
    %w[０ ワ ヲ ン ゛ ゜ ６ ７ ８ ９], 
    %w[Ｅ ア イ ウ エ オ Ａ Ｂ Ｃ Ｄ], 
    %w[Ｊ カ キ ク ケ コ Ｆ Ｇ Ｈ Ｉ], 
    %w[Ｏ サ シ ス セ ソ Ｋ Ｌ Ｍ Ｎ], 
    %w[Ｔ タ チ ツ テ ト Ｐ Ｑ Ｒ Ｓ], 
    %w[Ｙ ナ ニ ヌ ネ ノ Ｕ Ｖ Ｗ Ｘ], 
    %w[／ ハ ヒ フ ヘ ホ Ｚ ？ ！ ー], 
    ([""] + %w[マ ミ ム メ モ ￥ ＆] + ["", ""]), 
    ([""] + %w[ヤ （ ユ ） ヨ ＊ ＃ 　] + [""]), 
    %w[５ ラ リ ル レ ロ １ ２ ３ ４], 
  ]
  DAKU_BASE_REGEX = /[カキクケコサシスセソタチツテト]/
  DAKU_HANDAKU_BASE_REGEX = /[ハヒフヘホ]/
  
  def zenkaku2hankaku(str)
    NKF.nkf('-jZ4', str)
  end
  
  def hiragana2katakana(str)
    NKF.nkf("-wh2", str).gsub("¥", "￥")
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
    elsif char.unpack("C") == "\x21".unpack("C")
      
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
      166 => "02", # を
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
  
  def self.make_str_array(array) 
    array.map { |digits|
      i = digits[0].to_i
      j = digits[1].to_i
      TABLE[i][j]
    }
  end
  
  def self.merge_daku_handaku(char, follow_char)
    if follow_char[/゛/] && char[Regexp.union(DAKU_BASE_REGEX, DAKU_HANDAKU_BASE_REGEX)]
      [char.unpack("U*").first + 1].pack("U")
    elsif follow_char[/゜/] && char[DAKU_HANDAKU_BASE_REGEX]
      [char.unpack("U*").first + 2].pack("U")
    elsif follow_char[/゛/] && char[/ウ/]
      "ヴ"
    else
      char + follow_char
    end
  end
end
