package hxBrainfuck;

import hxBrainfuck.*;

//for testing purposes
class BrainfuckMain
{
    var bf:Brainfuck;
    public function new() 
    {
        bf = new Brainfuck();
    }
    public function run(code:String)
    {
        bf.load(code, true);
    }
}