/* 
rows(+P, +N, -L)
Extrait les lignes L1, L2 et L3 du plateau P
*/	
rows([A, B, C, D, E, F, G, H, I], [[A, B, C], [D, E, F], [G, H, I]]).

/*
cols(+P, -C)
Extrait les colonnes C1, C2 et C3 du plateau P
*/	
cols([A, B, C, D, E, F, G, H, I], [[A, D, G], [B, E, H], [C, F, I]]).

/*
diags(+P, -D)				
Extrait les diagonales D1 et D2 du plateau P
*/
diags([A, _, B, _, C, _, D, _, E], [[A, C, E], [B, C, D]]).

/*
calc_L(+J1, +J2, +L, -Pts)
Calcule les points sur une ligne, une colonne ou une diagonale
Si un pion du joueur courant : 10 pts, si 2 : 30 pts
Si un pion du joueur adverse : -10 pts, si 2 : -30 pts
Si un pion de chaque ou pas de pions : 0 pts
*/	
calc_L(J1, J2, L, Pts) :- member(J1, L), not(member(J2, L)), include(=:=(J1), L, R), length(R, Nb), Nb=:=3, Pts is 1000, !.					
calc_L(J1, J2, L, Pts) :- member(J1, L), not(member(J2, L)), include(=:=(J1), L, R), length(R, Nb), Nb=:=2, Pts is 30, !.
calc_L(J1, J2, L, Pts) :- member(J1, L), not(member(J2, L)), include(=:=(J1), L, R), length(R, Nb), Nb=:=1, Pts is 10, !.
calc_L(J1, J2, L, Pts) :- member(J2, L), not(member(J1, L)), include(=:=(J2), L, R), length(R, Nb), Nb=:=3, Pts is -1000, !.
calc_L(J1, J2, L, Pts) :- member(J2, L), not(member(J1, L)), include(=:=(J2), L, R), length(R, Nb), Nb=:=2, Pts is -30, !.
calc_L(J1, J2, L, Pts) :- member(J2, L), not(member(J1, L)), include(=:=(J2), L, R), length(R, Nb), Nb=:=1, Pts is -10, !.
calc_L(_J1, _J2, _L, 0).

/*
calc_p(+J1, +J2, +L, -Pts)
Calcule les points pour l'ensemble des lignes, colonnes ou diagonales du plateau
*/	
calc_p(J1, J2, [L1, L2, L3], Pts) :- calc_L(J1, J2, L1, Pts1), calc_L(J1, J2, L2, Pts2), calc_L(J1, J2, L3, Pts3), Pts is (Pts1 + Pts2 + Pts3).
calc_p(J1, J2, [L1, L2], Pts) :- calc_L(J1, J2, L1, Pts1), calc_L(J1, J2, L2, Pts2), Pts is (Pts1 + Pts2).

/*
eval_plateau(+J1, +J2, +P, -Val)										 
Evalue l'état du plateau P du point de vue du joueur J1 face à J2
*/										
eval_plateau(J1, J2, P, Val) :- rows(P, Rows), calc_p(J1, J2, Rows, PtsRows),
								cols(P, Cols), calc_p(J1, J2, Cols, PtsCols),
								diags(P, Diags), calc_p(J1, J2, Diags, PtsDiags),
								Val is PtsRows + PtsCols + PtsDiags.


