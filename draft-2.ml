{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}
USES cwstring, crt;

CONST alphabet : WideString = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"
CONST filename = 'letters.cvs'

function readTable(): array of array
    fic = file(filename,'read')
    k = 0
    l = 0
    data = array[0..45]
    for i de 1 à 45:
        line = array[0..45]
        case = ""
        if len(fic[i])=0:
            break
        for j de 1 à len(fic[i]):
            if fic[i][j]<>',':
                case = case+fic[i][j]
            elif fic[i][j] == '\n':
                continue (* ici on fait rien *)
            else:
                line[k] = case
                case = ""
                k = k+1
        data[l] = line
        l = l+1
    Return data

function updateTable(table):
    for x de 1 à len(table):
        for y de 1 à len(table[x]):
            table[x][y] = str(table[x][y])
    fic = file(filename,'w')
    for line in table:
        fic.write(','.join(line)+',\n')

function searchLine(letter): array
    tableau = readTable()
    for i de 1 à len(tableau):
        if tableau[i][1] = letter:
            Return tableau[i]
    Return None

function getNextLetter(letter):char
    randomize();
    probas = searchLine(letter)
    liste = array[1..??]
    k = 0
    for i de 1 à len(probas):
        for j de 1 à Round(int(probas[i])*1.5):
            liste[k] = str(alphabet+'ø')[i-1]
            k = k+1
    if len(liste)>0:
        Return liste[Random(len(liste))]
    else:
        return 'ø'

Procedure addWord(word,push=True,tableau=None):
    if tableau=None:
        tableau = readTable()
    i,j,k = 1
    while tableau[1][i]<>word[1]:
        i = i+1
    tableau[1][i] = int(tableau[1][i])+1
    for i de 1 à len(word)-2:
        while tableau[j][1]<>word[i]: (* on cherche la ligne *)
            j = j+1
        while tableau[1][k]<>word[i+1]: (* puis la colonne *)
            k = k+1
        tableau[j][k] = int(tableau[j][k])+1
        j,k = 1
    i = 1
    while tableau[i][1]<>word[len(word)]:
        i = i+1
    tableau[i][len(tableau[1])] = int(tableau[i][len(tableau[1])])+1

Procedure addText(text):
    tableau = None
    temp = ''
    count = 0
    for ch in text:
        if ch in alphabet:
            temp = temp+ch
        else:
            if len(temp)>0:
                tableau = addWord(temp,False,tableau)
                temp = ''
                count = count+1
    if len(temp)>0:
        tableau = addWord(temp,False,tableau)
        temp = ''
        count = count+1
    updateTable(tableau)
    writeln(count,' mot ajoutés !')

function getWord():
    result = ''
    ch = getNextLetter('ø')
    while ch<>'ø':
        result = result+ch
        ch = getNextLetter(ch)
    Return result

function getSentence(words=0):
    randomize();
    if words = 0:
        words = random(15)+5
    result = ''
    for _ in range(words):
        result = result + ' '+getWord()
    return result
