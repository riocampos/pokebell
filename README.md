# pokebell

This gem is convert from Japanese message written by Hiragana / Katakana / alphabet / digit to Japanese pager aka "Pokebell" 2-digits format codes.

## usage

```
pokeberu = Pokebell.new("ぽけべる")
pokeberu.pokebell #=> "650524640493"
pokeberu.code     #=> "650524640493"
pokeberu.str      #=> "ぽけべる"
pokeberu.to_a     #=> "ぽけべる"
```

## convert table

```
Pokebell.new("あいうえお").pokebell #=> "1112131415"
Pokebell.new("かきくけこ").pokebell #=> "2122232425"
Pokebell.new("さしすせそ").pokebell #=> "3132333435"
Pokebell.new("たちつてと").pokebell #=> "4142434445"
Pokebell.new("なにぬねの").pokebell #=> "5152535455"
Pokebell.new("はひふへほ").pokebell #=> "6162636465"
Pokebell.new("まみむめも").pokebell #=> "7172737475"
Pokebell.new("やゆよ").pokebell     #=> "818385"
Pokebell.new("（）").pokebell       #=> "8284"
Pokebell.new("らりるれろ").pokebell #=> "9192939495"
Pokebell.new("わをん").pokebell     #=> "010203"
Pokebell.new("゛゜").pokebell       #=> "0405"

Pokebell.new("ＡＢＣＤＥ").pokebell #=> "1617181910"
Pokebell.new("ＦＧＨＩＪ").pokebell #=> "2627282920"
Pokebell.new("ＫＬＭＮＯ").pokebell #=> "3637383930"
Pokebell.new("ＰＱＲＳＴ").pokebell #=> "4647484940"
Pokebell.new("ＵＶＷＸＹ").pokebell #=> "5657585950"
Pokebell.new("Ｚ？！ー／").pokebell #=> "6667686960"
Pokebell.new("￥＆").pokebell       #=> "7677"
Pokebell.new("＊＃　").pokebell     #=> "868788"
Pokebell.new("１２３４５").pokebell #=> "9697989990"
Pokebell.new("６７８９０").pokebell #=> "0607080900"
```

## example

```
Pokebell.new("ぱーる").pokebell #=> "61056993"
Pokebell.new("パール").pokebell #=> "61056993"
Pokebell.new("るびー").pokebell #=> "93620469"
Pokebell.new("ルビー").pokebell #=> "93620469"

Pokebell.new("perl").pokebell   #=> "46104837"
Pokebell.new("ruby").pokebell   #=> "48561750"
Pokebell.new("hello pokebell").pokebell
#=> "2810373730884630361017103737"
```

##TODO

* RSpec
* Emoji (Clock="78", Phone="79", Cup="70", Heart="89")
* Convert (Decode) from codes to Japanese charactors

## Contributing to pokebell
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 riocampos. See LICENSE.txt for
further details.

