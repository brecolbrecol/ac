#!/bin/bash
DIR="/usr/local/share/aire_acondicionado/"
ENCENDIDO="${DIR}encendido"

function activa_gpio5
{
	echo 5 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio5/direction
	echo 1 > /sys/class/gpio/gpio5/active_low
	sleep 1
	manda_pulso
	touch $ENCENDIDO
}

function manda_pulso
{
	if [[ -f "/sys/class/gpio/gpio5/value" ]]
	then
		echo 1 > /sys/class/gpio/gpio5/value ; sleep 0.5s ; echo 0 > /sys/class/gpio/gpio5/value 
	else
		activa_gpio5
	fi
}

function cambia_estado
{

	if [[ -f "$ENCENDIDO" ]]
	then
		echo -n "Apagando... " ; manda_pulso ; echo "OK"
		rm $ENCENDIDO
	else
		echo -n "Encendiendo... " ; manda_pulso ; echo "OK"
		touch $ENCENDIDO
	fi
}

function estado
{
	if [[ -f "$ENCENDIDO" ]]
	then
		echo "Estado: encendido"
	else
		echo "Estado: apagado"
	fi
}

function apaga
{
	[[ -f "$ENCENDIDO" ]] && cambia_estado || echo Ya estaba apagado
}

function enciende
{
	if [[ -f "$ENCENDIDO" ]]
	then
		echo Ya estaba encendido
	else
		cambia_estado 
	fi
}

function on
{
	enciende
}

function off
{
	apaga
}

function ayuda {
	echo "Comandos disponibles: on, off, enciende, apaga, cambia_estado, activa_gpio5"
}

mkdir -p $DIR 

if [[  $1 && ${1-x} ]]
then
    $1 $@
else
    estado
    ayuda
fi


