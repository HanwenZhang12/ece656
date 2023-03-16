alter table GamePlays 
drop column periodTimeRemaining,
drop column periodTime,
drop column periodType,
change column period periodNumber VARCHAR(10) NOT NULL;

create table PeriodData (
	periodNumber varchar(10),
    gameType varchar(10),
    periodType varchar(20) not null,
    primary key (periodNumber, gameType)
);