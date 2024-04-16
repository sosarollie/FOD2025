{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado}
program ej1;
type
	archivo_numeros = file of integer;
var
	nombre: string;
	archivo: archivo_numeros;
	num: integer;
begin
	write('Ingrese el nombre del archivo');
	read(nombre);
	Assign(archivo, nombre);
	rewrite(archivo);
	write('Ingrese un numero');
	read(num);
	while (num <> 30000) do begin
		write(archivo, num);
		write('Ingrese un numero');
		read(num);
	end;
	close(archivo);
end.
