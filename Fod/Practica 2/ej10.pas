program tp2ej10;
type
	mesa = record
		codP: integer;
		codL: integer;
		num: integer;
		cantV: integer;
	end;
	
	maestro = file of mesa;

procedure recorrido (var mae: maestro);
var
 provActual, locActual, totalProv, totalLoc, totalGeneral: integer;
 regm: mesa;
begin
 reset(mae);
 read(mae, regm);
 totalGeneral:= 0;
 while not eof(mae) do begin
	provActual:= regm.codP;
	totalProv:= 0;
	writeln('Codigo de Provincia');
	while (provActual = regm.codP) do begin
		locActual:= regm.codL;
		totalLoc:= 0;
		writeln('Codigo de Localidad    Total de Votos');
		while (provActual = regm.codP) and (locActual = regm.codL) do begin
			totalLoc:= totalLoc + regm.cantV;
			read(mae,regm);
		end;
		Writeln(regm.codL,'        ', totalLoc);
		totalProv:= totalProv + totalLoc;
	end;
	writeln('Total de Votos Provincia: ', totalProv);
	totalGeneral:= totalGeneral + totalProv;
 end;
 writeln('Total General de Votos: ', totalGeneral);
 close(mae);
end;

var
 mae: maestro;
begin
 Assign(mae, 'maestro');
 recorrido(mae);
end.
