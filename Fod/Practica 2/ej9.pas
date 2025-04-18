program tp2ej9;
const
 valorAlto = 9999;
type
	cliente = record
		cod: integer;
		nombre: string;
		apellido: string;
		anio : integer;
		mes : 1..12;
		dia : 1..31;
		monto : real;
	end;
	
	maestro = file of cliente;
	
procedure datosCliente (c: cliente);
begin
 with c do
	writeln(cod, ' ', nombre, ' ', apellido, ' ');
end;
	
procedure leerCliente (var archivo: maestro; var c: cliente);
begin
 if not eof(archivo) then
	read(archivo, c)
 else
	c.cod:= valorAlto;
end;

procedure recorrido (var mae: maestro);
var
 totalMes, totalAnio, totalEmpresa: real;
 codActual, anioActual, mesActual: integer;
 regm: cliente;
begin
 reset(mae);
 leerCliente(mae, regm);
 totalEmpresa:= 0;
 while (regm.cod <> valorAlto) do begin
	codActual:= regm.cod;
	datosCliente(regm);
	codActual:= regm.cod;
	while (codActual = regm.cod) do begin
		anioActual:= regm.anio;
		totalAnio:= 0;
		while (codActual = regm.cod ) and (anioActual = regm.anio) do begin
			mesActual:= regm.mes;
			totalMes:= 0;
			while (codActual = regm.cod) and (anioActual = regm.anio) and (mesActual = regm.mes) do begin
				totalMes:= totalMes + regm.monto;
				leerCliente(mae, regm);
			end;
			writeln('El total del mes es de ', totalMes:1:1);
			totalAnio:= totalAnio + totalMes
		end;
		totalEmpresa:= totalEmpresa + totalAnio;
		writeln('El total del anio es de ', totalAnio:1:1);
	end;
 end;
 writeln('El total de la empresa es de ', totalEmpresa:1:1);
 close(mae);
end;

var
 mae: maestro;
begin
 Assign(mae, 'maestro');
 recorrido(mae);
end.
				
		
		
		
		
		
		
		
		
		
		
		
