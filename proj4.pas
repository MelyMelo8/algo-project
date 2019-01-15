unit proj4;

{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}


//Temps de conjugaison : 1 présent - 2 futur simple

// public  - - - - - - - - - - - - - - - - - - - - - - - - -
interface

USES cwstring, crt, SysUtils, useful;

CONST alphabet : widestring ='abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-ø' ;
CONST menu_txt : widestring = 'Choisissez la compexité de la phrase :'+#10+'1 - Sujet Verbe'+#10+'2 - Sujet Verbe Adjectif'+#10+'3 - Sujet Verbe Adverbe Adjectif'+#10+'4 - Custom';
CONST voyelles : array[1..6] of widestring = ('a','e','i','o','u','y');
CONST neutral:array[0..1] of widestring=('d''','l''');
CONST plural:array[0..1] of widestring=('des','les');
CONST male:array[0..1] of widestring=('un','le');
CONST female:array[0..1] of widestring=('une','la');


procedure p4_main(n,s:integer);
function getRandomWord(filepath:widestring):widestring;
function askSyntax:widestring;
function replaceKeys(syntax:unicodeString):unicodeString;
function upperName(name:unicodeString):unicodeString;
function conjugMain(verb:widestring;sentence:widestring):widestring;
function conjug1(verb:widestring;temps,person:integer):widestring;
function conjug2(verb:widestring;temps,person:integer):widestring;
function getSubject:widestring;


// private - - - - - - - - - - - - - - - - - - - - - - - - -
implementation


procedure p4_main(n,s:integer);
var i,menu:integer; syntax:widestring;
Begin
    randomize;
    writeln(menu_txt);
    write('> ');readln(menu);
    CASE menu OF
        1: syntax:='-s -v';
        2: syntax:='-s -v -j';
        3: syntax:='-s -v -a -j';
        4: syntax := askSyntax;
    else begin writeln('Valeur invalide :/'); Exit;end;
    end;
    if length(syntax)<2 then begin
        writeln('Syntaxe invalide');Exit;
        end;
    for i:=1 to n do
        writeln(replaceKeys(syntax))
    //for i:=1 to n do writeln(getRandomWord('dico/nomPropre.txt'))
end;

function askSyntax:widestring;
Begin
    writeln('Utilisez les clés -s pour générer un sujet, -v pour un verbe, -j pour un adjectif, -a pour un adverbe, -p pour un nom propre et -c pour un nom commun.'+#10+'Tout autre caractère sera laissé tel quel');
    write('> ');readln(askSyntax);
end;

function replaceKeys(syntax:unicodeString):unicodeString;
var i:integer;
begin
    replaceKeys := '';
    i := 0;
    while i < length(syntax) do
        begin
        i := i+1;
        if syntax[i] = '-' then begin
            CASE syntax[i+1] OF
                'a' : replaceKeys := replaceKeys+getRandomWord('dico/adverbe.txt');
                'p' : replaceKeys := replaceKeys+upperName(getRandomWord('dico/nomPropre.txt'));
                'c' : replaceKeys := replaceKeys+getRandomWord('dico/nomCommun.txt');
                'v' : replaceKeys := replaceKeys+conjugMain(getRandomWord('dico/verbePremierEtDeuxiemeGroupe.txt'),replaceKeys);
                's' : replaceKeys := replaceKeys+getSubject;
            else begin replaceKeys := replaceKeys+syntax[i]; i := i-1; end;
            end;
            i := i+1;
            end
        else  replaceKeys := replaceKeys+syntax[i];
        end;
end;

function upperName(name:unicodeString):unicodeString;
var i:integer;
begin
    name[1] := upCase(name[1]);
    for i:=2 to length(name) do
        if name[i-1] = '-' then name[i] := upCase(name[i]);
    upperName := name;
end;

function getRandomWord(filepath:widestring):widestring;
var i,r:integer;
    fic:TextFile;
    res:widestring;
    line:widestring;
Begin
    assign(fic,filepath);
    try
        reset(fic);
        i := 1;
        while not eof(fic) do
            begin
            readln(fic,line);
            i := i+1;
            end;
        r := random(i);
        i := 1;
        close(fic);
        reset(fic);
        while not eof(fic) do
            begin
            readln(fic,line);
            if i=r then begin
                //writeln('find ',line);
                res := line ;
                end;
            i := i+1;
            end;
        close(fic);
        if length(res)=0 then res := getRandomWord(filepath);
        Exit(res);
    except on E: EInOutError do writeln('File handling error occurred. Details: ', E.Message);
    end;
end;


function conjugMain(verb:widestring;sentence:widestring):widestring;
Var root:widestring; person,tense:integer; lastword:widestring; words:listOfWords; //test:widestring;
begin
    if length(verb)<3 then Exit(verb);
    words := splitStr(sentence);
    lastword := lowercase(lastItem(words));
    if length(lastword)=0 then Exit(verb);
    CASE lastword OF
        'je' : person := 1;
        'tu' : person := 2;
        'il' : person := 3;
        'elle' : person := 3;
        'on' : person := 3;
        'nous' : person := 4;
        'vous' : person := 5;
        'ils' : person := 6;
        'elles' : person := 6;
    else person := 3;
    end;
    if length(words)>2 then
        begin
        if StrInArray(lastItem(words,2),plural) then person :=6;
        end;
    tense := random(2)+1;
    root := verb[1..length(verb)-2];
    if (verb[length(verb)] = 'r') and (verb[length(verb)-1] = 'e') and (verb<>'aller') then verb := conjug1(root,tense,person);
    if (verb[length(verb)] = 'r') and (verb[length(verb)-1] = 'i') then verb := conjug2(root,tense,person);
    conjugMain := verb;
end;

function conjug1(verb:widestring;temps,person:integer):widestring;
begin
    if temps=1 then //present
        CASE person OF
            1: conjug1 := verb+'e';
            2: conjug1 := verb+'es';
            3: conjug1 := verb+'e';
            4: conjug1 := verb+'ons';
            5: conjug1 := verb+'ez';
            6: conjug1 := verb+'ent';
        end;
    if temps=2 then //futur
        CASE person OF
            1: conjug1 := verb+'erai';
            2: conjug1 := verb+'eras';
            3: conjug1 := verb+'era';
            4: conjug1 := verb+'erons';
            5: conjug1 := verb+'erez';
            6: conjug1 := verb+'eront';
        end;
end;

function conjug2(verb:widestring;temps,person:integer):widestring;
begin
    if temps=1 then //present
        CASE person OF
            1: conjug2 := verb+'is';
            2: conjug2 := verb+'is';
            3: conjug2 := verb+'it';
            4: conjug2 := verb+'issons';
            5: conjug2 := verb+'issez';
            6: conjug2 := verb+'issent';
        end;
    if temps=2 then //futur
        CASE person OF
            1: conjug2 := verb+'irai';
            2: conjug2 := verb+'iras';
            3: conjug2 := verb+'ira';
            4: conjug2 := verb+'irons';
            5: conjug2 := verb+'irez';
            6: conjug2 := verb+'iront';
        end;
end;

function getSubject:widestring;
var noune:widestring;
begin;
    if random(2)=0 then Exit(upperName(getRandomWord('dico/nomPropre.txt')));
    noune := getRandomWord('dico/nomCommun.txt');
    //noune := 'anthropode';
    if random(2)=0 then // pluriel
        begin
        if (noune[length(noune)] = 'l') and (noune[length(noune)-1] = 'a') then noune := noune[1..length(noune)-2]+'aux'
        else if (noune[length(noune)]<>'s') and (noune[length(noune)]<>'x') then noune := noune+'s';
        noune := plural[random(2)]+' '+noune;
        end
    else begin //singulier
        if StrInArray(noune[1],voyelles) then
            noune := neutral[random(2)] + noune
        else if noune[1]='e' then
            noune := female[random(2)] + ' ' + noune //masculin
            else noune := male[random(2)] + ' ' + noune; //féminin
        end;
    getSubject := noune;
end;


end.
