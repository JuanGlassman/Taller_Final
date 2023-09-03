program apuntes;
const 
	dimf = 100;
	valor_alto = 9999;
type
	tipo = integer;
	diml = 0..dimf;
	vector = array [1..dimf] of tipo;



	arbol = ^nodo_arbol;
	nodo_arbol = record
		dato: tipo;
		HI: arbol;
		HD: arbol;
	end;
	
	
	
	lista = ^nodo_lista;
	nodo_lista = record
		dato: tipo;
		sig: lista;
	end;

	vector_lista = array [1..dimf] of lista;
	
	
	
	acumulador = record
		nom: tipo;
		total: real;
	end;
	
	lista_a = ^nodo_lista_a;
	nodo_lista_a = record
		dato: acumulador;
		sig: lista_a;
	end;

	vector_lista_a = array [1..dimf] of lista_a;





//ORDENAR VECTOR

procedure ordenar_seleccion (var v: vector; diml: diml);
var
	i,j,p: diml;
	item: tipo;
begin
	for i:= 1 to diml-1 do begin
		p:= i;
		for j:= i+1 to diml do
			if (v[j] < v[p]) then
				p:= j;
		item:= v[p];
		v[p]:= v[j];
		v[j]:= item;
	end;
end;

procedure ordenar_insercion(var v: vector; diml: diml);
var
	i,j: diml;
	act: tipo;
begin
	for i:= 2 to diml do begin
		act:= v[i];
		j:= i-1;
		while (j>0) and (v[j] > act) do begin
			v[j+1] := v[j];
			j:= j-1;
		end;
		v[j+1]:= act;
	end;
end;
		
//BUSQUEDA DICOTOMICA RECURSIVA y ITERATIVO
procedure busquedaDicotomica (v: vector; ini,fin: integer; dato:integer; var pos: integer);
var
	medio: integer;
begin
	if (ini > fin) then
	 pos:=-1
	else begin
		medio := (ini + fin) div 2;
		if (v[medio] = dato) then
			pos := medio
		else
			if (dato < v[medio]) then
				busquedaDicotomica (v, ini, medio-1,dato,pos)
			else
				busquedaDicotomica (v, medio+1, fin, dato,pos);
	end;
end;


procedure busquedaDicotomicaIterativa (v: vector; x: integer; var pos: integer);
var
	pri,ult,medio : integer;
begin
	pri :=1;	
	ult:= dimF;
	medio := (pri + ult) div 2;
	while ( (pri < ult) and (v[medio] <> x) ) do begin
		if (x < v[medio]) then 
			ult := medio-1
		else
			pri := medio +1;
		medio := (pri + ult) div 2;
	end;
	if (pri <> ult) then
		pos:= medio
	else
		pos :=-1;
	
end;












//ARBOL AGREGAR Y BUSCAR

procedure arbol_agregar(var a: arbol; num: integer); //crear
begin
	if (a = nil) then begin
		new(a);
		a^.dato:= num;
		a^.HI:= nil;
		a^.HD:= nil;
	end
	else
		if (num < a^.dato) then
			arbol_agregar(a^.HI, num)
		else
			arbol_agregar(a^.HD, num)
end;

function arbol_buscar(var a: arbol; num: tipo): arbol;
begin
	if (a=nil) then
		arbol_buscar:= nil
	else
		if (num = a^.dato) then
			arbol_buscar:= a 
		else
			if (num < a^.dato) then
				arbol_buscar:= arbol_buscar(a^.HI, num)
			else
				arbol_buscar := arbol_buscar(a^.HD, num)
end;







//MARGE SORT Y ACUMULADOR



procedure agregar_atras(var l:lista; dato: tipo);
var
	act: lista;
begin
	new(act);
	act^.dato:= dato;
	act^.sig:= l;
	l:= act;
end;


procedure marge_minimo_den(var v: vector_lista; var min: tipo);
var
	pos,i:integer; 
begin
	min := valor_alto;
	pos := 0;
	for i:= 1 to dimf do
		if (v[i] <> nil) and (v[i]^.dato < min) then begin
			min:= v[i]^.dato;
			pos := i;
		end;
	if (pos <> 0) then
		v[pos]:= v[pos]^.sig;
end;

procedure marge_deN (var v: vector_lista; var l:lista);
var 
	min: tipo;
begin
	l:= nil;
	marge_minimo_den(v,min);
	while (min <> valor_alto) do begin
		agregar_atras(l,min);
		marge_minimo_den(v,min);
	end;
end;


procedure marge_minimo_dea(var v: vector_lista_a; var min: acumulador);
var
	pos,i:integer; 
begin
	min.nom := valor_alto;
	pos := -1;
	for i:= 1 to dimf do
		if (v[i] <> nil) and (v[i]^.dato.nom <= min.nom) then begin
			min:= v[i]^.dato;
			pos := i;
		end;
	if (pos <> 0) then
		v[pos]:= v[pos]^.sig;
end;

procedure marge_acumulador (var v: vector_lista_a; var l:lista_a);
var 
	min,actual: acumulador;
begin
	l:= nil;
	marge_minimo_dea(v,min);
	while (min.nom <> valor_alto) do begin
		actual.nom:= min.nom; 
		actual.total:= 0;
		while (min.nom <> valor_alto) and (min.nom = actual.nom) do begin
			actual.total:= actual.total + min.total;
			marge_minimo_dea(v,min);
		end;
		agregar_atras(l,min);
	end;
end;








//IMPRIMIR RECURSIVAMENTE

procedure imprimir_recursivo_hacia_adelante (var l: lista);
begin
	if (l <> nil) then begin //caso base
		write (l^.dato); //imprime del primero al ultimo
		imprimir_recursivo_hacia_adelante(l^.sig);
	end;
end;

procedure imprimir_recursivo_hacia_atras (var l: lista);
begin
	if (l = nil) then begin //caso base
		write (l^.dato); //imprime del primero al ultimo
		imprimir_recursivo_hacia_adelante(l^.sig);
	end;
end;

procedure imprimirPreorden(a:arbol);
begin
	writeln('Numero de socio: ',a^.dato.num);
	if (a^.HI <> nil) then
		imprimirPreorden(a^.HI);
	if (a^.HD <> nil) then
		imprimirPreorden(a^.HD);
end;


//-------------------------------------------------------BUSQUEDA DICOTOMICA RECURSIVA
procedure busquedaDicotomica (v: vector; ini,fin: integer; dato:integer; var pos: integer);
var
	medio: integer;
begin
	if (ini > fin) then
	 pos:=-1
	else begin
		medio := (ini + fin) div 2;
		if (v[medio] = dato) then
			pos := medio
		else
			if (dato < v[medio]) then
				busquedaDicotomica (v, ini, medio-1,dato,pos)
			else
				busquedaDicotomica (v, medio+1, fin, dato,pos);
	end;
end;


//-------------------------------------------------------BUSQUEDA DICOTOMICA ITERATIVO
procedure busquedaDicotomicaIterativa (v: vector; x: integer; var pos: integer);
var
	pri,ult,medio : integer;
begin
	pri :=1;	
	ult:= dimF;
	medio := (pri + ult) div 2;
	while ( (pri < ult) and (v[medio] <> x) ) do begin
		if (x < v[medio]) then 
			ult := medio-1
		else
			pri := medio +1;
		medio := (pri + ult) div 2;
	end;
	if (pri <> ult) then
		pos:= medio
	else
		pos :=-1;
	
end;
