function s = simular_electrotermico_SMA_v3()
% SIMULAR_ELECTROTERMICO_SMA_V3
% Análisis electrotérmico de un hilo NiTi. Lazo abierto, sin Simulink.
% MATLAB R2025a. Resuelve una ecuación de balance de energía con ode45.
%
% IMPORTANTE: R_medida = 2.7 ohm se midió con multímetro de dos puntas.
% INCLUYE puntas y contactos. NO equivale necesariamente a R del alambre.
% El diámetro, cp, rho y h son supuestos/referencias, no pruebas Nexmetal.
% NO utilizar los valores de corriente de este código como instrucciones
% para energizar un alambre real o para una prueba sobre piel.
%
% MODELO: (rho*cp*pi*d^2*L/4)*dT/dt = I(t)^2*R - h*pi*d*L*(T-Ta)
% Referencia directa: https://www.mdpi.com/2076-0825/10/3/63
% Referencia propiedades: https://www.dynalloy.com/pdfs/TCF1140.pdf
% Referencia 0.30 mm: https://fwmetals.com/media/pbmke3zt/0-3-mm-acuator-data-sheet.pdf

clc; fprintf('\n=== MODELO ELECTROTERMICO SMA (ECUACIONES) v3 ===\n');

% -------- ENTRADAS EDITABLES --------
p.R_leida_Ohm = 2.70;    % medida real, 12 cm, dos puntas (SIN corregir)
p.R_puntas_Ohm = NaN;  % PENDIENTE: medir con puntas cortocircuitadas
p.L_m = 0.12;          % longitud medida
p.d_m = 0.30e-3;       % diámetro NOMINAL, confirmar con medición
p.rho_kg_m3 = 6450;   % densidad NiTi, Fort Wayne Metals y Dynalloy
p.cp_J_kgK = 0.20*4184; % Dynalloy: 0.2 cal/(g K)
p.h_W_m2K = 57.02;    % estimación anterior: NO medición de este montaje
p.Tamb_C = 25;        % supuesto de laboratorio; medir
p.T_obj_C = 60;       % objetivo NOMINAL, NO garantiza Af ni contracción
p.t_cal_s = 10;       % tiempo de calentamiento solicitado al escenario
p.t_espera_s = 2;     % inicio de aporte eléctrico
p.t_final_s = 35;     % tiempo de simulación
p.h_escenarios = [30 57.02 90]; % SOLO sensibilidad ilustrativa (no intervalos calibrados)

if isnan(p.R_puntas_Ohm)
    p.R_alambre_Ohm = p.R_leida_Ohm;
    p.etiqueta_R = 'Lectura sin corregir (R alambre + puntas + contactos)';
    warning('SMA:RnoCorregida', ['Se usa la lectura 2.70 ohm SIN corregir. ', ...
        'NO es resistencia propia confirmada del Nexmetal.']);
else
    assert(p.R_puntas_Ohm>=0 && p.R_puntas_Ohm<p.R_leida_Ohm,...
        'La resistencia de puntas debe ser >=0 y menor que la lectura.');
    p.R_alambre_Ohm = p.R_leida_Ohm-p.R_puntas_Ohm;
    p.etiqueta_R = 'Resistencia corregida por cortocircuito de puntas (aun incluye error de contacto)';
end
assert(p.L_m>0 && p.d_m>0 && p.cp_J_kgK>0 && p.rho_kg_m3>0 && p.h_W_m2K>0);
assert(p.T_obj_C>p.Tamb_C && p.t_cal_s>0 && p.t_espera_s>=0);

p.A_lateral_m2 = pi*p.d_m*p.L_m;        % superficie expuesta, sin extremos
p.Volumen_m3 = pi*p.d_m^2/4*p.L_m;
p.masa_kg = p.rho_kg_m3*p.Volumen_m3;
p.C_J_K = p.masa_kg*p.cp_J_kgK;    % capacidad térmica total
p.G_W_K = p.h_W_m2K*p.A_lateral_m2; % conducción a los terminales OMITIDA
p.tau_s = p.C_J_K/p.G_W_K;
p.t_corte_s = p.t_espera_s+p.t_cal_s;

% CORRIENTE TEORICA para alcanzar 60 C al finalizar t_cal_s,
% con I constante y modelo ideal, SIN calor de transformación.
p.I_esc_A = sqrt(p.G_W_K*(p.T_obj_C-p.Tamb_C)/...
                (p.R_alambre_Ohm*(1-exp(-p.t_cal_s/p.tau_s))));
p.P_on_W = p.I_esc_A^2*p.R_alambre_Ohm;
p.E_entrada_J = p.P_on_W*p.t_cal_s;

% -------- INTEGRACION NUMERICA CON ODE45 --------
opts = odeset('RelTol',1e-10,'AbsTol',1e-11);
t_pre = linspace(0,p.t_espera_s,60).';
T_pre = p.Tamb_C*ones(size(t_pre));
Tspan_cal = linspace(p.t_espera_s,p.t_corte_s,1300).';
[th,Th] = ode45(@(t,T) (p.P_on_W-p.G_W_K*(T-p.Tamb_C))/p.C_J_K,...
                 Tspan_cal,p.Tamb_C,opts);
Tspan_enf = linspace(p.t_corte_s,p.t_final_s,2000).';
[tc,Tc] = ode45(@(t,T) (-p.G_W_K*(T-p.Tamb_C))/p.C_J_K,...
                 Tspan_enf,Th(end),opts);
t = [t_pre(1:end-1);th;tc(2:end)];
T = [T_pre(1:end-1);Th;Tc(2:end)];

% Solución exacta POR TRAMOS del mismo modelo, para verificación
T_exacta = p.Tamb_C*ones(size(t));
k1 = t>=p.t_espera_s & t<=p.t_corte_s;
T_exacta(k1) = p.Tamb_C + (p.P_on_W/p.G_W_K)*...
               (1-exp(-(t(k1)-p.t_espera_s)/p.tau_s));
DT_corte = (p.P_on_W/p.G_W_K)*(1-exp(-p.t_cal_s/p.tau_s));
k2 = t>p.t_corte_s;
T_exacta(k2) = p.Tamb_C+DT_corte.*exp(-(t(k2)-p.t_corte_s)/p.tau_s);

P_in = zeros(size(t));
kcal = t>=p.t_espera_s & t<p.t_corte_s;
P_in(kcal) = p.P_on_W;
P_conv = p.G_W_K*(T-p.Tamb_C);
U = p.C_J_K*(T-p.Tamb_C);  % energía almacenada
Q_in = p.P_on_W*max(0,min(t,p.t_corte_s)-p.t_espera_s);
Q_conv = cumtrapz(t,P_conv);
residuo = Q_in-Q_conv-U;
err_temp = max(abs(T-T_exacta));
err_balance = max(abs(residuo));

assert(err_temp<0.02,'La integración de ode45 difiere de la solución exacta.');
assert(err_balance<0.02,'El balance energético tiene un error inesperado.');
assert(all(isfinite(T)) && min(T)>=p.Tamb_C-1e-6);

% -------- CORRIENTE VS TIEMPO Y SENSIBILIDAD DE CONVECCION --------
tiempos = [2 3 5 8 10 15 20].';
I_req = zeros(numel(tiempos),numel(p.h_escenarios));
for j=1:numel(p.h_escenarios)
    G = p.h_escenarios(j)*p.A_lateral_m2;
    tau = p.C_J_K/G;
    I_req(:,j) = sqrt(G*(p.T_obj_C-p.Tamb_C)./...
                         (p.R_alambre_Ohm*(1-exp(-tiempos./tau))));
end

% -------- RESULTADOS REPRODUCIBLES --------
outDir = fullfile(fileparts(mfilename('fullpath')),'Resultados');
if ~exist(outDir,'dir'), mkdir(outDir); end

f1=figure('Color','white','Name','SMA: calentamiento y enfriamiento');
plot(t,T,'k-','LineWidth',1.7); hold on;
plot(t,T_exacta,'k--','LineWidth',1.1);
yline(p.T_obj_C,'k:','60 °C nominal (solo objetivo)');
xline(p.t_corte_s,'k-.','Desconexion','LabelVerticalAlignment','bottom');
xlabel('Tiempo [s]'); ylabel('Temperatura del alambre [°C]');
title('Respuesta térmica idealizada del alambre NiTi (lazo abierto)');
legend('ode45','Solucion exacta','Location','best'); grid on; box on;
exportgraphics(f1,fullfile(outDir,'01_temperatura.png'),'Resolution',300);
exportgraphics(f1,fullfile(outDir,'01_temperatura.pdf'),'ContentType','vector');

f2=figure('Color','white','Name','SMA: potencia y perdida convectiva');
plot(t,P_in,'k-','LineWidth',1.6); hold on;
plot(t,P_conv,'k--','LineWidth',1.4);
xlabel('Tiempo [s]'); ylabel('Potencia [W]');
title('Potencia de Joule y perdida convectiva (modelo simplificado)');
legend('Potencia electrica I^2R','Conveccion h A (T-T_a)','Location','best');
grid on; box on;
exportgraphics(f2,fullfile(outDir,'02_potencias.png'),'Resolution',300);
exportgraphics(f2,fullfile(outDir,'02_potencias.pdf'),'ContentType','vector');

f3=figure('Color','white','Name','SMA: corriente y tiempo objetivo');
styles={'k-','k--','k:'}; hold on;
for j=1:numel(p.h_escenarios)
    plot(tiempos,I_req(:,j),styles{j},'LineWidth',1.7,...
        'DisplayName',sprintf('h=%.2f W/(m^2 K)',p.h_escenarios(j)));
end
xlabel('Tiempo para alcanzar 60 °C [s]'); ylabel('Corriente teorica constante [A]');
title('Analisis de sensibilidad a conveccion (escenarios no calibrados)');
legend('Location','northeast'); grid on; box on;
exportgraphics(f3,fullfile(outDir,'03_corriente_vs_tiempo.png'),'Resolution',300);
exportgraphics(f3,fullfile(outDir,'03_corriente_vs_tiempo.pdf'),'ContentType','vector');

f4=figure('Color','white','Name','SMA: balance de energia');
plot(t,Q_in,'k-','LineWidth',1.6); hold on;
plot(t,Q_conv+U,'k--','LineWidth',1.5);
xlabel('Tiempo [s]'); ylabel('Energia acumulada [J]');
title('Comprobacion: energia electrica vs almacenamiento + conveccion');
legend('Energia suministrada','Energia almacenada + perdida','Location','best');
grid on; box on;
exportgraphics(f4,fullfile(outDir,'04_balance_energia.png'),'Resolution',300);
exportgraphics(f4,fullfile(outDir,'04_balance_energia.pdf'),'ContentType','vector');

trazas = table(t,T,T_exacta,P_in,P_conv,U,Q_in,Q_conv,residuo,...
    'VariableNames',{'t_s','T_ode45_C','T_analitica_C','P_e_W','P_conv_W',...
                     'U_almacenada_J','E_entrada_J','E_conveccion_J','Residuo_J'});
writetable(trazas,fullfile(outDir,'trazas_electrotermicas.csv'));
columnas=cell(1,numel(p.h_escenarios));
for j=1:numel(p.h_escenarios)
    columnas{j}=sprintf('I_h_%g_A',p.h_escenarios(j));
    columnas{j}=strrep(columnas{j},'.','p');
end
sensi = array2table([tiempos I_req],'VariableNames',[{'tiempo_s'} columnas]);
writetable(sensi,fullfile(outDir,'sensibilidad_corriente.csv'));

f=fopen(fullfile(outDir,'resumen.txt'),'w');
fprintf(f,'MODELO ELECTROTERMICO SMA v3 (NO VALIDADO EN PROTOTIPO)\n');
fprintf(f,'Longitud=%.4f m, diametro nominal=%.4f mm\n',p.L_m,1e3*p.d_m);
fprintf(f,'R leida con dos puntas=%.4f ohm\n',p.R_leida_Ohm);
fprintf(f,'R del escenario=%.4f ohm: %s\n',p.R_alambre_Ohm,p.etiqueta_R);
fprintf(f,'rho=%.1f kg/m3, cp=%.3f J/kgK (otros fabricantes NiTi)\n',p.rho_kg_m3,p.cp_J_kgK);
fprintf(f,'h=%.3f W/(m2 K) NO calibrado; solo escenario de referencia\n',p.h_W_m2K);
fprintf(f,'C=%.6f J/K, G=%.8f W/K, tau=%.4f s\n',p.C_J_K,p.G_W_K,p.tau_s);
fprintf(f,'Corriente teorica para T=%.2f C en %.2f s: %.6f A\n',p.T_obj_C,p.t_cal_s,p.I_esc_A);
fprintf(f,'Potencia durante el pulso=%.6f W; energia=%.6f J\n',p.P_on_W,p.E_entrada_J);
fprintf(f,'Error maximo ode45/exacta=%.8g C\n',err_temp);
fprintf(f,'Error maximo de cierre energetico=%.8g J\n',err_balance);
fprintf(f,'Advertencias: sin calor latente, conduccion a soportes, R(T), radiacion, piel o sensores.\n');
fprintf(f,'NO USAR ESTA CORRIENTE COMO CONSIGNA PARA ENSAYOS FISICOS.\n');
fclose(f);

fprintf('R leida=%.3f ohm | R escenario=%.3f ohm [%s]\n',...
        p.R_leida_Ohm,p.R_alambre_Ohm,p.etiqueta_R);
fprintf('C=%.6f J/K | G=%.6f W/K | tau=%.3f s\n',...
        p.C_J_K,p.G_W_K,p.tau_s);
fprintf('I teorica para alcanzar %.1f °C en %.1f s: %.4f A [NO consigna experimental]\n',...
        p.T_obj_C,p.t_cal_s,p.I_esc_A);
fprintf('Error ode45 vs exacta: %.5g °C | error energetico: %.5g J\n',...
        err_temp,err_balance);
fprintf('Resultados: %s\n',outDir);

s = struct('parametros',p,'tiempo_s',t,'temperatura_C',T,...
           'temperatura_exacta_C',T_exacta,'potencia_W',P_in,...
           'perdida_conv_W',P_conv,'corriente_objetivo_A',p.I_esc_A,...
           'error_temperatura_C',err_temp,'error_energia_J',err_balance,...
           'tabla_trazas',trazas,'tabla_sensibilidad',sensi,'carpeta',outDir);
end
