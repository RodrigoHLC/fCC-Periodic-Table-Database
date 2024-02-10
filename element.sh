#! /bin/bash
# ↑  No idea what that was for

# --- VARIABLE FOR QUERYING PSQL --- 
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# --- FUNCTION FOR RETURNING DATA ---
GET_DATA(){
# echo $ELEMENT_DATA
echo $ELEMENT_DATA | while IFS="|" read NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT
do
  echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
}
# --- PROCESS STARTS HERE ---
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
# --- IF NO ARGUMENTS ARE PASSED TO THE SCRIPT:
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
# --- IF THERE ARE ARGUMENTS:
else
  # --- IF IT'S A NUMBER:
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$1;")
    GET_DATA
  # --- CHECK IF IT'S AN ATOMIC SYMBOL:
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id)  WHERE symbol='$1';")
    # IF SYMBOL EXISTS:
    if [[ $ELEMENT_DATA ]]
    then
      GET_DATA
    # IF SYMBOL DOESN'T EXIST:
    else
      echo "I could not find that element in the database."
    fi
  # --- IF IT'S A NAME:
  elif [[ $1 =~ ^[A-Z][a-z][a-z]+$ ]]
  then
    ELEMENT_DATA=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id)  WHERE name='$1';")
    # IF NAME EXISTS:
    if [[ $ELEMENT_DATA ]]
    then
      GET_DATA
    # IF NAME DOESN'T EXIST:
    else
      echo "I could not find that element in the database."
    fi
  # --- IF IT'S INVALID INPUT:
  else
   echo "I could not find that element in the database."
  fi
fi