:- include('regles.pl').

/*
lire_choix(-Choix, +Val)
Prédicat pour lire le choix de saisie (Choix) avec une valeur maximale Val
*/
lire_choix(Choix, Val) :- write('\nVeuillez saisir une valeur entre 0 et '), write(Val), writeln(' : '), read(Choix), integer(Choix), between(0, Val, Choix), !.
lire_choix(Choix, Val) :- writeln('\nSaisie incorrecte ! Recommencez.'), lire_choix(Choix, Val).

/*
lire_choix_positionnement(-Choix, +Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Prédicat pour lire la case (Choix) où on veut poser un pion. Les autres paramètres sont passés pour pouvoir revenir au menu avec les bons paramètres
*/
lire_choix_positionnement(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('Veuillez saisir le numero de la case ou vous souhaitez poser votre pion (valeur de 0 a 8, 9 pour annuler) : '), read(Choix), integer(Choix), between(0, 9, Choix),
								switch(Choix, [
									9 : afficher_jeu(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
									_ : !
								]), !.
lire_choix_positionnement(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('\nSaisie incorrecte ! Recommencez.'), lire_choix_positionnement(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup).

/*
lire_choix_deplacer_pion_origine(-Choix, +Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Idem lire_choix_positionnement. Permet de lire le choix de la position de départ (Choix) d'un déplacement de pion
*/
lire_choix_deplacer_pion_origine(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('Veuillez saisir le numero de la case d\'ou le deplacement commence (valeur de 0 a 8, 9 pour annuler) : '), read(Choix), integer(Choix), between(0, 9, Choix),
														switch(Choix, [
															9 : afficher_jeu(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
															_ : verif_correcte_dpo(Choix, Board, Joueur)
														]), !.
lire_choix_deplacer_pion_origine(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('\nSaisie incorrecte ! Recommencez.'), lire_choix_deplacer_pion_origine(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup).

/*
verif_correcte_dpo(+Choix, +Board, +Joueur)
Prédicat pour vérifier que la position d'origine du déplacement (Choix) de pion saisie est possible (çàd que la case Choix contienne un pion du joueur Joueur)
*/
verif_correcte_dpo(Choix, Board, Joueur) :- nth0(Choix, Board, Valeur), Valeur=:=Joueur.

/*
lire_choix_deplacer_pion_arrivee(-Choix, +ChoixOrigine, +Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Idem que lire_choix_deplacer_pion_origine avec passage du choix d'origine du déplacement. Permet de lire le choix de la position d'arrivée (Choix) d'un déplacement de pion
*/
lire_choix_deplacer_pion_arrivee(Choix, ChoixOrigine, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('Veuillez saisir le numero de la case ou vous voulez deplacer le pion (valeur de 0 a 8, 9 pour annuler) : '), read(Choix), integer(Choix), between(0, 9, Choix), 
															switch(Choix, [
																9 : afficher_jeu(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																_ : verif_correcte_dpa(Choix, Board, ChoixOrigine)
															]), !.
lire_choix_deplacer_pion_arrivee(Choix, ChoixOrigine, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('\nSaisie incorrecte ! Recommencez.'), lire_choix_deplacer_pion_arrivee(Choix, ChoixOrigine, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup).

/*
verif_correcte_dpa(+Choix, +Board, +ChoixOrigine)
Prédicat pour vérifier que la position d'arrivée du déplacement (Choix) de pion saisie est valide (çad que la case d'arrivée soit vide i.e. la valeur est nulle, et que la case ChoixOrigine soit adjacente à la case Choix en haut, en bas, à gauche ou à droite)
*/
verif_correcte_dpa(Choix, Board, ChoixOrigine) :- nth0(Choix, Board, Valeur), Valeur=:=0, is_adjacente_deplacer_pion(ChoixOrigine, Choix).

/*
lire_choix_deplace_case_origine(-Choix, +Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Idem que lire_choix_deplacer_pion_origine avec passage du choix d'origine du déplacement. Permet de lire le choix de la position d'arrivée (Choix) d'un déplacement de case
*/
lire_choix_deplace_case_origine(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('Veuillez saisir le numero de la case a deplacer (valeur de 0 a 8, 9 pour annuler) : '), read(Choix), integer(Choix), between(0, 9, Choix), 
												switch(Choix, [
													9 : afficher_jeu(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
													_ : verif_correcte_dco(Choix, Board)
												]), !.
lire_choix_deplace_case_origine(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('\nSaisie incorrecte ! Recommencez.'), lire_choix_deplace_case_origine(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup).

/*
verif_correcte_dco(+Choix, +Board)
Prédicat pour vérifier que la position d'origine du déplacement (Choix) de case saisie est possible (çàd que la case Choix est adjacente en haut, à gauche, à droite ou en bas à la case du trou)
*/
verif_correcte_dco(Choix, Board) :- nth0(Choix, Board, Valeur), Valeur\=(-1), is_adjacente_deplacer_case(Choix, X), nth0(X, Board, Val), Val=:=(-1).

/*
lire_choix_deplace_case_arrivee(-Choix, +ChoixOrigine, +Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Idem que lire_choix_deplacer_case_origine avec passage du choix d'origine du déplacement. Permet de lire le choix de la position d'arrivée (Choix) d'un déplacement de case
*/
lire_choix_deplace_case_arrivee(Choix, ChoixOrigine, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('Veuillez saisir le numero de la case ou vous voulez deplacer la case (valeur de 0 a 8, 9 pour annuler) : '), read(Choix), integer(Choix), between(0, 9, Choix), 
															switch(Choix, [
																9 : afficher_jeu(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																_ : verif_correcte_dca(Choix, ChoixOrigine, Board)
															]), !.
lire_choix_deplace_case_arrivee(Choix, ChoixOrigine, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('\nSaisie incorrecte ! Recommencez.'), lire_choix_deplace_case_arrivee(Choix, ChoixOrigine, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup).

/*
verif_correcte_dca(+Choix, +ChoixOrigine, +Board)
Prédicat pour vérifier que la position d'arrivée du déplacement (Choix) de case saisie est valide (çad que la case d'arrivée soit le trou, donc de valeur -1, et que la case ChoixOrigine soit adjacente à la case Choix en haut, en bas, à gauche ou à droite)
*/
verif_correcte_dca(Choix, ChoixOrigine, Board) :- nth0(Choix, Board, Valeur), Valeur=:=(-1), is_adjacente_deplacer_case(ChoixOrigine, Choix).

/*
lire_choix_deplace_deux_cases_origine(-Choix, +Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Idem que lire_choix_deplacer_case_origine avec passage du choix d'origine du déplacement. Permet de lire le choix de la position d'arrivée (Choix) d'un déplacement de deux cases
*/
lire_choix_deplace_deux_cases_origine(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('Veuillez saisir le numero de la case a l\'oppose de X souhaitee (valeur de 0 a 8, 9 pour annuler) : '), read(Choix), integer(Choix), between(0, 9, Choix), 
													switch(Choix, [
														9 : afficher_jeu(Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
														_ : verif_correcte_ddc(Choix, Board)
													]), !.
lire_choix_deplace_deux_cases_origine(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('\nSaisie incorrecte ! Recommencez.'), lire_choix_deplace_deux_cases_origine(Choix, Board, ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup).

/*
verif_correcte_ddc(+Choix, +Board)
Prédicat pour vérifier que la case choisie (Choix) est bien à l'opposé du trou
*/
verif_correcte_ddc(Choix, Board) :- nth0(Choix, Board, Valeur), Valeur\=(-1), oppose(Choix, X), nth0(X, Board, -1).

/*
afficher_coup_joue(+Coup, +Joueur)
Affiche le coup joué (Coup) selon le type de celui-ci
*/
afficher_coup_joue([0, X], Joueur) :- write('Le joueur '), write(Joueur), write(' va poser un pion sur la case '), write(X), writeln('.'), !. 
afficher_coup_joue([1, X, Y], Joueur) :- write('Le joueur '), write(Joueur), write(' va deplacer un pion de la case '), write(X), write(' a la case '), write(Y), writeln('.'), !.
afficher_coup_joue([2, X, Y], Joueur) :- write('Le joueur '), write(Joueur), write(' va deplacer une case de la position '), write(X), write(' a la position '), write(Y), writeln('.'), !.
afficher_coup_joue([3, X, Y], Joueur) :- write('Le joueur '), write(Joueur), write(' va deplacer deux cases de la position '), write(X), write(' a la position '), write(Y), writeln('.').						   

/*
choix_action_jeu_ia(+Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Prédicat de jeu de l'IA dans le cas où c'est IA vs. IA
Board représente le plateau, ChoixMenu le type de partie, ChoixDifficulte la difficulté de l'IA, Joueur le joueur courant, PionsDispo les pions dont dispose chaque joueur et DernierCoup le dernier coup joué
*/
choix_action_jeu_ia(Board, 1, ChoixDifficulte, 1, PionsDispo, DernierCoup) :- writeln('Joueur 1 (IA) va jouer.'),
																			get_liste_coups_successeurs(Board, 1, PionsDispo, ListeSuccesseursCoups),
																			affecte_prof(1, ChoixDifficulte, Prof),									
																			minmax(1, Board, PionsDispo, Prof, _V, Indice, DernierCoup),
																			nth0(Indice, ListeSuccesseursCoups, X),
																			maj_board_ia(Board, 1, PionsDispo, X, NewBoard, NewPionsDispo),
																			afficher_coup_joue(X, 1),
																			verifier_victoire(NewBoard, 1, ChoixDifficulte, 1, NewPionsDispo, X).
																				
choix_action_jeu_ia(Board, 1, ChoixDifficulte, 2, PionsDispo, DernierCoup) :- writeln('Joueur 2 (IA) va jouer.'),
																			get_liste_coups_successeurs(Board, 2, PionsDispo, ListeSuccesseursCoups),
																			affecte_prof(2, ChoixDifficulte, Prof),		
																			minmax(2, Board, PionsDispo, Prof, _V, Indice, DernierCoup),
																			nth0(Indice, ListeSuccesseursCoups, X),
																			maj_board_ia(Board, 2, PionsDispo, X, NewBoard, NewPionsDispo),
																			afficher_coup_joue(X, 2),
																			verifier_victoire(NewBoard, 1, ChoixDifficulte, 2, NewPionsDispo, X).																				

/*
choix_action_jeu(+Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)	
Idem ci-haut mais dans le cas de Joueur vs. IA	
Pour le Joueur IA, le prédicat détermine le coup à jouer et joue
Pour le Joueur non IA, on a un affichage des choix divers dont il dispose selon les variables du jeu
En outre, si il n'a plus de pions, il ne peut pas poser, si il ne peut pas déplacer un pion, le choix ne lui est pas offert, etc...
6 cas sont possibles pour le joueur	
*/												
choix_action_jeu(Board, ChoixMenu, ChoixDifficulte, 2, PionsDispo, DernierCoup) :- writeln('Joueur 2 (IA) va jouer.'), 
																				get_liste_coups_successeurs(Board, 2, PionsDispo, ListeSuccesseursCoups),
																				Profondeur is ((ChoixDifficulte + 1)*2),
																				minmax(2, Board, PionsDispo, Profondeur, _V, Indice, DernierCoup),
																				nth0(Indice, ListeSuccesseursCoups, X),
																				maj_board_ia(Board, 2, PionsDispo, X, NewBoard, NewPionsDispo),
																				afficher_coup_joue(X, 2),
																				verifier_victoire(NewBoard, ChoixMenu, ChoixDifficulte, 2, NewPionsDispo, X), 
																				!.								
choix_action_jeu([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- NumJoueur is (Joueur - 1),
																											nth0(NumJoueur, PionsDispo, X),
																											X\=0, X\=3, 
																											(A=:=(-1); B=:=(-1); C=:=(-1); D=:=(-1); F=:=(-1); G=:=(-1); H=:=(-1); I=:=(-1)),
																											write('Joueur '), write(Joueur), writeln(', a vous de jouer !\n'),
																											writeln('0 - Poser un pion.'),
																											writeln('1 - Deplacer un pion.'),
																											writeln('2 - Deplacer une case.'),
																											writeln('3 - Deplacer deux cases.'), 
																											writeln('4 - Retour au menu.'), 
																											lire_choix(ChoixAction, 4),
																											switch(ChoixAction, [
																												0 : poser_pion([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												1 : deplacer_pion([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												2 : deplacement_une_case([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												3 : deplacement_deux_cases([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												4 : menu
																											]), !.																
choix_action_jeu([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- NumJoueur is Joueur-1,
																											nth0(NumJoueur, PionsDispo, X),
																											X\=0, X\=3, 
																											not((A=:=(-1); B=:=(-1); C=:=(-1); D=:=(-1); F=:=(-1); G=:=(-1); H=:=(-1); I=:=(-1))),
																											write('Joueur '), write(Joueur), writeln(', a vous de jouer !\n'),
																											writeln('0 - Poser un pion.'),
																											writeln('1 - Deplacer un pion.'),
																											writeln('2 - Deplacer une case.'),
																											writeln('3 - Retour au menu.'),
																											lire_choix(ChoixAction, 3),
																											switch(ChoixAction, [
																												0 : poser_pion([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												1 : deplacer_pion([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												2 : deplacement_une_case([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												3 : menu
																											]), !.																																
choix_action_jeu([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- NumJoueur is Joueur-1,
																											nth0(NumJoueur, PionsDispo, 0),
																											(A=:=(-1); B=:=(-1); C=:=(-1); D=:=(-1); F=:=(-1); G=:=(-1); H=:=(-1); I=:=(-1)),
																											write('Joueur '), write(Joueur), writeln(', a vous de jouer !\n'),
																											writeln('0 - Deplacer un pion.'),
																											writeln('1 - Deplacer une case.'),
																											writeln('2 - Deplacer deux cases.'), 
																											writeln('3 - Retour au menu.'),
																											lire_choix(ChoixAction, 3),
																											switch(ChoixAction, [
																												0 : deplacer_pion([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												1 : deplacement_une_case([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												2 : deplacement_deux_cases([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												3 : menu
																											]), !.																
choix_action_jeu([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- NumJoueur is Joueur-1,
																											nth0(NumJoueur, PionsDispo, 0),
																											not((A=:=(-1); B=:=(-1); C=:=(-1); D=:=(-1); F=:=(-1); G=:=(-1); H=:=(-1); I=:=(-1))),
																											write('Joueur '), write(Joueur), writeln(', a vous de jouer !\n'),
																											writeln('0 - Deplacer un pion.'),
																											writeln('1 - Deplacer une case.'),
																											writeln('2 - Retour au menu.'),
																											lire_choix(ChoixAction, 2),
																											switch(ChoixAction, [
																												0 : deplacer_pion([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												1 : deplacement_une_case([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												2 : menu
																											]), !.																																	
choix_action_jeu([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- NumJoueur is Joueur-1,
																											nth0(NumJoueur, PionsDispo, 3),
																											(A=:=(-1); B=:=(-1); C=:=(-1); D=:=(-1); F=:=(-1); G=:=(-1); H=:=(-1); I=:=(-1)),
																											write('Joueur '), write(Joueur), writeln(', a vous de jouer !\n'),
																											writeln('0 - Poser un pion.'),
																											writeln('1 - Deplacer une case.'),
																											writeln('2 - Deplacer deux cases.'), 
																											writeln('3 - Retour au menu.'),
																											lire_choix(ChoixAction, 3),
																											switch(ChoixAction, [
																												0 : poser_pion([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												1 : deplacement_une_case([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												2 : deplacement_deux_cases([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												3 : menu
																											]), !.																
choix_action_jeu([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- NumJoueur is Joueur-1,
																											nth0(NumJoueur, PionsDispo, 3),
																											not((A=:=(-1); B=:=(-1); C=:=(-1); D=:=(-1); F=:=(-1); G=:=(-1); H=:=(-1); I=:=(-1))),
																											write('Joueur '), write(Joueur), writeln(', a vous de jouer !\n'),
																											writeln('0 - Poser un pion.'),
																											writeln('1 - Deplacer une case.'),
																											writeln('2 - Retour au menu.'),
																											lire_choix(ChoixAction, 2),
																											switch(ChoixAction, [
																												0 : poser_pion([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												1 : deplacement_une_case([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																												2 : menu
																											]), !.										

/*
afficher_jeu(+Board, +ChoixMenu, +ChoixDifficulte, +Joueur, +PionsDispo, +DernierCoup)
Affiche le plateau
*/
afficher_jeu([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup) :- writeln('\n+-----------+'),
																										write('| '), val_affichee(A, J), write(J), write(' | '), val_affichee(B, K), write(K), write(' | '), val_affichee(C, L), write(L), writeln(' |'),
																										writeln('+-----------+'),
																										write('| '), val_affichee(D, M), write(M), write(' | '), val_affichee(E, N), write(N), write(' | '), val_affichee(F, O), write(O), writeln(' |'),
																										writeln('+-----------+'),
																										write('| '), val_affichee(G, P), write(P), write(' | '), val_affichee(H, Q), write(Q), write(' | '), val_affichee(I, R), write(R), writeln(' |'),
																										writeln('+-----------+\n'),	
																										switch(ChoixMenu, [
																											0 : choix_action_jeu([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup),
																											1 : choix_action_jeu_ia([A, B, C, D, E, F, G, H, I], ChoixMenu, ChoixDifficulte, Joueur, PionsDispo, DernierCoup)
																										]), !.		
	
/*
afficher_jeu_fini(+Board)
Affiche le plateau et revient au menu (cas d'une victoire)
*/	
afficher_jeu_fini([A, B, C, D, E, F, G, H, I]) :- writeln('\n+-----------+'),
												write('| '), val_affichee(A, J), write(J), write(' | '), val_affichee(B, K), write(K), write(' | '), val_affichee(C, L), write(L), writeln(' |'),
												writeln('+-----------+'),
												write('| '), val_affichee(D, M), write(M), write(' | '), val_affichee(E, N), write(N), write(' | '), val_affichee(F, O), write(O), writeln(' |'),
												writeln('+-----------+'),
												write('| '), val_affichee(G, P), write(P), write(' | '), val_affichee(H, Q), write(Q), write(' | '), val_affichee(I, R), write(R), writeln(' |'),
												writeln('+-----------+\n'),	
												menu.										

/*
lancer_partie(+Choix, +ChoixMenu)
Lance la partie une fois le mode de jeu et, éventuellement, la difficulté sont choisis
Le prédicat génère le plateau initial Board, les pions disponibles initiaux PionsDispo et affiche le jeu pour le joueur 1
*/
lancer_partie(Choix, 0) :- writeln('\nPartie lancee.'), initBoard(Board), initPions(PionsDispo), afficher_jeu(Board, 0, Choix, 1, PionsDispo, []).
lancer_partie(Choix, 1) :- writeln('\nPartie lancee.'), initBoard(Board), initPions(PionsDispo), afficher_jeu(Board, 1, Choix, 1, PionsDispo, []).

/*
action_choix_difficulte(+ChoixMenu, +ChoixDifficulte)
Affiche la partie choisie avec difficulté et lance la partie
*/
action_choix_difficulte(0, 0) :- writeln('\nPartie Joueur vs. IA facile choisie.'), lancer_partie(0, 0).
action_choix_difficulte(1, 0) :- writeln('\nPartie Joueur vs. IA moyenne choisie.'), lancer_partie(1, 0).
action_choix_difficulte(2, 0) :- writeln('\nPartie Joueur vs. IA difficile choisie.'), lancer_partie(1, 0).
action_choix_difficulte(0, 1) :- writeln('\nPartie IA (facile) vs. IA (facile) choisie.'), lancer_partie(0, 1).
action_choix_difficulte(1, 1) :- writeln('\nPartie IA (facile) vs. IA (moyen) choisie.'), lancer_partie(1, 1).
action_choix_difficulte(2, 1) :- writeln('\nPartie IA (facile) vs. IA (difficile) choisie.'), lancer_partie(2, 1).
action_choix_difficulte(3, 1) :- writeln('\nPartie IA (moyen) vs. IA (moyen) choisie.'), lancer_partie(3, 1).
action_choix_difficulte(4, 1) :- writeln('\nPartie IA (moyen) vs. IA (difficile) choisie.'), lancer_partie(4, 1).
action_choix_difficulte(5, 1) :- writeln('\nPartie IA (difficile) vs. IA (difficile) choisie.'), lancer_partie(5, 1).
action_choix_difficulte(6, _ChoixMenu) :- writeln('\nRetour au menu choisi.'), menu.

/*
choix_difficulte(+ChoixMenu)
Affiche les difficultés au choix dans le mode Joueur vs. IA et lit le choix du joueur
*/
choix_difficulte(ChoixMenu) :- writeln('-------------------------------------------------------------------------------\n'),
							writeln('\t\t\t      0 - Facile\t\t\t'),
							writeln('\t\t\t      1 - Moyen\t\t\t'),
							writeln('\t\t\t      2 - Difficile\t\t\t'),
                    	    writeln('\t\t\t      3 - Retour menu\t\t\t\n'),
							writeln('-------------------------------------------------------------------------------'),
                    	    lire_choix(Choix, 3),
                    	    action_choix_difficulte(Choix, ChoixMenu).

/*
choix_difficulte_ia_ia
Affiche les difficultés au choix dans le mode IA vs. IA et lit le choix
*/							
choix_difficulte_ia_ia :- writeln('-------------------------------------------------------------------------------\n'),
						writeln('\t\t\t      0 - Facile vs. Facile\t\t\t'),
						writeln('\t\t\t      1 - Facile vs. Moyen\t\t\t'),
						writeln('\t\t\t      2 - Facile vs. Difficile\t\t\t'),
						writeln('\t\t\t      3 - Moyen vs. Moyen\t\t\t'),
						writeln('\t\t\t      4 - Moyen vs. Difficile\t\t\t'),
						writeln('\t\t\t      5 - Difficile vs. Difficile\t\t\t'),
                    	writeln('\t\t\t      6 - Retour menu\t\t\t\n'),
						writeln('-------------------------------------------------------------------------------'),
                    	lire_choix(Choix, 6),
                    	action_choix_difficulte(Choix, 1).							

/*
action_choix(+Choix)
Affiche le type de partie choisie et lance l'action correspondante
*/
action_choix(0) :- writeln('\nPartie joueur vs. IA choisie.\n'), choix_difficulte(0), !.
action_choix(1) :- writeln('\nPartie IA vs. IA choisie.\n'), choix_difficulte_ia_ia, !.
action_choix(2) :- writeln('\nAu revoir !'), halt.

/*
menu
Prédicat initial du jeu affichant le menu et demandant le type de partie à lancer
*/
menu :- writeln('\n----------------------------Bienvenue sur Force 3 !----------------------------\n'),
	writeln('Realise par Abdelhafid Sefiane, Nicolas Hergenroether et Mathilde Perrot (IA41)\n'),
   	writeln('-------------------------------------------------------------------------------\n'),
   	writeln('\t\t\t      0 - Joueur vs. IA\t\t\t'),
   	writeln('\t\t\t      1 - IA vs. IA\t\t\t'),
   	writeln('\t\t\t      2 - Quitter\t\t\t\n'),
   	writeln('-------------------------------------------------------------------------------'),
   	lire_choix(Choix, 2), 
   	action_choix(Choix).