unit seaWar;

interface

uses crt;

type
    matrix = array[1..10, 1..10] of char;

const
    ship = '#';

const
    sea = '-';

const
    dead = 'X';

const
    miss = 'o';

procedure showArr(ma, mi: matrix);
procedure generateArr(var ma: matrix);
procedure fillArr(var ma: matrix);
procedure placeHor(var ma: matrix; n: byte);
procedure placeVer(var ma: matrix; n: byte);
procedure placeShip(var ma: matrix; n: byte);
function shoot(var ma, mi: matrix; a, b: byte): byte;
function checkNear(ma: matrix; a, b: byte): boolean;
function playerTurn(var ma1, ma2, mi1: matrix; a, b: byte): boolean;
function gameOver(ma1, ma2: matrix): boolean;
function compTurn(var ma1, mi1, mi2: matrix): boolean;
function findBotA(a: byte): byte;
function findBotB(b: byte): byte;
procedure findBotAB(var a, b: byte);
procedure markAround(a, b: byte; var ma, mi: matrix);

implementation

function compTurn(var ma1, mi1, mi2: matrix): boolean;
var
    a, b, x: byte;

begin
    repeat
        a := random(1, 10);
        b := random(1, 10);
    until mi2[a, b] = sea;
    
    repeat
        x := shoot(ma1, mi2, a, b);
        case x of
            0: 
                begin
                    clrscr;
                    showArr(ma1, mi1);
                    textcolor(9);
                    writeln('Your opponent missed! (press any key to continue)');
                    readln;
                    compTurn := true;
                end;
            1: 
                begin
                    clrscr;
                    showArr(ma1, mi1);
                    textcolor(12);
                    writeln('Your opponent shot your ship!');
                    readln;
                    compTurn := false;
                    findBotAB(a, b);
                    markAround(a, b, ma1, mi2);
                end;
            2: 
                begin
                    clrscr;
                    showArr(ma1, mi1);
                    textcolor(12);
                    writeln('Your opponent killed your ship!');
                    readln;
                    compTurn := false;
                    a := random(1, 10);
                    b := random(1, 10);
                end;
        end;
    until x = 0;
end;

procedure markAround(a, b: byte; var ma, mi: matrix);
begin
    case a of
        1: 
            begin
                case b of
                    1: 
                        begin
                            if (ma[a, b + 1] = miss) or (ma[a, b + 1] = sea) then mi[a, b + 1] := miss;     //right
                            
                            if (ma[a + 1, b + 1] = miss) or (ma[a + 1, b + 1] = sea) then mi[a + 1, b + 1] := miss; //right
                            if (ma[a + 1, b] = miss) or (ma[a + 1, b] = sea) then mi[a + 1, b] := miss;            //mid
                        end;
                    10: 
                        begin
                            if (ma[a, b - 1] = miss) or (ma[a, b - 1] = sea) then mi[a, b - 1] := miss;        //left
                            
                            if (ma[a + 1, b - 1] = miss) or (ma[a + 1, b - 1] = sea) then mi[a + 1, b - 1] := miss;      //left
                            if (ma[a + 1, b] = miss) or (ma[a + 1, b] = sea) then mi[a + 1, b] := miss;            //mid
                        end;
                else 
                    begin
                        if (ma[a, b + 1] = miss) or (ma[a, b + 1] = sea) then mi[a, b + 1] := miss;     //right
                        if (ma[a, b - 1] = miss) or (ma[a, b - 1] = sea) then mi[a, b - 1] := miss;        //left
                        
                        if (ma[a + 1, b + 1] = miss) or (ma[a + 1, b + 1] = sea) then mi[a + 1, b + 1] := miss; //right
                        if (ma[a + 1, b - 1] = miss) or (ma[a + 1, b - 1] = sea) then mi[a + 1, b - 1] := miss;      //left
                        if (ma[a + 1, b] = miss) or (ma[a + 1, b] = sea) then mi[a + 1, b] := miss;            //mid
                    end;
                end;
            end;
        10: 
            begin
                case b of
                    1: 
                        begin
                            
                            if (ma[a - 1, b + 1] = miss) or (ma[a - 1, b + 1] = sea) then mi[a - 1, b + 1] := miss; //right
                            if (ma[a - 1, b] = miss) or (ma[a - 1, b] = sea) then mi[a - 1, b] := miss;            //mid
                            
                            if (ma[a, b + 1] = miss) or (ma[a, b + 1] = sea) then mi[a, b + 1] := miss;     //right
                        end;
                    10: 
                        begin
                            
                            if (ma[a - 1, b - 1] = miss) or (ma[a - 1, b - 1] = sea) then mi[a - 1, b - 1] := miss;      //left
                            if (ma[a - 1, b] = miss) or (ma[a - 1, b] = sea) then mi[a - 1, b] := miss;            //mid
                            
                            if (ma[a, b - 1] = miss) or (ma[a, b - 1] = sea) then mi[a, b - 1] := miss;        //left
                        end;
                else
                    begin
                        
                        if (ma[a - 1, b + 1] = miss) or (ma[a - 1, b + 1] = sea) then mi[a - 1, b + 1] := miss; //right
                        if (ma[a - 1, b - 1] = miss) or (ma[a - 1, b - 1] = sea) then mi[a - 1, b - 1] := miss;      //left
                        if (ma[a - 1, b] = miss) or (ma[a - 1, b] = sea) then mi[a - 1, b] := miss;            //mid
                        
                        if (ma[a, b + 1] = miss) or (ma[a, b + 1] = sea) then mi[a, b + 1] := miss;     //right
                        if (ma[a, b - 1] = miss) or (ma[a, b - 1] = sea) then mi[a, b - 1] := miss;        //left
                    end;
                end;
            end;
    else begin
            case b of
                1: 
                    begin
                        if (ma[a - 1, b + 1] = miss) or (ma[a - 1, b + 1] = sea) then mi[a - 1, b + 1] := miss; //right
                        if (ma[a - 1, b] = miss) or (ma[a - 1, b] = sea) then mi[a - 1, b] := miss;            //mid
                        
                        if (ma[a, b + 1] = miss) or (ma[a, b + 1] = sea) then mi[a, b + 1] := miss;     //right
                        
                        if (ma[a + 1, b + 1] = miss) or (ma[a + 1, b + 1] = sea) then mi[a + 1, b + 1] := miss; //right
                        if (ma[a + 1, b] = miss) or (ma[a + 1, b] = sea) then mi[a + 1, b] := miss;            //mid
                    end;
                10: 
                    begin
                        if (ma[a - 1, b - 1] = miss) or (ma[a - 1, b - 1] = sea) then mi[a - 1, b - 1] := miss;      //left
                        if (ma[a - 1, b] = miss) or (ma[a - 1, b] = sea) then mi[a - 1, b] := miss;            //mid
                        
                        if (ma[a, b - 1] = miss) or (ma[a, b - 1] = sea) then mi[a, b - 1] := miss;        //left
                        
                        if (ma[a + 1, b - 1] = miss) or (ma[a + 1, b - 1] = sea) then mi[a + 1, b - 1] := miss;      //left
                        if (ma[a + 1, b] = miss) or (ma[a + 1, b] = sea) then mi[a + 1, b] := miss;            //mid
                    end;
            else 
                begin
                    if (ma[a - 1, b + 1] = miss) or (ma[a - 1, b + 1] = sea) then mi[a - 1, b + 1] := miss; //right
                    if (ma[a - 1, b - 1] = miss) or (ma[a - 1, b - 1] = sea) then mi[a - 1, b - 1] := miss;      //left
                    if (ma[a - 1, b] = miss) or (ma[a - 1, b] = sea) then mi[a - 1, b] := miss;            //mid
                    
                    if (ma[a, b + 1] = miss) or (ma[a, b + 1] = sea) then mi[a, b + 1] := miss;     //right
                    if (ma[a, b - 1] = miss) or (ma[a, b - 1] = sea) then mi[a, b - 1] := miss;        //left
                    
                    if (ma[a + 1, b + 1] = miss) or (ma[a + 1, b + 1] = sea) then mi[a + 1, b + 1] := miss; //right
                    if (ma[a + 1, b - 1] = miss) or (ma[a + 1, b - 1] = sea) then mi[a + 1, b - 1] := miss;      //left
                    if (ma[a + 1, b] = miss) or (ma[a + 1, b] = sea) then mi[a + 1, b] := miss;            //mid
                end;
            end;
        end;
    end;
end;

procedure findBotAB(var a, b: byte);
var
    x, y: byte;
    check: boolean;
begin
    check := false;
    while check = false do 
    begin
        x := findBotA(a);
        y := findBotB(b);
        
        if (a = x) and (b <> y) then check := true
        else
        if (a <> x) and (b = y) then check := true;
    end;
    a := x;
    b := y;
end;

function findBotA(a: byte): byte;
var
    v: byte;
begin
    if a = 1 then 
    begin
        v := random(1, 2);
        case v of
            1: a := a;
            2: a := a + 1;
        end;
    end;
    if a = 10 then 
    begin
        v := random(1, 2);
        case v of
            1: a := a;
            2: a := a - 1;
        end;
    end;
    if (a > 1) and (a < 10) then 
    begin
        v := random(1, 3);
        case v of
            1: a := a;
            2: a := a + 1;
            3: a := a - 1;
        end;
    end;
    findBotA := a;
end;

function findBotB(b: byte): byte;
var
    v: byte;
begin
    if b = 1 then 
    begin
        v := random(1, 2);
        case v of
            1: b := b;
            2: b := b + 1;
        end;
    end;
    if b = 10 then 
    begin
        v := random(1, 2);
        case v of
            1: b := b;
            2: b := b - 1;
        end;
    end;
    if (b > 1) and (b < 10) then 
    begin
        v := random(1, 3);
        case v of
            1: b := b;
            2: b := b + 1;
            3: b := b - 1;
        end;
    end;
    findBotB := b;
end;

function playerTurn(var ma1, ma2, mi1: matrix; a, b: byte): boolean;
var
    ch: byte;
    win: boolean;
begin
    win := true;
    ch := shoot(ma2, mi1, a, b);
    clrscr;
    showArr(ma1, mi1);
    textcolor(10);
    case ch of 
        0: begin writeln('MISS!'); win := false; end;
        1: writeln('Shot, but not killed!');
        2: writeln('KillShot!');
    end;
    playerTurn := win;
end;

function shoot(var ma, mi: matrix; a, b: byte): byte;// 0 - мимо. 1 - попал. 2 - убил
begin
    if ma[a, b] = ship then 
    begin
        ma[a, b] := dead;
        mi[a, b] := dead;
        if checkNear(ma, a, b) then shoot := 1
        else shoot := 2;
    end
    else begin
        if ma[a, b] = sea then begin
            ma[a, b] := miss;
            mi[a, b] := miss;
        end
        else if ma[a, b] = dead then begin
            
            ma[a, b] := dead;
            mi[a, b] := dead;
        end;
    end;
end;

function checkNear(ma: matrix; a, b: byte): boolean;
var
    checkNearest: boolean; s: string[5];
begin
    try
        checkNearest := false;
        if a = 1 then               //TOP SIDE
            if (b = 1) and ((ma[a, b + 1] = ship) or (ma[a + 1, b] = ship)) then checkNearest := true
            else 
            if (b = 10) and ((ma[a, b - 1] = ship) or (ma[a + 1, b] = ship)) then checkNearest := true
            else 
            if ((b > 1) and (b < 10 )) and ((ma[a, b - 1] = ship) or (ma[a, b + 1] = ship) or (ma[a + 1, b] = ship)) then checkNearest := true;
        
        if a = 10 then         //BOTTOM SIDE
            if (b = 1) and ((ma[a, b + 1] = ship) or (ma[a - 1, b] = ship)) then checkNearest := true
            else 
            if (b = 10) and ((ma[a, b - 1] = ship) or (ma[a - 1, b] = ship)) then checkNearest := true
            else 
            if ((b > 1 ) and (b < 10)) and (ma[a, b - 1] = ship) or (ma[a, b + 1] = ship) or (ma[a - 1, b] = ship) then checkNearest := true;
        
        if (a > 1) and (a < 10) then 
            if (b = 1) and ((ma[a, b + 1] = ship) or (ma[a - 1, b] = ship) or (ma[a + 1, b] = ship)) then checkNearest := true
            else
            if (b = 10) and ((ma[a, b - 1] = ship) or (ma[a - 1, b] = ship) or (ma[a + 1, b] = ship)) then checkNearest := true
            else 
            if ((b > 1 ) and (b < 10)) and ((ma[a, b + 1] = ship) or (ma[a, b - 1] = ship) or (ma[a + 1, b] = ship) or (ma[a - 1, b] = ship)) then checkNearest := true;
        checkNear := checkNearest;
    
    
    except 
        on System.IndexOutOfRangeException do
            repeat
                textcolor(12);
                writeln('ERROR!!!');
                writeln(a, ' ', b);
                readln(s);
            until (s = 'yes') or (s = 'no'); end;
end;


procedure fillArr(var ma: matrix);
begin
    for var i := 4 downto 1 do
        for var j := 5 - i downto 1 do placeShip(ma, i);
end;

procedure generateArr(var ma: matrix);
begin
    for var i := 1 to 10 do 
        for var j := 1 to 10 do
            ma[i, j] := sea;
end;

procedure placeShip(var ma: matrix; n: byte);
begin
    if random(2) = 1 then placeHor(ma, n) else placeVer(ma, n);
end;

procedure placeHor(var ma: matrix; n: byte);
var
    check: boolean;
    a, b: byte;
begin
    repeat
        check := false;
        a := random(1, 10);
        b := random(1, 11 - n);
        for var i := 0 to n - 1 do
            if (a > 1) and (a < 10) then 
                if (b + i = 10) then begin//MIDDLE RIGHT SIDE
                    //center line
                    if (ma[a, b + i] <> sea)
                        then check := true;
                    if (ma[a, b + i - 1] <> sea)
                        then check := true;
                    
                    //top line
                    if (ma[a - 1, b + i] <> sea)
                        then check := true;
                    if (ma[a - 1, b + i - 1] <> sea)
                        then check := true;    
                    
                    //bottom line
                    if (ma[a + 1, b + i] <> sea)
                        then check := true;
                    if (ma[a + 1, b + i - 1] <> sea)
                        then check := true;
                end
                
                else if (b + i = 1) then begin//MIDDLE LEFT SIDE
                    //center line
                    if (ma[a, b + i] <> sea)
                        then check := true;
                    if (ma[a, b + i + 1] <> sea)
                        then check := true;
                    
                    //top line
                    if (ma[a - 1, b + i] <> sea)
                        then check := true;
                    if (ma[a - 1, b + i + 1] <> sea)
                        then check := true;
                    
                    //bottom line
                    if (ma[a + 1, b + i] <> sea)
                        then check := true;
                    if (ma[a + 1, b + i + 1] <> sea)
                        then check := true;
                end
                
                else 
                begin//ONLY MIDDLE
                    //center line
                    if (ma[a, b + i] <> sea)
                        then check := true;
                    if (ma[a, b + i - 1] <> sea)
                        then check := true;
                    if (ma[a, b + i + 1] <> sea)
                        then check := true;
                    
                    //top line
                    if (ma[a - 1, b + i] <> sea)
                        then check := true;
                    if (ma[a - 1, b + i - 1] <> sea)
                        then check := true;    
                    if (ma[a - 1, b + i + 1] <> sea)
                        then check := true;
                    
                    //bottom line
                    if (ma[a + 1, b + i] <> sea)
                        then check := true;
                    if (ma[a + 1, b + i - 1] <> sea)
                        then check := true;
                    if (ma[a + 1, b + i + 1] <> sea)
                        then check := true;
                end
            
            else if (a = 1) then               //TOP SIDE!!!
            begin
                if (b + i = 1) then begin//TOP LEFT CORNER
                    //center line
                    if (ma[a, b + i] <> sea)
                        then check := true;
                    if (ma[a, b + i + 1] <> sea)
                        then check := true;
                    
                    //bottom line
                    if (ma[a + 1, b + i] <> sea)
                        then check := true;
                    if (ma[a + 1, b + i + 1] <> sea)
                        then check := true;    
                end
                
                
                else if (b + i = 10) then begin//TOP RIGHT CORNER
                    //center line
                    if (ma[a, b + i] <> sea)
                        then check := true;
                    if (ma[a, b + i - 1] <> sea)
                        then check := true;
                    
                    //bottom line
                    if (ma[a + 1, b + i] <> sea)
                        then check := true;
                    if (ma[a + 1, b + i - 1] <> sea)
                        then check := true;
                end
                
                else                                              //TOP SIDE NO CORNER
                begin
                    
                    //center line
                    if (ma[a, b + i] <> sea)
                        then check := true;
                    if (ma[a, b + i - 1] <> sea)
                        then check := true;
                    if (ma[a, b + i + 1] <> sea)
                        then check := true;
                    
                    //bottom line
                    if (ma[a + 1, b + i] <> sea)
                        then check := true;
                    if (ma[a + 1, b + i - 1] <> sea)
                        then check := true;
                    if (ma[a + 1, b + i + 1] <> sea)
                        then check := true;
                end;
                
            end
            
            else if (a = 10) then                                //BOTTOM SIDE!!!
            begin
                if (b = 1) then
                begin//BOTTOM LEFT CORNER
                    //center line
                    if (ma[a, b + i] <> sea)
                        then check := true;
                    if (ma[a, b + i + 1] <> sea)
                        then check := true;
                    
                    //top line 
                    if (ma[a - 1, b + i] <> sea)
                        then check := true;   
                    if (ma[a - 1, b + i + 1] <> sea)
                        then check := true;    
                end
                
                
                else if (b + i = 10) then
                begin//BOTTOM RIGHT CORNER
                    //center line
                    if (ma[a, b + i] <> sea)
                        then check := true;
                    if (ma[a, b - 1] <> sea)
                        then check := true;
                    
                    //top line
                    if (ma[a - 1, b + i] <> sea)
                        then check := true;
                    if (ma[a - 1, b + i - 1] <> sea)
                        then check := true;    
                end
                
                else begin//BOTTOM SIDE NO CORNER
                    
                    //center line
                    if (ma[a, b + i] <> sea)
                        then check := true;
                    if (ma[a, b + i - 1] <> sea)
                        then check := true;
                    if (ma[a, b + i + 1] <> sea)
                        then check := true;
                    
                    //top line
                    if (ma[a - 1, b + i] <> sea)
                        then check := true;
                    if (ma[a - 1, b + i - 1] <> sea)
                        then check := true;    
                    if (ma[a - 1, b + i + 1] <> sea)
                        then check := true;
                end;
                
            end;
    until check = false;
    
    for var i := 0 to n - 1 do 
        ma[a, b + i] := ship;
end;

procedure placeVer(var ma: matrix; n: byte);
var
    check: boolean;
    a, b: byte;
begin
    repeat
        check := false;
        a := random(1, 11 - n);
        b := random(1, 10);
        for var i := 0 to n - 1 do                                         //MIDDLE SIDE!!!
            if (a > 1) and (a + i < 10) then 
                if (b = 10) then begin//MIDDLE RIGHT SIDE
                    //center line
                    if (ma[a + i, b] <> sea)
                        then check := true;
                    if (ma[a + i, b - 1] <> sea)
                        then check := true;
                    
                    //top line
                    if (ma[a + i - 1, b] <> sea)
                        then check := true;
                    if (ma[a + i - 1, b - 1] <> sea)
                        then check := true;    
                    
                    //bottom line
                    if (ma[a + i + 1, b] <> sea)
                        then check := true;
                    if (ma[a + i + 1, b - 1] <> sea)
                        then check := true;
                end
                
                else if (b = 1) then begin//MIDDLE LEFT SIDE
                    //center line
                    if (ma[a + i, b] <> sea)
                        then check := true;
                    if (ma[a + i, b + 1] <> sea)
                        then check := true;
                    
                    //top line
                    if (ma[a + i - 1, b] <> sea)
                        then check := true;
                    if (ma[a + i - 1, b + 1] <> sea)
                        then check := true;
                    
                    //bottom line
                    if (ma[a + i + 1, b] <> sea)
                        then check := true;
                    if (ma[a + i + 1, b + 1] <> sea)
                        then check := true;
                end
                
                else 
                begin//ONLY MIDDLE
                    //center line
                    if (ma[a + i, b] <> sea)
                        then check := true;
                    if (ma[a + i, b - 1] <> sea)
                        then check := true;
                    if (ma[a + i, b + 1] <> sea)
                        then check := true;
                    
                    //top line
                    if (ma[a + i - 1, b] <> sea)
                        then check := true;
                    if (ma[a + i - 1, b - 1] <> sea)
                        then check := true;    
                    if (ma[a + i - 1, b + 1] <> sea)
                        then check := true;
                    
                    //bottom line
                    if (ma[a + i + 1, b] <> sea)
                        then check := true;
                    if (ma[a + i + 1, b - 1] <> sea)
                        then check := true;
                    if (ma[a + i + 1, b + 1] <> sea)
                        then check := true;
                end
            
            else if (a = 1) then               //TOP SIDE!!!
            begin
                if (b = 1) then begin//TOP LEFT CORNER
                    //center line
                    if (ma[a + i, b] <> sea)
                        then check := true;
                    if (ma[a + i, b + 1] <> sea)
                        then check := true;
                    
                    //bottom line
                    if (ma[a + i + 1, b] <> sea)
                        then check := true;
                    if (ma[a + i + 1, b + 1] <> sea)
                        then check := true;    
                end
                
                
                else if (b = 10) then begin//TOP RIGHT CORNER
                    //center line
                    if (ma[a + i, b] <> sea)
                        then check := true;
                    if (ma[a + i, b - 1] <> sea)
                        then check := true;
                    
                    //bottom line
                    if (ma[a + i + 1, b] <> sea)
                        then check := true;
                    if (ma[a + i + 1, b - 1] <> sea)
                        then check := true;
                end
                
                else                                              //TOP SIDE NO CORNER
                begin
                    
                    //center line
                    if (ma[a + i, b] <> sea)
                        then check := true;
                    if (ma[a + i, b - 1] <> sea)
                        then check := true;
                    if (ma[a + i, b + 1] <> sea)
                        then check := true;
                    
                    //bottom line
                    if (ma[a + i + 1, b] <> sea)
                        then check := true;
                    if (ma[a + i + 1, b - 1] <> sea)
                        then check := true;
                    if (ma[a + i + 1, b + 1] <> sea)
                        then check := true;
                end;
                
            end
            
            else if (a + i = 10) then                                //BOTTOM SIDE!!!
            begin
                if (b = 1) then
                begin//BOTTOM LEFT CORNER
                    //center line
                    if (ma[a + i, b] <> sea)
                        then check := true;
                    if (ma[a + i, b + 1] <> sea)
                        then check := true;
                    
                    //top line 
                    if (ma[a + i - 1, b] <> sea)
                        then check := true;   
                    if (ma[a + i - 1, b + 1] <> sea)
                        then check := true;    
                end
                
                
                else if (b = 10) then
                begin//BOTTOM RIGHT CORNER
                    //center line
                    if (ma[a + i, b] <> sea)
                        then check := true;
                    if (ma[a + i, b - 1] <> sea)
                        then check := true;
                    
                    //top line
                    if (ma[a + i - 1, b] <> sea)
                        then check := true;
                    if (ma[a + i - 1, b - 1] <> sea)
                        then check := true;    
                end
                
                else begin//BOTTOM SIDE NO CORNER
                    
                    //center line
                    if (ma[a + i, b] <> sea)
                        then check := true;
                    if (ma[a + i, b - 1] <> sea)
                        then check := true;
                    if (ma[a + i, b + 1] <> sea)
                        then check := true;
                    
                    //top line
                    if (ma[a + i - 1, b] <> sea)
                        then check := true;
                    if (ma[a + i - 1, b - 1] <> sea)
                        then check := true;    
                    if (ma[a + i - 1, b + 1] <> sea)
                        then check := true;
                end;
                
            end;
        
        
        
        
        
        
    until check = false;
    
    for var i := 0 to n - 1 do 
        ma[a + i, b] := ship;
end;

procedure showArr(ma, mi: matrix);
begin
    writeln;
    textcolor(2);
    write('            Your map                           ');
    textcolor(4);
    writeln('Enemy map');
    writeln;
    textcolor(5);
    write('       a b c d e f g h i j                a b c d e f g h i j');
    writeln;
    writeln;
    for var i := 1 to 10 do 
    begin
        textcolor(13);
        write('   ', i:2, '  ');
        for var j := 1 to 10 do 
        begin
            textcolor(15);
            if ma[i, j] = sea then textcolor(3) 
            else if ma[i, j] = dead then textcolor(12)
            else if ma[i, j] = miss then textcolor(7);
            write(ma[i, j], ' ');
            textcolor(15);
        end;
        
        textcolor(13);
        write('           ', i:2, '  ');
        for var j := 1 to 10 do 
        begin
            textcolor(15);
            if mi[i, j] = sea then textcolor(3) 
            else if mi[i, j] = dead then textcolor(12)
            else if mi[i, j] = miss then textcolor(7);
            write(mi[i, j], ' ');
            
        end;
        
        writeln;
    end;
    writeln;
    textcolor(15);
end;

function gameOver(ma1, ma2: matrix): boolean;
var
    counter1, counter2: byte;
begin
    counter1 := 0;
    for var i := 1 to 10 do
        for var j := 1 to 10 do
            if ma1[i, j] = dead then counter1 := counter1 + 1;
    if counter1 = 80 then begin
        textcolor(14);
        writeln('Game Over. You win!');
    end;   
    
    counter2 := 0;
    for var i := 1 to 10 do
        for var j := 1 to 10 do
            if ma2[i, j] = dead then counter2 := counter2 + 1;
    if counter2 = 20 then begin
        textcolor(12);
        writeln('Game Over. You are looser!');
    end;   
    if (counter2 = 20) or (counter1 = 20)
        then gameOver := true
    else gameOver := false;
end;

end.