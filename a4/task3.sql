ALTER TABLE PlayerInfo ADD INDEX `PlayerId` (playerID ASC) VISIBLE;
ALTER TABLE GamePlaysPlayers ADD INDEX `grouped` (gameID ASC, playNumber ASC, playerRole ASC) VISIBLE;
ALTER TABLE GamePlays ADD INDEX `dateTime` (dateTime ASC) VISIBLE, ADD INDEX `playType` (playType ASC) VISIBLE;
ALTER TABLE TeamInfo ADD INDEX `teamID` (teamID ASC) VISIBLE;
ALTER TABLE Game ADD INDEX `gameID` (gameID ASC) VISIBLE;

explain analyze
with 
PenaltyTime as (select gameID, dateTime from GamePlays where playType = 'Penalty'),
GameID2010 as (select gameID from Game where season = 20102011),
MinDateTime as (select min(dateTime) as dateTime from PenaltyTime inner join GameID2010 using (gameID)),
GameInfo as (select gameID, playNumber, teamIDfor from GamePlays where dateTime = (select dateTime from MinDateTime)),
TeamIf as (select city, name, 1 as tag from TeamInfo where teamID = (select teamIDfor from GameInfo)),
PlayerIf as (select playerID from GamePlaysPlayers where gameID = (select gameID from GameInfo) and playNumber = (select playNumber from GameInfo) and playerRole = 'PenaltyOn'),
PlayerIf2 as (select firstName, lastName, 1 as tag from PlayerInfo where playerID = (select playerID from PlayerIf))
select firstName,lastName,city,name from TeamIf inner join PlayerIf2 using (tag);