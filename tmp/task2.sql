drop table if exists GameGoals;
drop table if exists GameShots;
drop table if exists GamePenalties;
drop table if exists GamePlaysPlayers;
drop table if exists TeamInfo;
drop table if exists PlayerInfo;
drop table if exists GameChallenges;
drop table if exists ExecutablePlays;
drop table if exists GamePlaysPlayers2;
drop table if exists GamePlaysPlayers3;
drop table if exists GamePlays;
drop table if exists Game;

select '---------------------------------------------------------------------------------------' as '';
select 'Create Game' as '';

create table Game (
        gameID decimal(10) primary key,
       	season decimal(8) check((season div 10000)+1 = (season % 10000) ) not null,
		gameType char(1) not null,
		dateTimeGMT datetime not null,
		awayTeamID int not null,
		homeTeamID int not null,
		awayGoals int check(awayGoals >= 0) not null,
		homeGoals int check(homeGoals >= 0) not null,
		outcome char(12) not null,
		homeRinkSideStart char(50) not null,
		venue varchar(64) not null,
		venueTimeZoneID char(20) not null,
		venueTimeZoneOffset char(50) not null,
		venueTimeZoneTZ char(3) not null,
        CONSTRAINT CHK_gameType CHECK(
        (substring(gameID, 5, 2) = '02' AND gameType="R" ) OR (substring(gameID, 5, 2) = '03' AND gameType="P" )
        OR (substring(gameID, 5, 2) = '04' AND gameType="A" ) 
        OR (substring(gameID, 5, 2) = '03' AND gameType="R" AND (YEAR(dateTimeGMT)=2020 AND MONTH(dateTimeGMT)=8))
        )
		  );


select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlays' as '';

create table GamePlays (
            playNumber char(14),
			gameID decimal(10),
			playType varchar(25) not null,
			period decimal(1) not null,
			periodType char(8) not null,
			periodTime int not null,
			periodTimeRemaining char(4) not null,
			dateTime datetime not null,
			description varchar(255) not null,
-- Additional Constraints
            primary key (playNumber),
            foreign key(gameID) references Game(gameID)
		       );

select '---------------------------------------------------------------------------------------' as '';
select 'Create PlayerInfo' as '';

create table PlayerInfo (
             playerID decimal(7) primary key,
			 firstName char(15) not null,
			 lastName char(20) not null,
			 nationality char(3) not null,
			 birthCity char(30) not null,
			 primaryPosition char(15) not null,
			 birthDate datetime not null,
			 birthStateProvince char(20) not null,
			 height char(7) not null,
			 heightInCM decimal(5,2) not null,
			 weight decimal(5,2) not null,
			 shootsCatches char(2) not null
-- Additional Constraints
			 );

select '---------------------------------------------------------------------------------------' as '';
select 'Create TeamInfo' as '';

create table TeamInfo (
               teamID int primary key,
       	       franchiseID int not null,
		       city char(15) not null,
		       name char(15) not null,
		       abbreviation char(3) unique not null);



select '---------------------------------------------------------------------------------------' as '';
select 'Create GameChallenges' as '';

create table GameChallenges(
                playNumber char(14),
                teamIDfor int,
			    teamIDagainst int,
-- Additional Constraints
                primary key(playNumber),
                foreign key(playNumber) references GamePlays(playNumber),
                foreign key(teamIDfor) references TeamInfo(teamID),
                foreign key(teamIDagainst) references TeamInfo(teamID)
			   );

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlaysPlayers' as '';

create table GamePlaysPlayers (
                playNumber char(14),
       	     	gameID decimal(10),
-- Additional Constraints fix-me
                primary key(playNumber, gameID),
                foreign key(playNumber) references GamePlays(playNumber),
                foreign key(gameID) references Game(gameID)
			      );

select '---------------------------------------------------------------------------------------' as '';
select 'Create ExecutablePlays' as '';

create table ExecutablePlays (
                playNumber char(14),
			    playerID decimal(7),
			    x char(4) not null,
			    y char(4) not null,
-- Additional Constraints fix-me the primary key 
                primary key(playNumber),
                foreign key(playNumber) references GamePlays(playNumber)
			      );

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlaysPlayers2' as '';

create table GamePlaysPlayers2 (
                playNumber char(14),
       	     	teamID decimal(10),
-- Additional Constraints
                primary key(playNumber),
                primary key(teamID),
                foreign key(playNumber) references GameChallenges(playNumber),
                foreign key(teamID) references TeamInfo(teamID)
			      );

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlaysPlayers3' as '';

create table GamePlaysPlayers3 (
                playNumber char(14),
			    playerID decimal(7),
			    playerRole char(10) not null,
-- Additional Constraints
                primary key(playNumber),
                foreign key(playNumber) references ExecutablePlays(playNumber),
                foreign key(playerID) references PlayerInfo(playerID)
			      );           

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePenalties' as '';

create table GamePenalties (
                playNumber char(14),
                secondaryType varchar(40) not null,
              	penaltySeverity char(15) not null,
			    penaltyMinutes decimal(2) not null,
-- Additional Constraints
                primary key(playNumber),
                foreign key(playNumber) references ExecutablePlays(playNumber)

			   );      

select '---------------------------------------------------------------------------------------' as '';
select 'Create GameShots' as '';

create table GameShots (
                playNumber char(14),
                secondaryType varchar(40) not null,
-- Additional Constraints
                primary key(playNumber),
                foreign key(playNumber) references ExecutablePlays(playNumber)
			      );

select '---------------------------------------------------------------------------------------' as '';
select 'Create GameGoals' as '';

create table GameGoals (
            playNumber char(14),
       	    strength char(12) not null,
			gameWinningGoal char(5) not null,
			emptyNet char(5) not null,
            goalsAway int not null,
			goalsHome int not null,
-- Additional Constraints
            primary key(playNumber),
            foreign key(playNumber) references GameShots(playNumber)
   		       );

delimiter //  
create trigger TeamTrigger before insert on Game for each row
begin
    IF (((NEW.teamIDfor IN (SELECT homeTeamID FROM Game WHERE gameID = NEW.gameID)) AND 
        (NEW.teamIDagainst NOT IN (SELECT awayTeamID FROM Game WHERE gameID = NEW.gameID))) OR 
       ((NEW.teamIDfor IN (SELECT awayTeamID FROM Game WHERE gameID = NEW.gameID)) AND 
        (NEW.teamIDagainst NOT IN (SELECT homeTeamID FROM Game WHERE gameID = NEW.gameID)))) THEN
            SIGNAL SQLSTATE '45000' set message_text = 'Team IDs not matching';
    END IF;
end//
delimiter ;

