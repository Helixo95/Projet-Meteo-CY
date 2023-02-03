#!/bin/bash

function main() {
    suppression_gnuplot #on supprime les graphiques précédents afin qu'il n'y ait aucune altercations
    #initialisation des variables à 0. Cela permet de voir si elles sont utilisées 
    temp=0
    pres=0
    vent=0
    humidite=0
    altitude=0
    date=0
    triLocalisation=0

    check $@    #permet de vérifier les arguments saisis lors de l'exécution du script
    check_date  #permet d'organiser le tri selon la date puis selon la position
    check_localisation_arguments
    
    #fonction qui organise le tri selon la position géographique => va créer un nouveau fichier .csv pour ne trier les données que selon le pays selectionné
    
    if [ "$triLocalisation" -eq "0" ] #si jamais aucun argument de tri selon la localisation a été passé en paramètre, alors un tri "simple" sera effectué
    then
        args #fonction pour checker les arguments rentrés en paramètre et trier dans un fichier texte si pas de tri selon les pays
    fi
    
    suppression_fichiers_annexes #supprime les fichiers de tris

    exit 0 #retourne 0 si tout s'est bien passé
}

function check(){
    while [ "$1" != "" ]; do
        case $1 in
            --help )
                help_user
                ;;
            --avl )
                echo "Tri avec un avl"
                ;;
            --abr )
                echo "Tri avec un abr"
                abr=true
                ;;
            --tab )
                echo "Tri avec un tableau"
                tab=true
                ;;
            -t )
                shift
                echo "Vous avez choisi de trier selon la température"
                temp=$1
                ;;
            -p )
                shift
                echo "Vous avez choisi de trier selon la pression"
                pres=$1
                ;;
            -w )
                echo "Vous avez choisi de trier selon le vent"
                vent=1
                ;;
            -m )
                echo "Vous avez choisi de trier selon l'humidité"
                humidite=1
                ;;
            -h )
                echo "Vous avez choisi de trier selon l'altitude"
                altitude=1
                ;;
            -F )
                echo "Vous avez choisi de trier en France"
                Fr=true
                ;;
            -G )
                echo "Vous avez choisi de trier en Guyane"
                Gu=true
                ;;
            -S )
                echo "Vous avez choisit de trier à Saint-Pierre et Miquelon"
                St=true
                ;;
            -A )
                echo "Vous avez choisit de trier aux Antilles"
                An=true
                ;;
            -O )
                echo "Vous avez choisi de trier dans l'Océan Indien"
                OI=true
                ;;
            -Q )
                echo "Vous avez choisit de trier en Antartique"
                Qu=true
                ;;
            -d )
                echo "Vous avez choisi de trier par date"
                date=1
                shift
                if [[ ! "$1" =~ ^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$ ]] #cherche une valeur entre 0 et 9 4 fois
                then
                    echo "la valeur <min> de l'option -d est incorrecte. Veuillez vous réferrez à --help pour connaitre l'utilisation du script"
                    exit 1
                fi
                dateMin=$1
                shift
                if [[ ! "$1" =~ ^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])$ ]]
                then
                    echo "la valeur <max> de l'option -d est incorrecte. Veuillez vous réferrez à --help pour connaitre l'utilisation du script"
                    exit 1
                fi
                dateMax=$1
                echo "$dateMin"
                echo "$dateMax"
                ;;
            -f )
                shift
                echo "Fichier passé en paramètre"
                file=$1
                ;;
            * )
                echo "Option non reconnue : $1. Veuillez vous référer au readme pour l'utilisation des arguments."
                help_user
                exit 6
                ;;
        esac
        shift
    done
    
    if [ "$file" = "" ]
    then
        echo "Pas de fichier en entrée"
        exit 5
    else
        echo "Le fichier à trier est $file"
    fi

    if [ "$humidite" -eq "0" ] && [ "$pres" -eq "0" ] &&  [ "$temp" -eq "0" ] &&  [ "$altitude" -eq "0" ] &&  [ "$vent" -eq "0" ]
    then
        echo "Veuillez saisir un argument de tri svp"
        exit 9
    fi
}

function help_user(){
    cat help.txt
}

function args(){
    if [ "$temp" -ne "0" ]
    then
        if [ "$temp" -eq "1" ]
        then
            touch temperature1.txt
            touch temp1.txt
            cat $file | awk -F ";" 'BEGIN{OFS=FS}; {if ($11==""); else print $1, $11}' | sort -t";" -k1n | tail -n+2 > temperature1.txt
            #compilation temperature1.txt touch temp1.txt #fonction pour compilation et exécution du c
            #si le c marchait, on aurait fait cat temp1.txt
            cat temperature1.txt | awk -F ";" 'BEGIN{OFS=FS; tempMin=$2; tempMax=$2; n=0; ID=""; somme=0} 
            {
                if(ID!=$1)
                {
                    if(n!=0)
                    {
                        print somme/n, tempMin, tempMax, ID
                    }
                    ID=$1;
                    tempMin=$2;
                    tempMax=$2;
                    n=0;
                    somme=0;
                }
                somme+=$2;
                n+=1;
                if(tempMin>$2) 
                    {
                        tempMin=$2
                    }
                    if(tempMax<$2) 
                    {
                        tempMax=$2
                    }
            }
            END {print somme/n";"tempMin";"tempMax";"ID}' > temperature_sort1.txt

gnuplot -persist <<-EOFMarker
    set terminal png size 1920,1080
    set output "t1_out.png"
    set datafile separator ";"
    set title "Température en fonction de la station"
    set xlabel "ID Station"
    set xtics rotate by 50 offset -3,-2
    set ylabel "Température (°C)"
    plot "temperature_sort1.txt" using 0:3:2 with filledcurve fc rgb "blue" title "Plage des températures", ''using 0:1:xtic(4) lw 3 with lines title "Température moyene"
    #colonne 0 prend n° de la ligne donc on reprend 4 pour xtic
    #1ère colonne : moyenne
    #2ème colonne : min
    #3ème colonne : max
    #4ème colonne : id station
EOFMarker

    
        elif [ "$temp" -eq "2" ]
        then
            touch temperature2.txt
            touch temp2.txt
            touch temperature_sort2.txt
            cat $file | awk -F ";" 'BEGIN{OFS=FS}; {if ($11==""); else print $2,$11}' | sort -t";" -k1 -n | tail -n+2 > temperature2.txt
            #compilation temperature2.txt temp2.txt
            #idem qu'à l'argument 1
            cat temperature2.txt | awk -F ";" 'BEGIN{OFS=FS; DATE=""; n=0; somme=0} 
            {
                if(DATE!=$1)
                {
                    if(n!=0)
                    {
                        print DATE, somme/n
                    }
                    DATE=$1;
                    n=0;
                    somme=0;
                }
                somme+=$2;
                n+=1;
            }
            END {print DATE";"somme/n}' > temperature_sort2.txt


gnuplot -persist <<-EOFMarker
    set terminal png size 1920,1080
    set output "t2_out.png"
    set title "Température par date"
    set xlabel "Date"
    set ylabel "Température (°C)"
    set datafile separator ";"
    set xdata time
    set timefmt '%Y-%m-%dT%H-%M%S'
    set xtics rotate by 50 offset -3,-2
    plot "temperature_sort2.txt" using 1:2 with lines title "Température moyene"
EOFMarker

        elif [ "$temp" -eq "3" ]
        then
            touch temperature3.txt
            touch temp3.txt
            #cat $file | awk -F ";" 'BEGIN{OFS=FS}; {if ($11==""); else printf "%+7s %-0s %-0s\n",  $1, $2, $11}' commande pour déclaler les espaces afin de faciliter le tri pour le programme c
            cat $file | awk -F ";" 'BEGIN{OFS=FS}; {if ($11==""); else print $1, $2, $11}' | sort -k 2n,2 -k 1n,1 | tail -n+2 > temperature3.txt
            #compilation temperature3.txt temp3.txt
            file=temperature3.txt #file=temp3.txt si c fonctionne
            sed 's/T/;/g' "$file" | awk -F ";" 'BEGIN{OFS=FS} 
            {
                split ($2, coord, ";")
            }
            {
                x = coord[1]; y = coord[2]
            }
            {
                if ($4=="" && $5==""); else print $1, x, y, $3
            }' | tail -n+2 > temperature_sort3.txt

            #gunplot qui aurait pu marcher 

#gnuplot -persist <<-EOFMarker
    #set terminal png size 1920,1080
    #set output "t3_out_1.png"
    #set xdata time
    #set timefmt "%Y-%m-%dT%H-%M%S"
    #set xtic rotate by 45
    #set xtics format "%Y-%m-%dT%H-%M%S"
    #set xlabel "Jour"
    #set ylabel "Valeur mesurée"
    #set datafile separator ";"

    #plot "temperature3.txt" using 1:3 with lines linetype 1 lc rgb "red" title "Heure 1",\
    # "temperature3.txt" using 2:3 with lines linetype 2 lc rgb "blue" title "Heure 2"
     
     #, \
     #'' using 1:4 with lines linetype 3 lc rgb "green" title "Heure 3"

#EOFMarker

        else
            echo "Vous avez rentré un mauvais argument pour la température. Veuillez réessayer avec 1, 2 ou 3."
            exit 7
        fi
    fi
    
    
    if [ "$pres" -ne "0" ]
    then
        if [ "$pres" -eq "1" ]
        then
            touch pression1.txt
            touch pres1.txt
            cat $file | awk -F ";" 'BEGIN{OFS=FS}; {if ($7==""); else print $1, $7}' | sort -t";" -k1n | tail -n+2 > pression1.txt
            #compilation pression1.txt pres1.txt
            cat pression1.txt | awk -F ";" 'BEGIN{OFS=FS; presMin=$2; presMax=$2; n=0; ID=""; somme=0} 
            {
                if(ID!=$1)
                {
                    if(n!=0)
                    {
                        print somme/n, presMin, presMax, ID
                    }
                    ID=$1;
                    presMin=$2;
                    presMax=$2;
                    n=0;
                    somme=0;
                }
                somme+=$2;
                n+=1;
                if(presMin>$2) 
                    {
                        presMin=$2
                    }
                    if(presMax<$2) 
                    {
                        presMax=$2
                    }
            }
            END {print somme/n";"presMin";"presMax";"ID}' > pression_sort1.txt

gnuplot -persist <<-EOFMarker
    set terminal png size 1920,1080
    set output "p1_out.png"
    set datafile separator ";"
    set title "Pression en fonction de la station"
    set xlabel "ID Station"
    set xtics rotate by 50 offset -3,-2
    set ylabel "Pression (Pa)"
    plot "pression_sort.txt" using 0:3:2 with filledcurve fc rgb "blue" title "Plage des pressions", ''using 0:1:xtic(4) lw 3 with lines title "Pression moyene"
    #colonne 0 prend n° de la ligne donc on reprend 4 pour xtic
    #1ère colonne : moyenne
    #2ème colonne : min
    #3ème colonne : max
    #4ème colonne : id
EOFMarker


        elif [ "$pres" -eq "2" ]
        then
            touch pression2.txt
            touch pres2.txt
            touch pression_sort2.txt
            cat $file | awk -F ";" 'BEGIN{OFS=FS}; {if ($7==""); else print $2,$7}' | sort -k 1n,1 | tail -n+2 > pression2.txt
            echo "pres = 2"
            #compilation pression2.txt pres2.txt
            cat pression2.txt | awk -F ";" 'BEGIN{OFS=FS; DATE=""; n=0; somme=0} 
            {
                if(DATE!=$1)
                {
                    if(n!=0)
                    {
                        print DATE, somme/n
                    }
                    DATE=$1;
                    n=0;
                    somme=0;
                }
                somme+=$2;
                n+=1;
            }
            END {print DATE";"somme/n}' > pression_sort2.txt

gnuplot -persist <<-EOFMarker
    set terminal png size 1920,1080
    set output "p2_out.png"
    set title "Pression par date"
    set xlabel "Date"
    set ylabel "Pression (Pa)"
    set datafile separator ";"
    set xdata time
    set timefmt '%Y-%m-%dT%H-%M%S'
    set xtics rotate by 50 offset -3,-2
    plot "pression_sort2.txt" using 1:2 with lines title "Pressions moyene"
EOFMarker

        elif [ "$pres" -eq "3" ]
        then
            touch pression3.txt
            touch pres3.txt
            cat $file | awk -F ";" 'BEGIN{OFS=FS}; {if ($7==""); else print $1, $2, $7}' | sort -k 2n,2 -k 1n,1 | tail -n+2 > pression3.txt
            #compilation pression3.txt pres3.txt
            file=pression3.txt
            sed 's/T/;/g' "$file" | awk -F ";" 'BEGIN{OFS=FS} 
            {
                split ($2, coord, ";")
            }
            {
                x = coord[1]; y = coord[2]
            }
            {
                if ($4=="" && $5==""); else print $1, x, y, $3
            }' | tail -n+2 > pression_sort3.txt

            #gnuplot

        else
            echo "Vous avez rentré un mauvais argument pour la pression. Veuillez réessayer avec 1, 2 ou 3."
            exit 8
        fi
    fi

    if [ "$vent" -eq "1" ]
    then
        touch vent.txt
        touch ventc.txt
        touch vent_sort.txt
        cat $file | sed 's/,/;/g' "$file" | awk -F ";" 'BEGIN{OFS=FS} 
        {
            split ($10, coord, ";")
        }
        {
            x = coord[1]; y = coord[2]
        }
        {
            if ($4=="" && $5==""); else print $1, $4, $5, $10, $11
        }' | sort -k 1n,1 | tail -n+2 > vent.txt
        #compilation vent.txt ventc.txt
        cat vent.txt | awk -F ";" 'BEGIN{OFS=FS; somme1=0; somme2=0; somme3=0; somme4=0; n=0; ID=""} 
            {
                if(ID!=$1)
                {
                    if(n!=0)
                    {
                        print ID, somme1/n, somme2/n, somme3/n, somme4/n
                    }
                    ID=$1;
                    n=0;
                    somme1=0;
                    somme2=0;
                    somme3=0;
                    somme4=0;
                }
                somme1+=$4;
                somme2+=$5;
                somme3+=$2;
                somme4+=$3;
                n+=1;
            }
            END {print ID";"somme1/n";"somme2/n";"somme3/n";"somme4/n}' > vent_sort.txt


gnuplot -persist <<-EOFMarker
    set terminal png size 1920,1080
    set output "vent_out.png"
    set title "Vents"
    set xlabel "Longitude"
    set ylabel "Latitude"
    set datafile separator ";"
    set angles degrees
    plot "vent_sort.txt" using 3:2:(sin(\$4)*\$5):(cos(\$4)*\$5) w vec title "force des vents" 
EOFMarker

    fi

    if [ "$altitude" -eq "1" ]
    then
        touch altitude.txt
        touch alt.txt
        sed 's/,/;/g' "$file" | awk -F ";" 'BEGIN{OFS=FS} 
            {
                split ($10, coord, ";")
            }
            {
                x = coord[1]; y = coord[2]
            }
            {
                if ($15==""); else print $15, $10, $11
            }' | tail -n+2 > altitude.txt
            touch altitude2.txt
            #compilation altitude.txt alt.txt
            sort -t";" -r -n altitude.txt > altitude2.txt
#la barre du diagramme de droite s'arrête à 180 alors qu'elle devrait aller à 800
gnuplot -persist <<-EOFMarker
    set terminal png size 1920,1080
    set output "altitude_out.png"
    set title "Altitude de la station"
    set xlabel "longitude"
    set ylabel "latitude"
    set datafile separator ";"
    set view map
    set dgrid3d
    set pm3d interpolate 0,0
    splot "altitude2.txt" using 3:2:1 with pm3d t "a"
EOFMarker


    fi

    if [ "$humidite" -eq "1" ]
    then
        touch humidite.txt
        touch hum.txt
        sed 's/,/;/g' "$file" | awk -F ";" ' BEGIN{OFS=FS}
            {
                split ($10, coord, ",")
            }
            {
                x = coord[1]; y = coord[2]
            }
            {
                if ($6==""); else print $6, $1, $10, $11
            }' | sort -t";" -r -n | tail -n+2 > humidite.txt
        #compilation humidite.txt hum.txt
        touch humidite_sort.txt
        cat humidite.txt | awk -F ";" 'BEGIN{OFS=FS; humMax=$1; ID=""; n=0} 
            {
                if(ID!=$2)
                {
                    if(n!=0)
                    {
                        print ID, humMax, $3, $4
                    }
                    ID=$2;
                    humMax=$1;
                    n=0
                }
                n+=1
                if(humMax<$1) 
                {
                   humMax=$1
                }
            }
            END {print ID";"humMax";"$3";"$4}' > humidite_sort.txt

gnuplot -persist <<-EOFMarker
    set terminal png size 1920,1080
    set output "humidite_out.png"
    set title "Humidité de la station"
    set xlabel "longitude"
    set ylabel "latitude"
    set datafile separator ";"
    set view map
    set dgrid3d
    set pm3d interpolate 0,0
    splot "humidite_sort.txt" using 4:3:2 with pm3d t "a"
EOFMarker

    fi
}

function check_date() {
    if [ "$date" -eq "1" ]
    then
        touch date.csv
        echo "$file"
        #j'ai remplacé ";" par "," dans s/T/,/g
        sed 's/T/!/g' "$file" | awk -F ";" -v Min="$dateMin" -v Max="$dateMax" '
        {
            split ($2, temps, "!")
        }
        {
            date = temps[1]; heure = temps[2]
        }
        {
            if(Min <= date && date <= Max) print $0
        }' > date.csv
        file=date.csv #vérifier que si date et pays on récupère bien les 16 colonnes
        echo "$file"
    fi
}

function check_localisation_arguments(){
    pays=0
    if [ $Fr ]
    then
        pays=`expr $pays + 1`
    fi
    
    if [ $Gu ]
    then
        pays=`expr $pays + 1`
    fi
    
    if [ $St ]
    then
        pays=`expr $pays + 1`
    fi
    
    if [ $An ]
    then
        pays=`expr $pays + 1`
    fi
    
    if [ $OI ]
    then
        pays=`expr $pays + 1`
    fi
    
    if [ $Qu ]
    then
        pays=`expr $pays + 1`
    fi
    
    if [ "$pays" -ne "0" ]
    then
        if [ "$pays" -ne "1" ]
        then
            echo "veuillez saisir moins de précisions selon la localisation"
            exit 9
        else
            echo "tri selon la région choisie"
            if [ $Fr ]
            then
                touch France.csv
                cat $file | awk -F ";"  '{if ($1<=07790) print $0}' > France.csv
                file=France.csv
                triLocalisation=1 #pour éviter que le tri selon les autres arguments soit effectué une deuxième fois dans le main
            fi
            if [ $OI ]
            then
                touch OceanIndien.csv
                cat $file | awk -F ";"  '{if ($1<=67005 && $1>=61968 && $1!=61998) print $0}' > OceanIndien.csv
                file=OceanIndien.csv
                args
                triLocalisation=1 #pour éviter que le tri selon les autres arguments soit effectué une deuxième fois dans le main
                
            fi
            if [ $Qu ]
            then
                touch Antartique.csv
                cat $file | awk -F ";"  '{if ($1=61998 || $1=89642) print $0}' > Antartique.csv
                file=Antartique.csv
                args
                triLocalisation=1 #pour éviter que le tri selon les autres arguments soit effectué une deuxième fois dans le main
            fi
            if [ $St ]
            then
                touch StPierre.csv
                cat $file | awk -F ";"  '{if ($1=71805) print $0}' > StPierre.csv
                file=StPierre.csv
                args
                triLocalisation=1 #pour éviter que le tri selon les autres arguments soit effectué une deuxième fois dans le main
            fi
            if [ $Gu ]
            then
                touch Guyane.csv
                cat $file | awk -F ";"  '{if ($>1=78890 && $1<=78925) print $0}' > Guyane.csv
                file=Guyane.csv
                args
                triLocalisation=1 #pour éviter que le tri selon les autres arguments soit effectué une deuxième fois dans le main
            fi
            if [ $An ]
            then
                touch Antilles.csv
                cat $file | awk -F ";"  '{if ($>1=81401 && $1<=81415) print $0}' > Antilles.csv
                file=Antilles.csv
                args
                triLocalisation=1 #pour éviter que le tri selon les autres arguments soit effectué une deuxième fois dans le main

            fi
        fi
    fi
}

function compilation() { #tri selon altitude et humidité dans l'ordre décroissant
    if [ "$humidite" -eq "1" ] || [ "$altitude" -eq "1" ]
    then
        if [ $abr ]
        then
            make
            ./tri_c -f $1 -o $2 -r --abr
            retour_c=$?
            valeur_retour_c retour_c
            #valeur retournée par le programme stockée dans $?
        fi
        if [ $tab ]
        then
            make
            ./tri_c -f $1 -o $2 -r --tab
            retour_c=$?
            valeur_retour_c retour_c
        else #tri avl dans tous les cas
            make
            ./tri_c -f $1 -o $2 -r --tab
            retour_c=$?
            valeur_retour_c retour_c
        fi
    else 
        if [ $abr ]
        then
            make
            ./tri_c -f $1 -o $2 --abr
            retour_c=$?
            valeur_retour_c retour_c
            #valeur retournée par le programme stockée dans $?
        fi
        if [ $tab ]
        then
            make
            ./tri_c -f $1 -o $2 --tab
            retour_c=$?
            valeur_retour_c retour_c
        else #tri avl dans tous les cas
            make
            ./tri_c -f $1 -o $2 --tab
            retour_c=$?
            valeur_retour_c retour_c
        fi
    fi
}


function valeur_retour_c() { #cette fonction permet de connaître les valeurs de retour du programme C, afin de savoir si le tri s'est bien passé ou non
    if [ "$1" -eq "0" ]
    then
        echo -e "\ntri réussi avec succès dans le programme C !\n"
    fi
    if [ "$1" -eq "1" ]
    then
        echo -e "\nerreur sur les options activées du programme C !\n"
    fi
    if [ "$1" -eq "2" ]
    then
        echo -e "\nerreur avec le fichier de données d'entrée dans le programme C !\n"
    fi
    if [ "$1" -eq "3" ]
    then
        echo -e "\nerreur avec le fichier de données en sortie dans le programme C !\n"
    fi
    if [ "$1" -eq "4" ]
    then
        echo -e "\nerreur interne lors du tri liée au programme C !\n"
    fi
}

function suppression_fichiers_annexes(){ #supprime tous les fichiers annexes de tri et on laisse le gnuplot pour que l'utilisateur puisse y avoir accès
    rm temperature1.txt 2>/dev/null #permet de ne rien afficher dans le terminal
    rm temperature_sort1.txt 2>/dev/null
    rm temp1.txt 2>/dev/null
    
    rm temperature2.txt 2>/dev/null
    rm temperature_sort2.txt 2>/dev/null
    rm temp2.txt 2>/dev/null
    
    rm temperature3.txt 2>/dev/null
    rm temperature_sort3.txt 2>/dev/null
    rm temp3.txt 2>/dev/null
    
    rm pression1.txt 2>/dev/null
    rm pression_sort1.txt 2>/dev/null
    rm pres1.txt 2>/dev/null
   
    rm pression2.txt 2>/dev/null
    rm pression_sort2.txt 2>/dev/null
    rm pres2.txt 2>/dev/null

    
    rm pression3.txt 2>/dev/null
    rm pression_sort3.txt 2>/dev/null
    rm pres3.txt 2>/dev/null
    
    rm vent.txt 2>/dev/null
    rm ventc.txt 2>/dev/null
    rm vent_sort.txt 2>/dev/null
    rm altitude.txt 2>/dev/null
    rm alt.txt 2>/dev/null
    rm altitude2.txt 2>/dev/null
    rm humidite.txt 2>/dev/null
    rm hum.txt 2>/dev/null
    rm humidite_sort.txt 2>/dev/null

    rm France.csv 2>/dev/null
    rm Guyane.csv 2>/dev/null
    rm OceanIndien.csv 2>/dev/null
    rm Antartique.csv 2>/dev/null
    rm StPierre.csv 2>/dev/null
    rm Antilles.csv 2>/dev/null

    rm date.csv 2>/dev/null
}

function suppression_gnuplot() {
    rm t1_out.png 2>/dev/null
    rm t2_out.png 2>/dev/null

    rm p1_out.png 2>/dev/null
    rm p2_out.png 2>/dev/null

    rm vent_out.png 2>/dev/null
    rm altitude_out.png 2>/dev/null
    rm humidite_out.png 2>/dev/null
}

main $@