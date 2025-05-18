program tp2ej3;
const
	valorAlto = 9999;
type
	provincia = record
		nombre: string[20];
		cantA: integer;
		cantE: integer;
	end;
	
	censo = record
		nombre: string[20];
		cod: integer;
		cantA: integer;
		cantE: integer;
	end;
	
	master = file of provincia;
	detail = file of censo;

procedure leer (var archivo: detail; var dato: censo);
begin
	if (not eof(archivo)) then
		read(archivo, dato)
	else
		dato.cod:= valorAlto;
end;

procedure minimo (var r1,r2,min: censo; var det1,det2: detail);
begin
	if (r1.cod <= r2.cod) then begin
		min:= r1;
		leer(det1,r1);
	end
	else begin
		min:= r2;
		leer(det2,r2);
	end;
end;

procedure actualizarMaestro (var mae1: master; var det1,det2: detail);
var
 regd1,regd2,min: censo;
 regm: provincia;
 aux: string[20];
 totalA: integer;
 totalE: integer;
begin
 read(mae1, regm);
 leer(det1, regd1);
 leer(det2, regd2);
 minimo(regd1,regd2,min,det1,det2);
 while (min.cod <> valorAlto) do begin
	aux:= min.nombre;
	totalA:= 0;
	totalE:= 0;
	while (min.nombre = aux) do begin
		totalA:= totalA + min.cantA;
		totalE:= totalE + min.cantE;
		minimo(regd1,regd2,min,det1,det2);
	end;
	while (regm.nombre <> min.nombre) do
		read(mae1,regm);
	regm.cantA:= regm.cantA + totalA;
	regm.cantE:= regm.cantE + totalE;
	seek(mae1, filepos(mae1) -1);
	write(mae1, regm);
	if (not eof(mae1)) then
		read(mae1,regm);
 end;
 close(mae1);
 close(det1);
 close(det2);
end;
		
var
 mae1: master;
 det1, det2: detail;
begin		
 Assign(mae1, 'maestro');
 Assign(det1, 'detalle1');
 Assign(det2, 'detalle2');
 reset(mae1);
 reset(det1);
 reset(det2);
 actualizarMaestro(mae1,det1,det2);
end.
		
		
