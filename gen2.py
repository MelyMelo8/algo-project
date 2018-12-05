l = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"  # liste des caractères possibles
# le symbole 'ø' sert à désigner un espace vide (au début ou à la fin du mot)
# le symbole ',' est le délimiteur des cases du tableau. C'est le caractère généralelment utilisé pour ce genre de cas (voir le type de fichier .csv pour plus d'info')
with open('letters2.csv','w',encoding='utf-8') as file:
    file.write('  ,ø,'+','.join(l)+',\n')
    n = len(l)+1
    file.write('øø,'+'0,'*n+'\n')
    for i in 'ø'+l:
        for j in l:
            file.write(i+j+','+'0,'*n+'\n')
