unit useful;

{$mode objfpc}
{$h+ }
(*
Ce package défini plusieurs fonctions utiles pour les autres fichiers du projet. Ces fonctions sont inspirées du langage Python, et permettent une manipulation plus aisée des listes (ou 'Arrays').

- 'StrInArray' cherche si une chaine de caractère se trouve dans une liste de strings : renvoie un booléen indiquant la présence
- 'RealInArray' est identique à 'StrInArray' mais pour un réel
- 'join' renvoie une chaine de caractères composée de toutes les strings d'une liste, mises bout à bout grâce au séparateur
- 'joinReal' et 'joinInt' sont identiques à 'join', mais pour des listes de réels ou d'entiers
- 'round2' arrondit un réel avec un certain nombre de chiffres après la virgule. L'argument 'precision' doit être une puissance de 10
- 'readFile' est une fonction qui lit un fichier et en renvoie les 50000 premières lignes. L'argument 'page' définit à partir de quelle ligne il faut commencer à compter
- 'indexInString' cherche la position d'un caractère dans une chaine de charatcères. C'est équivalent au pos() natif de Pascal
- 'splitStr' sépare une chaine de caractères en plusieurs fragments (maximum 100) en fonction d'un séparateur donné
- 'lastItem' renvoie la dernière valeur non vide d'une liste de widestring

Author: Arthur Blaise (blaisearth@eisti.fr) - ©2018-2019
*)


// public  - - - - - - - - - - - - - - - - - - - - - - - - -
interface

USES SysUtils, cwstring;

CONST alphabet : widestring = 'abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-ø' ;

Type lineOfProbas = array[1..44] of real;
Type tableOfProba = array[1..44] of lineOfProbas;
Type linesOfFile = array [1..50000] of widestring;
Type tableofFile = array[1..20] of linesOfFile; //les listes pascal ne sont pas assez grande pour contenir autant de lignes
Type listOfWords = array[1..100] of widestring;

function StrInArray(value:widestring; ArrayOfString:array of widestring): boolean;
function RealInArray(value:real; ArrayOfReals:array of real): boolean;
function join(liste:array of string; separator:string): string;
function joinReal(liste:array of real; separator:string): string;
function joinInt(liste:array of integer; separator:string) : string;
function round2(number:real; precision:integer): real;
function readFile(path:string;page:integer): linesOfFile;
function indexInString(list:widestring;item:UnicodeString):integer;
function splitStr(list:widestring;separator:unicodeString=' '):listOfWords;
function lastItem(list:array of widestring;rang:integer=1):widestring;


// private - - - - - - - - - - - - - - - - - - - - - - - - -
implementation

function StrInArray(value:widestring; ArrayOfString:array of widestring) : boolean;
var loop : widestring;
Begin
  for loop in ArrayOfString do
    if value = loop then
      Exit(true) ;
  result := false;
end;

function RealInArray(value:real; ArrayOfReals:array of real) : boolean;
var loop : real;
Begin
  for loop in ArrayOfReals do
  Begin
    if value = loop then
      Exit(true)
  end;
  result := false;
end;

function join(liste:array of string; separator:string) : string;
var i:integer;
    sortie : string;
Begin
  sortie := liste[1];
  for i:=2 to length(liste) do
    sortie := sortie + separator + liste[i];
  join := sortie;
end;

function joinReal(liste:array of real; separator:string) : string;
var i:integer;
    sortie : string;
Begin
  sortie := FloatToStr(liste[1]);
  for i:=2 to length(liste) do
    sortie := sortie + separator + FloatToStr(liste[i]);
  joinReal := sortie;
end;

function joinInt(liste:array of integer; separator:string) : string;
var i:integer;
    sortie : string;
Begin
  sortie := IntToStr(liste[1]);
  for i:=2 to length(liste) do
    sortie := sortie + separator + IntToStr(liste[i]);
  joinInt := sortie;
end;

function round2(number:real;precision:integer) : real;
begin;
    round2 := round(number*precision)/precision;
end;

function readFile(path:string;page:integer):linesOfFile;
var line:widestring;
    fic:TextFile;
    lines:linesOfFile;
    i,p:integer;
begin
    line := '';
    { $i- }
    assignFile(fic,path) ;
    reset(fic) ;
    if (IOResult <> 0) then
        writeln('le fichier ',path,' n'' existe_pas' )
    else
        begin
        i := 1;
        p := 1;
        repeat
            readln(fic,line);
            if p>=page then begin
                lines[i] := line;
                i := i+1;
                end;
            p := p+1;
            if i=length(lines) then
                break;
            until eof(fic);
        end;
    close(fic) ;
    readFile := lines ;
end;

function indexInString(list:widestring;item:UnicodeString):integer;
var i:integer;
begin
for i:=1 to length(list) do
  if list[i] = item then
    Exit(i) ;
Exit(-1);
end;

function splitStr(list:widestring;separator:unicodeString=' '):listOfWords;
var i:integer;c:unicodeString;
begin
    i := 1;
    for c in list do
        if c=separator then
            begin
            i := i+1;
            splitStr[i] := '';
            end
        else splitStr[i] := splitStr[i]+c ;
end;

function lastItem(list:array of widestring;rang:integer=1):widestring;
var i,ground:integer;
begin
    ground := Low(list);
    for i:=ground+rang to length(list) do
        begin
        if (length(list[i])<1) and (i>ground) then Exit(list[i-rang]);
        end;
    Exit(list[length(list)]);
end;

end.
