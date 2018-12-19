unit uDict;

{$mode objfpc}
{$h+ }
// this unit does something


// public  - - - - - - - - - - - - - - - - - - - - - - - - -
interface


type dictItem = array[1..2] of string;

type
    Dict = object
    public
        len :integer;
        keys : array[1..dictlen] of string;
        items : array[1..dictlen] of dictItem;
        constructor Init;
        function getItem(name:string):dictItem;
        procedure add(key,value:string);
        procedure print;
        procedure edit(name,newValue:string);
        procedure updateLen;
    end;

    // a list of procedure/function signatures makes
    // them useable from outside of the unit
    function Dict.getItem(name:string):dictItem;
    procedure Dict.add(key,value:string);
    procedure Dict.print;
    procedure Dict.edit(name,newValue:string);
    procedure Dict.updateLen;
    constructor Dict.init;

    // an implementation of a function/procedure
    // must not be in the interface-part


// private - - - - - - - - - - - - - - - - - - - - - - - - -
implementation
VAR dictlen: integer;

constructor Dict.init;
var i:integer;item:dictItem;
begin
    len := 0;
    item[1] := ''; item[2]:='';
    for i:=1 to dictlen do
        Begin
        keys[i] := '';
        items[i] := item
        end;
end;

procedure Dict.print;
var i:integer;
Begin
    writeln('');
    write('{');
    for i:=1 to len do
        begin
        write('''',items[i][1],''':''',items[i][2],'''');
        if i<len then write(', ');
        end;
    write('}');writeln('');
end;

procedure Dict.add(key,value:string);
var item : dictItem;
begin
    item[1] := key;
    item[2] := value;
    len := len+1;
    keys[len] := item[1];
    items[len] := item;
end;

function Dict.getItem(name:string):dictItem;
var i:integer;
Begin
    i := 1;
    (*for i:=1 to len do*)
    while keys[i]<>'' do
        if keys[i]=name then getItem:=items[i];
end;

procedure Dict.edit(name,newValue:string);
var i:integer; c:boolean;
begin
    c := False;
    for i:=1 to len do
        if keys[i]=name then
            begin
            items[i][2]:=newValue;
            c := True;
            end;
    if not c then add(name,newValue);
end;

procedure Dict.updateLen;
var i:integer;
Begin
    i := 0;
    while keys[i+1]<>'' do i := i+1;
    len := i;
end;


// initialization is the part executed
// when the unit is loaded/included
initialization
begin
	dictlen := 200; //max len of a dictionnary
    writeln('uDict initialized')
end;


// finalization is worked off at program end
finalization
begin
	// this unit says 'bye' at program halt
	writeln('bye');
end;
end.
