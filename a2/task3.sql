-- NHL 656 Database

tee a2-outfile.txt;

drop table if exists GameShifts;
drop table if exists GameScratches;
drop table if exists GameOfficials;
drop table if exists GamePlaysPlayers;
drop table if exists GamePenalties;
drop table if exists GameGoals;
drop table if exists GamePlays;
drop table if exists Game;
drop table if exists TeamInfo;
drop table if exists PlayerInfo;

select '---------------------------------------------------------------------------------------' as '';
select 'Create PlayerInfo' as '';

create table PlayerInfo (playerID decimal(7) primary key,
			 firstName char(15),
			 lastName char(20),
			 nationality char(3),
			 birthCity char(30),
			 primaryPosition char(15),
			 birthDate datetime,
			 birthStateProvince char(20),
			 height char(7),
			 heightInCM decimal(5,2),
			 weight decimal(5,2),
			 shootsCatches char(2)
-- Additional Constraints
			 );

load data infile '/var/lib/mysql-files/NHL_656/player_info.csv' ignore into table PlayerInfo
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';
--     ignore 1 lines;

show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
-- Team Information

select 'Create TeamInfo' as '';

create table TeamInfo (teamID int primary key,
       	     	       franchiseID int not null,
		       city char(15) not null,
		       name char(15) not null,
		       abbreviation char(3) unique not null);

load data infile '/var/lib/mysql-files/NHL_656/team_info.csv' into table TeamInfo
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';
--     ignore 1 lines
--     (teamID,franchiseID,city,shortName,abbreviation,@throwAway);

show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
-- Game Information: note that the ignore option on data loading means that a few thousand duplicate
-- primary keys are rejected, but so are half-a-dozen foreign key constraint violations
-- If replace is used, it will override the existing PK data but will get a rejection on an FK violation

select 'Create Game' as '';

create table Game (gameID decimal(10),
       	     	   season decimal(8),
		   gameType char(1),
		   dateTimeGMT datetime,
		   awayTeamID int,
		   homeTeamID int,
		   awayGoals int check(awayGoals >= 0),
		   homeGoals int check(homeGoals >= 0),
		   outcome char(12),
		   homeRinkSideStart char(50),
		   venue varchar(64),
		   venueTimeZoneID char(20),
		   venueTimeZoneOffset char(50),
		   venueTimeZoneTZ char(3) not null
		  );

create index GPKSubstitute on Game(gameID);

load data infile '/var/lib/mysql-files/NHL_656/game.csv' ignore into table Game
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';

show warnings limit 10;

-- ASSIGNMENT 2 CODE STARTS
select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlays' as '';
create table GamePlays (playID char(14),
			gameID decimal(10),
			teamIDfor int,
			teamIDagainst int,
			playType varchar(25),
			secondaryType varchar(40),
			x char(4),
			y char(4),
			period decimal(1),
			periodType ENUM('REGULAR', 'OVERTIME', 'SHOOTOUT'),
			periodTime int,
			periodTimeRemaining char(4),
			dateTime datetime,
			goalsAway int,
			goalsHome int,
			description varchar(255),
            FOREIGN KEY (teamIDfor)
            REFERENCES TeamInfo(teamID)
            ON UPDATE CASCADE ON DELETE RESTRICT,
			FOREIGN KEY (teamIDagainst)
            REFERENCES TeamInfo(teamID)
            ON UPDATE CASCADE ON DELETE RESTRICT
-- Additional Constraints
		       );

create index GPPKSubstituteIndex on GamePlays(playID);
create index GPgameIDIndex on GamePlays(gameID);

load data infile '/var/lib/mysql-files/NHL_656/game_plays.csv' ignore into table GamePlays
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n'
	 (playID, gameID, @vthree, @vfour, playType, secondaryType, x, y, period, @periodType, periodTime, periodTimeRemaining, dateTime, goalsAway, goalsHome, description)
	 set 
	 teamIDfor = NULLIF(@vthree,'NA'),
	 teamIDagainst = NULLIF(@vfour,'NA'),
	 periodType = @periodType;
     --     ignore 1 lines;

show warnings limit 10;
-- ASSIGNMENT 2 CODE ENDS

select '---------------------------------------------------------------------------------------' as '';
select 'Create GameGoals' as '';

create table GameGoals (playID char(14),
       	     	        strength char(12),
			gameWinningGoal char(5),
			emptyNet char(5)
-- Additional Constraints
   		       );

create index GGPKSubstitute on GameGoals(playID);

load data infile '/var/lib/mysql-files/NHL_656/game_goals.csv' ignore into table GameGoals
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';
--     ignore 1 lines;

show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePenalties' as '';

create table GamePenalties (playID char(14),
              	     	    penaltySeverity char(15),
			    penaltyMinutes decimal(2)
-- Additional Constraints
			   );

create index GPenPKSubstitute on GamePenalties(playID);

load data infile '/var/lib/mysql-files/NHL_656/game_penalties.csv' ignore into table GamePenalties
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';
--     ignore 1 lines;

show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlaysPlayers' as '';

create table GamePlaysPlayers (playID char(14),
       	     		       gameID decimal(10),
			       playerID decimal(7),
			       playerRole char(10)
-- Additional Constraints
			      );

create index GPP1 on GamePlaysPlayers(playID);
create index GPP2 on GamePlaysPlayers(gameID);
create index GPP3 on GamePlaysPlayers(playerID);

load data infile '/var/lib/mysql-files/NHL_656/game_plays_players.csv' ignore into table GamePlaysPlayers
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';
--      ignore 1 lines;

show warnings limit 10;

-- Game Officials --------------------------------------------------------------
select '----------------------------------------------------------------' as '';
select 'Create GameOfficials' as '';

create table GameOfficials (gameID decimal(10),
       	     		    officialName char(20),
			    officialType char(20)
-- Constraints
			   );

load data infile '/var/lib/mysql-files/NHL_656/game_officials.csv' ignore into table GameOfficials
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';

-- Game Scratches --------------------------------------------------------------
select '----------------------------------------------------------------' as '';
select 'Create GameScratches' as '';

create table GameScratches (gameID decimal(10),
       	     		    teamID int,
			    playerID decimal(7)
-- Constraints
			   );			    

load data infile '/var/lib/mysql-files/NHL_656/game_scratches.csv' ignore into table GameScratches
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';

-- Game Shifts -----------------------------------------------------------------
select '----------------------------------------------------------------' as '';
select 'Create GameShifts' as '';

create table GameShifts (gameID decimal(10),
       	     		 playerID decimal(7),
			 period decimal(1),
			 start int,
			 end int
-- Constraints
			);

create index GameShifts1 on GameShifts(gameID);
create index GameShifts2 on GameShifts(playerID);

load data infile '/var/lib/mysql-files/NHL_656/game_shifts.csv' ignore into table GameShifts
     fields terminated by ','
     enclosed by '"'
     lines terminated by '\n';

