program parcial40723;
type

	partido = record
		codE: integer;
		nombre: string;
		anio: integer;
		codT: integer;
		codR: integer;
		golE: integer;
		golR: integer;
		puntos: integer;
	end;

archivo_partidos = file of partido;

procedure leerPartido(var p: partido); //se dispone
procedure cargarArchivo(var a: archivo_partidos); //se dispone

procedure informar(var a: archivo_partidos);
var
 anioActual, codTorneoActual, codEActual, cantTotalGolesE, cantTotalGolesR, cantGanados, cantPerdidos, cantEmpatados, cantPuntosTotal, maxPuntos: integer;
 p: partido;
 nomActual, nomGanador: string;
begin
 reset(a);
 read(a, p);
 while not eof(a) do begin
	anioActual:= p.anio;
	writeln('Anio ', anioActual);
	while (p.anio = anioActual) do begin
		codTorneoActual:= p.codT;
		maxPuntos:= -1;
		nomGanador:= '';
		writeln('cod torneo ', codTorneoActual);
		while (p.codT = codTorneoActual) and (p.anio = anioActual) do begin
			codEActual:= p.codE;
			nomActual:= p.nombre;
			cantTotalGolesE:= 0;
			cantTotalGolesR:= 0;
			cantGanados:= 0;
			cantPerdidos:= 0;
			cantEmpatados:= 0;
			cantPuntosTotal:= 0;
			nomActual:= p.nombre;
			while (p.codE = codEActual) and (p.codT = codTorneoActual) and (p.anio = anioActual) do begin
				cantTotalGolesE:= cantTotalGolesE + p.golE;
				cantTotalGolesR:= cantTotalGolesR + p.golR;
				if (p.golE > p.golR) then begin
					cantGanados:= cantGanados + 1;
					cantPuntosTotal:= cantPuntosTotal + 3;
				end else if (p.golE < p.golR) then
					cantPerdidos:= cantPerdidos + 1
				else if (p.golE = p.golR) then begin
					cantEmpatados:= cantEmpatados + 1;
					cantPuntosTotal:= cantPuntosTotal + 1;
				end;
				read(a, p);
			end;
			if (cantPuntosTotal > maxPuntos) then begin
				maxPuntos:= cantPuntosTotal;
				nomGanador:= nomActual;
			end;
			writeln('equipo cod ', codEActual, ' ', nomActual);
			writeln('cantidad total de goles a favor equipo ', codEActual, ': ', cantTotalGolesE);
			writeln('cantidad total de goles en contra equipo ', codEActual, ':  ', cantTotalGolesR);
			writeln('diferencia de gol: ', cantTotalGolesE - cantTotalGolesR);
			writeln('cantidad de partidos ganados equipo ', codEActual, ': ', cantGanados);
			writeln('cantidad de partidos perdidos equipo ', codEActual, ': ', cantPerdidos);
			writeln('cantidad de partidos empatados equipo ', codEActual, ': ', cantEmpatados);
			writeln('cantidad de puntos equipo ', codEActual, ': ', cantPuntosTotal);
		end;
		writeln(nomGanador, ' fue campeon del torneo ', codTorneoActual, ' del anio ', anioActual);
	end;
  end;
  close(a);
 end;
 
var
 archivo: archivo_partidos;
begin
 Assign(archivo, 'partidos');
 rewrite(archivo);
 cargarArchivo(archivo);
 informar(archivo);
end.					
					
					
					
