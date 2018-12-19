import random

alphabet = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"
tablefilename = "letters2.csv"
listfilename = "nameslist.txt"
decimal_precision = 4

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

def getListWords():
    with open(listfilename,'r',encoding='utf-8') as file:
        l = file.read().split('\n')
    return l

def parseWord(word,dic):
    word = 'ø'+word+'ø'
    for j in range(len(word)-2):
        if word[j:j+2] in dic.keys():
            dic[word[j:j+2]].append(word[j+2])
        else:
            dic[word[j:j+2]] = [word[j+2]]
    return dic

def updateTable():
    words = getListWords()
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
                    line[j] = str( round(dic[line[0]].count(ref[j])/len(dic[line[0]]), decimal_precision) )
                else:
                    line[j] = '0.0'
            file.write(','.join(line)+',\n')

def searchLine(letters,tableau=None):
    if tableau==None:
        tableau = readTable()
    for i in range(0,len(tableau)):
        if tableau[i][0] == letters:
            return tableau[i]
    return None

def getNextLetters(letters,tableau=None):
    if tableau==None:
        tableau = readTable()
    if len(letters)==1:
        letters = 'ø'+letters
    probas = searchLine(letters,tableau)
    inc = 0.0
    goal = random.random()
    i = 0
    while inc<goal:
        i = i+1
        if i==len(probas):
            i = i-1
            break
        inc = inc + float(probas[i])
    return tableau[0][i]

def getWord(firstletter=None):
    if firstletter == None:
        word = 'ø'+alphabet[random.randint(0,27)]
    else:
        word = 'ø'+firstletter
    ch = ''
    tableau = readTable()
    while ch != 'ø':
        temp = word[-2]+word[-1]
        ch = getNextLetters(temp,tableau)
        word += ch
    return word[1:-1]

def getSentence(minlen=random.randint(5,20)):
    sentence = []
    while len(sentence)<minlen:
        sentence.append(getWord())
    return " ".join(sentence)

def addWord(word,push=True):
    liste = getListWords()
    word = word.lower()
    if word in liste:
        return False
    with open(listfilename,'a',encoding='utf-8') as file:
        file.write(word+'\n')
    if push:
        updateTable()
    return True

def addText(text):
    word = ""
    text = ' '+text.lower()
    count = [0,0]
    for i in range(len(text)):
        if text[i] in alphabet:
            word += text[i]
        elif len(word)>0:
            count[0] += 1
            if addWord(word,False):
                count[1] += 1
            word = ""
    updateTable()
    print("{c[1]} mots ajoutés sur {c[0]} ({p}%)!".format(c=count,p=round(count[1]*100/count[0])))
