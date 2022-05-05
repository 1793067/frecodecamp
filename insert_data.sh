#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS=,  read -r year round WINNER OPPONENT winner_goals opponent_goals;
do
  if [[ $WINNER != "winner" ]]
  then
    TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    if [[ -z $TEAM_ID_WINNER ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$WINNER')"
    fi
    if [[ -z $TEAM_ID_OPPONENT ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')"
    fi
    TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
           VALUES($year, '$round', $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $winner_goals, $opponent_goals)"
  fi


done