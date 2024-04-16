{
2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
y se decrementa en uno la cantidad de materias sin final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los
campos de cada alumno en una sola línea del archivo de texto.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez
   
}
program ej2;
const
	valorAlto = 9999;
type

	alumno = record
		cod: integer;
		apellido: string[20];
		nombre: string[20];
		cantSinFinal: integer;
		cantConFinal: integer;
	end;
	
	materia = record
		cod: integer;
	    estadoMateria: char;
	end;
	
	maestro = file of alumno;
	detalle = file of materia;

procedure leer (var archivo: detalle; var dato: materia);
begin
	if not eof (archivo) then 
		read(archivo, dato)
	else
		dato.cod:= valorAlto;
end;

procedure leerAlumno (var a: alumno);
begin
	with a do begin
		writeln('Ingrese cod del alumno');
		readln(cod);
		if (cod <> -1) then begin
			writeln('Ingrese apellido del alumno');
			readln(apellido);
			writeln('Ingrese nombre del alumno');
			readln(nombre);
			writeln('Ingrese cantidad de materias sin final del alumno');
			readln(cantSinFinal);
			writeln('Ingrese cantidad de materias con final del alumno');
			readln(cantConFinal);			
		end;
	end;
end;

procedure leerMateria(var m: materia);
begin
	with m do begin
		writeln('Ingrese codigo del alumno');
		readln(cod);
		if (cod <> -1) then begin
			writeln('Ingrese estado de la materia (F = final aprobado, C = cursada aprobada)');
			readln(estadoMateria);
		end;
	end;
end;
			
procedure cargarAlumnos (var maes: maestro);
var
	a: alumno;
begin
	rewrite(maes);
	leerAlumno(a);
	while (a.cod <> -1) do begin
		write(maes,a);
		leerAlumno(a);
	end;
end;

procedure cargarMaterias (var det: detalle);
var
	m: materia;
begin
	rewrite(det);
	leerMateria(m);
	while (m.cod <> -1) do begin
		write(det, m);
		leerMateria(m);
	end;
end;

procedure actualizar (var maes: maestro; var det: detalle);
var
	m: materia;
	a: alumno;
	codActual: integer;
	cantC: integer;
	cantF: integer;
begin
	reset(maes);
	reset(det);
	leer(det, m);
	while (m.cod <> valorAlto) do begin
		cantC:= 0;
		cantF:= 0;
		codActual:= m.cod;
		while (m.cod = codActual) do begin
			if (m.estadoMateria = 'c') then
				cantC:= cantC + 1
			else begin
				cantF:= cantF + 1;
				cantC:= cantC - 1;
			end;
			leer(det, m);
		end;
		read(maes, a);
		while (a.cod <> codActual) do
			read(maes, a);
		a.cantSinFinal:= cantC;
		a.cantConFinal:= cantF;
		seek(maes, filePos(maes) - 1);
		write(maes, a);
	end;
end;

procedure exportar (var maes: maestro; var alumnosTxt: Text);
var
	a:alumno;
begin
	reset(maes);
	rewrite(alumnosTxt);
	while not eof(maes) do begin
		read(maes, a);
		if (a.cantConFinal > a.cantSinFinal) then
			with a do
				writeln(alumnosTxt,cod,' ',apellido,' ',nombre,' ',cantSinFinal,' ',cantConFinal);
	end;
end;
		
var
	maes: maestro;
	det: detalle;
	alumnosTxt: Text;
BEGIN
	Assign(maes, 'archivo_maestro');
	Assign(det, 'archivo_detalle');
	Assign(alumnosTxt, 'alumnos.txt');	
	cargarAlumnos(maes);
	cargarMaterias(det);
	actualizar(maes,det);
	exportar(maes,alumnosTxt);
	close(maes);
	close(det);
END.

