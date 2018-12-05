l = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"  # liste des caractères possibles
# le symbole ',' est le délimiteur des cases du tableau. C'est le caractère généralelment utilisé pour ce genre de cas (voir le type de fichier .csv pour plus d'info')
with open('letters.csv','w',encoding='utf-8') as file:
    file.write(' ,'+','.join(l)+',ø,\n')
    n = len(l)+1
    for i in 'ø'+l:
        file.write(i+','+'0,'*n+'\n')
