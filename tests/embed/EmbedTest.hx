package;

import hxBrainfuck.*;

class EmbedTest
{
    public static function main()
    {
        var bf:Brainfuck = new Brainfuck();

        bf.register("P", function() {BFHelpers.print("Hello, world!");});
        bf.register("1", function() {BFHelpers.print(Std.string(bf.values));});
        bf.load('PPP++>+1', true);

        /**
            Output:
            Hello, world!
            Hello, world!
            Hello, world!
            [2,1]
        **/
    }
}