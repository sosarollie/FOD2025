program tp2ej2;
const
	valorAlto = 9999;
type

 producto = record
	cod: integer;
	nom: string[20];
	precio: real;
	stockA: integer;
	stockM: integer;
 end;
 
 venta = record
	cod: integer;
	cantV: integer;
 end;
 
 master = file of producto;
 detail = file of venta;
 
procedure leer (var archivo: detail; var dato: venta);
begin
 if (not eof(archivo)) then
	read(archivo, dato)
 else
	dato.cod:= valorAlto;
end;

function minimoPorDebajo (p: producto): boolean;
begin
 if (p.stockA < p.stockM) then
	minimo:= true;
 else
	minimo:= false;
end;

procedure listarTxt(var stockTXT: Text, var mae1: master);
var
 p: producto;
begin
	reset(mae1);
	rewrite(stockTXT);
	while (not eof(mae1)) do begin
		read(mae1, p);
		if (minimoPorDebajo(p)) then
			with p do
				writeln(stockTXT, cod, ' ', nom, ' ', precio:2:2 ' ', stockA, ' ', stockM, ' ');
		end;
	close(stockTXT);
	close(mae1);
end;

procedure actualizarMaster (var mae1: master; var det1: detail);
var
 aux: integer;
 regm: producto;
 regd: venta;
 total: integer;
begin
 write(mae1, regm);
 leer(det1, regd);
 while (regd.cod <> valorAlto) do begin
	aux:= regd.cod;
	total:= 0;
	while (aux = regd.cod) do
		total:= total + regd.cantV;
	while (regm.cod <> aux) do
		read(mae1,regm);
	regm.stockA:= regm.stockA - total;
	seek(mae1, filepos(mae1) -1);
	write(mae1,regm);
	if (not eof(mae1)) then
		read(mae1,regm);
 end;
end;

var
 mae1: master;
 det1: detail;
 stockTXT: Text;
begin
 Assign(mae1, 'maestro');
 Assign(det1, 'detalle');
 Assign(stockTXT, 'stock_minimo.txt');
 reset(mae1);
 reset(det1);
 actualizarMaster(mae1, det1);
 close(mae1);
 close(det1);
end.
