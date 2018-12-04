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

Procedure addWord(word):
    tableau = lireTableau()
    i,j,k = 0
    word = "ø"+word+"ø"
    for i de 1 à len(word)-1:
        while tableau[j][0]<>word[i,i+1]: (* on cherche la ligne *)
            j = j+1
        while tableau[0][k]<>word[i+1]: (* puis la colonne *)
            k = k+1
        tableau[j][k] = tableau[j][k]+1