drop table if exists PeriodData;
drop table if exists GamePlays;

create table GamePlays (
	playNumber varchar(45),
    gameID varchar(20),
	periodTime int not null,
	periodTimeRemaining int not null,
    dateTime datetime not null,
    description varchar(100) not null,
    primary key (playNumber),
	foreign key (gameID) references Game (gameID)
);

create table PeriodData (
	periodNumber varchar(10),
    gameType varchar(10),
    periodType varchar(20) not null,
    primary key (periodNumber, gameType),
	foreign key (gameType) references Game (gameType)
);