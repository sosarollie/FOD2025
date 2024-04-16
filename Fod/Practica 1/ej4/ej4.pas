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
program ej4;
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

procedure addEmpleado (var archivo: archivo_empleados);
var
	e, emp_cargado: empleado;
	repetido: boolean;
begin
	reset(archivo);
	leerEmpleado(e);
	while (e.apellido <> 'fin') do begin
		repetido:= false;
		while (not eof(archivo)) and (repetido = false) do begin //busco si esta repetido el numero de empleado
			read(archivo, emp_cargado); // se puede cargar solo el numero?
			if (emp_cargado.num = e.num) then
				repetido:= true;
		end;
		if (repetido = false) then begin
			seek(archivo, fileSize(archivo));
			write(archivo, e);
		end;
		leerEmpleado(e);
	end;
end;

procedure modificarEdad (var archivo: archivo_empleados);
var
	edad, num_emp: integer;
	encontre: boolean;
	e: empleado;
begin
	encontre:= false;
	writeln('Ingrese el numero de empleado a buscar');
	readln(num_emp);
	while (not eof(archivo)) and (encontre = false) do begin
		read(archivo, e);
		if (e.num = num_emp) then begin
			encontre:= true;
			writeln('Ingrese la edad actualizada');
			readln(edad);
			e.edad:= edad;
			seek(archivo, filePos(archivo)-1);
			write(archivo, e);
		end;
	end;
	if (encontre = true) then
		writeln('Empleado actualizado')
	else
		writeln('No se encontro el numero de empleado ', num_emp);	
end;
			
procedure exportar (var archivo: archivo_empleados; var todos_emp: Text);
var
	e: empleado;
begin
	reset (archivo);
	rewrite (todos_emp);
	while not eof (archivo) do begin
		read (archivo,e);
		with e do writeln (todos_emp,'|NRO: ',num:10,'|EDAD: ',edad:10,'|DNI: ',dni:10,'|APELLIDO: ',apellido:10,'|NOMBRE: ',nombre:10); 
	end;
	close (todos_emp)
end;		

procedure exportarSinDNI (var archivo: archivo_empleados; var sin_dni: Text);
var
	e: empleado;
begin
	reset(archivo);
	rewrite(sin_dni);
	while not eof(archivo) do begin
		read(archivo,e);
		if (e.dni = 00) then
			with e do
			writeln(sin_dni, '|NRO: ',num:10,'|EDAD: ',edad:10,'|DNI: ',dni:10,'|APELLIDO: ',apellido:10,'|NOMBRE: ',nombre:10);
	end;
	writeln('Exportado con exito');
	close(sin_dni);
end;

procedure abrir (var archivo: archivo_empleados; var todos_emp, sin_dni: Text);
var
	opcion: char;
begin
	reset(archivo);
	writeln('| A continuacion, elija una opcion a ejecutar |');
	writeln('a) Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
	writeln('b) Listar en pantalla los empleados de a uno por linea');
	writeln('c) Listar en pantalla los empleados mayores de 70 anios, proximos a jubilarse');
	writeln('d) Aniadir uno o mas empleados unicos al final del archivo');
	writeln('e) Modificar la edad de un empleado');
	writeln('f) Exportar a txt');
	writeln('g) Exportar empleados sin DNI');
	readln(opcion);
	case opcion of
		'a': nombreOApellido(archivo);
		'b': listarEmpleados(archivo);
		'c': mayores(archivo);
		'd': addEmpleado(archivo);
		'e': modificarEdad(archivo);
		'f': exportar(archivo, todos_emp);
		'g': exportarSinDNI(archivo, sin_dni);
		else writeln ('No se encuentra esa opcion');
	end;
end;

procedure crear (var archivo: archivo_empleados; var nombre_archivo: string; var todos_emp, sin_dni: Text);
begin
	rewrite(archivo);
	cargarEmpleados(archivo);
	clrscr;
	abrir(archivo, todos_emp, sin_dni);
end;

var
	opcion: char;
	archivo: archivo_empleados;
	todos_emp, sin_dni: Text;
	nombre_archivo: string[30];
begin
	textcolor(green);	
	writeln('| Bienvenido |');
	writeln('Ingrese el nombre del archivo');
	readln(nombre_archivo);
	Assign(archivo, nombre_archivo);
	Assign(todos_emp, 'todos_empleados.txt');
	Assign(sin_dni, 'faltaDNIEmpleado.txt');
	clrscr;
	writeln('| A continuacion, elija una opcion a ejecutar |');
	writeln('a) Crear archivo');
	writeln('b) Abrir archivo');
	readln(opcion);
	clrscr;
	if opcion = 'a' then
		crear(archivo, nombre_archivo, todos_emp, sin_dni)
	    else if opcion = 'b' then begin
			clrscr;
			abrir(archivo, todos_emp, sin_dni)
		end else writeln ('No se encuentra esa opcion');
	close(archivo);
end.





