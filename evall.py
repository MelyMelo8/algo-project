import sys, traceback

txt = "lol"
while txt!="":
    txt = input('>>> ')
    if txt=='':
        break
    try:
        print(eval(txt))
    except:
        try:
            exec(txt)
        except:
            print(traceback.format_exc())
