Create table TBL (Nmbr Integer ) ;
insert into TBL values
	(1),
	(0),
	(0),
	(1),
	(1),
	(1),
	(1),
	(0),
	(0),
	(1),
	(0),
	(1),
	(0),
	(1),
	(0),
	(1) ;
	
update TBL set Nmbr = case
	when Nmbr >0 then Nmbr+3 else Nmbr+2
	end ;
	