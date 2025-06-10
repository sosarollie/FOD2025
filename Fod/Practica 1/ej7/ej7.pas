program tp1ej7;
type
 novela = record
	cod: integer;
	nombre: string;
	genero: string;
	precio: real;
 end;
 
archivo = file of novela;

procedure carga (var novelas: Text; var archivo: archivo);
var
	nov: novela;
begin
	reset(novelas);
	rewrite(archivo);
	while not eof (novelas) do begin
		with nov do begin
			readln(novelas, cod, precio, genero);
			readln(novelas, nombre);
		end;
		write(archivo, nov);
	end;
	writeln('Archivo Cargado');
	close(novelas);
end;

procedure leerNovela (var n: novela);
begin
	with n do begin
		read(cod);
		read(nombre);
		read(genero);
		read(precio);
	end;
end;

procedure agregarNovela (var archivo: archivo);
var
 n: novela;
begin
 reset(archivo);
 seek(archivo, filePos(archivo) -1);
 leerNovela(n);
 write(archivo, n);
end;

procedure modificarNovela (var archivo: archivo);
var
 n: novela;
 cod: integer;
begin
 writeln('ingrese el codigo de novela a modificar');
 read(cod);
 while not eof(archivo) do begin
	read(archivo, n);
	if (n.cod = cod) then begin
		seek(archivo, filePos(archivo) -1);
		leerNovela(n);
		write(archivo, n);
	end;
 end;
end;

procedure abrir (var archivo: archivo);
var
 opcion: char;
begin
 reset(archivo);
 writeln('Que quiere realizar?');
 writeln('a) agregar una novela');
 writeln('b) modificar una novela');
 read(opcion);
 case (opcion) of
	'a': agregarNovela(archivo);
	'b': modificarNovela(archivo);
 end;
end;
 
var
 a: archivo;
 nombre: string;
 opcion: char;
 novelasTxt: Text;
begin
 writeln('Ingrese el nombre de novela a operar');
 read(nombre);
 Assign(a, nombre);
 Assign(novelasTxt, 'novelas.txt');
 writeln('Seleccione una opcion');
 read(opcion);
 case (opcion) of
	'a': carga(novelasTxt, a);
	'b': abrir(a);
 end;
 close(a);
end.





