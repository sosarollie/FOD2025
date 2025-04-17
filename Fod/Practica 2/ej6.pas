{Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}
program tp2ej6;
const
	valorAlto = 9999;
	n = 20;
type
	maestro = record
		codL: integer;
		nombreL: string;
		codC: integer;
		nombreC: string;
		cantAct: integer;
		cantNue: integer;
		cantRec: integer;
		cantFall: integer;
	end;
	
	localidad = record
		codL: integer;
		codC: integer;
		cantAct: integer;
		cantNue: integer;
		cantRec: integer;
		cantFall: integer;
	end;
	
 master = file of maestro;
 detail = file of localidad;
 vDet = array [1..n] of detail;
 vReg = array [1..n] of localidad;
 
procedure leer (var archivoDet: detail; var dato: localidad);
begin
 if (not eof(archivoDet)) then
	read(archivoDet, dato)
 else
    dato.codL:= valorAlto;
 end;
 
procedure minimo (var vd: vDet; var regd: vReg; var min: localidad);
var
 i, indiceMin: integer;
begin
 indiceMin:= 0;
 min.codL:= valorAlto;
 for i:= 1 to n do
	if (vd[i].codL <> valorAlto) then
		if (vd[i].codL < min.codL) or ((vd[i].codL = min.codL) and (vd[i].codC < min.codC)) then begin
			indiceMin:= i;
			min:= vd[i];
	end;
 if (indiceMin <> 0) then
	read(vd[i], regd[i];
end;

procedure actualizar (var maestro: master; var vd: vDet);
var
 vr: vReg;
 i, codActual, totalFall, totalRec, totalAct, totalNue: integer;
 min, regd: localidad;
 regm: master;
begin
 reset(maestro);
 for i:= 1 to n do begin
	reset(vd[i]);
	leer(vd[i], vr[i]) ;
 end;
 minimo (vd, vr, min);
 while (min.codL <> valorAlto) do begin
	totalFall:= 0;
	totalRec:= 0;
	totalAct:= 0;
	totalNue:= 0;
	codActual:= min.codL;
	while (min.codL = codActual) then begin
		totalFall:= totalFall + min.cantFall;
		totalRec:= totalRec + min.cantRec;
		totalAct:= totalAct + min.cantAct;
		totalNue:= totalNue + min.cantNue;
		minimo(vd, vr, min);
	end;
	read(maestro, regm);
	while (regm.codL <> min.codL) do
		read(maestro, regm);
	while (regm.codC <> min.codC) do
		read(maestro, regm);
	regm.cantFall:= regm.cantFall + totalFall;
	regm.cantRec:= regm.cantRec + totalRec;
	regm.cantAct:= totalAct;
	regm.cantNue:= totalNue;
	seek(maestro, filepos(maestro)-1);
	write(maestro, regm);
 end;
 for i:= 1 to n do
	close(vr[i]);
 close(maestro);
end;

procedure mayor50Act (var maestro: master);
var
 cant: integer;
 regm: master;
begin
	cant:= 0;
	while (not eof(maestro)) do begin
		read(maestro, regm);
		if (regm.cantAct < 50) then
			cant:= cant + 1;
	end;
	writeln('La cantidad de localidades con mas de 50 casos activos es de', cant);
end;

var
 vd: vDet;
 maestro: master;
 i: integer;
 num: string;
begin
 Assign(maestro, 'maestro');
 for i:= 1 to n do begin
	Str(i, num);
	Assign(vd[i], 'detalle' + num);
 end;
 actualizar(maestro, vd);
 mayor50Act(maestro);
end.
  
  
