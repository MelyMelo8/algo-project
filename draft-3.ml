{$mode objfpc}{$H+}
{$codepage UTF8}
{$I-}
USES cwstring, crt;

CONST alphabet : WideString = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"
tablefilename = "letters2.csv"
listfilename = "nameslist.txt"
decimal_precision = 4

procedure append(var liste:array of string; item:string): (* ajoute un item à une liste *)
    for i de 1 à len(liste):
        if liste[i]='':
            liste[i] = item
            exit

function join(liste:array of string; separator:string): string (* renvoie les items d'une liste joins dans une chaine de caractère *)
    result = liste[1]
    for i de 2 à len(liste):
        result = result + separator + liste[i]
    return result


function readTable(): array of array
    fic = file(tablefilename,'read')
    k = 1
    l = 1
    data = array[1..1895]
    for i de 1 à len(fic):
        line = array[1..45]
        case = ''
        if len(fic[i])==0:
            break (* on sort de la boucle *)
        for j de 1 à len(fic[i]):
            if fic[i][j]<>',':
                case = case+fic[i][j]
            elif fic[i][j]='\n':
                continue (* on fait rien et on passe à l'itération suivante *)
            else:
                line[k] = case
                case = ''
                k = k+1
        data[l] = line
        l = l+1
    Return data

function getListWords(): array of string
    fic = file(listfilename,'read') (* liste des lignes *)
    Return fic

function parseWord(word:string;dic:dictionnary): dictionnary
    word = 'ø'+word+'ø'
    for j de 1 à len(word)-2:
        if word[j:j+1] in dic.keys():
            append(dic[word[j:j+1]], word[j+2])
        else:
            dic[word[j:j+1]] = [word[j+2]]
        return dic

prodecure updateTable():
    words = getListWords()
    dic = dictionnary()
    for i de 1 à len(words):
        if len(words[i])==0:
            continue
        dic = parseWord(words[i],dic)
    table = readTable()
    ref = table[1]
    fic = file(tablefilename,'write')
    fic.write(','.join(table[0])+',\n')
    for i de 2 à len(table):
        line = table[i]
        for j de 2 à len(line):
            if line[1] in dic.keys():
                line[j] = str( round(dic[line[1]].count(ref[j])/len(dic[line[1]]), decimal_precision) )
            else:
                line[j] = '0.0'
        fic.write(','.join(line)+',\n')

function searchline(letters:string;tableau:array): array
    tableau = readTable()
    for i de 1 à len(tableau)
        if tableau[i][1] = letters
            Return tableau[i]
    Return None

function getNextLetter(letters:string;tableau:array=None): char
    randomize();
    if tableau=None:
        tableau = readTable()
    if len(letters)=1:
        letters = 'ø'+letters
    probas = searchline(letters,tableau)
    inc = 0.0
    goal = random() (* entre 0 et 1 *)
    i = 1
    while inc<goal:
        i = i+1
        if i=len(probas):
            break
        inc = inc + float(probas[i])
    return tableau[1][i]

function getWord(firstletter:char=None): string
    if firstletter = None:
        word = 'ø'+alphabet[random(1,27)] (* lettre aléatoire *)
    else:
        word = 'ø'+firstletter
    ch = ''
    tableau = readTable()
    while ch<> 'ø':
        temp = word[-2]+word[-1] (* deux derniers caractères du mot *)
        ch = getNextLetters(temp,tableau)
        word = word+ch
    return word[2:-2] (* on exclu le premier et dernier caractère, qui correspondent normalement à 'ø' *)

function getSentence(len:integer=0):string
    if len = 0:
        len = random(15)+5 (* random entre 5 et 20 *)
    sentence = array[1..len] of string
    while len(sentence)<len:
        append(sentence,getWord())
    return join(sentence,' ')

function addWord(word:string,push:boolean=True): boolean
    liste = getListWords()
    word = lower(word) (* on remplace toutes les majuscules par des minuscules *)
    if word in liste:
        Return False
    fic = file(listfilename,'append')
    fic.append(word+'\n')
    if push:
        updateTable()
    return True

procedure addText(text:WideString):
    word = ''
    text = ' '+lower(text)
    count = [0,0]
    for i de 1 à len(text):
        if text[i] in alphabet:
            word = word+text[i]
        elif len(word)>0:
            count[1] = count[1]+1
            if addWord(word,False):
                count[1] = count[1] + 1
            word = ''
    updateTable()
    p = round(cout[2]*100/count[1])
    writeln(c[2],' mots ajoutés sur 'c[1],' (',p,'%)')
