;------------------------------------------------------------
; Ethan Nguyen
; CMPR - 154 - Fall 2023
; October 13, 2023
; Collaboration : None
;----------------------------------------------------------
;Linker-input-add dependancies-Irvine32.lib;$(CoreLibraryDependencies);%(AdditionalDependencies)

INCLUDE Irvine32.inc

.data
    balance DWORD 0
    MAX_ALLOWED DWORD 20
    amount DWORD 0
    correctGuesses DWORD 0
    missedGuesses DWORD 0
    name BYTE 16 DUP(?)
    randomNum DWORD ?
    teamNameMsg BYTE "***TEAM NAME ***", 0

    menuMsg BYTE "*** MAIN MENU ***", 0
    selectMsg BYTE "PLEASE SELECT ONE OF THE FOLLOWING:", 0
    option1Msg BYTE "1: DISPLAY MY AVAILABLE CREDIT", 0
    option2Msg BYTE "2: ADD CREDIT TO MY ACCOUNT", 0
    option3Msg BYTE "3: PLAY THE GUESSING GAME", 0
    option4Msg BYTE "4: DISPLAY MY STATISTICS", 0
    option5Msg BYTE "5: TO EXIT", 0

    guessMsg BYTE "Guess a number between 1 and 10: ", 0
    correctGuessMsg BYTE "Congratulations! You guessed correctly.", 0
    wrongGuessMsg BYTE "Sorry, wrong guess. Try again.", 0
    playAgainMsg BYTE "Do you want to play again? (y/n): ", 0
    maxAllowedMsg BYTE "Amount exceeds the maximum allowed.", 0
    statsMsg BYTE "Statistics:", 0

    pressEnterMsg BYTE "Press Enter to continue...", 0

    exitMsg BYTE "Press any key to exit...", 0

    invalidChoiceMsg BYTE "Invalid choice. Please enter a number between 1 and 5.", 0

    playerGuess DWORD ?
    creditsToAdd DWORD ?

.code

main PROC
    ; Initialize Irvine32 library
    call Clrscr
    mov balance, 0
    mov MAX_ALLOWED, 20

    jmp mainLoop ; Jump to the main loop
main ENDP

mainLoop:
    ; Display team name and main menu
    mov edx, OFFSET teamNameMsg
    call WriteString
    call Crlf
    mov edx, OFFSET menuMsg
    call WriteString
    call Crlf
    mov edx, OFFSET selectMsg
    call WriteString
    call Crlf
    mov edx, OFFSET option1Msg
    call WriteString
    call Crlf
    mov edx, OFFSET option2Msg
    call WriteString
    call Crlf
    mov edx, OFFSET option3Msg
    call WriteString
    call Crlf
    mov edx, OFFSET option4Msg
    call WriteString
    call Crlf
    mov edx, OFFSET option5Msg
    call WriteString
    call Crlf

    ; Read the user's choice
    call ReadInt
    mov amount, eax

    cmp amount, 1
    je displayBalance
    cmp amount, 2
    je addCredits
    cmp amount, 3
    je playGame
    cmp amount, 4
    je displayStatistics
    cmp amount, 5
    je exitProgram

    ; If none of the options are selected, display an error message
    mov edx, OFFSET invalidChoiceMsg
    call WriteString
    call Crlf
    jmp mainLoop

displayBalance:
    ; Display available balance
    mov eax, balance
    call WriteDec
    call Crlf
    jmp mainLoop

addCredits:
    ; Add credits to the account
    mov edx, OFFSET option2Msg
    call WriteString
    call Crlf

    ; Read the credits to be added
    mov edx, OFFSET inputPrompt
    call WriteString
    call ReadInt
    mov creditsToAdd, eax

    ; Check if the total credits exceed the maximum allowed
    mov eax, creditsToAdd
    add eax, balance
    cmp eax, MAX_ALLOWED
    ja amountExceeded

    ; Update the balance
    mov eax, creditsToAdd
    add balance, eax

    ; Display a success message
    mov edx, OFFSET creditsAddedMsg
    call WriteString
    call Crlf
    jmp mainLoop

amountExceeded:
    mov edx, OFFSET maxAllowedMsg
    call WriteString
    call Crlf
    jmp mainLoop

playGame:
    ; Play the game
    call PlayGuessingGame

displayStatistics:
    ; Display user statistics
    mov edx, OFFSET statsMsg
    call WriteString
    mov eax, balance
    call WriteDec
    call Crlf
    mov eax, correctGuesses
    call WriteDec
    call Crlf
    mov eax, missedGuesses
    call WriteDec
    call Crlf

    ; Display money won and lost
    ; ...

    ; Wait for the user to press Enter
    mov edx, OFFSET pressEnterMsg
    call WriteString
    call ReadChar
    call Crlf
    jmp mainLoop

exitProgram:
    ; Exit the program
    mov edx, OFFSET exitMsg
    call WriteString
    call ReadChar
    ret

inputPrompt BYTE "Enter the amount to add: ", 0
creditsAddedMsg BYTE "Credits added successfully.", 0

PlayGuessingGame PROC
    ; Implementation of the game logic
    mov edx, OFFSET guessMsg
    call WriteString
    call ReadInt
    mov playerGuess, eax

    ; Create a random number between 1 and 10
    mov eax, 10  ; Random number between 1 and 10
    add eax, 1
    mov randomNum, eax

    ; Check if the guess is correct
    mov eax, amount
    cmp eax, randomNum
    je  CorrectGuess
    jmp WrongGuess

CorrectGuess:
    ; Update for correct guess
    add correctGuesses, 1
    add balance, 2  ; Credit the user account $2
    mov edx, OFFSET correctGuessMsg
    call WriteString
    call Crlf
    jmp playAgain  ; Jump to PlayAgain

WrongGuess:
    ; Update for wrong guess
    add missedGuesses, 1
    mov edx, OFFSET wrongGuessMsg
    call WriteString
    call Crlf
    
PlayAgain:
    ; Ask the user if they want to play again
    mov edx, OFFSET playAgainMsg
    call WriteString
    call ReadChar
    cmp al, 'y'
    je  mainLoop  ; Jump back to the main loop if 'y'
    jmp exitProgram  ; Otherwise, jump to exitProgram

PlayGuessingGame ENDP

END main
