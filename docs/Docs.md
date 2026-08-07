# hxBrainfuck Docs

hxBrainfuck is a simple, fast and embeddable interpreter of Brainfuck, written in Haxe, and packaged as a Haxelib.

## Basic Usage

``` haxe
package;

import hxbrainfuck.Brainfuck;

class BrainfuckTest
{
  public static function main()
  {
    var bf = new Brainfuck();
    bf.load("+[+.].");
    bf.run();
  }
}
```

## Embedding

You can easily expose new commands for Brainfuck to use using the `register` function.

``` haxe
register(cmd:String, func:Void->Void);
```

The command will be stored in a map and will be called whenever your selected symbol is ran. Here's an [example](https://github.com/KaiTheHaxeCoder/hxBrainfuck/blob/main/tests/embed/EmbedTest.hx).

