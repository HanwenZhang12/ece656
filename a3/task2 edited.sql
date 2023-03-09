
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
drop table if exists GamePlaysPlayers_2;
drop table if exists GameChallenges;
drop table if exists ExecutablePlays;
drop table if exists NonExecutablePlays;
drop table if exists GameShots;


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

show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
-- Team Information

select 'Create TeamInfo' as '';

create table TeamInfo (teamID int primary key,
       	     	       franchiseID int not null,
		       city char(15) not null,
		       name char(15) not null,
		       abbreviation char(3) unique not null);

show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
-- Game Information: note that the ignore option on data loading means that a few thousand duplicate
-- primary keys are rejected, but so are half-a-dozen foreign key constraint violations
-- If replace is used, it will override the existing PK data but will get a rejection on an FK violation

select 'Create Game' as '';

create table Game (gameID decimal(10) primary key ,
       	         season decimal(8) check(season%10000-1 = (season DIV 10000)),
				 
                   gameType char(1) check((gameType='R' AND SUBSTRING(gameID, 5, 2) = 2)  OR (gameType='P' AND SUBSTRING(gameID, 5, 2) = 3) OR (gameType='A' AND SUBSTRING(gameID, 5, 2) = 4))
				   dateTimeGMT datetime,
	outcome char(12),
	homeRinkSideStart char(50),
	venue varchar(64),
	venueTimeZoneID char(20),
	venueTimeZoneOffset char(50),
	venueTimeZoneTZ char(3) not null
				   );

show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlays' as '';

create table GamePlays (playNumber int,
                        gameID decimal(10),
                        playType varchar(25),
                        periodType char(8),
                        periodTime int,
                        periodTimeRemaining int,
                        description varchar(255),
                        primary key (gameID, playNumber),
                        foreign key (gameID) references Game(gameID),
						
                       );

show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create ExecutablePlays' as '';

create table ExecutablePlays (playNumber int,
                        gameID decimal(10),
                        x char(4),
				    y char(4),
				   teamIDfor int,
                   teamIDagainst int,
				    primary key (gameID, playNumber),
                    foreign key (gameID) references Game(gameID),
					foreign key (teamIDfor) references TeamInfo(teamID),
                    foreign key (teamIDagainst) references TeamInfo(teamID)
   		       );


show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create GameChallenges' as '';

create table GameChallenges(playNumber int,
        teamIDfor int,
	teamIDagainst int,
	foreign key (teamIDfor) references TeamInfo(teamID),
	foreign key (teamIDagainst) references TeamInfo(teamID),
	primary key (gameID, playNumber),
	foreign key (gameID, playNumber) references GamePlays(gameID, playNumber)
   		       );


show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create NonExecutablePlays' as '';

create table NonExecutablePlays(playNumber int,
                        gameID decimal(10),
				    primary key (gameID, playNumber),
                        foreign key (gameID) references Game(gameID)
   		       );


show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create GameGoals' as '';

create table GameGoals (playNumber int,
        strength char(12),
	gameWinningGoal bool,
	emptyNet bool,
	awayGoals int check(awayGoals >= 0),
	homeGoals int check(homeGoals >= 0),
	secondaryType varchar(40) not null,
-- Key Constraints
	primary key (gameID, playNumber),
	foreign key (gameID, playNumber) references GamePlays (gameID, playNumber)

   		       );


show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create GameShots' as '';

create table GameShots (playNumber int,
                        gameID decimal(10),
       	     	    secondaryType varchar(40) NOT NULL
					primary key (gameID, playNumber),
	                foreign key (gameID, playNumber) references GamePlays (gameID, playNumber)
   		       );


show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePenalties' as '';

create table GamePenalties (gameID decimal(10),
       	playNumber int,
        penaltySeverity char(15),
	penaltyMinutes decimal(2),
	secondaryType varchar(40) not null,
-- Key Constraints
	primary key (gameID, playNumber),
	foreign key (gameID, playNumber) references GamePlays(gameID, playNumber)

			   );

show warnings limit 10;

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlaysPlayers' as '';

create table GamePlaysPlayers (playID char(14),
       	     		       gameID decimal(10),
			       playerID decimal(7),
			       playerRole char(10) not null
				   primary key (gameID, playNumber, playerID),
	foreign key (gameID, playNumber) references ExecutablePlays(gameID, playNumber),
	foreign key (playerID) references PlayerInfo(playerID)
-- Additional Constraints
			      );

show warnings limit 10;

-- Game Officials --------------------------------------------------------------
select '----------------------------------------------------------------' as '';
select 'Create GameOfficials' as '';

create table GameOfficials (gameID decimal(10),
       	     		    officialName char(20),
			    officialType char(20)
-- Constraints
			   );

-- Game Scratches --------------------------------------------------------------
select '----------------------------------------------------------------' as '';
select 'Create GameScratches' as '';

create table GameScratches (gameID decimal(10),
       	     		    teamID int,
			    playerID decimal(7)
-- Constraints
			   );			    


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


-- Game Plays Players2 --------------------------------------------------------------
select '----------------------------------------------------------------' as '';
select 'Create GamePlaysPlayers_2' as '';

create table GamePlaysPlayers_2 (gameID decimal(10),
       	     	               playNumber int,
                               teamIDfor int,
                               teamIDagainst int,
                               primary key (gameID, playNumber),
                               foreign key (teamIDfor) references TeamInfo(teamID),
                               foreign key (teamIDagainst) references TeamInfo(teamID));
show warnings limit 10;

