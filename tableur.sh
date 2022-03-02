#!/bin/bash
#AUTORS = YOHAN GALOIS & STEEVEN NOWAK
OLDIFS=$IFS 
input=$stdin
output=$stdout
sepcollumninit="\t"
seplinesinit="\n"
sepcollumnout="\t"
seplinesout="\n"
inverse=0
if test $# -gt 0
then
while  (( test $# -ne 1 ))
do
case $1 in 
"^-in *")
input=${1:4:${#1}};break;;
"^-out *")
output=${1:5:${#1}};break;;
"^-scin *")
sepcollumninit=${1:6:${#$1}};break;;
"^-slin *")
seplinesinit=${1:6:${#$1}};break;;
"^-scout *") 
sepcollumnout=${1:7:${#$1}};break;;
"^-slout *")
seplinesout=${1:7:${#$1}};break;;
"^-inverse *")
inverse=1;break;;
esac
shift;
done
fi
if test $input = "stdin"
then
	read $input
fi
parcours $input

parcours(){
OLDIFS=$IFS
local sepcolumns=$sepcolumninit
local seplig=$seplinesinit
a=0
b=0
IFS=$seplig
for lig in $(cat $1)
do
    a=$[$a+1]
    IFS=$sepcolumns
    for col in $lig
        do
        if !((${col: -1} -eq $sepligne))
                then
                printf $(determinerexpr $col) > $output
                printf $sepcollumnout > $output
                IFS=$sepcolumns
                b=$[$b+1]
                fi
        printf $seplinesout > $output
        done
done
IFS=$OLDIFS
}

parcoursinv(){
OLDIFS=$IFS
local sepcolumns=$sepcolumninit
local seplig=$seplinesinit
a=0
b=0
IFS=$sepcolumns
for lig in $(cat $1)
do
    a=$[$a+1]
    IFS=$sepcolumns
    for col in $lig
        do
        if !((${col: -1} -eq $sepligne))
                then
                IFS=$sepcolumns
                b=$[$b+1]
                fi
        echo '\n'$col
        done
done
echo $a $b
IFS=$OLDIFS
}
readcoord(){
	if test $# -lt 2 
	then 
	echo "Not enough arguments , $0 require 2 args"
	exit 1
	fi
	
	OLDIFS=$IFS
	local sepcolumns=$sepcolumninit
	local seplig=$seplinesinit
	a=0
	b=0
	IFS=$seplig
	for lig in $(cat $input)
	do
    	a=$[$a+1]
    	b=0
    	IFS=$sepcolumns
    	for col in $lig
        	do
        	if !((${col: -1} -eq $sepligne))
                then
                IFS=$sepcolumns
                if ( [ $a -eq $1 ] && [ $b -eq $2 ] )
                	then
                	echo $col
                	IFS=$OLDIFS
                	exit 0
                	fi
                b=$[$b+1]
                fi
        done
	done
	echo -1
	IFS=$OLDIFS
}
readcoord2(){
i=$(cat $input)
c=$(echo $i | cut -f$1 -d$seplinesinit | cut -f$2 -d$sepcollumninit );
res=$c
}


retourne(){
	OLDIFS=$IFS
	local sepcolumns=$sepcolumninit
	local seplig=$seplinesinit
	a=0
	b=0
	IFS=$seplig
	for lig in $(cat $input)
	do
    	a=$[$a+1]
    	b=0
    	IFS=$sepcolumns
    	for col in $lig
        	do
        		printf $col$sepcollumnout > $output
                b=$[$b+1]
        done
        printf $seplinesout
	done
	echo -1
	IFS=$OLDIFS
}

convertir_commande(){
	if test $# -ne 1
	then
	printf "Not enough arguments , $0 require 2 args" > stderr
	exit 1
	fi
	echo ${1:1:${#1}};
	}
calcule_expo_ln_sqrt(){
	if test $# -ne 2
	then
	printf "Not enough arguments , $0 require 2 args" > stderr
	exit 1
	fi
	if test $(test_number $2) -eq 0
	then
	printf "$0 require 2 args , 1 integer " > stderr
	exit 1
	fi
	
	if test $1 -eq 'ln'
	then
	echo 'l($2)'|bc -l
	fi
	
	if test $1 -eq 'e'
	then
	echo 'e($2)'|bc -l
	fi
	
	if test $1 -eq 'sqrt'
	then 
	echo 'sqrt($2)'|bc -l
	fi
	
}
determinerexpr(){
	test ${1:0:1} -eq "="
	if test $? -eq 0
		then
		a=${1:1:${#$1}}
	fi

	case $a in

	"^[[:digit:]]*")
			echo $a;
	break;;

	"somme(*,*)")
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_cel $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_cel $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			d=$(somme $param2 $param3);
			echo $d;
	break;;

	"moyenne(*,*)")
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_cel $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_cel $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			d=$(moyenne $param2 $param3);
			echo $d;
	break;;

	"variance(*,*)")
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_cel $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_cel $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			d=$(variance $param2 $param3);
			echo $d;
	break;;

	"ecarttype(*,*)")
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_cel $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_cel $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			d=$(ecart_type $param2 $param3);
			echo $d;
	break;;

	"mediane(*,*)")
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_cel $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_cel $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			echo $(mediane $param2 $param3)
	break;;

	"min(*,*)")
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_cel $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_cel $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			d=$(min $param2 $param3);
			echo $d;
	break;;

	"max(*,*)")
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_cel $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_cel $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			echo $(max $param2 $param3)
	break;;

	"[l*c*]")
		param1=$(echo $a | cut -f1 -d'[' | cut -f1 -d']');
		par3=$param1
			o=$(test_cel $param1)
			if test $o -ne 0
			then
				param1=$(determinerexpr $par3)
			else
				param1=$par3
			fi
		e=$(readcoord2 ${a:1:1} ${a:3:1})
		echo $e
	break;;

	"+(*,*)")
			a=$1;
			param1=$(echo $a | cut -f1 -d'(' );
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_number $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_number $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			d=$(calcule_plus_moins_fois_divide_power $param1 $param2 $param3);
			echo $d;
	break;;
	"-(*,*)")
			a=$1;
			param1=$(echo $a | cut -f1 -d'(' );
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_number $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_number $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			d=$(calcule_plus_moins_fois_divide_power $param1 $param2 $param3);
			echo $d;
			break;;
			"\*(*,*)")
			a=$1;
			param1=$(echo $a | cut -f1 -d'(' );
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_number $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_number $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			d=$(calcule_plus_moins_fois_divide_power $param1 $param2 $param3);
			echo $d;
	break;;
	"^(*,*)")
			a=$1;
			param1=$(echo $a | cut -f1 -d'(' );
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_number $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_number $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			d=$(calcule_plus_moins_fois_divide_power $param1 $param2 $param3);
			echo $d;
	break;;
	"/(*,*)")
			a=$1;
			param1=$(echo $a | cut -f1 -d'(' );
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			par2=$param2
			o=$(test_number $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			par3=$param3
			o=$(test_number $param3)
			if test $o -ne 0
			then
				param3=$(determinerexpr $par3)
			else
				param3=$par3
			fi
			d=$(calcule_plus_moins_fois_divide_power $param1 $param2 $param3);
			echo $d;
	break;;

	"ln(*)")
			param1=$(echo $a | cut -f1 -d'(' );
			param2=$(echo $a | cut -f2 -d'(' |cut -f1 -d')');
			par2=$param2
			o=$(test_number $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			e=$(calcule_expo_ln_sqrt $param1 $param2);
			echo $e;
	break;;
	"e(*)")
			param1=$(echo $a | cut -f1 -d'(' );
			param2=$(echo $a | cut -f2 -d'(' |cut -f1 -d')');
			par2=$param2
			o=$(test_number $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			e=$(calcule_expo_ln_sqrt $param1 $param2);
			echo $e;
	break;;
	"sqrt(*)")
			param1=$(echo $a | cut -f1 -d'(' );
			param2=$(echo $a | cut -f2 -d'(' |cut -f1 -d')');
			par2=$param2
			o=$(test_number $param2)
			if test $o -ne 0
			then
				param2=$(determinerexpr $par2)
			else
				param2=$par2
			fi
			e=$(calcule_expo_ln_sqrt $param1 $param2);
			echo $e;
	break;;

	"concat(*,*)")
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			e=$(concat $param2 $param3 );
			echo $e;
	break;;

	"length(*)")
			param2=$(echo $a | cut -f2 -d'(' |cut -f1 -d')');
			e=$(length $param1 $param2);
			echo $e;
	break;;

	"substitute(*,*,*)")
			param2=$(echo $a | cut -f2 -d'(' | cut -f1 -d,);
			param3=$(echo $a | cut -f2 -d'(' | cut -f2 -d,|cut -f1 -d')');
			param4=$(echo $a | cut -f2 -d'(' | cut -f3 -d,|cut -f1 -d')');
			e=$(substitute $param2 $param3 $param4);
			echo $e;
	break;;

	"shell(*)")
			param2=$(echo $a | cut -f2 -d'(' |cut -f1 -d')');
			echo $($param2)
	break;;

	"display(*,*)")
			echo "break"
	break;;

	"size(*)")
			param2=$(echo $a | cut -f2 -d'(' |cut -f1 -d')');
			a=$(count_size $param2);
			echo $a;
	break;;

	"lines(*)")
			param2=$(echo $a | cut -f2 -d'(' |cut -f1 -d')');
			a=$(lines $param2);
			echo $a;
	break;;
esac

}


shell(){
	if test $# -ne 1
		then 
		printf "Not enough arguments , $0 require 1 args" > stderr
		exit 1
	fi
	echo `$1`
	}


length(){
	if test $# -ne 1
		then 
		printf "Not enough arguments , $0 require 1 args" > stderr
		exit 1
	fi
	echo ${#$1}
	length=${#$1}
	res=$length
	echo $res
}


lines(){
	if test $# -ne 1
		then 
		printf "Not enough arguments , $0 require 1 args" > stderr
		exit 1
	fi
	FILE=$1
	nblig=0
	if [ -f "$FILE" ]; then
		echo $(wc -l $FILE)
		nblig=$(wc -l $FILE)
	else 
		echo 0
	fi
    res=$nblig
    echo $res
}


concat(){
	if test $# -ne 2
		then 
		printf "Not enough arguments , $0 require 1 args" > stderr
		exit 1
	fi
	c=$1$2
	echo $res

}


substitute(){
	if test $# -ne 2
		then 
		printf "Not enough arguments , $0 require 1 args" > stderr
		exit 1
	fi
	i=0
	j=0
	while [ test ${1:i:1} -ne ${1:j:1} ]
		do
		i=$i+1
	done
	if test $i -eq ${#$1}
		then
		echo $1
		exit 0
	fi
	c=${1:0:i+1}
	while [ test ${1:i:1} -ne ${1:j:1} ]
		do
		i=$i+1
		j=$j+1
	done
	if test $j -eq ${#$2}
		then
		echo $1
		exit 0
	fi
	z=${#$1}
	z=$z-$i
	
	d=$c$2${1:$i:$z}
	echo $d
	}
	
	
count_size(){
	#test si le fichier existe et donne sa taille
	if test $# -ne 1
		then 
		printf "Not enough arguments , $0 require 1 args" > stderr
		exit 1
	fi
	FILE=$1
	taille=0
	if [ -f "$FILE" ]; then
		echo $(wc -c $FILE)
		taille=$(wc -c $FILE)
	else 
		echo 0
	fi
	res=$taille
	echo $res
	}
	
	
min(){
	if test $# -ne 3
	then
	printf "Not enough args , $0 requires 2 args " > stderr
	exit 1
	fi
	x1=${1:3:1}
	x2=${2:3:1}
	y1=${1:1:1}
	y2=${2:1:1}
	min=$(readcoord2 $1)
	for (( y=y1 ; y<y2 ; y++))
		do
		for (( x=x1 ; x<x2 ; x++ ))
			do
			case="l'$x'c'$y'"
			res=$(readcoord2 $case)
			if test $res -lt $min
				then
				min=$res
				fi
			done
		done 
	echo $res
}


max(){
	if test $# -ne 3
	then
	printf "Not enough args , $0 requires 2 args " > stderr
	exit 1
	fi
	x1=${1:3:1}
	x2=${2:3:1}
	y1=${1:1:1}
	y2=${2:1:1}
	max=(readcoord2 $1)
	for (( y=y1 ; y<y2 ; y++))
		do
		for (( x=x1 ; x<x2 ; x++ ))
			do
			case="l'$x'c'$y'"
			res=$(readcoord2 $case)
			if test $res -gt $max
				then
				max=$res
				fi
			done
		done 
	echo $res
}


somme(){
	if test $# -ne 3
	then
	printf "Not enough args , $0 requires 2 args " > stderr
	exit 1
	fi
	x1=${1:3:1}
	x2=${2:3:1}
	y1=${1:1:1}
	y2=${2:1:1}
	sum=$(readcoord2 $1)
	for (( y=y1 ; y<y2 ; y++))
		do
		for (( x=x1 ; x<x2 ; x++ ))
			do
			case="l'$x'c'$y'"
			res=$(readcoord2 $case)
			sum=$sum+$res
			done
		done 
	echo $sum
	}
	
	
moy(){
	if test $# -ne 3
	then
	printf "Not enough args , $0 requires 2 args " > stderr
	exit 1
	fi
	x1=${1:3:1}
	x2=${2:3:1}
	y1=${1:1:1}
	y2=${2:1:1}
	sum=$(readcoord2 $1)
	i=0
	for (( y=y1 ; y<y2 ; y++))
		do
		for (( x=x1 ; x<x2 ; x++ ))
			do
			case="l'$x'c'$y'"
			res=$(readcoord2 $case)
			sum=$sum+$res
			i=$i+1
			done
		done 
	moy=$sum/$i
	echo $moy
	}
	
	
variance(){
	if test $# -ne 3
	then
	printf "Not enough args , $0 requires 2 args " > stderr
	exit 1
	fi
	x1=${1:3:1}
	x2=${2:3:1}
	y1=${1:1:1}
	y2=${2:1:1}
	moy=$(moy $1 $2)
	sum=$(readcoord2 $1)
	i=0
	for (( y=y1 ; y<y2 ; y++))
		do
		for (( x=x1 ; x<x2 ; x++ ))
			do
			case="l'$x'c'$y'"
			res=$(readcoord2 $case)
			diff=$moy-$res
			diff=$diff*$diff
			sum=$sum+$diff
			i=$i+1
			done
		done 
	var=$sum/$i
	echo $var
	}
	
	
ecart_type(){
	if test $# -ne 3
	then
	printf "Not enough args , $0 requires 2 args " > stderr
	exit 1
	fi
	var=$(variance $1 $2)
	echo 'sqrt($var)'|bc -l
	}
	
	
calcule_plus_moins_fois_divide_power(){
	#calcule une operation de base entre deux nombres
	if test $# -ne 3
	then 
	printf "Not enough arguments , $0 require 3 args" > stderr
	exit 1
	fi
	if test $(test_number $2) -eq 0
	then 
	a=$2
	else
	a=$(determinerexpr() $2)
	fi
	if test $(test_number $3) -eq 0
	then 
	b=$3
	else
	b=$(determinerexpr() $3)
	fi
	case $1 in
	"+")
	c=$a+$b;break;;
	"-")
	c=$a-$b;break;;
	"*")
	c=$a*$b;break;;
	"/")
	c=$a/$b;break;;
	"^")
	c=$a**$b;break;;
	esac
	result=$c
	echo $c
	res=$c
	echo $res
	}
	
mediane(){
	if test $# -ne 2
	then
	printf "Not enough args , $0 requires 2 args " > stderr
	exit 1
	fi
	tab=()
	x1=${1:3:1}
	x2=${2:3:1}
	y1=${1:1:1}
	y2=${2:1:1}
	max=$(readcoord2 $1)
	for (( y=y1 ; y<y2 ; y++))
		do
		for (( x=x1 ; x<x2 ; x++ ))
			do
			case="l'$x'c'$y'"
			res=$(readcoord2 $case)
			tab=("${tab[@]}" $res )
			done
		done 
	OLDIFS=$IFS
	IFS=$' ' sorted=($(sort <<<"${tab[*]}"))
	IFS=$OLDIFS
	c=$[ ${#tab[@]} % 2 ]
	if test $c -eq 0
	then
	mid=$[ ${#tab[@]} / 2 ]
	echo ${tab[$mid]}
	else
	echo $[ $[ ${tab[$mid]} + ${tab[$[$mid+1]]} ] / 2]
	fi
	}
	
test_number(){
	res=$(test_int $1)
	if test $res -eq 0
		then
		echo $res
		exit 0
	fi
	res=$(test_float $1)
	if test $res -eq 0
		then
		echo $res
		exit 0
	fi
	echo 1
	exit 0
	}
	
	
test_int(){
echo $1|grep "^[0-9]*$"
res=$?
return $res
}


test_float(){
echo $1|grep "^[0-9]*.[0-9]*$"
res=$?
return $res
}

test_cel(){
	echo $1|grep "^l[0-9]c[0-9]$"
	res=$?
	return $res
}


