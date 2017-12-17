uses crt, seaWar;

var
    ma1, ma2, mi1, mi2: matrix; 
    {          Игроку   Боту
    Видимый    ma1      ma2
    Скрытый    mi1      mi2         }
    
    isPlaying, isPlayer: boolean;
    s: string[5];
    a, b: byte;
    c, d: integer;

begin
    isPlaying := true;
    while isPlaying do 
    begin
        isPlaying := false;
        generateArr(ma2);
        fillArr(ma2);
        generateArr(mi1);
        generateArr(mi2);
        repeat
            repeat
                clrscr;
                generateArr(ma1);
                fillArr(ma1);
                showArr(ma1, mi1);
                textcolor(10);
                writeln('Generate new map or start playing? ("play" for start / press any button for new map)');
                readln(s);
            until (s = 'yes') or (s = 'play');
            if s = 'play' then isPlaying := true;
        until isPlaying;
        
        a := 1;
        b := 1;
        c := 1;
        
        for var k := 0 to 99999 do 
        begin
            repeat
                clrscr;
                showArr(ma1, mi1);
                textcolor(10);
                writeln('Input coordinates');
                readln(s);
                if s = 'exit' then exit;
                case s[1] of    
                    'a', 'A': b := 1;
                    'b', 'B': b := 2;
                    'c', 'C': b := 3;
                    'd', 'D': b := 4;
                    'e', 'E': b := 5;
                    'f', 'F': b := 6;
                    'g', 'G': b := 7;
                    'h', 'H': b := 8;
                    'i', 'I': b := 9;
                    'j', 'J': b := 10;
                end;
                val(s[2], c, d);
                if (s[2] = '1') and (s[3] = '0') then c := 10;
                a := c;
                isPlayer := playerTurn(ma1, ma2, mi1, a, b);
                readln;
            until not isPlayer;
            if gameOver(mi1, mi2) then break;
            
            isPlayer := compTurn(ma1, mi1, mi2);
            if gameOver(mi1, mi2) then break;
            
        end;
        repeat
            clrscr;
            showArr(ma1, mi1);
            textcolor(14);
            writeln('Restart?');
            readln(s);
        until (s = 'yes') or (s = 'no');
        if s = 'yes' then isPlaying := true else isPlaying := false;
    end;
    
end.