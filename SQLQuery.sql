
create table items
(
	itemid int identity primary key,
	itemname varchar(255) unique
)

set nocount on
DECLARE @i int = 0
WHILE @i < 20000
BEGIN
    SET @i = @i + 1

	insert items (itemname) values ('foo' + convert(varchar, @i))
    /* do some work */
END
