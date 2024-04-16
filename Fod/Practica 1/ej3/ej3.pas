{Realizar un programa que presente un menú con opciones para
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una
única vez.}
program ej3;
uses crt;

type
	empleado = record
		num: integer;
		apellido: string[20];
		nombre: string[20];
		edad: integer;
		dni: integer;
	end;
	
	archivo_empleados = file of empleado;

procedure leerEmpleado (var e: empleado);
begin
	with e do begin
		writeln('Ingrese numero de empleado');
		readln(num);
		writeln('Ingrese apellido');
		readln(apellido);
		if (apellido <> 'fin') then begin
			writeln('Ingrese nombre');
			readln(nombre);
			writeln('Ingrese edad');
			readln(edad);
			writeln('Ingrese dni');
			readln(dni);
		end;
		writeln('');
	end;
end;

procedure imprimirEmpleado (e: empleado);
begin
	with e do begin
		writeln('Numero: ',num);
		writeln('Nombre: ',nombre);
		writeln('Apellido: ',apellido);
		writeln('Edad: ',edad);
		writeln('Dni: ',dni);
	end;
end;


procedure cargarEmpleados (var archivo: archivo_empleados);
var
	e: empleado;
begin
	leerEmpleado(e);
	while (e.apellido <> 'fin') do begin
		write(archivo, e);
		leerEmpleado(e);
	end;
end;

procedure nombreOApellido (var archivo: archivo_empleados);
var
	e: empleado;
	dato: string[30];
begin
	writeln('Ingrese el nombre o apellido del empleado a buscar');
	readln(dato);
	while not eof(archivo) do begin
		read(archivo, e);
		if (e.nombre = dato) or (e.apellido = dato) then
			imprimirEmpleado(e);
	end;
end;

procedure listarEmpleados (var archivo: archivo_empleados);
var
	e: empleado;
begin
	while not eof(archivo) do begin
		read(archivo, e);
		imprimirEmpleado(e);
	end;
end;

procedure mayores (var archivo: archivo_empleados);
var
	e: empleado;
begin
	while not eof(archivo) do begin
		read(archivo, e);
			if (e.edad > 70) then begin
				writeln('Proximo a jubilarse: ');
				imprimirEmpleado(e);
			end;
	end;
end;

procedure abrir (var archivo: archivo_empleados);
var
	opcion: char;
begin
	reset(archivo);
	writeln('| A continuacion, elija una opcion a ejecutar |');
	writeln('a) Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
	writeln('b) Listar en pantalla los empleados de a uno por linea');
	writeln('c) Listar en pantalla los empleados mayores de 70 anios, proximos a jubilarse');
	readln(opcion);
	case opcion of
		'a': nombreOApellido(archivo);
		'b': listarEmpleados(archivo);
		'c': mayores(archivo);
		else writeln ('No se encuentra esa opcion');
	end;
end;

procedure crear (var archivo: archivo_empleados; var nombre_archivo: string);
begin
	rewrite(archivo);
	cargarEmpleados(archivo);
	clrscr;
	abrir(archivo);
end;

var
	opcion: char;
	archivo: archivo_empleados;
	nombre_archivo: string[30];
begin
	textcolor(green);	
	writeln('| Bienvenido |');
	writeln('Ingrese el nombre del archivo');
	readln(nombre_archivo);
	Assign(archivo, nombre_archivo);
	clrscr;
	writeln('| A continuacion, elija una opcion a ejecutar |');
	writeln('a) Crear archivo');
	writeln('b) Abrir archivo');
	readln(opcion);
	clrscr;
	if opcion = 'a' then
		crear(archivo, nombre_archivo)
	    else if opcion = 'b' then begin
			clrscr;
			abrir(archivo)
		end else writeln ('No se encuentra esa opcion');
	close(archivo);
end.





