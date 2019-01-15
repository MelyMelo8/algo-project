unit proj1;

{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}


// public  - - - - - - - - - - - - - - - - - - - - - - - - -
interface

USES cwstring, crt ;

CONST alphabet : widestring ='abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-ø' ;

function creemotaleatoire(taille:integer):widestring;
procedure p1_main(n,s:integer);


// private - - - - - - - - - - - - - - - - - - - - - - - - -
implementation

function creemotaleatoire (taille : integer):widestring ;
    var res : widestring;
        c : unicodeString;
    begin
        // writeln('launched with ',taille);
        res :='';
        c := alphabet[random(length(alphabet))];
        while length(res)<taille do
            begin
            while c<>'ø' do
                begin
                res := res + c;
                c := alphabet[random(length(alphabet))+1];
                end;
            while c='ø' do
                c := alphabet[random(length(alphabet))];
            end;
        creemotaleatoire := res;
    end;

procedure p1_main(n,s:integer);
var i:integer;
Begin
    randomize;
    for i:=1 to n do
        writeln(creemotaleatoire(s));
end;

end.
