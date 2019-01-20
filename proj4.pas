unit proj4;

{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}
(*
Ce fichier définit les fonctions nécessaires à la quatrième question du projet, la création de phrases à partir de listes de mots. Ici il n'est pas question de probabilité, mais uniquement du hasard : les mots sont tirés parmi des listes contenues dans le dossier 'dico' en fonction du type de mot nécessaire. Il existe 5 types de mots utilisables : les adjectifs, les adverbes, les articles, les noms communs, les noms propres et les verbes.
La procédure principale demande à l'utilisateur de saisir une syntaxe particulière parmi une liste de syntaxes pré-définies, mais il est aussi possible de sélectionner sa propre syntaxe. Ensuite les autres fonctions analysent la syntaxe et placent correctement les mots nécessaires, en essayant d'accorder en genre et en nombre les noms communs, adjectifs et verbes.
Les entiers utilisés pour les temps de conjugaison sont 1 pour le présent, 2 pour le futur simple et 3 pour l'imparfait


- 'p4_main' est la procédure principale, appelée par le programme mère, et affiche n phrases générées à partir de la syntaxe donnée par l'utilisateur
- 'menu_txt' contient le message d'aide lors de la sélection de la syntaxe
- 'voyelles' est une liste de toutes les voyelles, utilisée lors de la génération du sujet pour élider l'article d'un sujet (l'innocence au lieu de la innocence)
- 'neutral', 'plural', 'male' et 'female' référencent les articles utilisables lors de la création d'un sujet. Neutral correspond aux articles élidés, les trois autres sont asesz explicites
- 'punctuation' contient la liste des ponctuations utilisées à la fin de chaque phrase. Une seule est tirée de manière aléatoire
- la fonction 'getRandomWord' tire une ligne aléatoire parmi celles contenues dans un fichier. Le chemin d'accès du fichier est renseigné en argument
- 'askSyntax' est une fonction demandant la syntaxe custom à utiliser lorsque l'utilisateur ne veut pas d'une syntaxe pré-définie
- 'replaceKeys' est une autre fonction majeure du programme, qui prend en paramètre la syntaxe de la phrase et remplace chaque mot-clé par un mot correspondant, suivant un schéma défini ('-v' pour un verbe, '-s' pour un sujet etc)
- 'upperName' permet de mettre les majuscules à un nom propre : une sur le premier caractère, et une autre après chaque tiret
- 'conjugMain' s'occupe de la conjugaison d'un verbe en l'accordant à l'article précédent. Cet article est cherché par l'algorithme jusqu'à 3 mots avant le verbe, et s'il n'est pas trouvé, la personne utilisée est la 3e du singulier
- 'conjug1' et 'conjug2' sont deux fonctions s'occupant de conjuger un verbe du premier ou du deuxième groupe grâce au temps et à la personne définie par 'conjugMain'
- 'getSubject' et 'getAdj' sont deux autres fonctions générant respectivement un sujet et un adjectif. Chacun s'accorde le mieux possible selon le contexte de la phrase générée
- 'getGenre' prend un mot en paramètre et, si ce mot est un article, renvoie le genre correspondant (0 : neutre, 1 : pluriel, 2 : masculin, 3 : féminin)

Author: Arthur Blaise (blaisearth@eisti.fr) - ©2018-2019
*)



// public  - - - - - - - - - - - - - - - - - - - - - - - - -
interface

USES cwstring, crt, SysUtils, useful;

CONST menu_txt : widestring = 'Choisissez la compexité de la phrase :'+#10+'1 - Sujet Verbe'+#10+'2 - Sujet Verbe Adjectif'+#10+'3 - Sujet Verbe Adverbe Adjectif'+#10+'4 - Custom';
CONST voyelles : array[1..6] of widestring = ('a','e','i','o','u','y');
CONST neutral:array[0..1] of widestring=('d''','l''');
CONST plural:array[0..1] of widestring=('des','les');
CONST male:array[0..1] of widestring=('un','le');
CONST female:array[0..1] of widestring=('une','la');
CONST punctuation:array[0..4] of widestring=('...','.',' !',' ','.');


procedure p4_main(n:integer);
function getRandomWord(filepath:widestring):widestring;
function askSyntax:widestring;
function replaceKeys(syntax:unicodeString):unicodeString;
function upperName(name:unicodeString):unicodeString;
function conjugMain(verb:widestring;sentence:widestring):widestring;
function conjug1(verb:widestring;temps,person:integer):widestring;
function conjug2(verb:widestring;temps,person:integer):widestring;
function getSubject:widestring;
function getGenre(word:widestring):integer;
function getAdj(adj,sentence:widestring):widestring;


// private - - - - - - - - - - - - - - - - - - - - - - - - -
implementation


procedure p4_main(n:integer);
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
                'j' : replaceKeys := replaceKeys+getAdj(getRandomWord('dico/adjectif.txt'),replaceKeys);
            else begin replaceKeys := replaceKeys+syntax[i]; i := i-1; end;
            end;
            i := i+1;
            end
        else  replaceKeys := replaceKeys+syntax[i];
        end;
    replaceKeys[1] := upCase(replaceKeys[1]);
    if (replaceKeys[length(replaceKeys)]<>'.') and (replaceKeys[length(replaceKeys)]<>'!') then replaceKeys := replaceKeys+punctuation[random(high(punctuation)+1)];
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
Var root:widestring; person,tense,genre:integer; lastword:widestring; words:listOfWords; //test:widestring;
begin
    if length(verb)<3 then Exit(verb);
    words := splitStr(sentence);
    lastword := lowercase(lastItem(words));
    genre := getGenre(lowercase(lastItem(words,1)));
    if genre = 4 then genre := getGenre(lowercase(lastItem(words,2))); // si le mot ne correspond pas, on cherche un mot plus loin (dans le cas d'un adjectif par exemple)
    if genre = 4 then genre := 2; // si on ne trouve toujours pas, on arrête les recherches et on prend par défaut, masculin singulier
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
    else person := 7;
    if (genre=1) and (person=7) then person:=6
    else if person=7 then person:=3;
    end;
    if length(words)>2 then
        begin
        if StrInArray(lastItem(words,2),plural) then person :=6;
        end;
    tense := random(3)+1;
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
    if temps=3 then //imparfait
        CASE person OF
            1: conjug1 := verb+'ais';
            2: conjug1 := verb+'ais';
            3: conjug1 := verb+'ait';
            4: conjug1 := verb+'ions';
            5: conjug1 := verb+'iez';
            6: conjug1 := verb+'aient';
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
    if temps=3 then //imparfait
        CASE person OF
            1: conjug2 := verb+'ais';
            2: conjug2 := verb+'ais';
            3: conjug2 := verb+'ait';
            4: conjug2 := verb+'ions';
            5: conjug2 := verb+'iez';
            6: conjug2 := verb+'aient';
        end;
end;

function getSubject:widestring;
var noune:widestring;
begin;
    if random(2)=0 then Exit(upperName(getRandomWord('dico/nomPropre.txt')));
    noune := getRandomWord('dico/nomCommun.txt');
    if random(2)=0 then // pluriel
        begin
        if (noune[length(noune)] = 'l') and (noune[length(noune)-1] = 'a') then noune := noune[1..length(noune)-2]+'aux'
        else if (noune[length(noune)]<>'s') and (noune[length(noune)]<>'x') then noune := noune+'s';
        noune := plural[random(2)]+' '+noune;
        end
    else begin //singulier
        if StrInArray(noune[1],voyelles) then
            noune := neutral[random(2)] + noune
        else if noune[length(noune)]='e' then
            noune := female[random(2)] + ' ' + noune     // masculin
            else noune := male[random(2)] + ' ' + noune; // féminin
        end;
    getSubject := noune;
end;

function getGenre(word:widestring):integer;
Begin
    if StrInArray(word,neutral) then getGenre      := 0    // le nom commence par une voyelle et est au singulier
    else if StrInArray(word,plural) then getGenre  := 1    // le nom est au pluriel
    else if StrInArray(word,male) then getGenre    := 2    // le nom est au masculin singulier
    else if StrInArray(word,female) then getGenre  := 3    // le nom est au féminin singulier
    else getGenre := 4 //aucune idée ¯\_(ツ)_/¯
end;

function getAdj(adj,sentence:widestring):widestring;
var genre:integer; words:listOfWords;
begin
    words := splitStr(sentence);
    genre := getGenre(lowercase(lastItem(words,3)));
    if genre = 4 then genre := getGenre(lowercase(lastItem(words,4))); // si le mot ne correspond pas, on cherche un mot plus loin (dans le cas d'un adjectif par exemple)
    if genre = 4 then genre := 2; // si on ne trouve toujours pas, on arrête les recherches et on prend par défaut, masculin singulier
    CASE genre OF
        1: if (adj[length(adj)]<>'x') and (adj[length(adj)]<>'s') then adj := adj+'s';
        3: if adj[length(adj)]<>'e' then adj := adj+'e';
    end;
    getAdj := adj;
end;


end.
