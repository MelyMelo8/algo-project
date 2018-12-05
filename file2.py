import random

alphabet = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"
filename = "letters.csv"

def readTable():
    with open(filename,'r',encoding='utf-8') as file:
        fic = file.read().split("\n")
    l = 0
    k = 0
    data = list()
    for i in range(0,len(fic)):
        line = []
        case = str()
        if len(fic[i])==0:
            break
        for j in range(0,len(fic[i])):
            if fic[i][j] != ',':
                case +=  fic[i][j]
            elif fic[i][j] == '\n':
                continue
            else:
                line.append(case)
                case = str()
                k += 1
        data.append(line)
        l += 1
    return data

def updateTable(table):
    for x in range(len(table)):
        for y in range(len(table[x])):
            table[x][y] = str(table[x][y])
    with open(filename,'w',encoding='utf-8') as file:
        for line in table:
            file.write(','.join(line)+',\n')

def searchLine(letter):
    tableau = readTable()
    for i in range(0,len(tableau)):
        if tableau[i][0] == letter:
            return tableau[i]
    return None

def getNextLetter(letter):
    probas = searchLine(letter)
    liste = list()
    for i in range(1,len(probas)):
        for _ in range(0, round(int(probas[i])*1.5)):
            liste.append(str(alphabet+"ø")[i-1])
    if len(liste)>0:
        return liste[random.randint(0,len(liste)-1)]
    else:
        return 'ø'

def getWord():
    result = str()
    ch = getNextLetter('ø')
    while ch != 'ø':
        result += ch
        ch = getNextLetter(ch)
    return result

def getSentence(words = random.randint(5,20)):
    result = getWord()
    for _ in range(words):
        result += " "+getWord()
    return result

def addWord(word,push=True,tableau=None):
    if tableau==None:
        tableau = readTable()
    i = j = k = 0
    word = word.lower()
    while tableau[0][i] != word[0]:
        i += 1
    tableau[1][i] = int(tableau[1][i])+1
    for i in range(0,len(word)-1):
        while tableau[j][0] != word[i]:
            j += 1
        while tableau[0][k] != word[i+1]:
            k += 1
        tableau[j][k] = int(tableau[j][k])+1
        j = k = 0
    i = 0
    while tableau[i][0] != word[len([word])-1]:
        i = i+1
    tableau[i][len(tableau[0])-1] = int(tableau[i][len(tableau[0])-1])+1
    if push:
        updateTable(tableau)
    else:
        return tableau

def addText(text):
    tableau = None
    temp = str()
    count = 0
    for ch in text:
        if ch in alphabet:
            temp += ch
        else:
            if len(temp)>0:
                tableau = addWord(temp,False,tableau)
                temp = ""
                count += 1
    if len(temp)>0:
            tableau = addWord(temp,False,tableau)
            temp = ""
            count += 1
    updateTable(tableau)
    print(count,"mot ajoutés !")
