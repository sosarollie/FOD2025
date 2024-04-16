{
El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
   
}


program ej3;
const

	valorAlto = 9999;

type

	producto = record
		cod: integer;
		nombre: string[20];
		precio: real;
		stockA: integer;
		stockM: integer;
	end;
	
	venta = record
		cod: integer;
		cant: integer;
	end;
	
	maestro = file of producto;
	detalle = file of venta;

procedure leer (var archivo: detalle; var dato: venta);
begin
	if not eof(archivo) then
		read(archivo, dato)
	else
		dato.cod:= valorAlto;
end;

procedure leerVenta (var v: venta);
begin
	with v do begin
		writeln('Ingrese cod del producto (venta)');
		readln(cod);
		if (cod <> -1) then begin
			writeln('Ingrese cantidad vendida');
			readln(cant);	
		end;
	end;
end;

procedure leerProducto (var p: producto);
begin
	with p do begin
		writeln('Ingrese cod del producto');
		readln(cod);
		if (cod <> -1) then begin
			writeln('Ingrese nombre del producto');
			readln(nombre);
			writeln('Ingrese precio del producto');
			readln(precio);
			writeln('Ingrese stock actual del producto');
			readln(stockA);
			writeln('Ingrese stock minimo del producto');
			readln(stockM);			
		end;
	end;
end;

procedure cargarProductos (var maes: maestro);
var
	p: producto;
begin
	rewrite(maes);
	leerProducto(p);
	while (p.cod <> -1) do begin
		write(maes, p);
		leerProducto(p);
	end;
end;

procedure cargarVentas (var det: detalle);
var
	v: venta;
begin
	rewrite(det);
	leerVenta(v);
	while (v.cod <> -1) do begin
		write(det, v);
		leerVenta(v);
	end;
end;

procedure actualizar (var maes: maestro; var det: detalle);
var
	p: producto;
	v: venta;
	codActual: integer;
	cantTotal: integer;
begin
	reset(maes);
	reset(det);
	leer(det,v);
	while not eof (det) do begin
		cantTotal:= 0;
		codActual:= v.cod;
		while (v.cod = codActual) do begin
			cantTotal:= cantTotal + v.cant;
			leer(det, v);
		end;
		read(maes, p);
		while (p.cod <> codActual) do
			read(maes, p);
		p.stockA:= p.stockA - cantTotal;
		write(maes,p);
	end;
end;

procedure exportar (var maes: maestro; var stockTxt: text);
var
	p: producto;
begin
	reset(maes);
	while not eof(maes) do begin
		read(maes, p);
		if (p.stockA < p.stockM) then
			with p do
				writeln(stockTxt,cod,' ',nombre,' ',precio,' ',stockM,' ',stockA,' ');
	end;
end;

var
	maes: maestro;
	det: detalle;
	stockTxt: Text;
BEGIN
	Assign(maes, 'archivo_maestro');
	Assign(det, 'archivo_detalle');
	Assign(stockTxt, 'stock_minimo.txt');
	cargarProductos(maes);
	cargarVentas(det);
	actualizar(maes, det);
	exportar(maes, stockTxt);
	close(maes);
	close(det);
END.

