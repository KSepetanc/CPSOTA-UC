*Put here network name
$set network pglib_opf_case3_lmbd.xlsx

*Enable end of line comments and define macro to stramline equation statement
$eolCom //
$macro equ(name) equation name;\
                 name

$include input_data\xlsx_to_gdx.gms
$include input_data\input_data.gms

*The following macro is used as a condition to identify generators that can change active power
$macro active_p_gen (pg_max(k)-pg_min(k)<>0)

free variable obj,dfi(t,i),dV(t,i),P(t,e,i,i),Q(t,e,i,i),Qgen(t,k),Pgen(t,k),v_a(t,e) "voltage approximation variable",cos_a(t,i,i) "cosine approximation",fi(t,i),V(t,i);
binary variable x(t,k),y(t,k),z(t,k);

parameter Vt(t,i),fit(t,i); //Operating point
parameter obj_step3,gap; //Postproc parameters
V.l(t,i)=1; //Variable initialization

*Load model definitions
$include model1_polar.gms
$include model2_presolve.gms
$include model3_UC.gms
$include model4_app_error.gms

option reslim=3600;
option nlp=knitro;
option rminlp=knitro;
option miqcp=gurobi;
option optcr=0.0;
option optca=0.0;
option threads=4;

*Use default Gurobi options (GAMS-Gurobi does not use Gurobi default options by default)
m3_UC.OptFile=1;
file opt gurobi option file /gurobi.opt/;
put opt;
put 'qcpdual 0'/;
putclose;



solve m1_polar using rminlp minimizing obj;


*Start (This part can be run iteratevly to enhance accuracy)
fit(t,i)=fi.l(t,i);
Vt(t,i)=V.l(t,i);


solve m2_presolve using nlp minimizing obj;


solve m3_UC using miqcp minimizing obj; //Consider using MIPStart if run in a loop (for it>=2)
obj_step3=obj.l;


solve m4_app_error using nlp minimizing obj; //Consider using verification solution as final solution. This way no iterations are required. This is recommended approach.
gap=(obj_step3-obj.l)/obj.l;

display gap;
*End (This part can be run iteratevly to enhance accuracy)
