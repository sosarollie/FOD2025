program tp2ej4;
uses crt;
const
 valorAlto = 9999;
 n = 30;
type
 producto = record
	cod: integer;
	nombre: string[20];
	desc: string[60];
	stockD: integer;
	stockM: integer;
	precio: real;
 end;
 
 sucursal = record
	cod: integer;
	cantV: integer;
 end;
 
 master = file of producto;
 detail = file of sucursal;
 vDetalles = array [1..n] of detail;
 vSucursales = array [1..n] of sucursal;
 
 procedure leer (var det: detail; var dato: sucursal);
 begin
  if (not eof(det)) then
	read(det, dato)
  else
	dato.cod:= valorAlto;
 end;
 
 procedure minimo (var vD: vDetalles; var vS: vSucursales; var min: sucursal);
 var
  i: integer;
  indiceMin: integer;
 begin
  indiceMin:= 0;
  min.cod:= valorAlto;
  for i:= 1 to n do
	if (vS[i].cod <> valorAlto) then
		if (vS[i].cod < min.cod) then begin
			indiceMin:= i;
			min:= vS[i];
		end;
	if (indiceMin <> 0) then
		leer(vD[indiceMin], vS[indiceMin]);
 end;

procedure actualizar (var mae1: master; var vD: vDetalles; var vS: vSucursales);
var
 min: sucursal;
 codActual: integer;
 cantVendido: integer;
 regm: producto;
 i: integer;
begin
 for i:= 1 to n do
	leer(vD[i], vS[i]);
 minimo(vD, vS, min);
 while (min.cod <> valorAlto) do begin
	codActual:= min.cod;
	cantVendido:= 0;
	if (min.cod = codActual) then begin
		cantVendido:= cantVendido - min.cantV;
		minimo(vD, vS, min);
	end;
	read(mae1, regm);
	while (regm.cod <> min.cod) do
		read(mae1,regm);
	regm.stockD:= regm.stockD - cantVendido;
	seek(mae1,filepos(mae1)-1);
	write (mae1, regm);
 end;
 for i:= 1 to n do
	close(vD[i]);
 close(mae1);
end;

procedure exportarTXT (var arcTXT: Text; var mae1: master);
var
 p: producto;
begin
 rewrite(arcTXT);
 while (not eof(mae1)) do begin
	read(mae1, p);
	with p do begin
	 if (stockD < stockM) then
		writeln(arcTXT, nombre, ' ', desc, ' ', stockD, ' ', precio:2:2);
	end;
 end;
 close(arcTXT);
end;
	
var
 mae1: master;
 vS: vSucursales;
 vD: vDetalles;
 arcTXT: Text;
 i: integer;
 aString: string;
begin
 Assign(mae1, 'maestro');
 Assign(arcTXT, 'stockpordebajo');
 for i:= 1 to n do begin
	Str (i,aString);
	Assign(vD[i], 'detalle' + aString);
	reset(vD[i]);
 end;
 reset(mae1);
 actualizar(mae1, vD, vS);
 exportarTXT(arcTXT, mae1);
end.
 
 
 
