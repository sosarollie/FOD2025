program tp2ej8;
uses crt;
const
 valorAlto = 9999;
 n = 16;
type
	provincia = record
		cod: integer;
		nombre: string;
		cantH: integer;
		cantK: integer;
	end;
	
	relevamiento = record
		cod: integer;
		cantK: integer;
	end;
	
	maestro = file of provincia;
	detalle = file of relevamiento;
	vDet = array [1..n] of detalle;
	vReg = array [1..n] of relevamiento;
	
procedure leer (var archivo: detalle; var dato: relevamiento);
begin
 if not eof(archivo) then
	read(archivo, dato)
 else
	dato.cod:= valorAlto;
end;

procedure minimo (var vD: vDet; var vR: vReg; var min: relevamiento);
var
 i, indiceMin: integer;
begin
 indiceMin:= 0;
 min.cod:= valorAlto;
 for i:= 1 to n do begin
	if (vR[i].cod <> valorAlto) then
		if (vR[i].cod < min.cod) then begin
			indiceMin:= i;
			min:= vR[i];
		end;
 end;
 if (indiceMin <> 0) then
	read(vD[indiceMin], vR[indiceMin]);
end;


procedure actualizar (var mae: maestro; var vD: vDet);
var
 i, codActual, totalKilos: integer;
 regm: provincia;
 vR: vReg;
 min: relevamiento;
begin
 reset(mae);
 for i:= 1 to n do begin
	reset(vD[i]);
	leer(vD[i], vR[i]);
 end;
 minimo(vD, vR, min);
 while (min.cod <> valorAlto) do begin
	totalKilos:= 0;
	codActual:= min.cod;
	while (min.cod = codActual) do begin
		totalKilos:= totalKilos + min.cantK;
		minimo (vD, vR, min);
	end;
	read(mae, regm);
	while (regm.cod <> min.cod) do
		read(mae, regm);
	regm.cantK:= regm.cantK + totalKilos;
	if (regm.cantK > 10000) then
		writeln('La provincia codigo ', regm.cod,' (', regm.nombre,') supera los 10mil kilos de yerba consumidos historicamente');
	seek(mae, filepos(mae) - 1);
	write(mae, regm);
 end;
 close(mae);
 for i:= 1 to n do
	close(vD[i]);
end;

var
 vD: vDet;
 mae: maestro;
 i: integer;
 num: string;
begin
 Assign(mae, 'maestro');
 for i:= 1 to n do begin
	Str(i, num);
	Assign(vD[i], 'detalle' + num);
 end;
 actualizar(mae, vD);
end.






