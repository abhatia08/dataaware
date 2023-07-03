"""Chardle
Program Description: create a program that asks the user for a 5 letter word. Then ask the user for a character. The program will output the index 
where the character is found in the word and the amount of times that character appears in the 5 letter word.

"""

# Ask user for a 5 letter word
five_chr_word: str = input("Enter a 5 character word: ")

# What if the user enters a word that is not 5 letters?
if (len(five_chr_word) != 5):
    print("Error: Word must contain 5 characters")
    exit()

# Ask user for a single charater 
character: str = input("Enter a single character: ")

#What if the user enters more than 1 character
if (len(character) != 1):
    print("Error: Character must be a single character.")
    exit()
print("Searching for " + character + " in " + five_chr_word)

# Where is that character in the 5 letter word?
if (character == five_chr_word[0]):
    print(character + " found at index 0")
if (character == five_chr_word[1]):
    print(character + " found at index 1")
if (character == five_chr_word[2]):
    print(character + " found at index 2")
if (character == five_chr_word[3]):
    print(character + " found at index 3")
if (character == five_chr_word[4]):
    print(character + " found at index 4")
else:
    print()

# How many times does that character appear in the word?
counter: int = sum(char == character for char in five_chr_word)
if (counter == 0):
    print("No instances of " + character + " found in " + five_chr_word)
if (counter == 1):
    print("1 instance of " + character + " found in " + five_chr_word)
if (counter == 2):
    print("2 instances of " + character + " found in " + five_chr_word)
if (counter == 3):
    print("3 instances of " + character + " found in " + five_chr_word)
if (counter == 4):
    print("4 instances of " + character + " found in " + five_chr_word)
if (counter == 5):
    print("5 instances of " + character + " found in " + five_chr_word)


    
