{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}
USES cwstring, crt;

CONST alphabet : WideString = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"

function creeMotAleatoire(taille):widestring
    randomize();
    result = ""
    for i de 1 à taille:
        result = result + alphabet[random(len(alphabet))]
    Return result
