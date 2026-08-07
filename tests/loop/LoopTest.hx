package;

import hxBrainfuck.*;

class LoopTest extends BrainfuckMain
{
    override function new()
    {
        super();
        bf.register("!", function() {trace(bf.values);});
        bf.load('>+[+]>>!');
        bf.run();
    }
    public static function main() 
    {
        var m = new LoopTest();
    }
}