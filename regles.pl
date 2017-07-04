:- include('evaluation.pl').

/*
switch(+ValeurTestee, +ListeCases)
Prédicat pour simuler un switch. Teste si la valeur ValeurTestee est égale à un des éléments de la liste ListeCases. Si c'est le cas, elle effectue l'action nécessaire
*/
switch(X, [Val:Goal|Cases]) :- (X=Val -> call(Goal); switch(X, Cases)).

/* 
replace_elem_in_list(+ListeEntree, +Index, +NewElem, -ListeSortie)
Prédicat pour remplacer l'élément à la position Index de la liste ListeEntree par le nouvel élément NewElem, retourne la nouvelle liste
*/
replace_elem_in_list(ListeEntree, Index, NewElem, ListeSortie) :- same_length(ListeEntree, ListeSortie),
																append(Prefix, [_|Suffix], ListeEntree),
																length(Prefix, Index),
																append(Prefix, [NewElem|Suffix], ListeSortie).   

/*
get_position_x(+Board, +Index, -Res)
Retourne la position Res du taquin sur le plateau Board en regardant tour à tour les valeurs du plateau à la position Index, incrémentée de 0 à 8, tant qu'on ne trouve pas le résultat
*/																
get_position_x(Board, Index, Index) :- nth0(Index, Board, -1), !.
get_position_x(Board, Index, Res) :- NewIndex is Index+1, get_position_x(Board, NewIndex, Res).

/*
check_position(+ChoixPosition, +Board, -Valide)
Teste si la pose d'un pion sur le plateau Board à la position ChoixPosition est possible
1 si oui, 0 sinon
*/
check_position(ChoixPosition, Board, 1) :- nth0(ChoixPosition, Board, 0), !.
check_position(_ChoixPosition, _Board, 0).

/*
decrementer_pions(+Joueur, +PionsDispo, -NewPionsDispo)
Retourne le nouveau nombre de pions NewPionsDispo en décrémentant le nombre de pions du joueur Joueur dans PionsDispo de 1
*/
decrementer_pions(1, [X, Y], [X1, Y]) :- X1 is X-1, !.
decrementer_pions(2, [X, Y], [X, Y1]) :- Y1 is Y-1 .

/*
create_list(+Item, +List, -NewList)
Concatène Item à la liste List
Utilisé ici pour créer des listes de listes
*/
create_list(Item, List, [Item|List]).

/*
list_empty(+Liste, -Vide)
Retourne 1 si liste Liste est vide, 0 sinon
*/
list_empty([], 1).
list_empty([_|_], 0).

/*
combine(+ListeEntree, -ListeSortie)
Retourne la liste ListeSortie à partir de la liste ListeEntree dont les éléments de premier ordre ont été réorganisés
Utilisé pour simplifier la création de listes de listes en accord avec create_list
*/
combine([], []).
combine([H|T], Q) :- combine(T, Q1), create_list(H, Q1, Q).

/*
get_succ_pose_pion(+CurrentBoard, +Joueur, ?Num, +PionsDispo, -Res)
Retourne la liste des états du plateau successeurs (Res) du plateau courant CurrentBoard, après pose d'un pion sur une des cases libres par le joueur courant (Joueur). Les pions disponibles (PionsDispo) sont passés en entrée pour tester la pose
Le parcours de chacune des cases possibles se fait récursivement via l'index Num
*/
get_succ_pose_pion(CurrentBoard, Joueur, 0, PionsDispo, Res) :- check_pose_pion(CurrentBoard, Joueur, PionsDispo, 0), get_board_pose_pion(CurrentBoard, 0, Joueur, NewBoard), get_succ_pose_pion(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), create_list(NewBoard, L, Res), !.
get_succ_pose_pion(CurrentBoard, Joueur, 0, PionsDispo, L) :- get_succ_pose_pion(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), !.
get_succ_pose_pion(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_pose_pion(CurrentBoard, Joueur, PionsDispo, Num), get_board_pose_pion(CurrentBoard, Num, Joueur, NewBoard), Num1 is Num+1, get_succ_pose_pion(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), create_list(NewBoard, L, Res), !.
get_succ_pose_pion(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_pose_pion(CurrentBoard, Joueur, PionsDispo, Num), get_board_pose_pion(CurrentBoard, Num, Joueur, NewBoard), Num1 is Num+1, get_succ_pose_pion(CurrentBoard, Joueur, Num1, PionsDispo, _L), create_list(NewBoard, [], Res), !.
get_succ_pose_pion(CurrentBoard, Joueur, Num, PionsDispo, L) :- Num=<8, not(check_pose_pion(CurrentBoard, Joueur, PionsDispo, Num)), Num1 is Num+1, get_succ_pose_pion(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), !.
get_succ_pose_pion(_CurrentBoard, _Joueur, _Num, _PionsDispo, []).

/*
get_liste_coups_associes_pose_pion(+CurrentBoard, +Joueur, ?Num, +PionsDispo, -Res)
Idem get_succ_pose_pion mais renvoie la liste des coups associés
*/
get_liste_coups_associes_pose_pion(CurrentBoard, Joueur, 0, PionsDispo, Res) :- check_pose_pion(CurrentBoard, Joueur, PionsDispo, 0), get_coup_associe_pose_pion(0, Coup), get_liste_coups_associes_pose_pion(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), create_list(Coup, L, Res), !.
get_liste_coups_associes_pose_pion(CurrentBoard, Joueur, 0, PionsDispo, L) :- get_liste_coups_associes_pose_pion(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), !.
get_liste_coups_associes_pose_pion(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_pose_pion(CurrentBoard, Joueur, PionsDispo, Num), get_coup_associe_pose_pion(Num, Coup), Num1 is Num+1, get_liste_coups_associes_pose_pion(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), create_list(Coup, L, Res), !.
get_liste_coups_associes_pose_pion(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_pose_pion(CurrentBoard, Joueur, PionsDispo, Num), get_coup_associe_pose_pion(Num, Coup), Num1 is Num+1, get_liste_coups_associes_pose_pion(CurrentBoard, Joueur, Num1, PionsDispo, _L), create_list(Coup, [], Res), !.
get_liste_coups_associes_pose_pion(CurrentBoard, Joueur, Num, PionsDispo, L) :- Num=<8, not(check_pose_pion(CurrentBoard, Joueur, PionsDispo, Num)), Num1 is Num+1, get_liste_coups_associes_pose_pion(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), !.
get_liste_coups_associes_pose_pion(_CurrentBoard, _Joueur, _Num, _PionsDispo, []).

/*
check_pose_pion(+Board, +Joueur, +PionsDispo, +Num)
Retourne vrai si le nombre de pions disponibles PionsDispo du joueur courant Joueur est différent de 0 et si la valeur du plateau Board à la position Num est 0 (case vide)
*/
check_pose_pion(Board, Joueur, PionsDispo, Num) :- JoueurTemp is Joueur-1, nth0(JoueurTemp, PionsDispo, X), X\=0, nth0(Num, Board, 0). 

/*
get_board_pose_pion(+Board, +Num, +Joueur, -NewBoard)
Retourne le plateau NewBoard après que le joueur Joueur a posé un pion sur le plateau Board à la position Num
*/
get_board_pose_pion(Board, Num, Joueur, NewBoard) :- replace_elem_in_list(Board, Num, Joueur, NewBoard).

/*
get_coup_associe_pose_pion(+Num, -Coup)
Retourne le coup Coup associé à la pose d'un pion à la position Num
*/
get_coup_associe_pose_pion(Num, [0, Num]).

/*
get_succ_deplace_pion(+CurrentBoard, +Joueur, ?Num, +PionsDispo, -Res)
Idem get_succ_pose_pion mais renvoie la liste des successeurs après un déplacement de pion
*/
get_succ_deplace_pion(CurrentBoard, Joueur, 0, PionsDispo, Res) :- check_deplace_pion(CurrentBoard, Joueur, PionsDispo, 0, ResAdj), get_board_deplace_pion(CurrentBoard, 0, Joueur, ResAdj, NewBoards), get_succ_deplace_pion(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), create_list(NewBoards, L, Res), !.
get_succ_deplace_pion(CurrentBoard, Joueur, 0, PionsDispo, L) :- get_succ_deplace_pion(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), !.
get_succ_deplace_pion(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_pion(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_board_deplace_pion(CurrentBoard, Num, Joueur, ResAdj, NewBoards), Num1 is Num+1, get_succ_deplace_pion(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0),create_list(NewBoards, L, Res), !.
get_succ_deplace_pion(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_pion(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_board_deplace_pion(CurrentBoard, Num, Joueur, ResAdj, NewBoards), Num1 is Num+1, get_succ_deplace_pion(CurrentBoard, Joueur, Num1, PionsDispo, _L), create_list(NewBoards, [], Res), !.
get_succ_deplace_pion(CurrentBoard, Joueur, Num, PionsDispo, L) :- Num=<8, not(check_deplace_pion(CurrentBoard, Joueur, PionsDispo, Num, _ResAdj)), Num1 is Num+1, get_succ_deplace_pion(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), !.
get_succ_deplace_pion(_CurrentBoard, _Joueur, _Num, _PionsDispo, []).

/*
get_liste_coups_deplace_pion(+CurrentBoard, +Joueur, ?Num, +PionsDispo, -Res)
Idem get_succ_deplace_pion mais renvoie la liste des coups associés
*/
get_liste_coups_deplace_pion(CurrentBoard, Joueur, 0, PionsDispo, Res) :- check_deplace_pion(CurrentBoard, Joueur, PionsDispo, 0, ResAdj), get_coups_associe_deplace_pion(0, Coups, ResAdj), get_liste_coups_deplace_pion(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), create_list(Coups, L, Res), !.
get_liste_coups_deplace_pion(CurrentBoard, Joueur, 0, PionsDispo, L) :- get_liste_coups_deplace_pion(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), !.
get_liste_coups_deplace_pion(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_pion(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_coups_associe_deplace_pion(Num, Coups, ResAdj), Num1 is Num+1, get_liste_coups_deplace_pion(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), create_list(Coups, L, Res), !.
get_liste_coups_deplace_pion(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_pion(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_coups_associe_deplace_pion(Num, Coups, ResAdj), Num1 is Num+1, get_liste_coups_deplace_pion(CurrentBoard, Joueur, Num1, PionsDispo, _L), create_list(Coups, [], Res), !.
get_liste_coups_deplace_pion(CurrentBoard, Joueur, Num, PionsDispo, L) :- Num=<8, not(check_deplace_pion(CurrentBoard, Joueur, PionsDispo, Num, _ResAdj)), Num1 is Num+1, get_liste_coups_deplace_pion(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), !.
get_liste_coups_deplace_pion(_CurrentBoard, _Joueur, _Num, _PionsDispo, []).

/*
check_deplace_pion(+Board, +Joueur, +PionsDispo, +Num, -Res)
Retourne les cases adjacentes à la position courante Num si le nombre de pions PionsDispo du joueur courant Joueur est différent de 3 et que ces cases sont vides
*/
check_deplace_pion(Board, Joueur, PionsDispo, Num, Res) :- JoueurTemp is Joueur-1, nth0(JoueurTemp, PionsDispo, X), X\=3, nth0(Num, Board, Joueur), findall(Z, is_adjacente_deplacer_pion(Num, Z), Liste), check_adjacents_deplace_pion(Liste, Board, Res), length(Res, A), A\=0 . 

/*
get_board_deplace_pion(+Board, +Num, +Joueur, +CasesAdjacentes, -Res)
Retourne la liste des états du plateau Res associés aux déplacements de pions sur les cases adjacentes CasesAdjacentes par le joueur Joueur à la position Num sur le plateau Board
*/
get_board_deplace_pion(Board, Num, Joueur, [H|R], Res) :- replace_elem_in_list(Board, Num, 0, NewBoard1), replace_elem_in_list(NewBoard1, H, Joueur, NewBoard), get_board_deplace_pion(Board, Num, Joueur, R, L), create_list(NewBoard, L, Res), !.
get_board_deplace_pion(_Board, _Num, _Joueur, [], []).

/*
get_coups_associe_deplace_pion(+Num, -Coups, +CasesAdjacentes)
Idem que get_board_deplace_pion avec la liste des coups
*/
get_coups_associe_deplace_pion(Num, Coups, [H|R]) :- get_coups_associe_deplace_pion(Num, L, R), create_list([1, Num, H], L, Coups), !.
get_coups_associe_deplace_pion(_Num, [], []).

/*
check_adjacents_deplace_pion(+Liste, +Board, -Res)
Renvoie la liste des états Res valides de déplacement de pion parmi la liste Liste, avec le plateau courant fourni
*/
check_adjacents_deplace_pion([H|R], Board, [H|R1]) :- nth0(H, Board, 0), check_adjacents_deplace_pion(R, Board, R1), !.
check_adjacents_deplace_pion([_H|R], Board, Res) :- check_adjacents_deplace_pion(R, Board, Res), !.
check_adjacents_deplace_pion(_Liste, _Board, []).

/*
deplace_pion_liste_compacte(+ListeEntree, -ResDeplacePion)
Retourne la liste de listes concaténée ResDeplacePion de ListeEntree
*/
deplace_pion_liste_compacte([H|R], ResDeplacePion) :- combine(H, Temp), deplace_pion_liste_compacte(R, Res), append(Temp, Res, ResDeplacePion), !.
deplace_pion_liste_compacte([], []).

/*
deplace_pion_coups_liste_compacte(+ListeEntree, -ResCoupsDeplacePion)
Idem que deplace_pion_liste_compacte mais avec la liste des coups associés
*/
deplace_pion_coups_liste_compacte([H|R], ResCoupsDeplacePion) :- combine(H, Temp), deplace_pion_coups_liste_compacte(R, Res), append(Temp, Res, ResCoupsDeplacePion), !.
deplace_pion_coups_liste_compacte([], []).

/*
get_succ_deplace_1case(+CurrentBoard, +Joueur, +Num, +PionsDispo, -Res)
Idem que get_succ_deplace_pion mais avec la liste des déplacements d'une case
*/
get_succ_deplace_1case(CurrentBoard, Joueur, 0, PionsDispo, Res) :- check_deplace_1case(CurrentBoard, Joueur, PionsDispo, 0, ResAdj), get_board_deplace_1case(CurrentBoard, 0, Joueur, ResAdj, NewBoards), get_succ_deplace_1case(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), create_list(NewBoards, L, Res), !.
get_succ_deplace_1case(CurrentBoard, Joueur, 0, PionsDispo, L) :- get_succ_deplace_1case(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), !.
get_succ_deplace_1case(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_1case(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_board_deplace_1case(CurrentBoard, Num, Joueur, ResAdj, NewBoards), Num1 is Num+1, get_succ_deplace_1case(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), create_list(NewBoards, L, Res), !.
get_succ_deplace_1case(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_1case(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_board_deplace_1case(CurrentBoard, Num, Joueur, ResAdj, NewBoards), Num1 is Num+1, get_succ_deplace_1case(CurrentBoard, Joueur, Num1, PionsDispo, _L), create_list(NewBoards, [], Res), !.
get_succ_deplace_1case(CurrentBoard, Joueur, Num, PionsDispo, L) :- Num=<8, not(check_deplace_1case(CurrentBoard, Joueur, PionsDispo, Num, _ResAdj)), Num1 is Num+1, get_succ_deplace_1case(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), !.
get_succ_deplace_1case(_CurrentBoard, _Joueur, _Num, _PionsDispo, []).

/*
get_liste_coups_deplace_1case(+CurrentBoard, +Joueur, +Num, +PionsDispo, -Res)
Idem que get_succ_deplace_1case mais retourne la liste des coups associés
*/
get_liste_coups_deplace_1case(CurrentBoard, Joueur, 0, PionsDispo, Res) :- check_deplace_1case(CurrentBoard, Joueur, PionsDispo, 0, ResAdj), get_coups_associe_deplace_1case(0, Coups, ResAdj), get_liste_coups_deplace_1case(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, X), X=:=0, create_list(Coups, L, Res), !.
get_liste_coups_deplace_1case(CurrentBoard, Joueur, 0, PionsDispo, L) :- get_liste_coups_deplace_1case(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), !.
get_liste_coups_deplace_1case(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_1case(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_coups_associe_deplace_1case(Num, Coups, ResAdj), Num1 is Num+1, get_liste_coups_deplace_1case(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), create_list(Coups, L, Res), !.
get_liste_coups_deplace_1case(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_1case(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_coups_associe_deplace_1case(Num, Coups, ResAdj), Num1 is Num+1, get_liste_coups_deplace_1case(CurrentBoard, Joueur, Num1, PionsDispo, _L), create_list(Coups, [], Res), !.
get_liste_coups_deplace_1case(CurrentBoard, Joueur, Num, PionsDispo, L) :- Num=<8, not(check_deplace_1case(CurrentBoard, Joueur, PionsDispo, Num, _ResAdj)), Num1 is Num+1, get_liste_coups_deplace_1case(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), !.
get_liste_coups_deplace_1case(_CurrentBoard, _Joueur, _Num, _PionsDispo, []).

/*
check_deplace_1case(+Board, +Joueur, +PionsDispo, +Num, -Res)
Idem que check_deplace_pion mais vérifie si le déplacement d'une case est possible
*/
check_deplace_1case(Board, _Joueur, _PionsDispo, Num, Res) :- findall(Z, is_adjacente_deplacer_case(Num, Z), Liste), check_adjacents_deplace_1case(Liste, Board, Res), length(Res, A), A\=0 . 

/*
get_board_deplace_1case(+Board, +Num, +Joueur, +CasesAdjacentes, -Res)
Idem que get_board_deplace_pion mais avec le déplacement d'une case
*/
get_board_deplace_1case(Board, Num, Joueur, [H|R], Res) :- nth0(Num, Board, Val), replace_elem_in_list(Board, Num, -1, NewBoard1), replace_elem_in_list(NewBoard1, H, Val, NewBoard), get_board_deplace_1case(Board, Num, Joueur, R, L), create_list(NewBoard, L, Res), !.
get_board_deplace_1case(_Board, _Num, _Joueur, [], []).

/*
get_coups_associe_deplace_1case(+Num, -Coups, +CasesAdjacentes)
Idem que get_coups_associe_deplace_pion mais avec le déplacement de case
*/
get_coups_associe_deplace_1case(Num, Coups, [H|R]) :- get_coups_associe_deplace_1case(Num, L, R), create_list([2, Num, H], L, Coups), !.
get_coups_associe_deplace_1case(_Num, [], []).

/*
check_adjacents_deplace_1case(+Liste, +Board, -Res)
Idem que check_adjacents_deplace_pion mais avec le déplacement de case
*/
check_adjacents_deplace_1case([H|R], Board, [H|R1]) :- nth0(H, Board, -1), check_adjacents_deplace_1case(R, Board, R1), !.
check_adjacents_deplace_1case([_H|R], Board, Res) :- check_adjacents_deplace_1case(R, Board, Res), ! .
check_adjacents_deplace_1case(_Liste, _Board, []).

/*
deplace_1case_liste_compacte(+Liste, -ResDeplace1Case)
Idem que deplace_pion_liste_compacte mais avec le déplacement de case
*/
deplace_1case_liste_compacte([H|R], ResDeplace1Case) :- combine(H, Temp), deplace_1case_liste_compacte(R, Res), append(Temp, Res, ResDeplace1Case), !.
deplace_1case_liste_compacte([], []).

/*
deplace_1case_coups_liste_compacte(+Liste, -ResCoupsDeplace1Case)
Idem que deplace_pion_coups_liste_compacte mais avec le déplacement de case
*/
deplace_1case_coups_liste_compacte([H|R], ResCoupsDeplace1Case) :- combine(H, Temp), deplace_1case_coups_liste_compacte(R, Res), append(Temp, Res, ResCoupsDeplace1Case), !.
deplace_1case_coups_liste_compacte([], []).

/*
get_succ_deplace_2case(+CurrentBoard, +Joueur, +Num, +PionsDispo, -Res)
Idem que get_succ_deplace_1case mais avec le déplacement de deux cases
*/
get_succ_deplace_2case(CurrentBoard, Joueur, 0, PionsDispo, Res) :- check_deplace_2case(CurrentBoard, Joueur, PionsDispo, 0, ResAdj), get_board_deplace_2case(CurrentBoard, 0, Joueur, ResAdj, NewBoards), get_succ_deplace_2case(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), create_list(NewBoards, L, Res), !.
get_succ_deplace_2case(CurrentBoard, Joueur, 0, PionsDispo, L) :- get_succ_deplace_2case(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), !.
get_succ_deplace_2case(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_2case(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_board_deplace_2case(CurrentBoard, Num, Joueur, ResAdj, NewBoards), Num1 is Num+1, get_succ_deplace_2case(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), create_list(NewBoards, L, Res), !.
get_succ_deplace_2case(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_2case(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_board_deplace_2case(CurrentBoard, Num, Joueur, ResAdj, NewBoards), Num1 is Num+1, get_succ_deplace_2case(CurrentBoard, Joueur, Num1, PionsDispo, _L), create_list(NewBoards, [], Res), !.
get_succ_deplace_2case(CurrentBoard, Joueur, Num, PionsDispo, L) :- Num=<8, not(check_deplace_2case(CurrentBoard, Joueur, PionsDispo, Num, _ResAdj)), Num1 is Num+1, get_succ_deplace_2case(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), !.
get_succ_deplace_2case(_CurrentBoard, _Joueur, _Num, _PionsDispo, []).

/*
get_liste_coups_deplace_2case(+CurrentBoard, +Joueur, +Num, +PionsDispo, -Res)
Idem que get_liste_coups_deplace_1case mais avec le déplacement de deux cases
*/
get_liste_coups_deplace_2case(CurrentBoard, Joueur, 0, PionsDispo, Res) :- check_deplace_2case(CurrentBoard, Joueur, PionsDispo, 0, ResAdj), get_coups_associe_deplace_2case(0, Coups, ResAdj), get_liste_coups_deplace_2case(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), create_list(Coups, L, Res), !.
get_liste_coups_deplace_2case(CurrentBoard, Joueur, 0, PionsDispo, L) :- get_liste_coups_deplace_2case(CurrentBoard, Joueur, 1, PionsDispo, L), list_empty(L, 0), !.
get_liste_coups_deplace_2case(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_2case(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_coups_associe_deplace_2case(Num, Coups, ResAdj), Num1 is Num+1, get_liste_coups_deplace_2case(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), create_list(Coups, L, Res), !.
get_liste_coups_deplace_2case(CurrentBoard, Joueur, Num, PionsDispo, Res) :- Num=<8, check_deplace_2case(CurrentBoard, Joueur, PionsDispo, Num, ResAdj), get_coups_associe_deplace_2case(Num, Coups, ResAdj), Num1 is Num+1, get_liste_coups_deplace_2case(CurrentBoard, Joueur, Num1, PionsDispo, _L), create_list(Coups, [], Res), !.
get_liste_coups_deplace_2case(CurrentBoard, Joueur, Num, PionsDispo, L) :- Num=<8, not(check_deplace_2case(CurrentBoard, Joueur, PionsDispo, Num, _ResAdj)), Num1 is Num+1, get_liste_coups_deplace_2case(CurrentBoard, Joueur, Num1, PionsDispo, L), list_empty(L, 0), !.
get_liste_coups_deplace_2case(_CurrentBoard, _Joueur, _Num, _PionsDispo, []).

/*
check_deplace_2case(+Board, +Joueur, +PionsDispo, +Num, -Res)
Idem que check_deplace_1case mais avec le déplacement de deux cases
*/
check_deplace_2case(Board, _Joueur, _PionsDispo, Num, Res) :- findall(Z, oppose(Num, Z), Liste), check_oppose(Liste, Board, Res), length(Res, A), A\=0 . 

/*
get_board_deplace_2case(+Board, +Num, +Joueur, +CasesAdjacentes, -Res)
Idem que get_board_deplace_1case mais avec le déplacement de deux cases
*/
get_board_deplace_2case(Board, Num, Joueur, [_H|R], Res) :- get_position_x(Board, 0, Index), get_valeur_interm(Num, Index, Interm), nth0(Num, Board, Val1), nth0(Interm, Board, Val2), nth0(Index, Board, Val3), replace_elem_in_list(Board, Index, Val2, NewBoard1), replace_elem_in_list(NewBoard1, Interm, Val1, NewBoard2), replace_elem_in_list(NewBoard2, Num, Val3, NewBoard), get_board_deplace_2case(Board, Num, Joueur, R, L), create_list(NewBoard, L, Res), !. 
get_board_deplace_2case(_Board, _Num, _Joueur, [], []).

/*
get_coups_associe_deplace_2case(+Num, -Coups, +CasesAdjacentes)
Idem que get_coups_associe_deplace_1case mais avec le déplacement de deux cases
*/
get_coups_associe_deplace_2case(Num, Coups, [H|R]) :- get_coups_associe_deplace_2case(Num, L, R), create_list([3, Num, H], L, Coups), !.
get_coups_associe_deplace_2case(_Num, [], []).

/*
check_oppose(+Liste, +Board, -Res)
Retourne la liste des cases Res à l'oppose des cases de la liste Liste, avec en entrée le plateau Board
*/
check_oppose([H|R], Board, [H|R1]) :- nth0(H, Board, -1), check_oppose(R, Board, R1), !.
check_oppose([_H|R], Board, Res) :- check_oppose(R, Board, Res), ! .
check_oppose(_Liste, _Board, []).

/*
deplace_2case_liste_compacte(+Liste, -ResDeplace2Case)
Idem que deplace_1case_liste_compacte mais avec le déplacement de deux cases
*/
deplace_2case_liste_compacte([H|R], ResDeplace2Case) :- combine(H, Temp), deplace_2case_liste_compacte(R, Res), append(Temp, Res, ResDeplace2Case), !.
deplace_2case_liste_compacte([], []).

/*
deplace_2case_coups_liste_compacte(+Liste, -ResCoupsDeplace2Case)
Idem que deplace_1case_coups_liste_compacte mais avec le déplacement de deux cases
*/
deplace_2case_coups_liste_compacte([H|R], ResCoupsDeplace2Case) :- combine(H, Temp), deplace_2case_coups_liste_compacte(R, Res), append(Temp, Res, ResCoupsDeplace2Case), !.
deplace_2case_coups_liste_compacte([], []).

/*
get_liste_successeurs(+Board, +Joueur, +PionsDispo, -ListeSuccesseurs)
Retourne la liste des états successeurs ListeSuccesseurs du plateau courant Board, pour un coup du joueur Joueur avec le nombre de pions disponibles PionsDispo
*/
get_liste_successeurs(Board, Joueur, PionsDispo, ListeSuccesseurs) :- get_succ_pose_pion(Board, Joueur, 0, PionsDispo, ResPosePion), 
																	get_succ_deplace_pion(Board, Joueur, 0, PionsDispo, Res1), deplace_pion_liste_compacte(Res1, ResDeplacePion), 
																	get_succ_deplace_1case(Board, Joueur, 0, PionsDispo, Res2), deplace_1case_liste_compacte(Res2, ResDeplace1Case), 
																	get_succ_deplace_2case(Board, Joueur, 0, PionsDispo, Res3), deplace_2case_liste_compacte(Res3, ResDeplace2Case),
																	append(ResDeplace2Case, [], Temp1), append(ResDeplace1Case, Temp1, Temp2), combine(Temp2, Temp3), append(ResDeplacePion, Temp3, Temp4), combine(Temp4, Temp5), append(ResPosePion, Temp5, Temp6), combine(Temp6, ListeSuccesseurs).

/*
get_liste_coups_successeurs(+Board, +Joueur, +PionsDispo, -ListeCoupsSuccesseurs)
Idem get_liste_successeurs mais renvoie la liste des coups associés
*/
get_liste_coups_successeurs(Board, Joueur, PionsDispo, ListeCoupsSuccesseurs) :-  get_liste_coups_associes_pose_pion(Board, Joueur, 0, PionsDispo, ResCoupsPosePion), 
																				get_liste_coups_deplace_pion(Board, Joueur, 0, PionsDispo, ResCoupsDeplacePion1), deplace_pion_liste_compacte(ResCoupsDeplacePion1, ResCoupsDeplacePion),
																				get_liste_coups_deplace_1case(Board, Joueur, 0, PionsDispo, ResCoupsDeplace1Case1), deplace_1case_liste_compacte(ResCoupsDeplace1Case1, ResCoupsDeplace1Case),
																				get_liste_coups_deplace_2case(Board, Joueur, 0, PionsDispo, ResCoupsDeplace2Case1), deplace_2case_liste_compacte(ResCoupsDeplace2Case1, ResCoupsDeplace2Case),
																				append(ResCoupsDeplace2Case, [], Temp1), append(ResCoupsDeplace1Case, Temp1, Temp2), combine(Temp2, Temp3), append(ResCoupsDeplacePion, Temp3, Temp4), combine(Temp4, Temp5), append(ResCoupsPosePion, Temp5, Temp6), combine(Temp6, ListeCoupsSuccesseurs).

/*
maj_board(+Board, +ChoixPosition, +Joueur, -NewBoard)
maj_board_deplacer_pion(+Board, +ChoixOrigine, +ChoixArrivee, +Joueur, -NewBoard)
maj_board_deplacer_case(+Board, +ChoixOrigine, +ChoixArrivee, +Joueur, -NewBoard)
maj_board_deplacer_deux_cases(+Board, +ChoixOrigine, +Joueur, -NewBoard)
Retourne le nouveau plateau NewBoard après la réalisation d'un coup par le joueur courant Joueur
Prend en entrée les paramètres spécifiés
*/
maj_board(Board, ChoixPosition, Joueur, NewBoard) :- replace_elem_in_list(Board, ChoixPosition, Joueur, NewBoard).
maj_board_deplacer_pion(Board, ChoixOrigine, ChoixArrivee, Joueur, NewBoard) :- replace_elem_in_list(Board, ChoixOrigine, 0, NewBoard1), replace_elem_in_list(NewBoard1, ChoixArrivee, Joueur, NewBoard).
maj_board_deplacer_case(Board, ChoixOrigine, ChoixArrivee, _Joueur, NewBoard) :- nth0(ChoixOrigine, Board, Val), replace_elem_in_list(Board, ChoixOrigine, -1, NewBoard1), replace_elem_in_list(NewBoard1, ChoixArrivee, Val, NewBoard).
maj_board_deplacer_deux_cases(Board, ChoixOrigine, _Joueur, NewBoard) :- get_position_x(Board, 0, Index), get_valeur_interm(ChoixOrigine, Index, Interm), nth0(ChoixOrigine, Board, Val1), nth0(Interm, Board, Val2), nth0(Index, Board, Val3), replace_elem_in_list(Board, Index, Val2, NewBoard1), replace_elem_in_list(NewBoard1, Interm, Val1, NewBoard2), replace_elem_in_list(NewBoard2, ChoixOrigine, Val3, NewBoard).

/*
verifier_victoire(+Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Vérifie si le joueur courant Joueur a remporté la partie après avoir joué un coup 
Prend en entrée tous les paramètres spécifiés
*/
verifier_victoire(Board, _ChoixMenu, _ChoixDifficulte, Joueur, _PionsDispo, _DernierCoup) :- check_victoire(Board, Joueur, 1), write('Le joueur '), write(Joueur), write(' remporte la partie ! Merci d\'avoir joue a Force 3 !\n'), afficher_jeu_fini(Board), !.
verifier_victoire(Board, _ChoixMenu, _ChoixDifficulte, Joueur, _PionsDispo, _DernierCoup) :- adversaire(Joueur, Adversaire), check_victoire(Board, Adversaire, 1), write('Le joueur '), write(Adversaire), write(' remporte la partie ! Merci d\'avoir joue a Force 3 !\n'), afficher_jeu_fini(Board), !.
verifier_victoire(Board, 0, ChoixDifficulte, 1, PionsDispo, DernierCoup) :- afficher_jeu(Board, 0, ChoixDifficulte, 2, PionsDispo, DernierCoup), !.
verifier_victoire(Board, 1, ChoixDifficulte, 1, PionsDispo, DernierCoup) :- sleep(3), afficher_jeu(Board, 1, ChoixDifficulte, 2, PionsDispo, DernierCoup), !.
verifier_victoire(Board, ChoixMenu, ChoixDifficulte, 2, PionsDispo, DernierCoup) :- sleep(3), afficher_jeu(Board, ChoixMenu, ChoixDifficulte, 1, PionsDispo, DernierCoup).

/*
poser_pion(+Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Idem deplacer_pion mais avec la pose de pion
*/
poser_pion(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- lire_choix_positionnement(ChoixPosition, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup), check_position(ChoixPosition, Board, Valide), Valide=:=1, decrementer_pions(Joueur, PionsDispo, NewPionsDispo), maj_board(Board, ChoixPosition, Joueur, NewBoard), verifier_victoire(NewBoard, ChoixMenu, ChoixDifficulte, Joueur, NewPionsDispo, [0, ChoixPosition]), !.
poser_pion(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('\nImpossible de positionner a cet endroit ! Recommencez.'), poser_pion(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup).

/*
deplacer_pion(+Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Tente d'effectuer un déplacement de pion en lisant le choix de l'utilisateur 
Si les choix sont bons, le plateau est mis à jour
Prend en entrée tous les paramètres spécifiés
*/
deplacer_pion(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- lire_choix_deplacer_pion_origine(ChoixOrigine, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup), lire_choix_deplacer_pion_arrivee(ChoixArrivee, ChoixOrigine, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup), maj_board_deplacer_pion(Board, ChoixOrigine, ChoixArrivee, Joueur, NewBoard), verifier_victoire(NewBoard, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, [1, ChoixOrigine, ChoixArrivee]).

/*
deplacement_une_case(+Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Idem deplacement_deux_cases mais avec une seule case
*/
deplacement_une_case(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- lire_choix_deplace_case_origine(ChoixO, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup), lire_choix_deplace_case_arrivee(ChoixA, ChoixO, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup), deplacer_case(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup, ChoixO, ChoixA).

/*
deplacer_case(+Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup, +ChoixOrigine, +ChoixArrivee)
Idem deplacer_deux_cases mais avec une seule case
*/
deplacer_case(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup, ChoixOrigine, ChoixArrivee) :- length(DernierCoup, 3), nth0(1, DernierCoup, ChoixArrivee), nth0(2, DernierCoup, ChoixOrigine), writeln('Vous ne pouvez pas jouer le deplacement inverse du dernier coup joue !\n'), deplacement_une_case(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup), !.
deplacer_case(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, _DernierCoup, ChoixOrigine, ChoixArrivee) :- maj_board_deplacer_case(Board, ChoixOrigine, ChoixArrivee, Joueur, NewBoard), verifier_victoire(NewBoard, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, [2, ChoixOrigine, ChoixArrivee]).

/*
deplacement_deux_cases(+Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Lit un déplacement de deux cases et tente d'effectuer le déplacement
Prend en entrée tous les paramètres spécifiés
*/
deplacement_deux_cases(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- lire_choix_deplace_deux_cases_origine(ChoixO, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup), deplacer_deux_cases(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup, ChoixO).

/*
deplacer_deux_cases(+Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup, +ChoixOrigine)
Vérifie si le choix saisi ChoixOrigine permet d'effectuer le déplacement de deux cases
Prend en entrée tous les paramètres spécifiés
*/
deplacer_deux_cases(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup, ChoixOrigine) :- length(DernierCoup, 3), nth0(2, DernierCoup, ChoixOrigine), writeln('Vous ne pouvez pas jouer le deplacement inverse du dernier coup joue !\n'), deplacement_deux_cases(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup), !.
deplacer_deux_cases(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, _DernierCoup, ChoixOrigine) :- maj_board_deplacer_deux_cases(Board, ChoixOrigine, Joueur, NewBoard), get_position_x(Board, 0, Index), verifier_victoire(NewBoard, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, [3, ChoixOrigine, Index]).

/*
maj_board_ia(+Board, +Joueur, +PionsDispo, +Coup, -NewBoard, -NewPionsDispo)
Retourne le plateau NewBoard et les nouveaux pions disponibles NewPionsDispo après un coup de l'IA
Prend en entrée le plateau courant Board, le joueur courant Joueur, le nombre de pions disponibles PionsDispo, et le coup joué Coup
*/
maj_board_ia(Board, Joueur, PionsDispo, [0, X], NewBoard, NewPionsDispo) :- maj_board(Board, X, Joueur, NewBoard), J is Joueur-1, nth0(J, PionsDispo, ValPions), NewValPions is ValPions-1, replace_elem_in_list(PionsDispo, J, NewValPions, NewPionsDispo), !.
maj_board_ia(Board, Joueur, PionsDispo, [1, X, Y], NewBoard, PionsDispo) :- maj_board_deplacer_pion(Board, X, Y, Joueur, NewBoard), !.
maj_board_ia(Board, Joueur, PionsDispo, [2, X, Y], NewBoard, PionsDispo) :- maj_board_deplacer_case(Board, X, Y, Joueur, NewBoard), !.
maj_board_ia(Board, Joueur, PionsDispo, [3, X, _Y], NewBoard, PionsDispo) :- maj_board_deplacer_deux_cases(Board, X, Joueur, NewBoard), !.
maj_board_ia(_Board, _Joueur, PionsDispo, [], _NewBoard, PionsDispo).

/*
minmax(+Joueur, +Board, +PionsDispo, +Profondeur, -V, -Indice, +DernierCoup)
Simule le fonctionnement de l'algorithme MinMax
Retourne la valeur de l'état successeur optimal V et l'indice associé Indice
Prend en entrée le joueur courant Joueur, le plateau courant Board, le nombre de pions disponibles PionsDispo, la profondeur courante Profondeur et le dernier coup joué DernierCoup
*/
minmax(Joueur, Board, PionsDispo, Profondeur, V, Indice, DernierCoup) :- max_value(Joueur, Board, Profondeur, -32767, 32767, PionsDispo, V, Indice, DernierCoup).

/*
max_value(+Joueur, +Board, +Profondeur, +Alpha, +Beta, +PionsDispo, -Res, -Indice, +DernierCoup)
Idem que min_value mais correspond à une ligne max
*/
max_value(Joueur, Board, 0, _Alpha, _Beta, _PionsDispo, Res, _Indice, _DernierCoup) :- adversaire(Joueur, Adversaire), eval_plateau(Joueur, Adversaire, Board, Res), !.
max_value(Joueur, Board, _Profondeur, _Alpha, _Beta, _PionsDispo, 2000, _Indice, _DernierCoup) :- check_victoire(Board, Joueur, 1), !.
max_value(Joueur, Board, _Profondeur, _Alpha, _Beta, _PionsDispo, -2000, _Indice, _DernierCoup) :- adversaire(Joueur, Adversaire), check_victoire(Board, Adversaire, 1), !.
max_value(Joueur, Board, Profondeur, Alpha, Beta, PionsDispo, Res, Indice, DernierCoup) :- get_liste_successeurs(Board, Joueur, PionsDispo, ListeSuccesseurs),
																						get_liste_coups_successeurs(Board, Joueur, PionsDispo, ListeSuccesseursCoups),
																						length(ListeSuccesseurs, Longueur), 
																						Prof is Profondeur - 1, 
																						boucle_successeurs_max(Joueur, Prof, PionsDispo, ListeSuccesseurs, ListeSuccesseursCoups, Alpha, Beta, -32767, 0, Longueur, Res, Indice, DernierCoup), !.																
max_value(_Joueur, _Board, _Profondeur, _Alpha, _Beta, _PionsDispo, -32767, _Indice, _DernierCoup).

/*
boucle_successeurs_max(+Joueur, +Profondeur, +PionsDispo, +ListeSuccesseurs, +ListeCoupsSuccesseurs, ?Alpha, ?Beta, +VEntree, ?RangCourant, +Longueur, -Resultat, -Indice, +DernierCoup)
Idem que boucle_successeurs_min mais correspond à une ligne Max
*/
boucle_successeurs_max(Joueur, Profondeur, PionsDispo, [H|R], [H1|R1], Alpha, Beta, VEntree, RangCourant, Longueur, Resultat, Indice, DernierCoup) :- not(is_coup_oppose(H1, DernierCoup)),
																																					( (RangCourant < Longueur) ->
																																						adversaire(Joueur, Adversaire), 
																																						min_value(Adversaire, H, Profondeur, Alpha, Beta, PionsDispo, Res, _Ind, H1), 
																																						maximum(VEntree, Res, ResTemp), 
																																						( (ResTemp >= Beta) ->
																																							Resultat is ResTemp, !
																																							;
																																							Rang is RangCourant+1, 
																																							maximum(Alpha, ResTemp, NewAlpha),
																																							boucle_successeurs_max(Joueur, Profondeur, PionsDispo, R, R1, NewAlpha, Beta, ResTemp, Rang, Longueur, ResultatTemp, Index, DernierCoup),
																																							maximum(ResultatTemp, ResTemp, Resultat),
																																							( (ResultatTemp =< ResTemp) -> 
																																								Indice = RangCourant
																																								;
																																								Indice = Index
																																							)
																																						)
																																						;
																																						Resultat is VEntree,
																																						Indice is Longueur,
																																						!
																																					), !.
boucle_successeurs_max(Joueur, Profondeur, PionsDispo, [_H|R], [_H1|R1], Alpha, Beta, VEntree, RangCourant, Longueur, Resultat, Indice, DernierCoup) :- ( (RangCourant < Longueur) ->
																																							( (VEntree >= Beta) ->
																																								Resultat is VEntree, !
																																								;
																																								Rang is RangCourant+1,
																																								maximum(Alpha, VEntree, NewAlpha),	
																																								boucle_successeurs_max(Joueur, Profondeur, PionsDispo, R, R1, NewAlpha, Beta, VEntree, Rang, Longueur, ResultatTemp, Index, DernierCoup),
																																								maximum(ResultatTemp, VEntree, Resultat),
																																								( (ResultatTemp =< VEntree) -> 
																																									Indice = RangCourant
																																									;
																																									Indice = Index
																																								)															
																																							)
																																							;
																																							Resultat is VEntree,
																																							Indice is Longueur,
																																							!
																																						), !.																																		
boucle_successeurs_max(_Joueur, _Profondeur, _PionsDispo, [], [], _Alpha, _Beta, _VEntree, _RangCourant, _Longueur, -32767, _Indice, _DernierCoup).

/*
min_value(+Joueur, +Board, +Profondeur, +Alpha, +Beta, +PionsDispo, -Res, -Indice, +DernierCoup)
Simule le calcul en profondeur de l'algorithme MinMax avec élagage alpha-beta
Renvoie la valeur de l'état successeur optimal Res ainsi que son indice Indice
Prend en entrée le joueur courant Joueur, la profondeur courant Profondeur, la valeur de l'alpha et du beta Alpa-Beta, ainsi que les pions disponibles PionsDispo et le dernier coup joué DernierCoup
*/
min_value(Joueur, Board, 0, _Alpha, _Beta, _PionsDispo, Res, _Indice, _DernierCoup) :- adversaire(Joueur, Adversaire), eval_plateau(Joueur, Adversaire, Board, Res), !.
min_value(Joueur, Board, _Profondeur, _Alpha, _Beta, _PionsDispo, -2000, _Indice, _DernierCoup) :- check_victoire(Board, Joueur, 1), !.
min_value(Joueur, Board, _Profondeur, _Alpha, _Beta, _PionsDispo, 2000, _Indice, _DernierCoup) :- adversaire(Joueur, Adversaire), check_victoire(Board, Adversaire, 1), !.
min_value(Joueur, Board, Profondeur, Alpha, Beta, PionsDispo, Res, Indice, DernierCoup) :- get_liste_successeurs(Board, Joueur, PionsDispo, ListeSuccesseurs), 
																						get_liste_coups_successeurs(Board, Joueur, PionsDispo, ListeSuccesseursCoups),
																						length(ListeSuccesseurs, Longueur),  
																						Prof is Profondeur - 1, 
																						boucle_successeurs_min(Joueur, Prof, PionsDispo, ListeSuccesseurs, ListeSuccesseursCoups, Alpha, Beta, 32767, 0, Longueur, Res, Indice, DernierCoup), !.																
min_value(_Joueur, _Board, _Profondeur, _Alpha, _Beta, _PionsDispo, 32767, _Indice, _DernierCoup).

/*
boucle_successeurs_min(+Joueur, +Profondeur, +PionsDispo, +ListeSuccesseurs, +ListeCoupsSuccesseurs, ?Alpha, ?Beta, +VEntree, ?RangCourant, +Longueur, -Resultat, -Indice, +DernierCoup)
Prédicat pour simuler la boucle des successeurs ListeSuccesseurs-ListeCoupsSuccesseurs du plateau courant
Le joueur courant Joueur, la profondeur courante Profondeur, le nombre de pions disponibles PionsDispo sont fournis
Le prédicat simule le calcul en largeur avec l'alpha Alpha, le beta Beta, la valeur d'entrée VEntree pour le calcul, le rang courant RangCourant et la longueur totale Longueur pour le contrôle de boucle
Le prédicat renvoie le résultat optimal Resultat parmi les successeurs ainsi que l'indice de celui-ci, en prenant en compte le dernier coup joué DernierCoup
*/
boucle_successeurs_min(Joueur, Profondeur, PionsDispo, [H|R], [H1|R1], Alpha, Beta, VEntree, RangCourant, Longueur, Resultat, Indice, DernierCoup) :- not(is_coup_oppose(H1, DernierCoup)),
																																					( (RangCourant < Longueur) -> 
																																						adversaire(Joueur, Adversaire), 
																																						max_value(Adversaire, H, Profondeur, Alpha, Beta, PionsDispo, Res, _Ind, H1),
																																						minimum(VEntree, Res, ResTemp),
																																						( (ResTemp =< Alpha) ->
																																							Resultat = ResTemp, !
																																							;
																																							Rang is RangCourant+1, 
																																							minimum(Beta, ResTemp, NewBeta),
																																							boucle_successeurs_min(Joueur, Profondeur, PionsDispo, R, R1, Alpha, NewBeta, ResTemp, Rang, Longueur, ResultatTemp, Index, DernierCoup),
																																							minimum(ResultatTemp, ResTemp, Resultat),
																																							( (ResultatTemp >= ResTemp) -> 
																																								Indice = RangCourant
																																								;
																																								Indice = Index
																																							)
																																						)
																																						;
																																						Resultat is VEntree, 
																																						Indice is Longueur,
																																						!
																																					), !.
boucle_successeurs_min(Joueur, Profondeur, PionsDispo, [_H|R], [_H1|R1], Alpha, Beta, VEntree, RangCourant, Longueur, Resultat, Indice, DernierCoup) :- ( (RangCourant < Longueur) -> 
																																							( (VEntree =< Alpha) ->
																																								Resultat = VEntree, !
																																								;
																																								Rang is RangCourant+1, 
																																								minimum(Beta, VEntree, NewBeta),
																																								boucle_successeurs_min(Joueur, Profondeur, PionsDispo, R, R1, Alpha, NewBeta, VEntree, Rang, Longueur, ResultatTemp, Index, DernierCoup),
																																								minimum(ResultatTemp, VEntree, Resultat),
																																								( (ResultatTemp >= VEntree) -> 
																																									Indice = RangCourant
																																									;
																																									Indice = Index
																																								)
																																							)
																																							;
																																							Resultat is VEntree, 
																																							Indice is Longueur,
																																							!
																																						), !.																																		
boucle_successeurs_min(_Joueur, _Profondeur, _PionsDispo, [], [], _Alpha, _Beta, _VEntree, _RangCourant, _Longueur, 32767, _Indice, _DernierCoup).

/*
maximum(+Valeur1, +Valeur2, ?Res)
Teste ou retourne le maximum Res des valeurs Valeur1 et Valeur2
*/	
maximum(X, Y, X) :- (X >= Y), !.
maximum(_X, Y, Y).

/*
minimum(+Valeur1, +Valeur2, ?Res)
Idem avec le minimum
*/	
minimum(X, Y, X) :- (X =< Y), !.
minimum(_X, Y, Y).

/*
initBoard(-Board)
Retourne le plateau initialisé
Valeurs du plateau : 0 vide, -1 trou, 1 j1, 2 j2
*/
initBoard([0, 0, 0, 0, -1, 0, 0, 0, 0]). 

/*
initPions(-PionsDispo)
Retourne le nombre de pions de chaque joueur initialisé
*/
initPions([3, 3]).

/*
check_victoire(+Board, +Joueur, -Victoire)
Teste si le plateau Board fourni est un état vainqueur pour le joueur Joueur
Retourne Victoire=1 si c'est le cas, 0 sinon
*/
check_victoire([Joueur, Joueur, Joueur, _, _, _, _, _, _], Joueur, 1).
check_victoire([_, _, _, Joueur, Joueur, Joueur, _, _, _], Joueur, 1).
check_victoire([_, _, _, _, _, _, Joueur, Joueur, Joueur], Joueur, 1).
check_victoire([Joueur, _, _, Joueur, _, _, Joueur, _, _], Joueur, 1).
check_victoire([_, Joueur, _, _, Joueur, _, _, Joueur, _], Joueur, 1).
check_victoire([_, _, Joueur, _, _, Joueur, _, _, Joueur], Joueur, 1).
check_victoire([Joueur, _, _, _, Joueur, _, _, _, Joueur], Joueur, 1).
check_victoire([_, _, Joueur, _, Joueur, _, Joueur, _, _], Joueur, 1).
check_victoire(_Board, _Joueur, 0).

/*
is_coup_oppose(+Coup1, +Coup2)
Réussit si le coup Coup2 est le coup opposé au coup Coup2
Ceci ne s'applique qu'aux déplacements de case
*/
is_coup_oppose([2, X, Y], [2, Y, X]).
is_coup_oppose([3, X, Y], [3, Y, X]).

/*
adversaire(+Joueur1, ?Joueur2)
Retourne l'adversaire Joueur2 du joueur Joueur1 fourni 
*/
adversaire(1, 2).
adversaire(2, 1).

/*
val_affichee(+Val, -ValAffichee)
Retourne la valeur à afficher sur le plateau selon la valeur Val fournie
*/
val_affichee(-1, 'X') :- !.
val_affichee(X, X). 

/*
affecte_prof(+Joueur, +Choix, -Profondeur)
Retourne la profondeur Profondeur selon le joueur courant Joueur et le choix Choix effectué dans le menu du choix de difficulté de l'IA vs. IA
*/
affecte_prof(1, 0, 2).
affecte_prof(1, 1, 2).
affecte_prof(1, 2, 2).
affecte_prof(1, 3, 4).
affecte_prof(1, 4, 4).
affecte_prof(1, 5, 6).
affecte_prof(2, 0, 2).
affecte_prof(2, 1, 4).
affecte_prof(2, 2, 6).
affecte_prof(2, 3, 4).
affecte_prof(2, 4, 6).
affecte_prof(2, 5, 6).	

/*
is_adjacente_deplacer_pion(+CaseTestee, ?CaseAdjacenteDeplacePion)
Teste ou retourne la case adjacente CaseAdjacenteDeplacePion de la case testée CaseTestee pour un déplacement de pion
*/
is_adjacente_deplacer_pion(0, 1).
is_adjacente_deplacer_pion(0, 3).
is_adjacente_deplacer_pion(0, 4).
is_adjacente_deplacer_pion(1, 0).
is_adjacente_deplacer_pion(1, 2).
is_adjacente_deplacer_pion(1, 3).
is_adjacente_deplacer_pion(1, 4).
is_adjacente_deplacer_pion(1, 5).
is_adjacente_deplacer_pion(2, 1).
is_adjacente_deplacer_pion(2, 4).
is_adjacente_deplacer_pion(2, 5).
is_adjacente_deplacer_pion(3, 0).
is_adjacente_deplacer_pion(3, 1).
is_adjacente_deplacer_pion(3, 4).
is_adjacente_deplacer_pion(3, 6).
is_adjacente_deplacer_pion(3, 7).
is_adjacente_deplacer_pion(4, 0).
is_adjacente_deplacer_pion(4, 1).
is_adjacente_deplacer_pion(4, 2).
is_adjacente_deplacer_pion(4, 3).
is_adjacente_deplacer_pion(4, 5).
is_adjacente_deplacer_pion(4, 6).
is_adjacente_deplacer_pion(4, 7).
is_adjacente_deplacer_pion(4, 8).
is_adjacente_deplacer_pion(5, 1).
is_adjacente_deplacer_pion(5, 2).
is_adjacente_deplacer_pion(5, 4).
is_adjacente_deplacer_pion(5, 7).
is_adjacente_deplacer_pion(5, 8).
is_adjacente_deplacer_pion(6, 3).
is_adjacente_deplacer_pion(6, 4).
is_adjacente_deplacer_pion(6, 7).
is_adjacente_deplacer_pion(7, 3).
is_adjacente_deplacer_pion(7, 4).
is_adjacente_deplacer_pion(7, 5).
is_adjacente_deplacer_pion(7, 6).
is_adjacente_deplacer_pion(7, 8).
is_adjacente_deplacer_pion(8, 4).
is_adjacente_deplacer_pion(8, 5).
is_adjacente_deplacer_pion(8, 7).

/*
is_adjacente_deplacer_case(+CaseTestee, ?CaseAdjacenteDeplacePion)
Teste ou retourne la case adjacente CaseAdjacenteDeplacePion de la case testée CaseTestee pour un déplacement de case
*/
is_adjacente_deplacer_case(0, 1).
is_adjacente_deplacer_case(0, 3).
is_adjacente_deplacer_case(1, 0).
is_adjacente_deplacer_case(1, 2).
is_adjacente_deplacer_case(1, 4).
is_adjacente_deplacer_case(2, 1).
is_adjacente_deplacer_case(2, 5).
is_adjacente_deplacer_case(3, 0).
is_adjacente_deplacer_case(3, 4).
is_adjacente_deplacer_case(3, 6).
is_adjacente_deplacer_case(4, 1).
is_adjacente_deplacer_case(4, 3).
is_adjacente_deplacer_case(4, 5).
is_adjacente_deplacer_case(4, 7).
is_adjacente_deplacer_case(5, 2).
is_adjacente_deplacer_case(5, 4).
is_adjacente_deplacer_case(5, 8).
is_adjacente_deplacer_case(6, 3).
is_adjacente_deplacer_case(6, 7).
is_adjacente_deplacer_case(7, 4).
is_adjacente_deplacer_case(7, 6).
is_adjacente_deplacer_case(7, 8).
is_adjacente_deplacer_case(8, 5).
is_adjacente_deplacer_case(8, 7).

/*
oppose(+CaseTestee, ?CaseOppose)
Teste ou retourne la case CaseOppose à l'opposé du taquin à la position CaseTestee
*/
oppose(0, 2).
oppose(0, 6).
oppose(1, 7).
oppose(2, 0).
oppose(2, 8).
oppose(3, 5).
oppose(5, 3).
oppose(6, 0).
oppose(6, 8).
oppose(7, 1).
oppose(8, 2).
oppose(8, 6).

/*
get_valeur_interm(+CaseOrigine, +CaseArrivee, ?CaseInterm)
Teste ou retourne la case CaseInterm comprise entre la case CaseOrigine et la case CaseArrivee
*/ 
get_valeur_interm(0, 2, 1).
get_valeur_interm(0, 6, 3).
get_valeur_interm(1, 7, 4).
get_valeur_interm(2, 0, 1).
get_valeur_interm(2, 8, 5).
get_valeur_interm(3, 5, 4).
get_valeur_interm(5, 3, 4).
get_valeur_interm(6, 0, 3).
get_valeur_interm(6, 8, 7).
get_valeur_interm(7, 1, 4).
get_valeur_interm(8, 2, 5).
get_valeur_interm(8, 6, 7).