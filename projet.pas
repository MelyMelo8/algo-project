Program LingueMachina;

{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}

(*
Fichier principal du projet "La machine à inventer des mots"

Ce fichier utilise les packages proj1, proj2, proj3 et proj4 afin d'être en mesure de créer des mots ou des phrases de manière aléatoire, via plusieurs techniques différentes
La constante help_text contient le texte affiché pour l'aide de ce programme

Authors:
    Arthur Blaise (blaisearth@eisti.eu)
    Loann Pottier (pottierloa@eisti.eu)
Copyright ©2018-2019
*)

USES proj1, proj2, proj3, proj4, SysUtils;

CONST help_text:string =                                                     #10+
'NOM'                                                                       +#10+
'     Projet - La machine à inventer des mots'                              +#10+
                                                                             #10+
'SYNTAXE'                                                                   +#10+
'     projet [OPTIONS]'                                                     +#10+
                                                                             #10+
'DESCRIPTION'                                                               +#10+
'     Génère des mots ou des phrases à partir du dictionnaire FILE'         +#10+
'     -a        utilise la méthode aléatoire pour générer les mots'         +#10+
'     -d        utilise la méthode des digrammes pour générer les mots'     +#10+
'     -t        utilise la méthode des trigrammes pour générer les mots'    +#10+
'     -p        génère une phrase aléatoire'                                +#10+
'     -n NB     génère NB mots (par défaut génère 100 mots)'                +#10+
'     -s NB     affiche uniquement des mots de NB caractères'               +#10+
'     -r FILE   recharge la table de probabilités à partir d''une liste de mots'+#10+
'     -h        affiche cette aide et quitte'                               +#10+
                                                                             #10+
'AUTEURS'                                                                   +#10+
'     Écrit par A. Blaise, L. Pottier' ;



Var i,n,s:integer;r:string;
    help_sent:boolean;
begin
    s:=1;n:=100;r:='';
    help_sent := False;
    if ParamCount=0 then writeln(help_text)
    else
        for i:=1 to ParamCount do
            case ParamStr(i) of
                '-s': if i< ParamCount then try s:= StrToInt(ParamStr(i+1)) ; except continue; end;
                '-n': if i< ParamCount then try n:= StrToInt(ParamStr(i+1)) ; except continue; end;
                '-r': if i< ParamCount then try r:= ParamStr(i+1)           ; except continue; end;
            end;
        for i:=1 to ParamCount do
            case ParamStr(i) of
                '-a': begin p1_main(n,s); break; end;
                '-d': begin P2_main(n,s,r); break; end;
                '-t': begin P3_main(n,s,r); break; end;
                '-p': begin P4_main(n,s); break; end;
            else if not help_sent then
                    begin writeln(help_text);
                    help_sent:=True;
                    end;
            end;
    writeln('');
end.
