equ(m3_obj)..            obj =e= sum((t,k),Pgen(t,k)*Pgen(t,k)*c2(k) + Pgen(t,k)*c1(k) + (c0(k)*x(t,k) + scost(k)*y(t,k))$active_p_gen + c0(k)$(not active_p_gen) );

equ(m3_bus_p)(t,i)..     sum(bus_gen(i,k),Pgen(t,k)) - sum(bus_loads(i,l),dp(l))*load_f(t) - sum(arcs(e,i,j),P(t,e,i,j)) - (Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*sum(bus_shunts(i,s),gsh(s)) =e= 0;

equ(m3_bus_q)(t,i)..     sum(bus_gen(i,k),Qgen(t,k)) - sum(bus_loads(i,l),dq(l))*load_f(t) - sum(arcs(e,i,j),Q(t,e,i,j)) + (Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*sum(bus_shunts(i,s),bsh(s)) =e= 0;


equ(m3_power_fr)(t,arcs_from(e,i,j))..           P(t,e,i,j) =e=  (Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*(gl(e) + gl_fr(e))/(tap(e)*tap(e))  + v_a(t,e)/2
                                                                -( gl(e)*cos(fit(t,i)-fit(t,j)-shift(e)) + bl(e)*sin(fit(t,i)-fit(t,j)-shift(e)) ) * ( Vt(t,i)*Vt(t,j)*cos_a(t,i,j) + dV(t,i)*Vt(t,j) + dV(t,j)*Vt(t,i) )/tap(e)
                                                                -( bl(e)*cos(fit(t,i)-fit(t,j)-shift(e)) - gl(e)*sin(fit(t,i)-fit(t,j)-shift(e)) ) * ( Vt(t,i)*Vt(t,j)*(dfi(t,i)-dfi(t,j)) )/tap(e) ;

equ(m3_power_to)(t,arcs_to(e,i,j))..             P(t,e,i,j) =e=  (Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*(gl(e) + gl_to(e))                  + v_a(t,e)/2
                                                                -( gl(e)*cos(fit(t,i)-fit(t,j)+shift(e)) + bl(e)*sin(fit(t,i)-fit(t,j)+shift(e)) ) * ( Vt(t,i)*Vt(t,j)*cos_a(t,j,i) + dV(t,i)*Vt(t,j) + dV(t,j)*Vt(t,i) )/tap(e)
                                                                -( bl(e)*cos(fit(t,i)-fit(t,j)+shift(e)) - gl(e)*sin(fit(t,i)-fit(t,j)+shift(e)) ) * ( Vt(t,i)*Vt(t,j)*(dfi(t,i)-dfi(t,j)) )/tap(e) ;


equ(m3_reactive_fr)(t,arcs_from(e,i,j))..        Q(t,e,i,j) =e= -(Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*(bl(e) + bl_fr(e))/(tap(e)*tap(e))
                                                                +( bl(e)*cos(fit(t,i)-fit(t,j)-shift(e)) - gl(e)*sin(fit(t,i)-fit(t,j)-shift(e)) ) * ( Vt(t,i)*Vt(t,j)*cos_a(t,i,j) + dV(t,i)*Vt(t,j) + dV(t,j)*Vt(t,i) )/tap(e)
                                                                -( gl(e)*cos(fit(t,i)-fit(t,j)-shift(e)) + bl(e)*sin(fit(t,i)-fit(t,j)-shift(e)) ) * ( Vt(t,i)*Vt(t,j)*(dfi(t,i)-dfi(t,j)) )/tap(e) ;

equ(m3_reactive_to)(t,arcs_to(e,i,j))..          Q(t,e,i,j) =e= -(Vt(t,i)*Vt(t,i) + 2*Vt(t,i)*dV(t,i) )*(bl(e) + bl_to(e))
                                                                +( bl(e)*cos(fit(t,i)-fit(t,j)+shift(e)) - gl(e)*sin(fit(t,i)-fit(t,j)+shift(e)) ) * ( Vt(t,i)*Vt(t,j)*cos_a(t,j,i) + dV(t,i)*Vt(t,j) + dV(t,j)*Vt(t,i) )/tap(e)
                                                                -( gl(e)*cos(fit(t,i)-fit(t,j)+shift(e)) + bl(e)*sin(fit(t,i)-fit(t,j)+shift(e)) ) * ( Vt(t,i)*Vt(t,j)*(dfi(t,i)-dfi(t,j)) )/tap(e) ;



*The only constraint definition difference between step2 and step3 is in the (2.8.x) and (2.9.x) constraints.

equ(m3_v_a_1)(t,arcs_from(e,i,j))$(m2_v_a.m(t,e,i,j)>0 and gl(e)>0)..            v_a(t,e) =g= (gl(e) + gl_fr(e))*dV(t,i)*dV(t,i)/(tap(e)*tap(e))
                                                                                              - 2*gl(e)*cos(fit(t,i)-fit(t,j)-shift(e))*dV(t,i)*dV(t,j)/tap(e)
                                                                                              + (gl(e) + gl_to(e))*dV(t,j)*dV(t,j) ;

equ(m3_v_a_2)(t,arcs_from(e,i,j))$(m2_v_a.m(t,e,i,j)<=0 or gl(e)<=0)..           v_a(t,e) =e= 0;


*Consider scaling the following two constraint with the factor 100 (multiplying both sides of the constraints), mostly useful for CPLEX.
equ(m3_cos_a_1)(t,bus_pairs(i,j))$(m2_cos_a.m(t,i,j)<0)..                        cos_a(t,i,j) =l= 1 - (dfi(t,i)-dfi(t,j))*(dfi(t,i)-dfi(t,j))/2;

equ(m3_cos_a_2)(t,bus_pairs(i,j))$(m2_cos_a.m(t,i,j)>=0)..                       cos_a(t,i,j) =e= 1;



equ(m3_linemax)(t,arcs(e,i,j))..                 P(t,e,i,j)*P(t,e,i,j) + Q(t,e,i,j)*Q(t,e,i,j) =l= Slinemax(e)*Slinemax(e);

equ(m3_pg_max)(t,k)..                            Pgen(t,k) =l= (pg_max(k)*x(t,k))$active_p_gen + pg_max(k)$(not active_p_gen);
equ(m3_pg_min)(t,k)..                            Pgen(t,k) =g= (pg_min(k)*x(t,k))$active_p_gen + pg_min(k)$(not active_p_gen);
equ(m3_pq_max)(t,k)..                            Qgen(t,k) =l= (qg_max(k)*x(t,k))$active_p_gen + qg_max(k)$(not active_p_gen);
equ(m3_pq_min)(t,k)..                            Qgen(t,k) =g= (qg_min(k)*x(t,k))$active_p_gen + qg_min(k)$(not active_p_gen);


equ(m3_volt_max)(t,i)..                          dV(t,i) + Vt(t,i) =l= vmax(i);
equ(m3_volt_min)(t,i)..                          dV(t,i) + Vt(t,i) =g= vmin(i);

equ(m3_ref)(t,ref_buses(i))..                    dfi(t,i) + fit(t,i) =e= 0;

equ(m3_angmax)(t,bus_pairs(i,j))..               ( dfi(t,i)+fit(t,i) ) - ( dfi(t,j)+fit(t,j) ) =l= angmax(i,j);
equ(m3_angmin)(t,bus_pairs(i,j))..               ( dfi(t,i)+fit(t,i) ) - ( dfi(t,j)+fit(t,j) ) =g= angmin(i,j);

equ(m3_R_UP)(t,k)$(ramp_up(k)>0 and ord(t)>1)..  Pgen(t,k) - Pgen(t-1,k) =l= ramp_up(k);
equ(m3_R_DN)(t,k)$(ramp_dn(k)<0 and ord(t)>1)..  Pgen(t,k) - Pgen(t-1,k) =g= ramp_dn(k);

equ(m3_3bin_1)(t,k)$active_p_gen..               y(t,k) - z(t,k) =e= x(t,k) - x(t-1,k) - 1$(ord(t)=1);
equ(m3_3bin_2)(t,k)$active_p_gen..               y(t,k) + z(t,k) =l= 1;

equ(m3_3bin_MD)(t,k)$active_p_gen..              sum(tt$(ord(tt)>=ord(t)-MD(k)+1 and ord(tt)<=ord(t)),z(tt,k)) =l= 1 - x(t,k);
equ(m3_3bin_MU)(t,k)$active_p_gen..              sum(tt$(ord(tt)>=ord(t)-MU(k)+1 and ord(tt)<=ord(t)),y(tt,k)) =l= x(t,k);


model m3_UC /m3_obj,m3_bus_p,m3_bus_q,m3_power_fr,m3_power_to,m3_reactive_fr,m3_reactive_to,m3_v_a_1,m3_v_a_2,m3_cos_a_1,m3_cos_a_2,m3_linemax,m3_pg_max,m3_pg_min,m3_pq_max,m3_pq_min,
             m3_volt_max,m3_volt_min,m3_ref,m3_angmax,m3_angmin,m3_R_UP,m3_R_DN,m3_3bin_1,m3_3bin_2,m3_3bin_MD,m3_3bin_MU/;

*The model is MIQCP
