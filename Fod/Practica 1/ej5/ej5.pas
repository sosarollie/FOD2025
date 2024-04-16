{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares deben contener: código de celular, nombre,
descripción, marca, precio, stock mínimo y stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas. En la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.}
program ej5;
uses crt;

type
	celular = record
		cod: integer;
		precio: real;
		marca: string[30];
		stockDisp: integer;
		stockMin: integer;
		desc: string;
		nombre: string[30];
	end;

	archivo_celulares = file of celular;

procedure carga (var celulares: Text; var archivo: archivo_celulares);
var
	cel: celular;
begin
	reset(celulares);
	rewrite(archivo);
	while not eof (celulares) do begin
		with cel do begin
			readln(celulares, cod, precio, marca);
			readln(celulares, stockDisp, stockMin, desc);
			readln(celulares, nombre);
		end;
		write(archivo, cel);
	end;
	writeln('Archivo Cargado');
	close(celulares);
end;
	
procedure imprimirCelular (cel: celular);
begin
	with cel do begin
		writeln('CODIGO: ', cod, ' PRECIO: ', precio:2:2, ' MARCA: ', marca);
		writeln('STOCK DISPONIBLE: ', stockDisp, ' STOCK MINIMO: ', stockMin, ' DESCRIPCION: ', desc);
		writeln('NOMBRE: ', nombre);
	end;
end;

procedure celularesStockMenor (var archivo: archivo_celulares);
var
	cel: celular;
begin
	clrscr;
	reset(archivo);
	writeln('Lista de celulares con stock menor al minimo:');
	while not eof(archivo) do begin
		read(archivo, cel);
		if (cel.stockDisp < cel.stockMin) then
			imprimirCelular(cel);
	end;
end;
	
procedure cadenaChar (var archivo: archivo_celulares);
var
	cel: celular;
	cad: string;
begin
	clrscr;
	reset(archivo);
	writeln('Ingrese cadena de caracteres a buscar ');
	readln(cad);
	while not eof(archivo) do begin
		read(archivo, cel);
		if (cel.desc = cad) then // como leer si contiene y no si es igual?
			imprimirCelular(cel);
	end;
end;

procedure exportar (var archivo: archivo_celulares; var celulares: Text);
var
	cel: celular;
begin
	reset(archivo);
	rewrite(celulares);
	while not eof (archivo) do begin
		read(archivo,cel);
		with cel do begin
			writeln(celulares,'CODIGO: ', cod, ' PRECIO: ', precio:2:2, ' MARCA: ', marca);
			writeln(celulares,'STOCK DISPONIBLE: ', stockDisp, ' STOCK MINIMO: ', stockMin, ' DESCRIPCION: ', desc);
			writeln(celulares,'NOMBRE: ', nombre);
		end;
	end;
	close(celulares);
end;
	
procedure leer (var c:celular);
begin
	with c do begin
		write ('INGRESE CODIGO DEL CELULAR: '); readln (cod);
		if (cod <> -1) then begin
			write ('INGRESE PRECIO DEL CELULAR: '); readln (precio);
			write ('INGRESE MARCA DEL CELULAR: '); readln (marca);
			write ('INGRESE STOCK DISPONIBLE: '); readln (stockDisp);
			write ('INGRESE STOCK MINIMO: '); readln (stockMin);
			write ('INGRESE DESCRIPCION: '); readln (desc);
			write ('INGRESE NOMBRE DEL CELULAR: '); readln (nombre);
		end;
		writeln ('');
	end;
end;

procedure aniadirCelular (var archivo: archivo_celulares);
var
	nuevo: celular;
begin
	reset(archivo);
	seek(archivo, fileSize(archivo));
	leer(nuevo);
	while (nuevo.cod <> -1) do begin
		write(archivo, nuevo);
		leer(nuevo);
	end;
end;
		
procedure modificar (var archivo: archivo_celulares);
var
	stockNuevo: integer;
	nombre: string;
	encontre: boolean;
	cel: celular;
begin
	encontre:= false;
	writeln('Ingrese el nombre de celular a modificar');
	readln(nombre);
	writeln('Ingrese el nuevo stock');
	readln(stockNuevo);
	reset(archivo);
	while (not eof(archivo) and (encontre = false)) do begin
		read(archivo, cel);
		if (cel.nombre = nombre) then begin
			encontre:= true;
			cel.stockDisp:= stockNuevo;
		end;
	if (encontre = true) then begin
		seek(archivo, filePos(archivo)-1);
		write(archivo, cel);
		writeln('Stock actualizado');
	end else
		writeln('No se encontro el celular');
	end;
end;
	
procedure exportarSinStock (var archivo: archivo_celulares; var sinStock: Text);	
var
	cel: celular;
begin
	reset(archivo);
	rewrite(sinStock);
	while not eof(archivo) do begin
		read(archivo, cel);
		if (cel.stockDisp = 0) then
			with cel do begin
				writeln(sinStock,'CODIGO: ', cod, ' PRECIO: ', precio:2:2, ' MARCA: ', marca);
				writeln(sinStock,'STOCK DISPONIBLE: ', stockDisp, ' STOCK MINIMO: ', stockMin, ' DESCRIPCION: ', desc);
				writeln(sinStock,'NOMBRE: ', nombre);
			end;
		end;
	close(sinStock);
	end;
	
procedure opciones (var archivo: archivo_celulares; var celulares, sinStock: Text);
var
	opcion: string;
begin
	clrscr;
	writeln('Seleccione la accion a realizar');
	writeln('');
	writeln('a) Crear archivo');
	writeln('b) Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock minimo.');
	writeln('c) Ingresar cadena de caracteres y buscar descripcion de celulares');
	writeln('d) Exportar a .txt');
	writeln('e) Aniadir uno o más celulares al final del archivo con sus datos ingresados por teclado');
	writeln('f) Modificar el stock de un celular dado');
	writeln('g) Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0');
	readln(opcion);
	case opcion of
		'a': carga(celulares,archivo);
		'b': celularesStockMenor(archivo);
		'c': cadenaChar(archivo);
		'd': exportar(archivo, celulares);
		'e': aniadirCelular(archivo);
		'f': modificar(archivo);
		'g': exportarSinStock(archivo, sinStock);
		else writeln('No se encuentra esa opcion');
	end;
end;

var
	archivo: archivo_celulares;
	celulares, sinStock: Text;
	nombre: string;
begin
	textcolor(red);
	writeln('Ingrese el nombre del archivo');
	readln(nombre);
	clrscr;
	Assign(archivo, nombre);
	Assign(sinStock, 'sinStock.txt');
	Assign(celulares, 'celulares.txt');
	opciones(archivo, celulares, sinStock);
	close(archivo);
end.

