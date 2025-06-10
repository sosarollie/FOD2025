program tp3ej1;
uses crt;
type
	empleado = record
		num: integer;
		ape: string[20];
		nom: string[20];
		edad: integer;
		dni: integer;
	end;

archivo_empleados = file of empleado;

procedure leerEmpleado (var e: empleado);
begin
	with e do begin
		writeln('Ingrese el numero de empleado');
		readln(num);
		writeln('Ingrese el apellido');
		readln(ape);
		if (ape <> 'fin') then begin
			writeln('Ingrese el nombre');
			readln(nom);
			writeln('Ingrese la edad ');
			readln(edad);
			writeln('Ingrese el DNI ');
			readln(dni);
		end;
	end;
end;

procedure imprimirEmpleado (e: empleado);
begin
	with e do begin
		writeln('Numero: ',num);
		writeln('Nombre: ',nom);
		writeln('Apellido: ',ape);
		writeln('Edad: ',edad);
		writeln('Dni: ',dni);
	end;
end;

procedure cargarArchivo (var a: archivo_empleados);
var
 e: empleado;
begin
 leerEmpleado(e);
 while (e.ape <> 'fin') do begin
	write(a, e);
	leerEmpleado(e);
 end;
end;

procedure listarNomAp(var a: archivo_empleados);
var
 nom: string;
 dato: empleado;
begin
	writeln('Ingrese el nombre o apellido a buscar');
	read(nom);
	while not eof(a) do begin
		read(a, dato);
		if ((nom = dato.nom) or (nom = dato.ape)) then
			imprimirEmpleado(dato);
	end;
end;

procedure listarTodos (var a: archivo_empleados);
var
 dato: empleado;
begin
	while not eof(a) do begin
		read(a, dato);
		imprimirEmpleado(dato);
		writeln(' ');
	end;
end;

procedure listarJubilacion (var a: archivo_empleados);
var
 dato: empleado;
begin
	while not eof(a) do begin
		read(a, dato);
		if (dato.edad > 70) then begin	
			imprimirEmpleado(dato);
			writeln(' ');
		end;
	end;
end;

procedure agregarAlFinal (var a: archivo_empleados);
var
 e, empCargado: empleado;
 repetido: boolean;
begin
 reset(a);
 leerEmpleado(e);
 while (e.ape <> 'fin') do begin
	repetido:= false;
	while (not eof(a)) and (repetido = false) do begin
		read(a, empCargado);
		if (empCargado.dni = e.dni) then
			repetido:= true;
			seek(a, fileSize(a));
			write(a, e);
		leerEmpleado(e);
	end;
 end;
end;

procedure modifEdad (var a: archivo_empleados);
var
 e: empleado;
 nNum, nEdad: integer;
 encontre: boolean;
begin
 writeln('Ingrese el numero del empleado a modificar');
 read(nNum);
 writeln('Ingrese la edad correcta');
 read(nEdad);
 encontre:= false;
 while (not eof(a)) and (encontre = false) do begin
	read(a, e);
	if (e.num = nNum) then begin
		encontre:= true;
		e.edad:= nEdad;
		write(a, e);
	end;
	leerEmpleado(e);
 end;
end;

procedure exportarTxt (var a: archivo_empleados); //consultar
var
 empTxt: Text;
 e: empleado;
begin
 reset(a);
 Assign(empTxt, 'todos_empleados.txt');
 rewrite(empTxt);
 while not eof (a) do begin
	read(a, e);
	with e do writeln(empTxt, '|NRO: ',num:10,'|EDAD: ',edad:10,'|DNI: ',dni:10,'|APELLIDO: ',ape:10,'|NOMBRE: ',nom:10);
 end;
 writeln('Exportado con exito');
 close(empTxt);
end;

procedure exportarSinDni (var a: archivo_empleados);
var
 e: empleado;
 empSinDni: Text;
begin
 reset(a);
 Assign(empSinDni, 'faltaDNIEmpleado.txt');
 rewrite(empSinDni);
 while not eof(a) do begin
	read(a, e);
	if (e.dni = 00) then
		with e do writeln(empSinDni, '|NRO: ',num:10,'|EDAD: ',edad:10,'|DNI: ',dni:10,'|APELLIDO: ',ape:10,'|NOMBRE: ',nom:10);
 end;
 writeln('Exportado con exito');
 close(empSinDni);
end;

procedure baja (var a: archivo_empleados);
var
 e: empleado;
 num: integer;
begin
 reset(a);
 writeln('Ingrese el numero de empleado a eliminar');
 read(num);
 read(a, e);
 // se avanza hasta el numero de empleado a eliminar
 while (e.num <> num) do 
	read(a, e);
 // se avanza al siguiente del empleado
 read(a, e);
 // se copian los registros restantes
 while (not eof(a)) do begin
	seek(a, filepos(a) - 2);
	write(a, e);
	seek(a, filepos(a) + 1);
	read(a, e);
 end;
 truncate(a);
end;

procedure opciones (var a: archivo_empleados);
var
 opcion: char;
begin
 writeln('Ingrese una opcion');
 writeln(' ');
 writeln('a) Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado, el cual se proporciona desde el teclado.');
 writeln('b) Listar en pantalla los empleados de a uno por línea.');
 writeln('c) Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.');
 writeln('d) Añadir uno o más empleados al final del archivo con sus datos ingresados por teclado.');
 writeln('e) Modificar la edad de un empleado dado.');
 writeln('f) Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.');
 writeln('g) Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).');
 writeln('h) Eliminar un empleado con su numero');
 read(opcion);
 case opcion of
	'a': listarNomAp(a);
	'b': listarTodos(a);
	'c': listarJubilacion(a);
	'e': modifEdad(a);
	'f': exportarTxt(a);
	'g': exportarSinDni(a);
	'h': baja(a);
	else writeln('No existe esa operacion, ingrese una valida');
 end;
end;

procedure crear (var a: archivo_empleados);
begin
 rewrite(a);
 cargarArchivo(a);
 clrscr;
 opciones(a);
end;

var
 a: archivo_empleados;
 opcion: char;
 nom: string;
begin
 textcolor(blue);	
 writeln('| Bienvenido |');
 writeln('Ingrese el nombre del archivo');
 readln(nom);
 Assign(a, nom);
 clrscr;
 writeln('| A continuacion, elija una opcion a ejecutar |');
 writeln('a) Crear archivo');
 writeln('b) Abrir archivo');
 readln(opcion);
 clrscr;
 case opcion of
	'a': crear(a);
	'b': opciones(a);
	else writeln('No se encuentra esa opcion');
 end;
 close(a);
end.
