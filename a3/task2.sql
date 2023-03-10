drop table if exists GameShots;
drop table if exists GamePlaysPlayers2;
drop table if exists GamePlaysPlayers;
drop table if exists OfficialChallenge;
drop table if exists ExecutablePlays;
drop table if exists NonExecutablePlays;
drop table if exists TeamInfo;
drop table if exists PlayerInfo;
drop table if exists GamePenalties;
drop table if exists GameGoals;
drop table if exists GamePlays;
drop table if exists Game;

select '---------------------------------------------------------------------------------------' as '';
select 'Create Game' as '';

create table Game (
	gameID varchar(20) primary key,
	season int check(season % 10000 - 1 = (season div 10000)) not null,
	gameType varchar(10) not null,
	dateTimeGMT datetime not null,
    awayTeamID int not null,
    homeTeamID int not null,
    awayGoals varchar(10) not null,
    homeGoals varchar(10) not null,
	outcome varchar(45) not null,
	homeRinkSideStart varchar(20) not null,
	venue varchar(45) not null,
	venueTimeZoneID varchar(45) not null,
	venueTimeZoneOffset varchar(10) not null,
	venueTimeZoneTZ varchar(10) not null,
    CONSTRAINT chk_Game CHECK (
		(gameType = 'R' and substring(gameID, 5, 2) = '02') 
		or (gameType = 'P' and substring(gameID, 5, 2) = '03') 
		or (gameType = 'A' and substring(gameID, 5, 2) = '04')
        or (gameType = 'R' and substring(gameID, 5, 2) = '03' and dateTimeGMT between '2020-08-01 00:00:00' and '2020-08-31 23:59:59')
    )
);

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlays' as '';

create table GamePlays (
	playNumber varchar(45),
    gameID varchar(20),
    period varchar(10) not null,
    periodType varchar(20) not null,
	periodTime int not null,
	periodTimeRemaining int not null,
    dateTime datetime not null,
    description varchar(100) not null,
    primary key (playNumber),
	foreign key (gameID) references Game (gameID)
);

select '---------------------------------------------------------------------------------------' as '';
select 'Create GameGoals' as '';

create table GameGoals (
	playNumber varchar(45),
    playType varchar(20) not null,
    secondaryType varchar(20),
    goalsAway varchar(10) not null,
    goalsHome varchar(10) not null,
    strength varchar(20) not null,
	gameWinningGoal bool not null,
	emptyNet bool not null,
    primary key (playNumber),
    foreign key (playNumber) references GamePlays (playNumber)
);

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePenalties' as '';

create table GamePenalties (
	playNumber varchar(45),
	playType varchar(20) not null,
    secondaryType varchar(20),
    penaltySeverity varchar(20) not null,
    penaltyMinutes int not null,
	primary key (playNumber),
	foreign key (playNumber) references GamePlays (playNumber)
);

select '---------------------------------------------------------------------------------------' as '';
select 'Create PlayerInfo' as '';

create table PlayerInfo (
	playerID varchar(20) primary key,
	firstName varchar(20) not null,
	lastName varchar(20) not null,
	nationality varchar(10) not null,
	birthCity varchar(45) not null,
	primaryPosition varchar(20) not null,
	birthDate datetime not null,
	birthStateProvince varchar(20) not null,
	height varchar(10) not null,
	heightInCM decimal(5,2) not null,
	weight decimal(5,2) not null,
	shootsCatches varchar(10) not null
);

select '---------------------------------------------------------------------------------------' as '';
select 'Create TeamInfo' as '';

create table TeamInfo (
	teamID int primary key,
	franchiseID int not null,
	city varchar(20) not null,
	name varchar(20) not null,
	abbreviation varchar(10) not null
);

select '---------------------------------------------------------------------------------------' as '';
select 'Create NEP' as '';

create table NonExecutablePlays (
	playNumber varchar(45),
	gameType varchar(20) not null,
    primary key (playNumber),
    foreign key (playNumber) references GamePlays(playNumber)
);

select '---------------------------------------------------------------------------------------' as '';
select 'Create EP' as '';

create table ExecutablePlays (
	playNumber varchar(45),
    teamIDfor int,
    teamIDagainst int,
    x int not null,
    y int not null,
    primary key (playNumber),
    foreign key (playNumber) references GamePlays(playNumber),
    foreign key (teamIDfor) references TeamInfo(teamID),
    foreign key (teamIDagainst) references TeamInfo(teamID)
);

select '---------------------------------------------------------------------------------------' as '';
select 'Create OC' as '';

create table OfficialChallenge (
	playNumber varchar(45),
	gameType varchar(20) not null,
    teamIDfor int,
    teamIDagainst int,
    primary key (playNumber),
    foreign key (playNumber) references GamePlays(playNumber)
);

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlayPlayers' as '';

create table GamePlaysPlayers (
	playNumber varchar(45),
    gameID varchar(20),
    playerID varchar(20),
    playerRole varchar(20) not null,
    primary key (playNumber, gameID, playerID),
    foreign key (playNumber) references ExecutablePlays(playNumber),
    foreign key (gameID) references Game(gameID),
	foreign key (playerID) references PlayerInfo(playerID)
);

select '---------------------------------------------------------------------------------------' as '';
select 'Create GamePlayPlayers2' as '';

create table GamePlaysPlayers2 (
	playNumber varchar(45),
    gameID varchar(20),
    playerID varchar(20),
    playerRole varchar(20) not null,
    primary key (playNumber, gameID, playerID),
    foreign key (playNumber) references OfficialChallenge(playNumber),
    foreign key (gameID) references Game(gameID),
	foreign key (playerID) references PlayerInfo(playerID)
);

select '---------------------------------------------------------------------------------------' as '';
select 'Create GameShots' as '';

create table GameShots (
	playNumber varchar(45),
	playType varchar(20) not null,
    secondaryType varchar(20),
	primary key (playNumber),
	foreign key (playNumber) references GamePlays (playNumber)
);

DROP TRIGGER IF EXISTS checker;

select '---------------------------------------------------------------------------------------' as '';
select 'Create Trigger' as '';

DELIMITER $$
CREATE TRIGGER checker AFTER INSERT ON Game FOR EACH ROW
BEGIN
	declare aid int;
	declare hid int;
    declare gid int;
    select awayTeamID into aid from inserted;
    select homeTeamID into hid from inserted;
    select gameID into gid from inserted;
    if aid not in (select teamID from TeamInfo) or hid not in (select teamID from TeamInfo) then 
		delete from Game where gameID = gid;
	end if;
END$$
DELIMITER ;

