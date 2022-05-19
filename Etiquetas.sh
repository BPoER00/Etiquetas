#!/bin/bash

#autor: Bryan Emanuel Paz Ramirez
#Carne: 1190-19-39292

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

#funcion para pintar la tabla
function printTable(){

    local -r delimiter="${1}"
    local -r data="$(removeEmptyLines "${2}")"

    if [[ "${delimiter}" != '' && "$(isEmptyString "${data}")" = 'false' ]]
    then
        local -r numberOfLines="$(wc -l <<< "${data}")"

        if [[ "${numberOfLines}" -gt '0' ]]
        then
            local table=''
            local i=1

            for ((i = 1; i <= "${numberOfLines}"; i = i + 1))
            do
                local line=''
                line="$(sed "${i}q;d" <<< "${data}")"

                local numberOfColumns='0'
                numberOfColumns="$(awk -F "${delimiter}" '{print NF}' <<< "${line}")"

                if [[ "${i}" -eq '1' ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi

                table="${table}\n"

                local j=1

                for ((j = 1; j <= "${numberOfColumns}"; j = j + 1))
                do
                    table="${table}$(printf '#| %s' "$(cut -d "${delimiter}" -f "${j}" <<< "${line}")")"
                done

                table="${table}#|\n"

                if [[ "${i}" -eq '1' ]] || [[ "${numberOfLines}" -gt '1' && "${i}" -eq "${numberOfLines}" ]]
                then
                    table="${table}$(printf '%s#+' "$(repeatString '#+' "${numberOfColumns}")")"
                fi
            done

            if [[ "$(isEmptyString "${table}")" = 'false' ]]
            then
                echo -e "${table}" | column -s '#' -t | awk '/^\+/{gsub(" ", "-", $0)}1'
            fi
        fi
	fi
}

function removeEmptyLines(){

    local -r content="${1}"
    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString(){

    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString(){

    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}

function trimString(){

    local -r string="${1}"
    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}


#funcion para salir
function ctrl_c( ){
        echo -e "\n${redColour}[!] Saliendo...\n${endColour}"
	rm -r variables.txt total.txt 2>/dev/null
        tput cnorm; exit 1
}

function helpPanel()
{
        echo -e "\n\n${grayColour}[${endColour}${yellowColour}!${endColour}${grayColour}]${endColour}${yellowColour} Uso: ./Etiquetas.sh${endColour}"
        for i in $(seq 1 80); do echo -ne "${grayColour}-"; done; echo -ne "${endColour}"
	echo -e "\n\t${blueColour}[${endColour}${grayColour}-a${endColour}${blueColour}]${endColour}${turquoiseColour} Accion Para Etiquetas${endColour}${yellowColour}\t Ejemplo ./Etiquetas.sh -a Opcion${endColour}"
	echo -e "\n\t\t${purpleColour}Etiquetas${endColour}${grayColour}\t ACCION: Hace Un Conteo De Las Etiquetas${endColour}"
	tput cnorm
}

function Dependencias()
{
        tput civis
        clear; Dependencies=(aircrack-ng macchanger)

        echo -e "${yellowColour}[*]${endColour}${grayColour} Comprobando programas necesarios...${endColour}"

        sleep 2

        echo -e "\n${yellowColour}[*]${endColour}${blueColour} Herramientas${endColour}${purpleColour} html2text${endColour}"

        test -f /usr/bin/html2text

                if [ "$(echo $?)" == "0" ]; then
                        echo -e "${greenColour}(Installed)${endColour}"
                else
                        echo -e "${redColour}(Not Installed)${endColour}\n"
                        echo -e "${yellowColour}[*]${endColour}${grayColour} Instalando Herramienta${endColour}"

                        sudo apt-get insstall html2text -y > /dev/null 2>&1

                fi

                sleep 1
	echo -e "${yellowColour}[*]${endColour}${grayColour} Herramienta Instalada...${endColour}"

}

function EtiquetasControlador()
{
	tput cnorm
	clear
	echo -ne "\n\n${grayColour}[${endColour}${purpleColour}!${endColour}${grayColour}]${endColour}${turquoiseColour} Ingrese Su Direccion: ${endColour}${grayColour}" && read ruta
	echo -e "${endColour}"

	echo -e "${grayColour}[${endColour}${purpleColour}*${endColour}${grayColour}]${endColour}${turquoiseColour} Espere Mientras Contamos Las Etiquetas...${endColour}"

	echo "Nombre De Etiqueta_Cantidad De Etiquetas" >> variables.txt

	var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<HTML" | wc -l)
	echo "Etiquetas HTML_"$var >> variables.txt

	varC=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</HTML" | wc -l)
	echo "Etiquetas /HTML_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<HEAD" | wc -l)
        echo "Etiquetas HEAD_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</HEAD" | wc -l)
        echo "Etiquetas /HEAD_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<BODY" | wc -l)
        echo "Etiquetas BODY_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</BODY" | wc -l)
        echo "Etiquetas /BODY_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<TITLE" | wc -l)
        echo "Etiquetas TITLE_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</TITLE" | wc -l)
        echo "Etiquetas /TITLE_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<STYLE" | wc -l)
        echo "Etiquetas STYLE_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</STYLE" | wc -l)
        echo "Etiquetas /STYLE_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<SCRIPT" | wc -l)
        echo "Etiquetas SCRIPT_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</SCRIPT" | wc -l)
        echo "Etiquetas /SCRIPT_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<META" | wc -l)
        echo "Etiquetas META_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<LINK" | wc -l)
        echo "Etiquetas LINK_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "DOCTYPE" | wc -l)
        echo "Etiquetas DOCTYPE_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<P" | wc -l)
        echo "Etiquetas P_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</P" | wc -l)
        echo "Etiquetas /P_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<H1" | wc -l)
        echo "Etiquetas H1_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</H1" | wc -l)
        echo "Etiquetas /H1_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<H2" | wc -l)
        echo "Etiquetas H2_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</H2" | wc -l)
        echo "Etiquetas /H2_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<H3" | wc -l)
        echo "Etiquetas H3_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</H3" | wc -l)
        echo "Etiquetas /H3_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<H4" | wc -l)
        echo "Etiquetas H4_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</H4" | wc -l)
        echo "Etiquetas /H4_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<H5" | wc -l)
        echo "Etiquetas H5_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</H5" | wc -l)
        echo "Etiquetas /H5_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<H6" | wc -l)
        echo "Etiquetas H6_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</H6" | wc -l)
        echo "Etiquetas /H6_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<A" | wc -l)
        echo "Etiquetas A_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</A" | wc -l)
        echo "Etiquetas /A_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<STRONG" | wc -l)
        echo "Etiquetas STRONG_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</STRONG" | wc -l)
        echo "Etiquetas /STRONG_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<BR" | wc -l)
        echo "Etiquetas BR_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<IMG" | wc -l)
        echo "Etiquetas IMG_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<VIDEO" | wc -l)
        echo "Etiquetas VIDEO_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<IFRAME" | wc -l)
        echo "Etiquetas IFRAME_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<AUDIO" | wc -l)
        echo "Etiquetas AUDIO_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<UL" | wc -l)
        echo "Etiquetas UL_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</UL" | wc -l)
        echo "Etiquetas /UL_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<OL" | wc -l)
        echo "Etiquetas OL_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</OL" | wc -l)
        echo "Etiquetas /OL_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<DIV" | wc -l)
        echo "Etiquetas DIV_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</DIV" | wc -l)
        echo "Etiquetas /DIV_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<HEADER" | wc -l)
        echo "Etiquetas HEADER_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</HEADER" | wc -l)
        echo "Etiquetas /HEADER_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<FOOTER" | wc -l)
        echo "Etiquetas FOOTER_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</FOOTER" | wc -l)
        echo "Etiquetas /FOOTER_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<TABLE" | wc -l)
        echo "Etiquetas TABLE_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</TABLE" | wc -l)
        echo "Etiquetas /TABLE_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<TR" | wc -l)
        echo "Etiquetas TR_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</TR" | wc -l)
        echo "Etiquetas /TR _"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<TD" | wc -l)
        echo "Etiquetas TD_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</TD" | wc -l)
        echo "Etiquetas /TD_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<TH" | wc -l)
        echo "Etiquetas TH_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</TH" | wc -l)
        echo "Etiquetas /TH_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<INPUT" | wc -l)
        echo "Etiquetas INPUT_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<FORM" | wc -l)
        echo "Etiquetas FORM_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</FORM" | wc -l)
        echo "Etiquetas /FORM_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<LABEL" | wc -l)
        echo "Etiquetas LABEL_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</LABEL" | wc -l)
        echo "Etiquetas /LABEL_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<TEXTAREA" | wc -l)
        echo "Etiquetas TEXTAREA_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</TEXTAREA" | wc -l)
        echo "Etiquetas /TEXTAREA_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "<BUTTON" | wc -l)
        echo "Etiquetas BUTTON_"$var >> variables.txt

        var=$(curl -s "$(echo $ruta)" |  html2text -check | grep "</BUTTON" | wc -l)
        echo "Etiquetas /BUTTON_"$var >> variables.txt

	echo -e "${blueColour}"
	printTable '_' "$(cat variables.txt)"
	echo -e "${endColour}"

	var=$(curl -s "$(echo $ruta)" |  html2text -check | wc -l)
	echo "Total Etiquetas_"$var >> total.txt

	echo -e "${blueColour}"
	printTable '_' "$(cat total.txt)"
	echo -e "${endColour}"

	sleep 10


	echo -e "\n\n${grayColour}[${endColour}${purpleColour}*${endColour}${grayColour}]${endColour}${turquoiseColour} Acontinuacion se le mostrara el codigo si no desea verlo puede pulsar ctrl+c${endColour}"
	sleep 3

	echo -e "$(curl -s "$(echo $ruta)" |  html2text -check)"
	rm -r variables.txt total.txt  2>/dev/null
}

#funcion principal

contador=0

while getopts "a:h:" arg; do

        case $arg in
		a) urlDatos=$OPTARG; let contador+=1;;
                h) helpPanel;;
        esac

done

#comparacion de opciones
tput civis

if [ $contador -eq 0 ]; then
        helpPanel
else
        if [ "$(echo $urlDatos)" == "Etiquetas" ]; then
		Dependencias
                EtiquetasControlador
        fi
fi


