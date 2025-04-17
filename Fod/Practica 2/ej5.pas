{Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}
program tp2ej5;
uses crt;
const
	valorAlto = 9999;
	n = 5;
type
	date = record
		dia: integer;
		mes: integer;
		anio: integer;
	end;

	servidor = record
		cod: integer;
		fecha: date;
		tiempo_total_de_sesiones_abiertas: integer;
	end;
	
	maquina = record
		cod: integer;
		fecha: date;
		tiempo_sesion: integer;
	end;
	
	master = file of servidor;
	detail = file of maquina;
	vMaquinas = array [1..n] of detail;
	vReg = array [1..n] of maquina;
	
	
procedure leer (var vm: detail; var dato: maquina);
begin
 if (not eof(vm)) then
	read(vm, dato)
 else
	dato.cod:= valorAlto;
end;

procedure minimo (var vm: vMaquinas; var regd: vReg; var min: maquina);
var
 i: integer;
 indiceMin: integer;
begin
 indiceMin:= 0;
 min.cod:= valorAlto;
 for i:= 1 to n do
	if (vm[i].cod <> valorAlto) then
			if (registro[i].cod < min.cod) or ((registro[i].cod = min.cod) and (registro[i].fecha.dia < min.fecha.dia) and (registro[i].fecha.mes <=  min.fecha.mes) and (registro[i].fecha.anio <=  min.fecha.anio)) then begin
				indiceMin:= i;
				min:= vm[i];
			end;
 if (indiceMin <> 0) then
	read(vm[indiceMin], regd[indiceMin]);
end;

procedure actualizar (var mae1: master; var vm: vMaquinas; var regd: vReg);
var
 min: maquina;
 i,codActual,total: integer;
 regm: servidor;
begin
 reset(mae1);
 reset(vm);
 for i:= 1 to n do
	leer(vm[i], regd[i]);
 minimo(vm, regd, min);
 while (min.cod <> valorAlto) do begin
	total:= 0;
	codActual:= min.cod
	if (min.cod = codActual) do begin
		total:= total + min.tiempo_sesion;
		minimo(vm, regd, min);
	end;
	read(mae1, regm);
	while (regm.cod <> min.cod) do
		read(mae1, regm);
	regm.tiempo_total_de_sesiones_abiertas:= tiempo_total_de_sesiones_abiertas + total;
	seek(mae1, filepos(mae1) -1);
	write(mae1, regm);
 end;
 for i:= 1 to n do
	close(vm[i]);
 close(mae1);
end;

var
 vm: vMaquinas;
 regd: vReg;
 mae1: master;
 i: integer;
 num: string;
begin
 Assign(mae1, 'maestro');
 for i:= 1 to n do begin
	Str(i, num);
	Assign(vm[i], 'detalle' + num);
 end;
 actualizar(mae1, vm, regd);
end.
		
		
	
	
	
	
	
	
	
