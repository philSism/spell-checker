/**
 * Author: Filotas Sismanis
 */

:- style_check(-singleton).
/**
 * Dictionary with the correct words.
 */
word([a,n,d]).
word([r,e,d]).
word([h,e,l,l,o]).
word([m,a,n]).
word([w,o,m,a,n]).
word([b,o,o,k]).
word([t,h,e]).
word([c,o,m,p,u,t,e,r]).
word([c,a,r]).
word([p,r,o,l,o,g]).
word([p,e,n,c,i,l]).
word([t,a,b,l,e]).
word([b,l,u,e]).
word([k,i,d]).
word([g,o,o,d]).
word([n,i,g,h,t]).
word([m,o,r,n,i,n,g]).

/**
 * In case a word is correct.
 */
correctword(Word, Word) :-
	word(Word).

/**
 * When a letter is missing from the word. Two sublists 'Head' and 'Tail' are created
 * and the letter is added between them.
 */
missingletter(WrongWord, CorrectWord) :-
	append(Head, Tail, WrongWord),
	word(CorrectWord),
	append(Head, [Letter | Tail], CorrectWord).

/**
 * When there is an extra letter, the word is split in two sublists
 * in order to find the letter and remove it.
 */
deleteletter(WrongWord, CorrectWord) :-
	append(Head, [Letter | Tail], WrongWord),
	word(CorrectWord),
	append(Head, Tail, CorrectWord).

/**
 * In case a letter must be added in a different position. The word is split in two sublists
 * 'Head' and 'Rest' and the second list is searched for the letter. When it is found, it is inserted
 * in the list 'NewRest' and merged with 'Head' to get the complete word.
 */
moveletter(Word, CorrectWord) :-  
	append(Head, Rest, Word),
	append(Middle, [Letter | Tail], Rest),
	word(CorrectWord),
	append([Letter | Middle], Tail, NewRest),
	append(Head, NewRest, CorrectWord).
	
/**
 * When a wrong letter is located, the word is split in two sublists
 * and the wrong letter is replaced with the correct one.
 */
changeletter(Word, CorrectWord) :-  
	append(Begin, [Letter | End], Word),
	word(CorrectWord),
	append(Begin, [NewLetter | End], CorrectWord),
	NewLetter \= Letter.
	
/**
 * In case two letters are in the wrong position,
 * without necessarily being next to each other.
 */
swapletters(WrongWord, CorrectWord) :-
	append(Begin, [Letter1|Rest], Word),
	append(Middle, [Letter2|End], Rest),
	word(CorrectWord),
	append(Middle, [Letter1|End], NewRest),
	append(Begin, [Letter2|NewRest], CorrectWord),
	Letter1 \= Letter2.

/**
 * The spellchecking that calls the rest of the functions
 * to check and correct wrong words.
 */
orthografos([],[]).
orthografos([Word | Rest1], [CorrectWord | Rest2]) :-
	correctword(Word, CorrectWord),
	orthografos(Rest1, Rest2).
	
orthografos([Word | Rest1], [CorrectWord | Rest2]) :-
	missingletter(Word, CorrectWord),
	orthografos(Rest1, Rest2).

orthografos([Word | Rest1], [CorrectWord | Rest2]) :-
	deleteletter(Word, CorrectWord),
	orthografos(Rest1, Rest2).
	
orthografos([Word | Rest1], [CorrectWord | Rest2]) :-
	moveletter(Word, CorrectWord),
	orthografos(Rest1, Rest2).
	
orthografos([Word | Rest1], [CorrectWord | Rest2]) :-
	changeletter(Word, CorrectWord),
	orthografos(Rest1, Rest2).

orthografos([Word | Rest1], [CorrectWord | Rest2]) :- 
	swapletters(Word, CorrectWord),
	orthografos(Rest1, Rest2).