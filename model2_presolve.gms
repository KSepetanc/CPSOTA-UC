equ(m2_obj)..            obj =e= sum((t,k),Pgen(t,k)*Pgen(t,k)*c2(k) + Pgen(t,k)*c1(k) + (c0(k)*x.l(t,k) + scost(k)*y.l(t,k))$active_p_gen + c0(k)$(not active_p_gen) );

equ(m2_bus_p)(t,i)..     sum(bus_gen(i,k),Pgen(t,k)) - sum(bus_loads(i,l),dp(l))*load_f(t) - sum(arcs(e,i,j),P(t,e,i,j)) - (Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*sum(bus_shunts(i,s),gsh(s)) =e= 0;

equ(m2_bus_q)(t,i)..     sum(bus_gen(i,k),Qgen(t,k)) - sum(bus_loads(i,l),dq(l))*load_f(t) - sum(arcs(e,i,j),Q(t,e,i,j)) + (Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*sum(bus_shunts(i,s),bsh(s)) =e= 0;


equ(m2_power_fr)(t,arcs_from(e,i,j))..           P(t,e,i,j) =e=  (Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*(gl(e) + gl_fr(e))/(tap(e)*tap(e))  + v_a(t,e)/2
                                                                -( gl(e)*cos(fit(t,i)-fit(t,j)-shift(e)) + bl(e)*sin(fit(t,i)-fit(t,j)-shift(e)) ) * ( Vt(t,i)*Vt(t,j)*cos_a(t,i,j) + dV(t,i)*Vt(t,j) + dV(t,j)*Vt(t,i) )/tap(e)
                                                                -( bl(e)*cos(fit(t,i)-fit(t,j)-shift(e)) - gl(e)*sin(fit(t,i)-fit(t,j)-shift(e)) ) * ( Vt(t,i)*Vt(t,j)*(dfi(t,i)-dfi(t,j)) )/tap(e) ;

equ(m2_power_to)(t,arcs_to(e,i,j))..             P(t,e,i,j) =e=  (Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*(gl(e) + gl_to(e))                  + v_a(t,e)/2
                                                                -( gl(e)*cos(fit(t,i)-fit(t,j)+shift(e)) + bl(e)*sin(fit(t,i)-fit(t,j)+shift(e)) ) * ( Vt(t,i)*Vt(t,j)*cos_a(t,j,i) + dV(t,i)*Vt(t,j) + dV(t,j)*Vt(t,i) )/tap(e)
                                                                -( bl(e)*cos(fit(t,i)-fit(t,j)+shift(e)) - gl(e)*sin(fit(t,i)-fit(t,j)+shift(e)) ) * ( Vt(t,i)*Vt(t,j)*(dfi(t,i)-dfi(t,j)) )/tap(e) ;


equ(m2_reactive_fr)(t,arcs_from(e,i,j))..        Q(t,e,i,j) =e= -(Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*(bl(e) + bl_fr(e))/(tap(e)*tap(e))
                                                                +( bl(e)*cos(fit(t,i)-fit(t,j)-shift(e)) - gl(e)*sin(fit(t,i)-fit(t,j)-shift(e)) ) * ( Vt(t,i)*Vt(t,j)*cos_a(t,i,j) + dV(t,i)*Vt(t,j) + dV(t,j)*Vt(t,i) )/tap(e)
                                                                -( gl(e)*cos(fit(t,i)-fit(t,j)-shift(e)) + bl(e)*sin(fit(t,i)-fit(t,j)-shift(e)) ) * ( Vt(t,i)*Vt(t,j)*(dfi(t,i)-dfi(t,j)) )/tap(e) ;

equ(m2_reactive_to)(t,arcs_to(e,i,j))..          Q(t,e,i,j) =e= -(Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*(bl(e) + bl_to(e))
                                                                +( bl(e)*cos(fit(t,i)-fit(t,j)+shift(e)) - gl(e)*sin(fit(t,i)-fit(t,j)+shift(e)) ) * ( Vt(t,i)*Vt(t,j)*cos_a(t,j,i) + dV(t,i)*Vt(t,j) + dV(t,j)*Vt(t,i) )/tap(e)
                                                                -( gl(e)*cos(fit(t,i)-fit(t,j)+shift(e)) + bl(e)*sin(fit(t,i)-fit(t,j)+shift(e)) ) * ( Vt(t,i)*Vt(t,j)*(dfi(t,i)-dfi(t,j)) )/tap(e) ;

equ(m2_v_a)(t,arcs_from(e,i,j))..                v_a(t,e) =e= (gl(e) + gl_fr(e))*dV(t,i)*dV(t,i)/(tap(e)*tap(e))
                                                              - 2*gl(e)*cos(fit(t,i)-fit(t,j)-shift(e))*dV(t,i)*dV(t,j)/tap(e)
                                                              + (gl(e) + gl_to(e))*dV(t,j)*dV(t,j) ;

equ(m2_cos_a)(t,bus_pairs(i,j))..                cos_a(t,i,j) =e= 1 - (dfi(t,i)-dfi(t,j))*(dfi(t,i)-dfi(t,j))/2;


equ(m2_linemax)(t,arcs(e,i,j))..                 P(t,e,i,j)*P(t,e,i,j) + Q(t,e,i,j)*Q(t,e,i,j) =l= Slinemax(e)*Slinemax(e);

equ(m2_pg_max)(t,k)..                            Pgen(t,k) =l= (pg_max(k)*x.l(t,k))$active_p_gen + pg_max(k)$(not active_p_gen);
equ(m2_pg_min)(t,k)..                            Pgen(t,k) =g= (pg_min(k)*x.l(t,k))$active_p_gen + pg_min(k)$(not active_p_gen);
equ(m2_pq_max)(t,k)..                            Qgen(t,k) =l= (qg_max(k)*x.l(t,k))$active_p_gen + qg_max(k)$(not active_p_gen);
equ(m2_pq_min)(t,k)..                            Qgen(t,k) =g= (qg_min(k)*x.l(t,k))$active_p_gen + qg_min(k)$(not active_p_gen);

equ(m2_volt_max)(t,i)..                          dV(t,i) + Vt(t,i) =l= vmax(i);
equ(m2_volt_min)(t,i)..                          dV(t,i) + Vt(t,i) =g= vmin(i);

equ(m2_ref)(t,ref_buses(i))..                    dfi(t,i) + fit(t,i) =e= 0;

equ(m2_angmax)(t,bus_pairs(i,j))..               ( dfi(t,i)+fit(t,i) ) - ( dfi(t,j)+fit(t,j) ) =l= angmax(i,j);
equ(m2_angmin)(t,bus_pairs(i,j))..               ( dfi(t,i)+fit(t,i) ) - ( dfi(t,j)+fit(t,j) ) =g= angmin(i,j);

equ(m2_R_UP)(t,k)$(ramp_up(k)>0 and ord(t)>1)..  Pgen(t,k) - Pgen(t-1,k) =l= ramp_up(k);
equ(m2_R_DN)(t,k)$(ramp_dn(k)<0 and ord(t)>1)..  Pgen(t,k) - Pgen(t-1,k) =g= ramp_dn(k);


model m2_presolve /m2_obj,m2_bus_p,m2_bus_q,m2_power_fr,m2_power_to,m2_reactive_fr,m2_reactive_to,m2_v_a,m2_cos_a,m2_linemax,m2_pg_max,m2_pg_min,m2_pq_max,m2_pq_min,
                   m2_volt_max,m2_volt_min,m2_ref,m2_angmax,m2_angmin,m2_R_UP,m2_R_DN/;

*The model will be run as NLP (it is nonconvex QCQP)















