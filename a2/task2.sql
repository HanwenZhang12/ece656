-- A1-Q1 start
select birthDate from PlayerInfo where firstName = 'Sidney' and lastName = 'Crosby';
-- A1-Q1 end

-- A1-Q2 start
select count(teamID) from TeamInfo;
-- A1-Q2 end

-- A1-Q3 start
select count(distinct(nationality)) from PlayerInfo;
-- A1-Q3 end

-- A1-Q4 start
select (select count(PlayerID) from PlayerInfo where nationality = 'CAN')/count(PlayerID) from PlayerInfo;
-- A1-Q4 end

-- A1-Q5 start
select (select count(PlayerID) from PlayerInfo where month(birthDate) = 12)/count(PlayerID) from PlayerInfo;
-- A1-Q5 end

-- A1-Q6 start
select count(playerID) from PlayerInfo where playerID in (select playerID from Game inner join GamePlaysPlayers on Game.gameID = GamePlaysPlayers.gameID where season = 20082009) and playerID in (select playerID from Game inner join GamePlaysPlayers on Game.gameID = GamePlaysPlayers.gameID where season = 20182019);
-- A1-Q6 end

-- A1-Q7 start
select max(P.gp) from (select count(GamePenalties.playID) as gp from GamePenalties inner join GamePlays on GamePenalties.playID = GamePlays.playID group by gameID) as P;

select distinct(name) from (select awayTeamID from Game where gameID in (select gameID from (select gameID, count(GamePenalties.playID) as gp from GamePenalties inner join GamePlays on GamePenalties.playID = GamePlays.playID group by gameID) as P where (select max(Q.gp) from (select count(GamePenalties.playID) as gp from GamePenalties inner join GamePlays on GamePenalties.playID = GamePlays.playID group by gameID) as Q) = P.gp) union select homeTeamID from Game where gameID in (select gameID from (select gameID, count(GamePenalties.playID) as gp from GamePenalties inner join GamePlays on GamePenalties.playID = GamePlays.playID group by gameID) as P where (select max(Q.gp) from (select count(GamePenalties.playID) as gp from GamePenalties inner join GamePlays on GamePenalties.playID = GamePlays.playID group by gameID) as Q) = P.gp)) as R inner join TeamInfo on awayTeamID = teamID;
-- A1-Q7 end

-- A2-Q1 start
select season, firstName, lastName from (select U.season, U.score, playerID from (select S.season, max(S.score) as maxs from (select G.season, sum(G.awayGoals) as score, GamePlaysPlayers.playerID from (select gameID, season, awayGoals from Game where awayTeamID = (select teamID from TeamInfo where name = 'Maple Leafs') union all select gameID, season, homeGoals from Game where homeTeamID = (select teamID from TeamInfo where name = 'Maple Leafs')) as G inner join GamePlaysPlayers on G.gameID = GamePlaysPlayers.gameID group by GamePlaysPlayers.playerID, G.season) as S group by S.season) as T inner join (select G.season, sum(G.awayGoals) as score, GamePlaysPlayers.playerID from (select gameID, season, awayGoals from Game where awayTeamID = (select teamID from TeamInfo where name = 'Maple Leafs') union all select gameID, season, homeGoals from Game where homeTeamID = (select teamID from TeamInfo where name = 'Maple Leafs')) as G inner join GamePlaysPlayers on G.gameID = GamePlaysPlayers.gameID group by GamePlaysPlayers.playerID, G.season) as U on T.season = U.season and T.maxs = U.score) as V inner join PlayerInfo on V.playerID = PlayerInfo.playerID;
-- A2-Q1 end

-- A2-Q2 start
select season, avg(R.awayGoals) from (select season, awayGoals, playerID from (select gameID, season, awayGoals from Game where awayTeamID = (select teamID from TeamInfo where name = 'Maple Leafs') union select gameID, season, homeGoals from Game where homeTeamID = (select teamID from TeamInfo where name = 'Maple Leafs')) as P inner join (select GamePlaysPlayers.playerID, gameID from GamePlaysPlayers inner join PlayerInfo on PlayerInfo.playerID = GamePlaysPlayers.playerID where birthCity = 'Toronto') as Q on P.gameID = Q.gameID) as R group by season;
-- A2-Q2 end

-- A2-Q3 start
select city, name, pos from(select X.awayTeamID, pos from (select awayTeamID, max(avgs) as maxavg from(select awayTeamID, avg(score) as avgs, 'C' as pos from (select awayTeamID, score from (select awayTeamID, primaryPosition, S.playerID, sum(awayGoals) as score from (select awayTeamID, awayGoals, Q.playerID, primaryPosition from (select primaryPosition, playerID from PlayerInfo where primaryPosition = 'C' or primaryPosition = 'LW' or primaryPosition = 'RW') as Q inner join (select awayTeamID, awayGoals, playerID from (select gameID, awayTeamID, awayGoals from Game) as P inner join GamePlaysPlayers on P.gameID = GamePlaysPlayers.gameID) as R on Q.playerID = R.playerID) as S group by awayTeamID, primaryPosition, S.playerID) as T where primaryPosition = 'C') as U group by awayTeamID union select awayTeamID, avg(score) as avgs, 'W' as pos from (select awayTeamID, score from (select awayTeamID, primaryPosition, S.playerID, sum(awayGoals) as score from (select awayTeamID, awayGoals, Q.playerID, primaryPosition from (select primaryPosition, playerID from PlayerInfo where primaryPosition = 'C' or primaryPosition = 'LW' or primaryPosition = 'RW') as Q inner join (select awayTeamID, awayGoals, playerID from (select gameID, awayTeamID, awayGoals from Game) as P inner join GamePlaysPlayers on P.gameID = GamePlaysPlayers.gameID) as R on Q.playerID = R.playerID) as S group by awayTeamID, primaryPosition, S.playerID) as T where primaryPosition = 'LW' or primaryPosition = 'RW') as V group by awayTeamID) as W group by awayTeamID) as X inner join (select awayTeamID, avg(score) as avgs, 'C' as pos from (select awayTeamID, score from (select awayTeamID, primaryPosition, S.playerID, sum(awayGoals) as score from (select awayTeamID, awayGoals, Q.playerID, primaryPosition from (select primaryPosition, playerID from PlayerInfo where primaryPosition = 'C' or primaryPosition = 'LW' or primaryPosition = 'RW') as Q inner join (select awayTeamID, awayGoals, playerID from (select gameID, awayTeamID, awayGoals from Game) as P inner join GamePlaysPlayers on P.gameID = GamePlaysPlayers.gameID) as R on Q.playerID = R.playerID) as S group by awayTeamID, primaryPosition, S.playerID) as T where primaryPosition = 'C') as U group by awayTeamID union select awayTeamID, avg(score) as avgs, 'W' as pos from (select awayTeamID, score from (select awayTeamID, primaryPosition, S.playerID, sum(awayGoals) as score from (select awayTeamID, awayGoals, Q.playerID, primaryPosition from (select primaryPosition, playerID from PlayerInfo where primaryPosition = 'C' or primaryPosition = 'LW' or primaryPosition = 'RW') as Q inner join (select awayTeamID, awayGoals, playerID from (select gameID, awayTeamID, awayGoals from Game) as P inner join GamePlaysPlayers on P.gameID = GamePlaysPlayers.gameID) as R on Q.playerID = R.playerID) as S group by awayTeamID, primaryPosition, S.playerID) as T where primaryPosition = 'LW' or primaryPosition = 'RW') as V group by awayTeamID) as Z on X.awayTeamID = Z.awayTeamID and X.maxavg = Z.avgs) as Y inner join TeamInfo on Y.awayTeamID = TeamInfo.teamID;
-- A2-Q3 end

-- A2-Q4 start
WITH playIDWithScores AS (select playID,gameID from GamePlays where playType = 'Goal'),playersWhoScored AS (select playerID from GamePlaysPlayers where playerRole = 'Scorer' and playID in (select playID from playIDWithScores)) select firstName,lastName from PlayerInfo where primaryPosition = 'G' and playerID in (select playerID from playersWhoScored);
-- A2-Q4 end


















