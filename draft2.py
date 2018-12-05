import random

alphabet = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"
tablefilename = "letters.csv"
listfilename = "nameslist.txt"

def readTable():
    with open(tablefilename,'r',encoding='utf-8') as file:
        fic = file.read().split('\n')
    l = k = 0
    data = list()
    for i in range(0,len(fic)):
        line = []
        case = str()
        if len(fic[i])==0:
            break
        for j in range(0,len(fic[i])):
            if fic[i][j] != ',':
                case += fic[i][j]
            elif fic[i][j] == '\n':
                continue
            else:
                line.append(case)
                case = str()
                k += 1
        data.append(line)
        l += 1
    return data

def parseWord(word,dic):
    word = 'ø'+word+'ø'
    for j in range(len(word)-1):
        if word[j] in dic.keys():
            dic[word[j]].append(word[j+1])
        else:
            dic[word[j]] = [word[j+1]]
    return dic

def updateTable():
    with open(listfilename,'r',encoding='utf-8') as file:
        words = file.read().split('\n')
    dic = dict()
    for i in range(len(words)):
        if len(words[i])==0:
            continue
        dic = parseWord(words[i],dic)
    table = readTable()
    ref = table[0]
    with open(tablefilename,'w',encoding='utf-8') as file:
        file.write(','.join(table[0])+',\n')
        for i in range(1,len(table)):
            line = table[i]
            for j in range(1,len(line)):
                if line[0] in dic.keys():
                    line[j] = str( round(dic[line[0]].count(ref[j])/len(dic[line[0]]),3) )
                else:
                    line[j] = '0.0'
            file.write(','.join(line)+',\n')

def searchLine(letter,tableau=None):
    if tableau==None:
        tableau = readTable()
    for i in range(0,len(tableau)):
        if tableau[i][0] == letter:
            return tableau[i]
    return None

def getNextLetter(letter,tableau=None):
    if tableau==None:
        tableau = readTable()
    probas = searchLine(letter,tableau)
    inc = 0.0
    goal = random.random()
    i = 0
    while inc<goal:
        i += 1
        inc += float(probas[i])
    return tableau[0][i]
