%% P25/11 - Figuras desde archivos RAW REALES de LTspice 26
% MATLAB R2025a. Sin Simulink ni toolboxes externos.
% Lee el RAW binario UTF-16LE sin compresion, producido al ejecutar los ASC.
% NO vuelve a simular el circuito; NO infiere fuerza magnetica del P25.
% Circuitos y modelos MOSFET/diodo PRELIMINARES, no certificados.
% Datos nominales: Vb=12V, Rb=80 ohm; L es exploratoria, no medida.
clear; clc; close all;
base = fileparts(mfilename('fullpath'));
dest = fullfile(base,'Resultados_MATLAB');
if ~exist(dest,'dir'), mkdir(dest); end
nombres = {'01_P25_Pulsos', '02_P25_Barrido_inductancia', ...
           '03_P25_PWM_25_50_75', '04_P25_Zener_9V_OPCIONAL'};
tags = {'SIM-01 pulsos','SIM-02 barrido L','SIM-03 PWM','SIM-04 Zener exploratorio'};
res = cell(1,4);
for j=1:4
    rutas={fullfile(base,'Circuitos',[nombres{j} '.raw']), ...
           fullfile(base,'Datos_LTspice',[nombres{j} '.raw']), ...
           fullfile(base,[nombres{j} '.raw'])};
    hit=find(cellfun(@isfile,rutas),1);
    if isempty(hit)
        fprintf('PENDIENTE %s: abre y ejecuta su .asc en LTspice.\n',tags{j});
        continue
    end
    fprintf('Leyendo %s ...\n',rutas{hit});
    try
        res{j}=leerRawLTspice(rutas{hit});
        fprintf('  %d paso(s) y %d variables.\n',numel(res{j}.pasos),numel(res{j}.names));
    catch err
        warning('No se pudo leer %s: %s',nombres{j},err.message);
    end
end
if all(cellfun(@isempty,res))
    error(['No hay archivos RAW procesables. Ejecuta los .asc en LTspice ' ...
           '(boton Run); guarda los .raw en la carpeta Circuitos junto a los .asc.']);
end
Rbob=80; filas={};

%% F01: pulso ON/OFF
if ~isempty(res{1})
    assert(numel(res{1}.pasos)==1,'SIM01: se esperaba un solo paso');
    s=res{1}.pasos{1}; t=s.t;
    gate=canal(s,'V(GATE)'); drain=canal(s,'V(DRAIN)'); ib=canal(s,'I(L_BOB)');
    inds=muestreo(t,gate,4500);
    f=figure('Color','w','Position',[100 70 960 700]);
    tiledlayout(3,1,'TileSpacing','compact','Padding','compact');
    nexttile; plot(t(inds)*1e3,gate(inds),'LineWidth',1.1);grid on;
    ylabel('V_{GS} [V]');title('SIM-01. Conmutacion P25/11 - resultados de LTspice');
    nexttile; plot(t(inds)*1e3,ib(inds)*1e3,'LineWidth',1.1);grid on;
    ylabel('I_{bobina} [mA]');
    nexttile; plot(t(inds)*1e3,drain(inds),'LineWidth',1.1);grid on;
    ylabel('V_{Drain} [V]');xlabel('Tiempo [ms]');
    guardar(f,dest,'F01_P25_Pulsos');
    on=t>=0.012 & t<=0.016;
    filas(end+1,:)={'SIM01','UNICO',mean(gate(on)),mean(drain(on)), ...
        mean(ib(on)),sqrt(mean(ib(on).^2)),Rbob*mean(ib(on).^2), ...
        max(drain(t>=.017 & t<=.027)),tiempoI10(s,.017)};
end

%% F02: sensibilidad a inductancia hipotetica (5,20,100 mH)
if ~isempty(res{2})
    ww=res{2}.pasos;
    LmH=[5 20 100];
    if numel(ww)~=numel(LmH)
        warning('SIM02: %d pasos; se esperaban tres. Etiquetas se asignan por orden.',numel(ww));
        LmH=1:numel(ww);
    end
    f=figure('Color','w','Position',[100 70 940 590]);
    tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
    a1=nexttile;hold(a1,'on');grid(a1,'on');
    a2=nexttile;hold(a2,'on');grid(a2,'on');
    for j=1:numel(ww)
        s=ww{j};t=s.t;g=canal(s,'V(GATE)');i=canal(s,'I(L_BOB)');v=canal(s,'V(DRAIN)');
        sel=t>=.0168 & t<=.021;
        ids=find(sel);ids=ids(muestreo(t(ids),g(ids),2200));
        plot(a1,(t(ids)-.017)*1e3,i(ids)*1e3,'LineWidth',1.15);
        plot(a2,(t(ids)-.017)*1e3,v(ids),'LineWidth',1.15);
        on=t>=.012 & t<=.016;
        filas(end+1,:)={'SIM02',sprintf('L=%.0f mH [HIP]',LmH(j)), ...
            mean(g(on)),mean(v(on)),mean(i(on)),sqrt(mean(i(on).^2)), ...
            Rbob*mean(i(on).^2),max(v(t>=.017 & t<=.027)),tiempoI10(s,.017)};
    end
    title(a1,'SIM-02. Efecto de inductancia hipotetica en el apagado');
    ylabel(a1,'I_{bobina} [mA]');
    ylabel(a2,'V_{Drain} [V]');xlabel(a2,'Tiempo relativo a 17 ms [ms]');
    ley=arrayfun(@(x)sprintf('L = %.0f mH [hip.]',x),LmH,'UniformOutput',false);
    legend(a1,ley,'Location','best');legend(a2,ley,'Location','best');
    guardar(f,dest,'F02_P25_Barrido_Inductancia');
end

%% F03: PWM 500 Hz con duty 25/50/75 % (20 ciclos utiles)
if ~isempty(res{3})
    ww=res{3}.pasos; duty=[25 50 75];
    if numel(ww)~=3
        warning('SIM03: esperado 3 pasos, obtenidos %d.',numel(ww));
        duty=1:numel(ww);
    end
    IM=zeros(numel(ww),1); IR=zeros(numel(ww),1); P=zeros(numel(ww),1);
    f=figure('Color','w','Position',[100 70 940 580]);
    tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
    a1=nexttile;hold(a1,'on');grid(a1,'on');
    a2=nexttile;hold(a2,'on');grid(a2,'on');
    for j=1:numel(ww)
        s=ww{j}; t=s.t; gate=canal(s,'V(GATE)'); i=canal(s,'I(L_BOB)');v=canal(s,'V(DRAIN)');
        seleccion=t>=0.030 & t<=0.050; t2=t(seleccion); i2=i(seleccion);
        if numel(t2)<2, error('SIM03 paso %d no tiene suficientes datos para calculos.',j);end
        dur=t2(end)-t2(1);
        IM(j)=trapz(t2,i2)/dur;
        IR(j)=sqrt(trapz(t2,i2.^2)/dur);
        P(j)=Rbob*IR(j)^2;
        selplot=t>=0.030 & t<=0.036;
        ids=find(selplot);ids=ids(muestreo(t(ids),gate(ids),2400));
        plot(a1,(t(ids)-.030)*1e3,gate(ids),'LineWidth',1.0);
        plot(a2,(t(ids)-.030)*1e3,i(ids)*1e3,'LineWidth',1.05);
        filas(end+1,:)={'SIM03',sprintf('PWM %g %%',duty(j)),mean(gate(seleccion)), ...
            mean(v(seleccion)),IM(j),IR(j),P(j),max(v(seleccion)),NaN};
    end
    title(a1,'SIM-03. PWM de 500 Hz - respuesta electrica P25/11');
    ylabel(a1,'V_{GS} [V]');ylabel(a2,'I_{bobina} [mA]');
    xlabel(a2,'Tiempo relativo a 30 ms [ms]');
    ley=arrayfun(@(x)sprintf('Duty %.0f %%',x),duty,'UniformOutput',false);
    legend(a1,ley,'Location','best');legend(a2,ley,'Location','best');
    guardar(f,dest,'F03_P25_PWM_FormasOnda');
    f=figure('Color','w','Position',[100 70 850 430]);
    plot(duty,P,'s-','LineWidth',1.25,'MarkerSize',7);grid on;
    xlabel('Ciclo util [%]');ylabel('P_{bobina,media} [W]');
    title('SIM-03. Potencia resistiva estimada a partir de I_{RMS}');
    guardar(f,dest,'F03b_P25_PWM_Potencia');
end

%% F04: comparacion entre diodo normal y diodo+Zener; modelo NO VALIDADO
if ~isempty(res{1}) && ~isempty(res{4})
    a=res{1}.pasos{1};b=res{4}.pasos{1};
    f=figure('Color','w','Position',[100 70 940 570]);
    tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
    aa=nexttile;hold(aa,'on');grid(aa,'on');
    bb=nexttile;hold(bb,'on');grid(bb,'on');
    lista={a,b};lab={'Diodo','Diodo+Zener 9 V [hip.]'};
    for j=1:2
        s=lista{j};t=s.t;g=canal(s,'V(GATE)');i=canal(s,'I(L_BOB)');v=canal(s,'V(DRAIN)');
        select=t>=.0168 & t<=.021;
        id=find(select);id=id(muestreo(t(id),g(id),2700));
        plot(aa,(t(id)-.017)*1e3,i(id)*1e3,'LineWidth',1.15);
        plot(bb,(t(id)-.017)*1e3,v(id),'LineWidth',1.15);
        on=t>=.012&t<=.016;
        if j==2
            filas(end+1,:)={'SIM04','Diodo+Zener [HIP]',mean(g(on)),mean(v(on)), ...
                mean(i(on)),sqrt(mean(i(on).^2)),Rbob*mean(i(on).^2), ...
                max(v(t>=.017&t<=.027)),tiempoI10(s,.017)};
        end
    end
    title(aa,'SIM-04. Apagado con proteccion alternativa hipotetica');
    ylabel(aa,'I_{bobina} [mA]');ylabel(bb,'V_{Drain} [V]');
    xlabel(bb,'Tiempo relativo a 17 ms [ms]');
    legend(aa,lab,'Location','best');legend(bb,lab,'Location','best');
    guardar(f,dest,'F04_P25_Comparacion_Apagado');
end

%% Tablas de resultados y trazabilidad
if ~isempty(filas)
    tabla=cell2table(filas,'VariableNames',{'Simulacion','Escenario','VGS_ON_prom_V', ...
        'Vdrain_prom_V','I_bob_media_A','I_bob_RMS_A','P_bob_media_W', ...
        'Vdrain_pico_V','t_caida_10pct_ms'});
    writetable(tabla,fullfile(dest,'Tabla_Resultados_P25.csv'));
    disp(tabla);
end
fid=fopen(fullfile(dest,'LEER_ANTES_DE_USAR.txt'),'w');
if fid>0
 fprintf(fid,'P25/11: figuras procesadas desde los RAW de LTspice, NO resultados MATLAB de simulacion.\n');
 fprintf(fid,'R=80 ohm nominal; L=5/20/100 mH son HIPOTESIS de sensibilidad.\n');
 fprintf(fid,'MOSFET y diodo: modelos preliminares, NO de fabricante.\n');
 fprintf(fid,'Simulacion de Zener: EXPLORATORIA, no es la PCB fabricada.\n');
 fprintf(fid,'Tiempos calculados: corriente al 10%% del valor antes del apagado de 17 ms, NO tiempo de liberacion mecanica.\n');
 fprintf(fid,'No demuestra fuerza de retencion, frenado del dedo, temperatura de bobina ni seguridad vestible.\n');
 fprintf(fid,'No copie figuras a la tesis sin revisar la simulacion, su log y la interpretacion fisica.\n');
 fclose(fid);
end
fprintf('\nArchivos creados en %s\n',dest);

%% FUNCIONES AUXILIARES
function S=leerRawLTspice(path)
 fid=fopen(path,'r','ieee-le');
 assert(fid>0,'No se pudo abrir: %s',path);
 c=onCleanup(@()fclose(fid));
 bytes=fread(fid,Inf,'*uint8')';
 marca=uint8(unicode2native(sprintf('Binary:\n'),'UTF-16LE'));
 pos=strfind(bytes,marca);
 if numel(pos)~=1
     error('RAW no reconocido: falta Binary UTF-16LE. Archivo: %s',path);
 end
 cabecera=native2unicode(bytes(1:pos-1),'UTF-16LE');
 if ~contains(lower(cabecera),'nocompression')
     error('RAW comprimido. En ASC usa .options plotwinsize=0 y vuelve a simular.');
 end
 nv=regexp(cabecera,'No\. Variables:\s*(\d+)','tokens','once');
 np=regexp(cabecera,'No\. Points:\s*(\d+)','tokens','once');
 if isempty(nv) || isempty(np),error('Sin numero de variables o puntos.');end
 nvar=str2double(nv{1});npoints=str2double(np{1});
 vars=regexp(cabecera,'(?m)^\s*\d+\t([^\t\r\n]+)\t[^\r\n]+','tokens');
 nombres=cellfun(@(x)x{1},vars,'UniformOutput',false);
 if numel(nombres)~=nvar,error('No se identificaron todas las variables RAW.');end
 ini=pos+numel(marca); ancho=8+4*(nvar-1);
 assert(numel(bytes)-ini+1==ancho*npoints,'Tamano RAW inesperado (fastaccess/compresion u otro formato).');
 b=reshape(bytes(ini:end),ancho,npoints);
 [~,~,endi]=computer;
 assert(endi=='L','El lector requiere procesador little-endian.');
 tt=double(typecast(reshape(b(1:8,:),1,[]),'double'))';
 vals=double(reshape(typecast(reshape(b(9:end,:),1,[]),'single'),nvar-1,npoints))';
 datos=[tt vals];
 comienzos=[1;find(diff(tt)<-1e-12)+1];finales=[comienzos(2:end)-1;npoints];
 S.names=nombres;S.pasos=cell(numel(comienzos),1);
 for jj=1:numel(comienzos)
     inds=comienzos(jj):finales(jj);
     aux.names=nombres;aux.t=datos(inds,1);aux.Y=datos(inds,:);
     S.pasos{jj}=aux;
 end
end
function z=canal(S,nombre)
 k=find(strcmpi(S.names,nombre),1);
 if isempty(k),error('No existe canal %s. Disponibles: %s',nombre,strjoin(S.names,', '));end
 z=S.Y(:,k);
end
function indexes=muestreo(t,g,maxpoints)
 n=numel(t);if n==0,indexes=[];return;end
 indexes=unique([round(linspace(1,n,min(n,maxpoints))), ...
                   find(abs(diff(g))>.3)',find(abs(diff(g))>.3)'+1]);
 indexes=indexes(indexes>=1&indexes<=n);
end
function ms=tiempoI10(s,toff)
 t=s.t;i=canal(s,'I(L_BOB)');
 antes=t<toff & t>=toff-1e-4;
 ms=NaN;if ~any(antes),return;end
 I0=median(i(antes));if I0<=0,return;end
 ix=find(t>=toff & i<=.1*I0,1,'first');
 if ~isempty(ix),ms=1e3*(t(ix)-toff);end
end
function guardar(fig,dest,nombre)
 exportgraphics(fig,fullfile(dest,[nombre '.png']),'Resolution',180);
 exportgraphics(fig,fullfile(dest,[nombre '.pdf']),'ContentType','vector');
 close(fig);
end
