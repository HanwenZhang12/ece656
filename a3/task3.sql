drop table if exists PeriodData;

create table PeriodData (
	periodNumber varchar(10),
    gameType varchar(10),
    periodType varchar(20) not null,
    primary key (periodNumber, gameType)
);

INSERT INTO PeriodData (periodNumber, gameType, periodType) SELECT distinct gp.period, g.gameType, gp.periodType FROM GamePlays gp INNER JOIN Game g ON gp.gameID = g.gameID;

alter table GamePlays drop column periodType, change column period periodNumber VARCHAR(10) NOT NULL, add foreign key (periodNumber) references PeriodData(periodNumber);