#!/usr/bin/env ruby
# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

match_hash = {
  "カキクケコ" => "2122232425",
  "ガギグゲゴ" => "21042204230424042504",
  "パピプペポ" => "61056205630564056505",
  "ヤユヨ" => "818385",
  "（）" => "8284",
  "ラリルレロ" => "9192939495",
  "ワヲン" => "010203",
  "ＡＢＣＤＥ" => "1617181910",
  "Ｚ？！ー／" => "6667686960",
  "￥＆＊＃　" => "7677868788",
  "１２３４５６７８９０" => "96979899900607080900",
  "パンガオイシイー" => "61050321041512321269",
  "ヴアイオリン" => "13041112159203",
}  

match_hash1 = match_hash.merge({
  "あいうえお" => "1112131415",
  "ｻｼｽｾｿ" => "3132333435",
  "゛゜" => "0405",
  "あ゛" => "1104",
  "ﾊﾞﾋﾞﾌﾞﾍﾞﾎﾞ" => "61046204630464046504",
  "67890" => "0607080900",
  "hello pokebell" => "2810373730884630361017103737",
})
match_hash2 = match_hash.merge({
  "　゛　゜" => "88048805",
  "バビブベボ" => "61046204630464046504",
  "６７８９０" => "0607080900",
  "ＨＥＬＬＯ　ＰＯＫＥＢＥＬＬ" => "2810373730884630361017103737",
})

describe "Pokebell" do
  match_hash1.each_pair do |str, num|
    context %[give string "#{str}"] do
      it do
        str_pokebell = Pokebell.new(str)
        expect(str_pokebell.pokebell).to eq num
      end
    end
  end
  
  context "give number 111" do
    it 'raise ArgumentError' do
      expect { Pokebell.number("111") }.to raise_error ArgumentError, "wrong digit length (must be even digits)"
    end
  end
  
  context 'give number "abc"' do
    it 'raise ArgumentError' do
      expect { Pokebell.number("abc") }.to raise_error ArgumentError, "wrong digit length (must be even digits)"
    end
  end
  
  match_hash2.each_pair do |str, num|
    context %[give number "#{num}"] do
      it do
        num_pokebell = Pokebell.number(num)
        expect(num_pokebell.str).to eq str
      end
    end
  end
end
