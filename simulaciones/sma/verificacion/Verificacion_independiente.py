"""Verificación NUMÉRICA independiente con SciPy, no es ejecución MATLAB.
No son medidas experimentales ni validación del hilo Nexmetal."""
from pathlib import Path
import numpy as np
from scipy.integrate import solve_ivp, cumulative_trapezoid
import matplotlib.pyplot as plt

root=Path(__file__).parent
out=root/'Vista_Previa'
out.mkdir(exist_ok=True)
R=2.7; L=.12; d=.00030; rho=6450; cp=.2*4184; h=57.02; Ta=25.; Tstar=60.
A=np.pi*d*L; V=np.pi*d**2/4*L; C=rho*cp*V; G=h*A;tau=C/G
I=np.sqrt(G*(Tstar-Ta)/(R*(1-np.exp(-10/tau))))
P=R*I**2; to=2.;off=12.;tf=35.
tpre=np.linspace(0,to,60)[:-1]
th=np.linspace(to,off,1300);tc=np.linspace(off,tf,2000)
sa=solve_ivp(lambda t,T:[(P-G*(T[0]-Ta))/C],(to,off),[Ta],t_eval=th,rtol=1e-10,atol=1e-11)
sb=solve_ivp(lambda t,T:[(-G*(T[0]-Ta))/C],(off,tf),[sa.y[0,-1]],t_eval=tc,rtol=1e-10,atol=1e-11)
t=np.r_[tpre,th,tc[1:]];T=np.r_[np.ones_like(tpre)*Ta,sa.y[0],sb.y[0,1:]]
Te=np.ones_like(t)*Ta
k=(t>=to)&(t<=off);Te[k]=Ta+(P/G)*(1-np.exp(-(t[k]-to)/tau))
k=t>off;Te[k]=Ta+(P/G)*(1-np.exp(-10/tau))*np.exp(-(t[k]-off)/tau)
Pin=np.where((t>=to)&(t<off),P,0.);P_loss=G*(T-Ta)
U=C*(T-Ta);Qin=P*np.maximum(0,np.minimum(t,off)-to);Qloss=cumulative_trapezoid(P_loss,t,initial=0)
errtemp=np.max(np.abs(T-Te));errenergy=np.max(np.abs(Qin-Qloss-U))
print(dict(I=I,P=P,C=C,G=G,tau=tau,R=R,max_temp=np.max(T),max_T_error=errtemp,max_energy_error=errenergy))
assert errtemp<.02
assert errenergy<.02

plt.rcParams.update({'font.size':10,'axes.titlesize':12,'figure.facecolor':'white','axes.facecolor':'white'})
def save(fig,stem):
 fig.tight_layout();fig.savefig(out/f'{stem}.png',dpi=240,bbox_inches='tight');fig.savefig(out/f'{stem}.pdf',bbox_inches='tight');plt.close(fig)

fig,ax=plt.subplots(figsize=(7.7,4.5))
ax.plot(t,T,color='black',lw=1.8,label='Integración numérica')
ax.plot(t,Te,color='gray',ls='--',lw=1.4,label='Solución exacta')
ax.axhline(60,color='black',ls=':',lw=1,label='60 °C nominal (objetivo)')
ax.axvline(12,color='gray',ls='-.',lw=1)
ax.set(xlabel='Tiempo [s]',ylabel='Temperatura del alambre [°C]',title='Calentamiento y enfriamiento del alambre NiTi — escenario idealizado')
ax.grid(alpha=.3);ax.legend(loc='upper right',fontsize=8)
save(fig,'01_temperatura_verificacion_independiente')
fig,ax=plt.subplots(figsize=(7.7,4.5))
ax.plot(t,Pin,color='black',lw=1.7,label='Potencia de Joule')
ax.plot(t,P_loss,color='gray',ls='--',lw=1.5,label='Pérdidas convectivas')
ax.set(xlabel='Tiempo [s]',ylabel='Potencia [W]',title='Potencia de entrada y pérdidas en el modelo')
ax.grid(alpha=.3);ax.legend()
save(fig,'02_potencia_verificacion_independiente')
fig,ax=plt.subplots(figsize=(7.7,4.5))
targets=np.array([2,3,5,8,10,15,20])
for hv,ls in [(30,'-'),(57.02,'--'),(90,':')]:
 Gv=hv*A;tv=C/Gv
 iv=np.sqrt(Gv*(Tstar-Ta)/(R*(1-np.exp(-targets/tv))))
 ax.plot(targets,iv,color='black',ls=ls,lw=1.8,label=f'h = {hv:g} W/(m² K)')
ax.set(xlabel='Tiempo objetivo [s]',ylabel='Corriente teórica constante [A]',title='Sensibilidad de la corriente estimada a las pérdidas térmicas')
ax.grid(alpha=.3);ax.legend()
save(fig,'03_corriente_objetivo_sensibilidad')
fig,ax=plt.subplots(figsize=(7.7,4.5))
ax.plot(t,Qin,color='black',lw=1.8,label='Energía eléctrica')
ax.plot(t,Qloss+U,color='gray',ls='--',lw=1.4,label='Energía almacenada + convección')
ax.set(xlabel='Tiempo [s]',ylabel='Energía [J]',title='Verificación del balance energético')
ax.grid(alpha=.3);ax.legend()
save(fig,'04_balance_energia')
(out/'RESULTADOS_VERIFICACION.txt').write_text(f'''Verificación independiente SciPy: NO es MATLAB NI medida Nexmetal.
R leída 2 puntas: 2.7 ohm (SIN corrección)
Cth: {C:.9f} J/K
G: {G:.9f} W/K, h=57.02 NO calibrado
Tau: {tau:.5f} s
Corriente hipotética para 60 °C en 10s: {I:.5f} A
Potencia hipotética: {P:.5f} W
Temperatura máxima calculada: {np.max(T):.5f} °C
Máx error ODE/solución exacta: {errtemp:.4e} °C
Máx error energético: {errenergy:.4e} J
No predice transformación de fase ni seguridad de contacto.
''',encoding='utf8')
