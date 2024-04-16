program ej2;
type
	archivo_numeros = file of integer;
	
procedure cargarInformacion (var archivo: archivo_numeros; num: integer;
								var cant_menores: integer; var prom: real);
var
	sum: integer;
	cant_num: integer;
begin
	cant_menores:= 0;
	sum:= 0;
	cant_num:= 0;
	while not eof(archivo) do begin
		read(archivo, num);
		if (num < 1500) then
			cant_menores:= cant_menores + 1;
		sum:= sum + num;
		cant_num:= cant_num + 1;
		writeln(num);
	end;
	prom:= (sum / cant_num);
end;

var
	nombre: string[50];
	archivo: archivo_numeros;
	num: integer;
	cant_menores: integer;
	prom: real;
begin
	writeln('Ingrese el nombre del archivo');
	read(nombre);
	Assign(archivo, nombre);
	reset(archivo);
	cargarInformacion(archivo, num, cant_menores, prom);
	writeln('La cantidad de numeros menores a 1500 es de ', cant_menores);
	writeln('El promedio de todos los numeros es de ', prom:2:2);
	close(archivo);
end.
