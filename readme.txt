Bonjour,

Merci d'utiliser notre programme de tri de données météorologiques. 

Voici tous les détails nécessaires pour comprendre le fonctionnement de notre script. 

Pour exécuter le script, vérifiez que vous avez bien tous les droits rentrant dans votre terminal "ls -l". Si cela n'est pas le cas, rentrez "chmod u+x `nom du script`". 

Si cela n'est pas déjà fait, il vous faudra installer l'utilitaire "gnuplot" sur votre terminal avec la commande "sudo apt install gnuplot". 

Il est nécessaire de rentrer en paramètre le nom du fichier à trier, précédé de la commande "-f". Pour un fichier du nom "données_météo", il faudra exécuter le script suivi de "-f données_météo" sans quoi un message d'erreur s'affichera.

Les options de tri son multiples. Vous pouvez trier selon 15 options (au moins l'une des 5 premières options doit être choisie sans quoi le script ne se lancera pas) :
	1) La température "-t" suivi de "1" (produit en sortie les températures minimales, maximales et moyennes par station dans l’ordre croissant du numéro de station), "2" (produit en sortie les températures moyennes par date/heure, triées dans l’ordre chronologique. La moyenne se fait sur toutes les stations) ou "3" (produit en sortie les températures par date/heure par station. Elles seront triées d’abord par ordre chronologique, puis par ordre croissant de l’identifiant de la station). 
	2) La pression "-p" suivi de "1" (produit en sortie les pressions minimales, maximales et moyennes par station dans l’ordre croissant du numéro de station), "2" (produit en sortie les pressions moyennes par date/heure, triées dans l’ordre chronologique. La moyenne se fait sur toutes les stations) ou "3" (produit en sortie les pressions par date/heure par station. Elles seront triées d’abord par ordre chronologique, puis par ordre croissant de l’identifiant de la station).
	3) Le vent "-w" : produit en sortie l’orientation moyenne et la vitesse moyenne des vents pour chaque station. Quand on parle de moyenne, il s’agira de faire la somme pour chaque composante du vecteur, et d’en faire la moyenne une fois tous les vecteurs traités. On aura donc une moyenne sur l’axe X et une moyenne sur l’axe Y : les 2 résultats fournissant le module et l’orientation moyens demandés. Les données seront triées par identifiant croissant de la station.
	4) L'altitude "-h" : produit en sortie l’altitude pour chaque station. Les altitudes seront triées par ordre décroissant. 
	5) L'humidité "-m" : produit en sortie l’humidité maximale pour chaque station. Les valeurs d’humidités seront triées par ordre décroissant.
	6) L'option "-F" :(F)rance : France métropolitaine + Corse.
	7) L'option "-G":(G)uyanefrançaise.
	8) L'option "-S" : (S)aint - Pierre et Miquelon (ile située à l’Est du Canada. 
	9) L'option "-A" : (A)ntilles.
	10) L'option "-O" : (O)céanindien.
	11) L'option "-Q" : antarcti(Q)ue.
	12) L'option "-d" : permet de trier selon la date. Les données de sortie sont dans l’intervalle de dates [<min>..<max>] incluses. Le format des dates est une chaine de type YYYY-MM-DD (année-mois-jour). Ainsi, pour sélectionner un intervalle de dates, il faut rentrer par exemple "2010-05-12 2020-12-24".
	13) L'option de tri "--tab" : tri effectué à l’aide d’une structure linéaire (au choix un tableau ou une liste chaînée). 
	14) L'option de tri "--abr" : tri effectué à l’aide d’une structure de type ABR. 
	15) L'option de tri "--avl" : tri effectué à l’aide d’une structure de type AVL.


Un exemple d'arguments : 
	Ne marche pas : ./script_shell.sh -f meteo_filtered_data_v1.csv -d 2010-01-12 2010-10-25 -F -t 1 -A
	Ne marche pas : ./script_shell.sh -f meteo_filtered_data_v1.csv -d 2010-01-12 2010-10-25 -F
	Fonctionne : ./script_shell.sh -f meteo_filtered_data_v1.csv -d 2010-01-12 2010-10-25 -F -t 1
	Fonctionne et est identique au précédent : ./script_shell.sh -t 1 -f meteo_filtered_data_v1.csv -d 2010-01-12 2010-10-25 -F

PS : les options peuvent être rentrées dans l'ordre souhaité, cela n'influencera pas la sortie du script.



Une fois le script lancé, il y a différents codes de retour : (valeurs 1 à 4 prises par le programme de tri en C)
	si 0 : le programme s'est exécuté correctement (aussi bien le script que le C)
 	si 1 : erreur sur les options activées (mauvaise combinaison, option obligatoire manquante, ... )
	si 2 : erreur avec le fichier de données d’entrée (impossible de l’ouvrir, impossible de lire le contenu, format de données incorrect, ... )
	si 3 : erreur avec le fichier de données de sortie (impossible de l’ouvrir, d’écrire dedans, ... )
	si 4 : toute autre erreur d’exécution interne
	si 5 : problème avec le fichier en entrée -> pas de fichier implique pas de code qui tourne
	si 6 : mauvais argument
	si 7 : mauvaise donnée pour la température
	si 8 : mauvaise donnée pour la pression
	si 9 : aucun argument n'a été passé en paramètre pour effectuer le tri



Petit problème en humidité : j'ai essayé avec head de corriger mais ça n'a pas marché => titre des colonnes en bas



