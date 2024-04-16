{
1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez 
}

program ej1;
const
	valorAlto = 9999;
type

	empleado = record
		cod: integer;
		nom: string[30];
		monto: real;
	end;
	
	maestro = file of empleado;
	detalle = file of empleado;

procedure leer (var e: empleado);
begin
	with e do begin
		writeln('Ingrese el codigo del empleado');
		readln(cod);
		if (cod <> -1) then begin
			writeln('Ingrese el nombre del empleado');
			readln(nom);
			writeln('Ingrese el monto del empleado');
			readln(monto);
		end;
	end;
end;

procedure leer2 (var archivo: detalle; var dato: empleado);
begin
	if (not eof (archivo)) then
		read(archivo,dato)
	else
		dato.cod:= valorAlto;
end;

procedure crear (var det: detalle);
var
	e: empleado;
begin
	rewrite(det);
	leer(e);
	while (e.cod <> -1) do begin
		write(det, e);
		leer(e)
	end;
end;

procedure compactar (var maes: maestro; var det: detalle);
var
	e: empleado;
	c: empleado;
	codActual: integer;
begin
	rewrite(maes);
	reset(det);
	leer2(det, e);
	while (e.cod <> valorAlto) do begin
		codActual:= e.cod;
		c.monto:= 0;
		while (e.cod = codActual) do begin
			c.monto:= c.monto + e.monto;
			leer2(det, e);
		end;
		c.cod:= e.cod;
		c.nom:= e.nom;
		write(maes, c);
	end;
	close(det);
end;

var
	maes: maestro;
	det: detalle;
BEGIN
	Assign(maes, 'archivo_empleado');
	Assign(det, 'archivo_comprimido');
	crear(det);
	compactar(maes, det);
	close(maes);
END.

