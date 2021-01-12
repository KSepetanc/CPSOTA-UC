equ(m1_obj)..            obj =e= sum((t,k),Pgen(t,k)*Pgen(t,k)*c2(k) + Pgen(t,k)*c1(k) + (c0(k)*x(t,k) + scost(k)*y(t,k))$active_p_gen + c0(k)$(not active_p_gen) );

equ(m1_bus_p)(t,i)..     sum(bus_gen(i,k),Pgen(t,k)) - sum(bus_loads(i,l),dp(l))*load_f(t) - sum(arcs(e,i,j),P(t,e,i,j)) - V(t,i)*V(t,i)*sum(bus_shunts(i,s),gsh(s)) =e= 0;

equ(m1_bus_q)(t,i)..     sum(bus_gen(i,k),Qgen(t,k)) - sum(bus_loads(i,l),dq(l))*load_f(t) - sum(arcs(e,i,j),Q(t,e,i,j)) + V(t,i)*V(t,i)*sum(bus_shunts(i,s),bsh(s)) =e= 0;


equ(m1_power_fr)(t,arcs_from(e,i,j))..           P(t,e,i,j) =e=  V(t,i)*V(t,i)*(gl(e) + gl_fr(e))/(tap(e)*tap(e))
                                                                -V(t,i)*V(t,j)*(gl(e)*cos(fi(t,i)-fi(t,j)-shift(e)) + bl(e)*sin(fi(t,i)-fi(t,j)-shift(e)))/tap(e);

equ(m1_power_to)(t,arcs_to(e,i,j))..             P(t,e,i,j) =e=  V(t,i)*V(t,i)*(gl(e) + gl_to(e))
                                                                -V(t,i)*V(t,j)*(gl(e)*cos(fi(t,i)-fi(t,j)+shift(e)) + bl(e)*sin(fi(t,i)-fi(t,j)+shift(e)))/tap(e);

equ(m1_reactive_fr)(t,arcs_from(e,i,j))..        Q(t,e,i,j) =e= -V(t,i)*V(t,i)*(bl(e) + bl_fr(e))/(tap(e)*tap(e))
                                                                -V(t,i)*V(t,j)*(gl(e)*sin(fi(t,i)-fi(t,j)-shift(e)) - bl(e)*cos(fi(t,i)-fi(t,j)-shift(e)))/tap(e);

equ(m1_reactive_to)(t,arcs_to(e,i,j))..          Q(t,e,i,j) =e= -V(t,i)*V(t,i)*(bl(e) + bl_to(e))
                                                                -V(t,i)*V(t,j)*(gl(e)*sin(fi(t,i)-fi(t,j)+shift(e)) - bl(e)*cos(fi(t,i)-fi(t,j)+shift(e)))/tap(e);

equ(m1_linemax)(t,arcs(e,i,j))..                 P(t,e,i,j)*P(t,e,i,j) + Q(t,e,i,j)*Q(t,e,i,j) =l= Slinemax(e)*Slinemax(e);

equ(m1_pg_max)(t,k)..                            Pgen(t,k) =l= (pg_max(k)*x(t,k))$active_p_gen + pg_max(k)$(not active_p_gen);
equ(m1_pg_min)(t,k)..                            Pgen(t,k) =g= (pg_min(k)*x(t,k))$active_p_gen + pg_min(k)$(not active_p_gen);
equ(m1_pq_max)(t,k)..                            Qgen(t,k) =l= (qg_max(k)*x(t,k))$active_p_gen + qg_max(k)$(not active_p_gen);
equ(m1_pq_min)(t,k)..                            Qgen(t,k) =g= (qg_min(k)*x(t,k))$active_p_gen + qg_min(k)$(not active_p_gen);


equ(m1_volt_max)(t,i)..                          V(t,i) =l= vmax(i);
equ(m1_volt_min)(t,i)..                          V(t,i) =g= vmin(i);

equ(m1_ref)(t,ref_buses(i))..                    fi(t,i) =e= 0;

equ(m1_angmax)(t,bus_pairs(i,j))..               fi(t,i) - fi(t,j) =l= angmax(i,j);
equ(m1_angmin)(t,bus_pairs(i,j))..               fi(t,i) - fi(t,j) =g= angmin(i,j);

equ(m1_R_UP)(t,k)$(ramp_up(k)>0 and ord(t)>1)..  Pgen(t,k) - Pgen(t-1,k) =l= ramp_up(k);
equ(m1_R_DN)(t,k)$(ramp_dn(k)<0 and ord(t)>1)..  Pgen(t,k) - Pgen(t-1,k) =g= ramp_dn(k);

equ(m1_3bin_1)(t,k)$active_p_gen..               y(t,k) - z(t,k) =e= x(t,k) - x(t-1,k) - 1$(ord(t)=1);
equ(m1_3bin_2)(t,k)$active_p_gen..               y(t,k) + z(t,k) =l= 1;

equ(m1_3bin_MD)(t,k)$active_p_gen..              sum(h$(ord(h)>=ord(t)-MD(k)+1 and ord(h)<=ord(t)),z(h,k)) =l= 1 - x(t,k);
equ(m1_3bin_MU)(t,k)$active_p_gen..              sum(h$(ord(h)>=ord(t)-MU(k)+1 and ord(h)<=ord(t)),y(h,k)) =l= x(t,k);

model m1_polar/m1_obj,m1_bus_p,m1_bus_q,m1_power_fr,m1_power_to,m1_reactive_fr,m1_reactive_to,m1_linemax,m1_pg_max,m1_pg_min,m1_pq_max,m1_pq_min,
               m1_volt_max,m1_volt_min,m1_ref,m1_angmax,m1_angmin,m1_R_UP,m1_R_DN,m1_3bin_1,m1_3bin_2,m1_3bin_MD,m1_3bin_MU/;

*The model will be run as RMINLP (relaxed binary variables)








