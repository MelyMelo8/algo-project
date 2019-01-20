unit proj1;

{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}
(*
Ce fichier définit les fonctions nécessaires à la première question du projet, à savoir la création de mots de manière complètement aléatoire. N'utilisant aucun fichier, aucune table de probabilité, ce programme s'en trouve réduit au strict minimum.
Comme dans les autres fichiers de projet, la fonction p1_main est appelée par le programme mère afin de générer un certain nombre de mots. Les variables n et s sont respectivement utilisées pour définir le nombre de mots et la longueur de ceux-ci.


- 'alphabet' contient la liste de tout les caractères qu'il est possible de retrouver dans un mot. Le caractère spécial 'ø' est utilisé pour définir la fin d'un mot, il ne sera jamais affiché en sortie
- 'creemotaleatoire' est une fonction qui crée un mot de contenu et longueur aléatoire, à partir de la taille minimale. Pour faire simple, la fonction ajoute des caractères un par un au mot jusqu'à trouver 'ø', indiquant la fin du mot
- 'p1_main' est la procédure principale, appelée par le programme mère, et affiche n mots générés

Author: Arthur Blaise (blaisearth@eisti.fr) - ©2018-2019
*)


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
        c : widestring;
    begin
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
                c := alphabet[random(length(alphabet))+1];
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
