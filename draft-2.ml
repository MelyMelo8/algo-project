{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}
USES cwstring, crt;

CONST alphabet : WideString = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"


function lireTableau(): array of array
    fic = fichier
    k = 0
    l = 0
    data = array[0..45]
    for i de 0 à len(fic):
        line = array[0..45]
        for j de 0 à len(fic[i]):
            if fic[i][j]<>';':
                case = case+fic[i][j]
            else if:
                line[k] = case
                case = ""
                k = k+1
        data[l] = line
        l = l+1
    Return data

function searchLine(letter): array
    tableau = lireTableau()
    for i de 0 à len(tableau):
        if tableau[i][0] = letter:
            Return tableau[i]
    Return None

function getNextLetter(letter):char
    randomize();
    probas = searchLine(letter)
    total = 0
    for i de 1 à len(probas):
        total += probas[i]
    liste = array[0..total]
    k = 0
    for i de 1 à len(probas):
        for j de 1 à Round(int(probas[i])*1.5):
            liste[k] = alphabet[i]
    result = liste[Eandom(total)]

Procedure addWord(word):
    tableau = lireTableau
    i,j,k = 0
    while tableau[0][i]<>word[i]:
        i = i+1
    tableau[1][i] = tableau[1][i]+1
    for i de 0 à len(word)-2:
        while tableau[j][0]<>word[i]:
            j = j+1
        while tableau[0][k]<>word[i+1]:
            k = k+1
        tableau[j][k] = tableau[j][k]+1
    i = 0
    while tableau[0][i]<>word[len(word)]:
        i = i+1
    tableau[i][len(tableau[0])] = tableau[i][len(tableau[0])]+1

function Begin():
    result = ""
    ch = getNextLetter("begin")
    while ch<>"fin":
        result = result+ch
        ch = getNextLetter(ch)
    Return result