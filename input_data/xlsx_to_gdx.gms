$onecho > input_data_copy.txt
i=input_data\\data\%network%
o=input_data\grid_data.gdx

set=i                    rng=Set1!A3             Rdim=1 Cdim=0
set=e                    rng=Set1!C3             Rdim=1 Cdim=0
set=k                    rng=Set1!E3             Rdim=1 Cdim=0
set=l                    rng=Set1!G3             Rdim=1 Cdim=0
set=s                    rng=Set1!I3             Rdim=1 Cdim=0
set=ref_buses            rng=Set1!K3             Rdim=1 Cdim=0

set=arcs_from            rng=Set2!A3             Rdim=3 Cdim=0
set=bus_pairs            rng=Set2!E3             Rdim=2 Cdim=0
set=bus_gen              rng=Set2!H3             Rdim=2 Cdim=0
set=bus_loads            rng=Set2!K3             Rdim=2 Cdim=0
set=bus_shunts           rng=Set2!N3             Rdim=2 Cdim=0

par=bl                   rng=Param1!A3           Rdim=1 Cdim=0
par=gl                   rng=Param1!D3           Rdim=1 Cdim=0
par=bl_fr                rng=Param1!G3           Rdim=1 Cdim=0
par=bl_to                rng=Param1!J3           Rdim=1 Cdim=0
par=gl_fr                rng=Param1!M3           Rdim=1 Cdim=0
par=gl_to                rng=Param1!P3           Rdim=1 Cdim=0
par=Slinemax             rng=Param2!A3           Rdim=1 Cdim=0
par=shift                rng=Param2!D3           Rdim=1 Cdim=0
par=tap                  rng=Param2!G3           Rdim=1 Cdim=0
par=angmin               rng=Param2!J3           Rdim=2 Cdim=0
par=angmax               rng=Param2!N3           Rdim=2 Cdim=0
par=vmax                 rng=Param3!A3           Rdim=1 Cdim=0
par=vmin                 rng=Param3!D3           Rdim=1 Cdim=0
par=dp                   rng=Param3!G3           Rdim=1 Cdim=0
par=dq                   rng=Param3!J3           Rdim=1 Cdim=0
par=gsh                  rng=Param3!M3           Rdim=1 Cdim=0
par=bsh                  rng=Param3!P3           Rdim=1 Cdim=0
par=pg_max               rng=Param4!A3           Rdim=1 Cdim=0
par=pg_min               rng=Param4!D3           Rdim=1 Cdim=0
par=qg_max               rng=Param4!G3           Rdim=1 Cdim=0
par=qg_min               rng=Param4!J3           Rdim=1 Cdim=0
par=c2                   rng=Param4!M3           Rdim=1 Cdim=0
par=c1                   rng=Param4!P3           Rdim=1 Cdim=0
par=c0                   rng=Param4!S3           Rdim=1 Cdim=0


$offecho

$call gdxxrw @input_data_copy.txt


*---------------------------------------------------------------------

$call del /f input_data_copy.txt


