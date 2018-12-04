{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}
USES cwstring, crt;

CONST alphabet : WideString = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"


function readTable(): array of array
    fic = fichier
    k = 0
    l = 0
    data = array[0..1895]
    for i de 1 à len(fic):
        line = array[0..45]
        case = ""
        for j de 0 à len(fic[i]):
            if fic[i][j]<>';':
                case = case+fic[i][j]
            else:
                line[k] = case
                case = ""
                k = k+1
        data[l] = line
        l = l+1
    Return data

function searchline(letters): array
    tableau = readTable()
    for i de 1 à len(tableau)
        if tableau[i][1] = letters
            Return tableau[i]
    Return None

function getNextLetter(letters): char
    randomize();
    probas = searchline(letters)
    total = 0
    liste = array[1..??]
    k = 0
    for i de 1 à len(probas):
        for j de 1 à Round(int(probas[i])*1.5):
            liste[k] = alphabet[i]
    Return liste[Random(total)]
