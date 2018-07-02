import os

def returnPath():
    
    path = os.path.dirname(__file__)
    file = open("path.txt",'w')
    file.write(path)
    file.close()

returnPath()