import random

alphabet = "abcdefghijklmnopqrstuvwxyzàâéèêëîïôùûüÿæœç-"

def creeMotAleatoire(taille):
    result = ""
    for _ in range(0,taille):
        result += alphabet[random.randint(0,len(alphabet)-1)]
    return result
