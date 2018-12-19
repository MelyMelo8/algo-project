Program testDict;

{$mode objfpc}
{$h+ }


CONST dictlen = 200;

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

Var dictionnaire: Dict;
    i: integer;
Begin
  (*
  dictionnaire.Init;
  dictionnaire.add('hey key','valuuues');
  dictionnaire.add('key num 2','I''m a string, u know?');
  write(dictionnaire.len,' items dans le dictionnaire :');
  dictionnaire.print();

  dictionnaire.edit('key num 2','new valuue');
  dictionnaire.edit('key num 4','new valuue here tooo');
  writeln('');write('Edition du dictionnaire : (',dictionnaire.len,' items)');
  dictionnaire.print;

  writeln('');writeln('Itération des items dans une boucle for :');
  for i:=1 to dictionnaire.len do
    writeln(dictionnaire.items[i][1],' : ',dictionnaire.items[i][2]);
  *)
end.
