program tp2ej7;
const
	valorAlto = 9999;
type
	
	rango = 0..10;
	
	alumno = record
		cod: integer;
		apellido: string;
		nombre: string;
		cursadas: integer;
		materias: integer;
	end;
	
	detalle = record
		codA: integer;
		codM: integer;
		fecha: string;
		resultado: rango; //0 = cursada desaprobada, 1 = cursada aprobada, 2-10 = nota final
	end;
	
	master = file of alumno;
	archivo_detalle = file of detalle;

procedure leer (var archivo: archivo_detalle; var dato: detalle);
begin
 if not eof (archivo) then
	read(archivo, dato)
 else
	dato.codA:= valorAlto;
end;

procedure minimo (var r1,r2,min: detalle; var det1,det2: archivo_detalle);
begin
 min.codA:= valorAlto;
 if (((r1.codA < r2.codA) and (r1.codM <= r2.codM)) or ((r1.codA = r2.codA) and (r1.codM <= r2.codM))) then begin
	min:= r1;
	leer(det1, r1);
 end;
 if (((r2.codA < r1.codA) and (r2.codM <= r1.codM)) or ((r2.codA = r1.codA) and (r2.codM <= r1.codM))) then begin
	min:= r2;
	leer(det2, r2);
 end;
end;

procedure actualizar (var maestro: master; var det1,det2: archivo_detalle);
var
 min, r1, r2: detalle;
 cantMaterias, cantCursadas: integer;
 codActual: integer;
 regm: alumno;
begin
 reset(maestro);
 leer(det1, r1);
 leer(det2, r2);
 minimo(r1, r2, min, det1, det2);
 while (min.codA <> valorAlto) do begin
	cantMaterias:= 0;
	cantCursadas:= 0;
	codActual:= min.codA;
	while (min.codA = codActual) do begin
		if (min.resultado = 1) then
			cantCursadas:= cantCursadas + 1
		else if (min.resultado >= 4) then
			cantMaterias:= cantMaterias + 1;
		minimo(r1, r2, min, det1, det2);
	end;
	read(maestro, regm);
	while (regm.cod <> min.codA) do
		read(maestro, regm);
	regm.cursadas:= cantCursadas;
	regm.materias:= cantMaterias;
	seek(maestro, filepos(maestro) -1);
	write(maestro, regm);
 end;
 close(maestro);
 close(det1);
 close(det2);
end;

var
 det1,det2: archivo_detalle;
 maestro: master;
begin
 Assign(maestro, 'maestro');
 Assign(det1, 'detalle1');
 Assign(det2, 'detalle2');
end.
	
	
	
	
	
 
