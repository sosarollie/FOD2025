{Dada la siguiente estructura:
type
reg_flor = record
nombre: String[45];
codigo: integer;
end;
tArchFlores = file of reg_flor;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente
procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.}
program tp3ej4;
type
	flor = record
		nombre: string[45];
		codigo: integer;
	end;

 archivo_flores = file of flor;
 
 procedure leerFlor(var f: flor);
 begin
	with f do begin
		writeln('Ingrese nombre de flor');
		read(nombre);
		writeln('Ingrese codigo de flor');
		read(codigo);
	end;
 end;

procedure inicializarArchivo(var a: archivo_flores);
var
 indice: flor;
begin
 rewrite(a);
 indice.codigo := 0;
 write(a, indice);
end;

procedure agregarFlor(var a: archivo_flores; f: flor);
var
 indice: flor;
begin
 reset(a);
 read(a, indice);
 if (indice.codigo < 0) then begin
	seek(a, abs(indice.codigo));
	read(a, indice); //guardo el proximo indice a reutilizar
	seek(a, filepos(a) - 1); //vuelvo al lugar libre
	write(a, f); //guardo el dato que pasa por parametro
	seek(a, 0); //vuelvo al espacio de indice
	write(a, indice); //guardo el nuevo indice;
 end else begin
	seek (a, filesize(a));
	write(a, f);
 end;
end;

procedure cargarArchivo (var a: archivo_flores);
var
 f: flor;
begin
 inicializarArchivo(a);
 leerFlor(f);
 while (f.nombre <> 'ZZZ') do begin
	agregarFlor(a, f);
	leerFlor(f);
 end;
end;

procedure eliminarFlor(var a: archivo_flores; f: flor);
var
 indice,n: flor;
begin
 reset(a);
 read(a, indice);
 while(not eof(a) and (indice.codigo <> f.codigo)) do begin
	read(a, n);
	 if (n.codigo = f.codigo) then begin
		n.codigo := indice.codigo; //reemplazo el indice de la posicion eliminada por el que tenia en la cabecera
		indice.codigo:= n.codigo * -1; //elimino el valor de la posicion y lo agrego como ultimo de la cabecera
		seek(a, filepos(a) - 1); 
		write(a, n); // elimino
		seek(a, 0);
		write(a, indice); // actualizo cabecera
	 end; 
 end;
end;

procedure listarTodas (var a: archivo_flores);
var
 f: flor;
begin
 reset(a);
 read(a, f);
 while (not eof(a)) do begin
	if (f.codigo > 0) then begin
		writeln(f.nombre);
		writeln(f.codigo);
	end;
	read(a, f);
 end;
end;

var
 a: archivo_flores;
 f: flor;
begin
 Assign(a, 'archivoFlores');
 cargarArchivo(a);
 leerFlor(f);
 eliminarFlor(a, f);
 listarTodas(a);
end.
 
