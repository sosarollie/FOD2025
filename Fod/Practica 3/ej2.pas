program tp3ej2;
const valorAlto = 9999;
type

	asistente = record
		num: integer;
		ape: string;
		nom: string;
		email: string;
		tel: integer;
		dni: integer;
	end;
	
archivo_asistentes = file of asistente;

procedure leerAsistente(var a: asistente);
begin
	with a do begin
		read (num);
		if (num <> -1) then begin
			read(ape);
			read(nom);
			read(email);
			read(tel);
			read(dni);
		end;
	end;
end;

procedure cargarArchivo (var a: archivo_asistentes);
var
 asis: asistente;
begin
 rewrite(a);
 leerAsistente(asis);
 while (asis.num <> -1) do begin
	write(a, asis);
	leerAsistente(asis);
 end;
end;

procedure leer (var a: archivo_asistentes; var dato: asistente);
begin
	if (not eof(a)) then
		read(a, dato)
	else
		dato.num:= valorAlto;
end;


procedure bajaLogica (var a: archivo_asistentes);
var
 reg: asistente;
begin
 reset(a);
 leer(a, reg);
 while (reg.num <> valorAlto) do begin
	if (reg.num < 1000) then begin
		reg.nom := '*' + reg.nom;
		seek(a, filePos(a) - 1);
		write(a, reg);
	end;
	leer(a, reg);
 end;
end;

var
 a: archivo_asistentes;
begin
 Assign(a, 'maestro');
 cargarArchivo(a);
 bajaLogica(a);
 close(a);
end.
