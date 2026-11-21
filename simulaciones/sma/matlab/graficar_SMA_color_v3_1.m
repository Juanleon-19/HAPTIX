function salida = graficar_SMA_color_v3_1()
% GRAFICAR_SMA_COLOR_V3_1
% PRESENTACION SOLAMENTE: reconstruye 4 figuras a partir de CSV ya
% calculados por simular_electrotermico_SMA_v3.m (MATLAB R2025a).
% No recalcula el modelo ni altera ecuaciones, entradas o resultados.
%
% USO:
%  1. Pon este .m al lado de simular_electrotermico_SMA_v3.m
%  2. Ejecuta primero s = simular_electrotermico_SMA_v3; si no existen CSV
%  3. Ejecuta graficar_SMA_color_v3_1
%
% Si no encuentra Resultados local, solicitará elegir el CSV de trazas.

base = fileparts(mfilename('fullpath'));
resultados = fullfile(base,'Resultados');
trazaFile = fullfile(resultados,'trazas_electrotermicas.csv');
if ~isfile(trazaFile)
    [f,d] = uigetfile('*.csv','Selecciona trazas_electrotermicas.csv');
    if isequal(f,0), error('No se seleccionó archivo de resultados.'); end
    trazaFile = fullfile(d,f);
    resultados = d;
end
sensFile = fullfile(resultados,'sensibilidad_corriente.csv');
assert(isfile(sensFile), 'Falta sensibilidad_corriente.csv en: %s', resultados);

D = readtable(trazaFile);
S = readtable(sensFile);
required = {'t_s','T_ode45_C','T_analitica_C','P_e_W','P_conv_W', ...
    'U_almacenada_J','E_entrada_J','E_conveccion_J','Residuo_J'};
assert(all(ismember(required,D.Properties.VariableNames)), ...
    'El CSV de trazas no corresponde a la v3 esperada.');

% Paleta técnica: legible en pantalla y con líneas diferenciadas.
C.azul    = [0.10 0.35 0.67];
C.naranja = [0.90 0.42 0.09];
C.verde   = [0.12 0.53 0.44];
C.rojo    = [0.78 0.20 0.24];
C.morado  = [0.40 0.30 0.68];
C.gris    = [0.42 0.45 0.50];
C.negro   = [0.19 0.23 0.29];
C.celeste = [0.20 0.58 0.73];
C.suave   = [0.92 0.95 0.98];

out = fullfile(resultados,'Figuras_Color_v3_1');
if ~isfolder(out), mkdir(out); end

% 1. Respuesta térmica, objetivo de diseño y apagado de potencia
[f,ax] = nuevafigura('01 | Temperatura del alambre');
hold(ax,'on');
ymin = min(D.T_ode45_C); ymax = max([D.T_ode45_C; 60]);
onT = D.t_s(D.P_e_W > 0);
assert(~isempty(onT),'No se detectó el pulso de calentamiento en el CSV.');
tInicio = min(onT); tFin = max(onT);
p = patch(ax, [tInicio tFin tFin tInicio], [ymin-2 ymin-2 ymax+4 ymax+4], ...
    C.suave, 'EdgeColor','none','FaceAlpha',0.65,'HandleVisibility','off');
uistack(p,'bottom');
plot(ax,D.t_s,D.T_ode45_C,'Color',C.azul,'LineWidth',2.5, ...
    'DisplayName','Integración numérica (ode45)');
plot(ax,D.t_s,D.T_analitica_C,'--','Color',C.naranja,'LineWidth',1.5, ...
    'DisplayName','Solución analítica');
yline(ax,60,':','Color',C.rojo,'LineWidth',1.6, ...
    'DisplayName','Objetivo nominal: 60 °C');
xline(ax,tFin,'-.','Color',C.gris,'LineWidth',1.4, ...
    'DisplayName','Corte de corriente');
xlabel(ax,'Tiempo (s)');ylabel(ax,'Temperatura del alambre (°C)');
title(ax,'Calentamiento y enfriamiento de un alambre NiTi', ...
    'FontWeight','bold');
subtitle(ax,'Modelo de primer orden | Datos bibliográficos y resistencia sin corregir');
legend(ax,'Location','northeast');
xlim(ax,[min(D.t_s),max(D.t_s)]);
exportar(f,out,'01_temperatura_color');

% 2. Potencia aportada, potencia perdida por convección
[f,ax] = nuevafigura('02 | Potencias');
plot(ax,D.t_s,D.P_e_W,'Color',C.naranja,'LineWidth',2.3, ...
    'DisplayName','Potencia eléctrica I²R');hold(ax,'on');
plot(ax,D.t_s,D.P_conv_W,'Color',C.azul,'LineWidth',2.2, ...
    'DisplayName','Pérdidas por convección');
xlabel(ax,'Tiempo (s)');ylabel(ax,'Potencia (W)');
title(ax,'Potencia suministrada y disipación térmica','FontWeight','bold');
subtitle(ax,sprintf('Pulso activo: %.1f–%.1f s | Después: enfriamiento libre',tInicio,tFin));
legend(ax,'Location','northeast');xlim(ax,[min(D.t_s),max(D.t_s)]);
exportar(f,out,'02_potencias_color');

% 3. Corriente vs. tiempo: comparación de coeficientes h
[f,ax] = nuevafigura('03 | Sensibilidad a convección');
col = {C.celeste,C.morado,C.verde};
vars = S.Properties.VariableNames;
vars = vars(~strcmp(vars,'tiempo_s'));
for k=1:numel(vars)
    if k > numel(col), cc=C.negro; else, cc=col{k}; end
    % Identificación desde encabezados I_h_30_A, I_h_57p02_A, etc.
    hn = erase(erase(vars{k},'I_h_'),'_A');
    hn = strrep(hn,'p','.');
    plot(ax,S.tiempo_s,S.(vars{k}),'-o','Color',cc,'LineWidth',2.1, ...
        'MarkerSize',6,'MarkerFaceColor','white', ...
        'DisplayName',sprintf('h = %s W/(m²·K)',hn));
    hold(ax,'on');
end
xlabel(ax,'Tiempo para alcanzar 60 °C (s)');
ylabel(ax,'Corriente constante teórica (A)');
title(ax,'Sensibilidad de la corriente al intercambio térmico', ...
    'FontWeight','bold');
subtitle(ax,'Escenarios ilustrativos, no calibrados ni recomendados para pruebas');
legend(ax,'Location','northeast');
exportar(f,out,'03_sensibilidad_color');

% 4. Balance energético y sus tres componentes
[f,ax] = nuevafigura('04 | Energía y balance');
plot(ax,D.t_s,D.E_entrada_J,'Color',C.azul,'LineWidth',2.3, ...
    'DisplayName','Energía eléctrica aportada');hold(ax,'on');
plot(ax,D.t_s,D.E_conveccion_J,'Color',C.naranja,'LineWidth',2, ...
    'DisplayName','Energía perdida por convección');
plot(ax,D.t_s,D.U_almacenada_J,'Color',C.verde,'LineWidth',2, ...
    'DisplayName','Energía térmica almacenada');
plot(ax,D.t_s,D.E_conveccion_J + D.U_almacenada_J,'--', ...
    'Color',C.morado,'LineWidth',1.6, ...
    'DisplayName','Suma: convección + almacenada');
xlabel(ax,'Tiempo (s)');ylabel(ax,'Energía (J)');
title(ax,'Conservación de energía en el modelo electrotérmico', ...
    'FontWeight','bold');
subtitle(ax,'La suma de las contribuciones coincide con la energía eléctrica');
legend(ax,'Location','southeast');
exportar(f,out,'04_balance_energia_color');

% Resumen: los CSV originales no se modifican
fid = fopen(fullfile(out,'LEEME_FIGURAS_COLOR.txt'),'w');
fprintf(fid,'FIGURAS DE PRESENTACIÓN SMA v3.1\n');
fprintf(fid,'Fuente: CSV de MATLAB v3, sin recalcular ni alterar datos.\n');
fprintf(fid,'Error maximo ode45/analitica: %.4g °C\n', ...
    max(abs(D.T_ode45_C-D.T_analitica_C)));
fprintf(fid,'Residuo energetico maximo: %.4g J\n',max(abs(D.Residuo_J)));
fprintf(fid,'Aun NO validado experimentalmente en el Nexmetal.\n');
fprintf(fid,'R = 2,7 ohm corresponde a lectura de dos puntas sin corregir.\n');
fprintf(fid,'No usar corriente calculada como consigna de banco.\n');
fclose(fid);

fprintf('\nFiguras a color exportadas en: %s\n',out);
salida = out;
end

function [fig,ax]=nuevafigura(nombre)
fig=figure('Name',nombre,'Color','white','Units','pixels', ...
    'Position',[110 90 1080 620]);
ax=axes(fig,'Position',[.105 .14 .84 .75]);
set(ax,'Color','white','Box','off', 'FontName','Arial', ...
    'FontSize',11,'LineWidth',0.9, ...
    'XGrid','on','YGrid','on', ...
    'GridAlpha',0.12, 'MinorGridAlpha',0.06);
end

function exportar(fig,carpeta,nombre)
exportgraphics(fig,fullfile(carpeta,[nombre '.png']),'Resolution',320);
exportgraphics(fig,fullfile(carpeta,[nombre '.pdf']),'ContentType','vector');
end
