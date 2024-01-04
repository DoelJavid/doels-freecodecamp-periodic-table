#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
QUERY="FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE"
if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    CONDITION="atomic_number=$1"
  else
    CONDITION="symbol='$1' OR name='$1'"
  fi
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number $QUERY $CONDITION")
  if [[ -n $ATOMIC_NUMBER ]]
  then
    NAME=$($PSQL "SELECT name $QUERY $CONDITION")
    SYMBOL=$($PSQL "SELECT symbol $QUERY $CONDITION")
    TYPE=$($PSQL "SELECT type $QUERY $CONDITION")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass $QUERY $CONDITION")
    MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius $QUERY $CONDITION")
    BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius $QUERY $CONDITION")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  else
    echo "I could not find that element in the database."
  fi
else
  echo "Please provide an element as an argument."
fi