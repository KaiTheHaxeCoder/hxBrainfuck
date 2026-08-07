package hxBrainfuck;

import hxBrainfuck.BFHelpers;

class Brainfuck
{
    public var pointer:Int = 0;
    public var values:Array<Int> = [0];

    public var commands:Map<String, Void->Void> = new Map();
    public var functions:Map<Int, Brainfuck> = new Map();

    public var code:String = '';

    public var paused:Bool = false;

    public function call(func:Int)
    {
        if (exists(func))
            functions.get(func).run();
    }

    inline public function exists(func:Int)
        return functions.exists(func);

    public function register(cmd:String, func:Void->Void)
    {
        if (cmd.length != 1)
        {
            throw "command must be exactly one character long!";
            return;
        }

        commands.set(cmd, func);
    }

    public function registerFunction(id:Int, code:String):Brainfuck
    {
        var bf = new Brainfuck();
        bf.load(code);
        functions.set(id, bf);
        return bf;
    }

    public function new () {}

    inline public function load(code:String, ?autoRun:Bool = false)
    {
        this.code = code;
        if (autoRun)
            run();
    }

    public function run(?input = '', ?verbose = false):Dynamic
    {
        if (verbose) trace("Interpreting code: " + code);

        if (code == null || code == "")
        {
            BFHelpers.print("Error: No code provided.");
            return null;
        }

        if (verbose) trace("Code length: " + code.length);

        var codeArray:Array<String> = BFHelpers.arrayizeString(code);

        var useInput:Bool = false;

        for (char in codeArray) {
            if (char == ",")
            {
                useInput = true;
                break;
            }
        }

        if (verbose) trace("Using input..." + (useInput ? " Yes" : " No"));

        var inputs:Int = -1;
        var output:String = "";

        var i:Int = 0;
        var curIndex:Int = 0;
        var doLoop:Bool = false;
        var loopLength:Int = 0;

        register(">", function () 
        {
            pointer += 1;
            if (pointer >= values.length)
                values.push(0);

            if (verbose) trace("New pointer: " + pointer);
        });
        register("<", function () 
        {
            pointer -= 1;
            if (pointer < 0)
                pointer = 0;

            if (verbose) trace("New pointer: " + pointer);
        });
        register("+", function()
        {
            values[pointer] += 1;
            if (values[pointer] > 255)
                values[pointer] = 0;

            if (verbose) trace("New value: " + values[pointer]);
        });
        register("-", function()
        {
            values[pointer] -= 1;
            if (values[pointer] < 0)
                values[pointer] = 255;

            if (verbose) trace("New value: " + values[pointer]);
        });
        register(".", function()
        {
            output += String.fromCharCode(values[pointer]);
            if (verbose) trace("Added " + String.fromCharCode(values[pointer]) + " to output.");
        });
        register(",", function()
        {
            if (useInput) //kinda a just in case thing i guess
            {
                inputs ++;
                values[pointer] = input.charCodeAt(inputs);
                if (verbose) trace("Read " + values[pointer] + " from input.");
            }
        });
        register("[", function() {
            if (values[pointer] == 0)
            {
                // Jump forward to matching ]
                var open = 1;
                while (open > 0)
                {
                    i++;
                    if (i >= codeArray.length) {
                        BFHelpers.print("Error: Unmatched [");
                        return;
                    }

                    if (codeArray[i] == "[") open++;
                    else if (codeArray[i] == "]") open--;
                }
            }
        });

        register(']', function() {
            if (values[pointer] != 0)
            {
                // Jump back to matching [
                var close = 1;
                while (close > 0)
                {
                    i--;
                    if (i < 0) {
                        BFHelpers.print("Error: Unmatched ]");
                        return;
                    }

                    if (codeArray[i] == "]") close++;
                    else if (codeArray[i] == "[") close--;
                }
            }
        });

        //Function shit
        register("@", function() {
            call(values[pointer]);
        });

        register("{", function() {
            var funcCode = '';
            registerFunction(1, funcCode);
        });

        while (i < codeArray.length)
        {
            if (paused) continue;
            if (verbose) trace("Current index: " + i);

            if (commands.exists(codeArray[i]))
                commands.get(codeArray[i])();
            i ++;
        }
        return output;
    }
}