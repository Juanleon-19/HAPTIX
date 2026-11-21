%% ERM - Graficas reproducibles a partir de los archivos RAW de LTspice
% Solo lectura de resultados y graficacion. NO simula el motor en MATLAB.
% Version 2.0. No requiere Simulink ni toolboxes adicionales.
% Entradas: Datos_LTspice/01_ERM_Pulsos.raw, 02_ERM_PWM.raw
% Salidas: Resultados_generados/*.png, *.pdf, *.csv, *.txt
%
% Modelo de LTspice: R=92.5 ohm (medida del motor detenido);
% L=349 uH (inductancia de referencia de OTRO motor ERM);
% AO3400A y diodo: modelos SPICE aproximados, no oficiales.
%
% IMPORTANTE: solo corriente del equivalente electrico R-L, no
% consumo real del motor girando ni respuesta vibrotactil.

clear; clc; close all;
base = fileparts(mfilename('fullpath'));
inDir = fullfile(base, 'Datos_LTspice');
outDir = fullfile(base, 'Resultados_generados');
if ~exist(outDir,'dir'), mkdir(outDir); end
Rmotor = 92.5; Vnom = 3.0; fPWM = 1e4;

% Leer directamente LTspice RAW binario UTF-16LE, no comprimido,
% de analisis transitorio (time=double; otras variables=float32).
p = leerRawLTspice(fullfile(inDir,'01_ERM_Pulsos.raw'));
w = leerRawLTspice(fullfile(inDir,'02_ERM_PWM.raw'));
assert(numel(p.pasos)==1, 'SIM01 debe tener un paso.');
assert(numel(w.pasos)==3, 'SIM02 debe tener exactamente tres pasos: 25, 50 y 75 por ciento.');

%% Datos SIM01 - conmutacion de tres pulsos
a = p.pasos{1};
t1 = a.t;
g1 = canal(a,'V(gate)');
d1 = canal(a,'V(drain)');
m1 = canal(a,'I(RMOTOR)');
di1 = canal(a,'I(D1)');
f1 = canal(a,'I(VPOWER)');
vs1 = canal(a,'V(vmotor)');

% Identificacion de la corriente de RECIRCULACION del diodo:
% solo intervalos en que el gate esta bajo y el drenador supera +VMOTOR.
% El pico global del diodo puede producirse en el ENCENDIDO por el modelo
% capacitivo del diodo; no se debe llamar "corriente de rueda libre".
rec1 = (g1 < 0.2) & (d1 > vs1 + 0.10) & (di1 > 0) & (m1 > 0);
Irec1 = max0(di1(rec1));
Iglobal1 = max0(di1);
sel_on = (t1>=0.06)&(t1<=0.14);
Pload1 = m1.^2 .* Rmotor;
Psource1 = -vs1 .* f1;

%% Figura 01 - tren de pulsos: tensiones, corriente y potencia
fig=figuraNueva('ERM | Tren de pulsos', 9.7, 7.5);
% Se reducen puntos SOLO para dibujar el intervalo largo;
% los calculos y CSV siempre utilizan TODOS los puntos originales.
frentes=find(abs(diff(g1))>0.7);
idx=unique([1:12:numel(t1),frentes',frentes'+1,numel(t1)]);
tl=tiledlayout(fig,3,1,'TileSpacing','compact','Padding','compact');
ax=nexttile(tl); plot(ax,t1(idx)*1000,g1(idx),'LineWidth',1.1); hold(ax,'on');
plot(ax,t1(idx)*1000,d1(idx),'LineWidth',1.1); grid(ax,'on');
ylabel(ax,'Tension [V]'); legend(ax,{'V_{GS}','V_{DS}'},'Location','northeast');
title(ax,'SIM-01. Conmutacion del ERM mediante tres pulsos');
xlim(ax,[0 600]);
ax=nexttile(tl);plot(ax,t1(idx)*1000,m1(idx)*1e3,'LineWidth',1.2);grid(ax,'on');
ylabel(ax,'I_{ERM,modelo} [mA]');xlim(ax,[0 600]);
ax=nexttile(tl);plot(ax,t1(idx)*1000,Pload1(idx)*1e3,'LineWidth',1.1);grid(ax,'on');
ylabel(ax,'P_{R} [mW]');xlabel(ax,'Tiempo [ms]');xlim(ax,[0 600]);
guardarFigura(fig,outDir,'F01_ERM_Conmutacion_Pulsos');

%% Figura 02 - detalle del apagado del primer pulso
rango = (t1>=0.149985) & (t1<=0.15004);
fig=figuraNueva('ERM | Apagado y diodo', 9.7, 5.9);
tl=tiledlayout(fig,2,1,'TileSpacing','compact','Padding','compact');
ax=nexttile(tl); plot(ax,(t1(rango)-0.150)*1e6,g1(rango),'LineWidth',1.15);
hold(ax,'on');plot(ax,(t1(rango)-0.150)*1e6,d1(rango),'LineWidth',1.15);
grid(ax,'on');ylabel(ax,'Tension [V]');legend(ax,{'V_{GS}','V_{DS}'},'Location','best');
title(ax,'SIM-01. Transitorio electrico al apagar el MOSFET');
ax=nexttile(tl);plot(ax,(t1(rango)-0.150)*1e6,m1(rango)*1e3,'LineWidth',1.2);
hold(ax,'on');plot(ax,(t1(rango)-0.150)*1e6,di1(rango)*1e3,'LineWidth',1.1);
grid(ax,'on');ylabel(ax,'Corriente [mA]');xlabel(ax,'Tiempo relativo a 150 ms [us]');
legend(ax,{'Corriente de carga','Corriente de D1'},'Location','best');
guardarFigura(fig,outDir,'F02_ERM_Apagado_Diodo');

%% Datos SIM02 - PWM 10 kHz, tres escalones de duty
D = [25 50 75];
N = numel(D);
Imedia = zeros(N,1); Irms=zeros(N,1); Ifuente=zeros(N,1);
Pfuente=zeros(N,1); PR=zeros(N,1); E10ms=zeros(N,1);
IdiodoFlanco=zeros(N,1); IdiodoRec=zeros(N,1);
for k=1:N
    b=w.pasos{k}; tt=b.t;
    ig=canal(b,'V(gate)'); vd=canal(b,'V(drain)');
    vm=canal(b,'V(vmotor)');
    ir=canal(b,'I(RMOTOR)'); id=canal(b,'I(D1)');
    isrc=canal(b,'I(VPOWER)');
    on=(tt>=0.01)&(tt<=0.02); tw=tt(on);
    dur=tw(end)-tw(1);
    Imedia(k) = trapz(tw, ir(on))/dur;
    Irms(k) = sqrt(trapz(tw,ir(on).^2)/dur);
    Ifuente(k) = trapz(tw,-isrc(on))/dur;
    Pfuente(k) = trapz(tw,-vm(on).*isrc(on))/dur;
    PR(k) = trapz(tw,ir(on).^2*Rmotor)/dur;
    E10ms(k) = trapz(tw,ir(on).^2*Rmotor);
    IdiodoFlanco(k)=max0(id(on));
    mascaraRec = on & (ig<0.2) & (vd>vm+0.10) & (id>0) & (ir>0);
    IdiodoRec(k)=max0(id(mascaraRec));
end

%% Figura 03 - formas de onda PWM: el gate (50%) y las tres corrientes
fig=figuraNueva('ERM | PWM 10kHz', 9.7, 6.1);
tl=tiledlayout(fig,2,1,'TileSpacing','compact','Padding','compact');
b=w.pasos{2};win=(b.t>=0.0100)&(b.t<=0.0103);
ax=nexttile(tl);plot(ax,(b.t(win)-0.010)*1e6,canal(b,'V(gate)',win),'LineWidth',1.1);
grid(ax,'on');ylabel(ax,'V_{GS} [V]');
title(ax,'SIM-02. PWM de 10 kHz; ejemplo de gate a D = 50 %');
ax=nexttile(tl);hold(ax,'on');
for k=1:N
    b=w.pasos{k};win=(b.t>=0.0100)&(b.t<=0.0103);
    plot(ax,(b.t(win)-0.010)*1e6,canal(b,'I(RMOTOR)',win)*1e3,'LineWidth',1.1);
end
grid(ax,'on');ylabel(ax,'I_{ERM,modelo} [mA]');xlabel(ax,'Tiempo relativo a 10 ms [us]');
legend(ax,{'25 %','50 %','75 %'},'Location','best');
guardarFigura(fig,outDir,'F03_ERM_PWM_FormasDeOnda');

%% Figura 04 - potencia media y energia del equivalente por duty
fig=figuraNueva('ERM | Potencia media PWM',9.7,4.9);
ax=axes(fig);plot(ax,D,Pfuente*1000,'o-','LineWidth',1.5,'MarkerSize',7);
hold(ax,'on');plot(ax,D,PR*1000,'s--','LineWidth',1.4,'MarkerSize',7);
grid(ax,'on');xticks(ax,D);xlim(ax,[20 80]);
ylabel(ax,'Potencia media [mW]');xlabel(ax,'Ciclo de trabajo PWM [%]');
title(ax,'SIM-02. Consumo electrico del modelo R-L (10 kHz)');
legend(ax,{'Desde fuente ideal de 3 V','Disipada en R_{motor}'},'Location','northwest');
guardarFigura(fig,outDir,'F04_ERM_Potencia_vs_Duty');

%% Tablas reproducibles de resultados
TablaPWM=table(D(:),Imedia*1e3,Irms*1e3,Ifuente*1e3,Pfuente*1e3,PR*1e3,E10ms*1e3,IdiodoFlanco*1e3,IdiodoRec*1e3, ...
    'VariableNames',{'Duty_pct','I_motor_media_mA','I_motor_RMS_mA','I_fuente_media_mA', ...
    'P_fuente_media_mW','P_resistencia_media_mW','E_resistencia_10ms_mJ', ...
    'I_diodo_pico_sin_filtrar_mA','I_diodo_recirc_apagado_mA'});
writetable(TablaPWM,fullfile(outDir,'Tabla_Resultados_PWM.csv'));

Nombres={'VGS_activa_V';'VDS_activa_V';'I_motor_activa_mA';'P_resistencia_activa_mW'; ...
    'Energia_resistencia_3pulsos_mJ';'Energia_fuente_3pulsos_mJ'; ...
    'I_diodo_pico_sin_filtrar_mA';'I_diodo_recirc_apagado_mA'};
Valores=[mean(g1(sel_on));mean(d1(sel_on));mean(m1(sel_on))*1e3; ...
    mean(Pload1(sel_on))*1e3;trapz(t1,Pload1)*1e3; ...
    trapz(t1,Psource1)*1e3;Iglobal1*1e3;Irec1*1e3];
TablaPulsos=table(Nombres,Valores,'VariableNames',{'Medicion','Valor'});
writetable(TablaPulsos,fullfile(outDir,'Tabla_Resultados_Pulsos.csv'));

f=fopen(fullfile(outDir,'LEER_ANTES_DE_USAR_LAS_FIGURAS.txt'),'w');
assert(f>0,'No se pudo crear texto de trazabilidad.');
fprintf(f,'LTspice ERM: resultados re-graficados sin volver a simular.\n');
fprintf(f,'Rmotor=92.5 ohm, medida en reposo; Lmotor=349 uH, referencia de otro ERM.\n');
fprintf(f,'AO3400A/1N5819: MODELOS SPICE APROXIMADOS, no modelos certificados.\n');
fprintf(f,'Los archivos RAW proceden de LTspice 26.1.1, no de MATLAB.\n');
fprintf(f,'Pico total de corriente D1 durante PWM puede deberse a transitorios de flanco: NO es corriente de recirculacion.\n');
fprintf(f,'"Recirc apagado" se filtra por gate<0.2 V, drain>riel+0.1 V y corriente de motor positiva.\n');
fprintf(f,'SIM01: I_diodo_max_total = %.3f mA; I_diodo_recirc_apagado = %.3f mA.\n',Iglobal1*1e3,Irec1*1e3);
fprintf(f,'No predice corriente del motor girando, velocidad, vibracion, temperatura, ni bateria real.\n');
fprintf(f,'La potencia P_resistencia es disipacion en RMOTOR del equivalente R-L.\n');
fprintf(f,'La potencia P_fuente es tomada de fuente ideal de 3 V, no incluye regulador/bateria.\n');
fprintf(f,'No inferir rendimiento del AO3400A real desde el MOSFET generico del esquema.\n');
fclose(f);

disp(TablaPulsos);disp(TablaPWM);
fprintf('\nFiguras (PNG + PDF vectorial) y tablas en: %s\n',outDir);

%% Funciones auxiliares locales: lectura binaria RAW y exportacion
function S=leerRawLTspice(path)
    if ~exist(path,'file'),error('Falta archivo LTspice: %s',path);end
    fid=fopen(path,'r','ieee-le');
    assert(fid>0,'No se pudo abrir: %s',path);
    limpieza=onCleanup(@()fclose(fid));
    bytes=fread(fid,inf,'*uint8')';
    marca=uint8(unicode2native(sprintf('Binary:\n'),'UTF-16LE'));
    inicio=strfind(bytes,marca);
    if numel(inicio)~=1, error('RAW no soportado: no hay marcador Binary UTF-16LE.');end
    header=native2unicode(bytes(1:inicio-1),'UTF-16LE');
    if ~contains(lower(header),'nocompression')
        error('RAW comprimido/no reconocido. Desactiva compresion (.options plotwinsize=0).');
    end
    v=regexp(header,'No\. Variables:\s*(\d+)','tokens','once');
    p=regexp(header,'No\. Points:\s*(\d+)','tokens','once');
    if isempty(v)||isempty(p),error('Faltan No. Variables o No. Points en el RAW.');end
    nVar=str2double(v{1});nPoints=str2double(p{1});
    vars=regexp(header,'(?m)^\s*\d+\t([^\t\r\n]+)\t[^\r\n]+','tokens');
    names=cellfun(@(x)x{1},vars,'UniformOutput',false);
    assert(numel(names)==nVar,'Error al leer nombres de variables RAW.');
    desde=inicio+numel(marca);
    ancho=8+4*(nVar-1);
    assert(numel(bytes)-desde+1==ancho*nPoints, ...
       'Tamanio RAW inesperado: no es float32 + double sin compresion.');
    b=reshape(bytes(desde:end),ancho,nPoints);
    % Los archivos de Windows/LTspice estan en little-endian.
  [~, ~, endian] = computer;
assert(endian == 'L', 'Este lector espera arquitectura little-endian.');
    t=double(typecast(reshape(b(1:8,:),1,[]),'double'))';
    vv=double(reshape(typecast(reshape(b(9:end,:),1,[]),'single'),nVar-1,nPoints))';
    Y=[t,vv];
    starts=[1;find(diff(t)<-1e-12)+1]; stops=[starts(2:end)-1;nPoints];
    S.names=names;S.pasos=cell(numel(starts),1);
    for k=1:numel(starts)
        ii=starts(k):stops(k);
        q.names=names;q.t=Y(ii,1);q.Y=Y(ii,:);
        S.pasos{k}=q;
    end
end

function x=canal(S,nombre,mascara)
    i=find(strcmpi(S.names,nombre),1);
    if isempty(i),error('Canal faltante: %s',nombre);end
    x=S.Y(:,i);
    if nargin>=3,x=x(mascara);end
end

function x=max0(y)
    if isempty(y),x=0;else,x=max(0,max(y));end
end

function fig=figuraNueva(nombre,w,h)
    fig=figure('Name',nombre,'Color','w','Units','inches','Position',[1 1 w h], ...
        'PaperPositionMode','auto','Visible','off');
    set(fig,'DefaultAxesFontName','Arial','DefaultAxesFontSize',10, ...
            'DefaultTextFontName','Arial');
end

function guardarFigura(fig,carpeta,nom)
    exportgraphics(fig,fullfile(carpeta,[nom '.png']),'Resolution',300);
    exportgraphics(fig,fullfile(carpeta,[nom '.pdf']),'ContentType','vector');
    close(fig);
end
