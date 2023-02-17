tee a3-outfile.txt;

drop table if exists BetterGamePlays;
drop table if exists BetterGameGoals;
drop table if exists BetterGamePenalties;
drop table if exists BetterGamePlaysPlayers;

drop view if exists GamePlays1;
drop view if exists GameGoals1;
drop view if exists GamePenalties1;
drop view if exists GamePlaysPlayers1;

create table BetterGamePlays like GamePlays;

create table BetterGameGoals like GameGoals;

create table BetterGamePenalties like GamePenalties;

create table BetterGamePlaysPlayers like GamePlaysPlayers;

ALTER TABLE BetterGamePlays ADD playNumber int;

ALTER TABLE BetterGameGoals ADD playNumber int, ADD gameID decimal(10,0);

ALTER TABLE BetterGamePenalties ADD playNumber int, ADD gameID decimal(10,0);

ALTER TABLE BetterGamePlaysPlayers ADD playNumber int;

ALTER TABLE BetterGamePlays DROP COLUMN playID;

ALTER TABLE BetterGameGoals DROP COLUMN playID;

ALTER TABLE BetterGamePenalties DROP COLUMN playID;

ALTER TABLE BetterGamePlaysPlayers DROP COLUMN playID;

INSERT INTO BetterGamePlays (playNumber, gameID, teamIDfor, teamIDagainst, playType, secondaryType, x, y, period, periodType, periodTime, periodTimeRemaining, dateTime, goalsAway, goalsHome, description) SELECT SUBSTR(REGEXP_SUBSTR(playID, '_([0-9][0-9]*)$'), 2), gameID, teamIDfor, teamIDagainst, playType, secondaryType, x, y, period, periodType, periodTime, periodTimeRemaining, dateTime, goalsAway, goalsHome, description FROM GamePlays;

INSERT INTO BetterGameGoals (playNumber, gameID, strength, gameWinningGoal, emptyNet) SELECT SUBSTR(REGEXP_SUBSTR(playID, '_([0-9][0-9]*)$'), 2), SUBSTR(REGEXP_SUBSTR(playID, '^[0-9][0-9]*_'), 1, 10), strength, gameWinningGoal, emptyNet FROM GameGoals;

INSERT INTO BetterGamePenalties (playNumber, gameID, penaltySeverity, penaltyMinutes) SELECT SUBSTR(REGEXP_SUBSTR(playID, '_([0-9][0-9]*)$'), 2), SUBSTR(REGEXP_SUBSTR(playID, '^[0-9][0-9]*_'), 1, 10), penaltySeverity, penaltyMinutes FROM GamePenalties;

INSERT INTO BetterGamePlaysPlayers (playNumber, gameID, playerID, playerRole) SELECT SUBSTR(REGEXP_SUBSTR(playID, '_([0-9][0-9]*)$'), 2), gameID, playerID, playerRole FROM GamePlaysPlayers;

DROP TABLE GamePlays;
DROP TABLE GameGoals;
DROP TABLE GamePenalties;
DROP TABLE GamePlaysPlayers;

CREATE VIEW GamePlays AS SELECT CONCAT(gameID, '_', playNumber) as playID,
gameID,
teamIDfor,
teamIDagainst,
playType,
secondaryType,
x,
y,
period,
periodType,
periodTimeRemaining,
dateTime,
goalsAway,
goalsHome,
description
FROM BetterGamePlays;

CREATE VIEW GameGoals AS SELECT CONCAT(gameID, '_', playNumber) as playID,
strength,
gameWinningGoal,
emptyNet
FROM BetterGameGoals;

CREATE VIEW GamePenalties AS SELECT CONCAT(gameID, '_', playNumber) as playID,
penaltySeverity,
penaltyMinutes
FROM BetterGamePenalties;

CREATE VIEW GamePlaysPlayers AS SELECT CONCAT(gameID, '_', playNumber) as playID,
gameID,
playerID,
playerRole
FROM BetterGamePlaysPlayers;


ALTER TABLE Game ADD PRIMARY KEY (gameID);

ALTER TABLE BetterGamePlays ADD PRIMARY KEY (gameID, playNumber);

ALTER TABLE BetterGameGoals ADD PRIMARY KEY (gameID, playNumber);

ALTER TABLE BetterGamePenalties ADD PRIMARY KEY (gameID, playNumber);

ALTER TABLE BetterGamePlaysPlayers ADD PRIMARY KEY (gameID, playNumber,playerID);

ALTER TABLE Game ADD FOREIGN KEY (homeTeamID) REFERENCES TeamInfo(teamID);

ALTER TABLE Game ADD FOREIGN KEY (awayTeamID) REFERENCES TeamInfo(teamID);

ALTER TABLE BetterGamePlays ADD FOREIGN KEY (gameID) REFERENCES Game(gameID);

ALTER TABLE BetterGamePlays ADD FOREIGN KEY (teamIDfor) REFERENCES TeamInfo(teamID);

ALTER TABLE BetterGamePlays ADD FOREIGN KEY (teamIDagainst) REFERENCES TeamInfo(teamID);

ALTER TABLE BetterGameGoals ADD FOREIGN KEY (gameID, playNumber) REFERENCES BetterGamePlays(gameID, playNumber);

ALTER TABLE BetterGamePenalties ADD FOREIGN KEY (gameID, playNumber) REFERENCES BetterGamePlays(gameID, playNumber);

ALTER TABLE BetterGamePlaysPlayers ADD FOREIGN KEY (gameID, playNumber) REFERENCES BetterGamePlays(gameID, playNumber);

ALTER TABLE BetterGamePlaysPlayers ADD FOREIGN KEY (playerID) REFERENCES PlayerInfo(playerID);