equ(m4_obj)..            obj =e= sum((t,k),Pgen(t,k)*Pgen(t,k)*c2(k) + Pgen(t,k)*c1(k) + (c0(k)*x.l(t,k) + scost(k)*y.l(t,k))$active_p_gen + c0(k)$(not active_p_gen) );

equ(m4_bus_p)(t,i)..     sum(bus_gen(i,k),Pgen(t,k)) - sum(bus_loads(i,l),dp(l))*load_f(t) - sum(arcs(e,i,j),P(t,e,i,j)) - V(t,i)*V(t,i)*sum(bus_shunts(i,s),gsh(s)) =e= 0;

equ(m4_bus_q)(t,i)..     sum(bus_gen(i,k),Qgen(t,k)) - sum(bus_loads(i,l),dq(l))*load_f(t) - sum(arcs(e,i,j),Q(t,e,i,j)) + V(t,i)*V(t,i)*sum(bus_shunts(i,s),bsh(s)) =e= 0;


equ(m4_power_fr)(t,arcs_from(e,i,j))..           P(t,e,i,j) =e=  V(t,i)*V(t,i)*(gl(e) + gl_fr(e))/(tap(e)*tap(e))
                                                                -V(t,i)*V(t,j)*(gl(e)*cos(fi(t,i)-fi(t,j)-shift(e)) + bl(e)*sin(fi(t,i)-fi(t,j)-shift(e)))/tap(e);

equ(m4_power_to)(t,arcs_to(e,i,j))..             P(t,e,i,j) =e=  V(t,i)*V(t,i)*(gl(e) + gl_to(e))
                                                                -V(t,i)*V(t,j)*(gl(e)*cos(fi(t,i)-fi(t,j)+shift(e)) + bl(e)*sin(fi(t,i)-fi(t,j)+shift(e)))/tap(e);

equ(m4_reactive_fr)(t,arcs_from(e,i,j))..        Q(t,e,i,j) =e= -V(t,i)*V(t,i)*(bl(e) + bl_fr(e))/(tap(e)*tap(e))
                                                                -V(t,i)*V(t,j)*(gl(e)*sin(fi(t,i)-fi(t,j)-shift(e)) - bl(e)*cos(fi(t,i)-fi(t,j)-shift(e)))/tap(e);

equ(m4_reactive_to)(t,arcs_to(e,i,j))..          Q(t,e,i,j) =e= -V(t,i)*V(t,i)*(bl(e) + bl_to(e))
                                                                -V(t,i)*V(t,j)*(gl(e)*sin(fi(t,i)-fi(t,j)+shift(e)) - bl(e)*cos(fi(t,i)-fi(t,j)+shift(e)))/tap(e);

equ(m4_linemax)(t,arcs(e,i,j))..                 P(t,e,i,j)*P(t,e,i,j) + Q(t,e,i,j)*Q(t,e,i,j) =l= Slinemax(e)*Slinemax(e);

equ(m4_pg_max)(t,k)..                            Pgen(t,k) =l= (pg_max(k)*x.l(t,k))$active_p_gen + pg_max(k)$(not active_p_gen);
equ(m4_pg_min)(t,k)..                            Pgen(t,k) =g= (pg_min(k)*x.l(t,k))$active_p_gen + pg_min(k)$(not active_p_gen);
equ(m4_pq_max)(t,k)..                            Qgen(t,k) =l= (qg_max(k)*x.l(t,k))$active_p_gen + qg_max(k)$(not active_p_gen);
equ(m4_pq_min)(t,k)..                            Qgen(t,k) =g= (qg_min(k)*x.l(t,k))$active_p_gen + qg_min(k)$(not active_p_gen);


equ(m4_volt_max)(t,i)..                          V(t,i) =l= vmax(i);
equ(m4_volt_min)(t,i)..                          V(t,i) =g= vmin(i);

equ(m4_ref)(t,ref_buses(i))..                    fi(t,i) =e= 0;

equ(m4_angmax)(t,bus_pairs(i,j))..               fi(t,i) - fi(t,j) =l= angmax(i,j);
equ(m4_angmin)(t,bus_pairs(i,j))..               fi(t,i) - fi(t,j) =g= angmin(i,j);

equ(m4_R_UP)(t,k)$(ramp_up(k)>0 and ord(t)>1)..  Pgen(t,k) - Pgen(t-1,k) =l= ramp_up(k);
equ(m4_R_DN)(t,k)$(ramp_dn(k)<0 and ord(t)>1)..  Pgen(t,k) - Pgen(t-1,k) =g= ramp_dn(k);

model m4_verification /m4_obj,m4_bus_p,m4_bus_q,m4_power_fr,m4_power_to,m4_reactive_fr,m4_reactive_to,m4_linemax,m4_pg_max,m4_pg_min,m4_pq_max,m4_pq_min,
                       m4_volt_max,m4_volt_min,m4_ref,m4_angmax,m4_angmin,m4_R_UP,m4_R_DN/;

*The model is NLP
