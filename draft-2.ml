{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}
USES cwstring, crt;

CONST alphabet : WideString = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"
CONST tablefilename = 'letters.cvs'
CONST listfilename = 'nameslist.txt'
decimal_precision = 4

function readTable(): array of array
    fic = file(filename,'read')
    k,l = 0
    data = array[0..45]
    for i de 1 à 45:
        line = array[0..45]
        case = ''
        if len(fic[i])=0:
            break
        for j de 1 à len(fic[i]):
            if fic[i][j]<>',':
                case = case+fic[i][j]
            elif fic[i][j] == '\n':
                continue (* ici on fait rien *)
            else:
                line[k] = case
                case = ''
                k = k+1
        data[l] = line
        l = l+1
    Return data

procedure updateTable():
    words = file(listfilename,'read') (* liste des mots *)
    dic = dictionnary
    for x de 1 à len(table):
        if len(words[i]) = 0:
            continue
        dic = parseWord(words[i],dic)
    table = readTable()
    ref = table[0]
    fic = file(tablefilename,'write')
    fic.write(','.join(table[0])+'\n')
    for i de 2 à len(table):
        line = table[i]
        for j de 2 à len(line):
            if line[0] in dic.keys():
                line[j] = str( round(dic[line[1]].count(ref[j])/len(dic[line[1]]), decimal_precision) )
            else:
                line[j] = '0.0'
        fic.write(','.join(line)+',\n')

function parseWord(word,dic): dictionnary
    word = 'ø'+word+'ø'
    for j de 1 à len(word)-1:
        if word[j] in dic.keys():
            dic[word[j]].append(word[j+1])
        else:
            dic[word[j]] = [word[j+1]]
    return dic

function searchLine(letter,tableau=None): array or None
    if tableau = None:
        tableau = readTable()
    for i de 1 à len(tableau):
        if tableau[i][1] = letter:
            Return tableau[i]
    Return None

function getNextLetter(letter,tableau=None):char
    randomize();
    if tableau=None:
        tableau = readTable()
    probas = searchLine(letter,tableau)
    inc = 0.0 (* incrément *)
    goal = random() (* entre 0 et 1 *)
    i = 0
    while inc<goal:
        i = i+1
        inc = inc+float(probas[i]) (* on ajoute la proba de cette lettre à l'incrément *)
    return tableau[0][i]

function getWord(firstletter=None): string
    if firstletter=None:
        word = 'ø'
    else:
        word = 'ø'+firstletter
    ch = ''
    while ch<>'ø':
        ch = getNextLetter(word[-1]) (* -1 désigne le dernier caractère *)
        word = word+ch
    Return word[2:-1]

function getSentence(words=0): string
    if words = 0:
        words = random(15)+5
    sentence = array[1..words]
    for i de 1 à words:
        sentence[i] = getWord()
    return ' '.join(sentence)

function getListWords(): array of string
    fic = file(listfilename,'read')
    return fic.split('\n') (* liste des lignes *)

funtcion addWord(word,push=True): boolean (* booléen indiquant si le mot a bien été ajouté *)
    liste = getListWords()
    word = word.lower() (* on met toutes les lettres en minuscules *)
    if word in liste:
        return False
    fic = file(listfilename,'append')
    fic.write(word)
    if push:
        updateTable()
    return True

Procedure addText(text):
    word = ''
    text = ' '+text.lower()
    count = [0,0]
    for i de 1 à len(texte):
        if text[i] in alphabet:
            word = word+text[i]
        elif len(word)>0:
            count[0] = count[0]+1
            if addWord(word,False):
                count[1] = count[1]+1
            word = ''
    updateTable()
    p=round(count[1]*100/count[0])
    writeln(c[1],' mots ajoutés sur ',c[0],' (',p,'%)')
