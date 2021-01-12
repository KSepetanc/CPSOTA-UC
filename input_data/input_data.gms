set t/t1*t24/;
alias(t,h);

set i "bus", e "branch", k "gen", l "load", s "shunt";
alias(i,j);
set arcs(e,i,i),arcs_from(e,i,i),arcs_to(e,i,i),bus_gen(i,k),bus_loads(i,l),bus_pairs(i,i),ref_buses(i),bus_shunts(i,s);


$gdxin input_data\grid_data.gdx
$load i,e,k,l,s,arcs_from,bus_gen,bus_loads,bus_pairs,ref_buses,bus_shunts
$gdxin

arcs_to(e,i,j)=arcs_from(e,j,i);
arcs(e,i,j)=arcs_from(e,i,j)+arcs_to(e,i,j);

parameter bl(e),gl(e),gl_fr(e),gl_to(e),bl_fr(e),bl_to(e),Slinemax(e),shift(e),tap(e),angmax(i,j),angmin(i,j),
         vmax(i),vmin(i),dp(l) "active load",dq(l) "reactive load",gsh(s),bsh(s),pg_max(k),pg_min(k),qg_max(k),qg_min(k),c2(k),c1(k),c0(k);

$gdxin input_data\grid_data.gdx
$load bl,gl,gl_fr,gl_to,bl_fr,bl_to,Slinemax,shift,tap,angmax,angmin,vmax,vmin,dp,dq,gsh,bsh,pg_max,pg_min,qg_max,qg_min,c2,c1,c0
$gdxin


parameter ramp_up(k),ramp_dn(k),MD(k),MU(k),scost(k) "start cost";
parameter load_f(t) "load scaling factor"
/'t1'  0.67,'t2'  0.63,'t3'  0.60,'t4'  0.59,'t5'  0.59,'t6'  0.60,'t7'  0.74,'t8'  0.86,'t9'  0.95,'t10' 0.96,'t11' 0.96,'t12' 0.95,
 't13' 0.95,'t14' 0.95,'t15' 0.93,'t16' 0.94,'t17' 0.99,'t18' 1.00,'t19' 1.00,'t20' 0.96,'t21' 0.91,'t22' 0.83,'t23' 0.73,'t24' 0.63/;

ramp_up(k)= 0.5*( abs(pg_min(k)) +abs(pg_max(k)) );
ramp_dn(k)=-0.5*( abs(pg_min(k)) +abs(pg_max(k)) );

MD(k)$(pg_max(k)<=1)=2;
MU(k)$(pg_max(k)<=1)=2;
MD(k)$(pg_max(k)> 1)=4;
MU(k)$(pg_max(k)> 1)=4;

scost(k)=1500;
c0(k)$(c0(k)=0)=c1(k)/10;


