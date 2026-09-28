module alu_top (carry,
    clk,
    negative,
    overflow,
    rst_n,
    zero,
    a,
    b,
    op,
    y);
 output carry;
 input clk;
 output negative;
 output overflow;
 input rst_n;
 output zero;
 input [7:0] a;
 input [7:0] b;
 input [2:0] op;
 output [7:0] y;

 wire _000_;
 wire _001_;
 wire _002_;
 wire _003_;
 wire _004_;
 wire _005_;
 wire _006_;
 wire _007_;
 wire _008_;
 wire _009_;
 wire _010_;
 wire _011_;
 wire _012_;
 wire _013_;
 wire _014_;
 wire _015_;
 wire _016_;
 wire _017_;
 wire _018_;
 wire _019_;
 wire _020_;
 wire _021_;
 wire _022_;
 wire _023_;
 wire _024_;
 wire _025_;
 wire _026_;
 wire _027_;
 wire _028_;
 wire _029_;
 wire _030_;
 wire _031_;
 wire _032_;
 wire _033_;
 wire _034_;
 wire _035_;
 wire _036_;
 wire _037_;
 wire _038_;
 wire _039_;
 wire _040_;
 wire _041_;
 wire _042_;
 wire _043_;
 wire _044_;
 wire _045_;
 wire _046_;
 wire _047_;
 wire _048_;
 wire _049_;
 wire _050_;
 wire _051_;
 wire _052_;
 wire _053_;
 wire _054_;
 wire _055_;
 wire _056_;
 wire _057_;
 wire _058_;
 wire _059_;
 wire _060_;
 wire _061_;
 wire _062_;
 wire _063_;
 wire _064_;
 wire _065_;
 wire _066_;
 wire _067_;
 wire _068_;
 wire _069_;
 wire _070_;
 wire _071_;
 wire _072_;
 wire _073_;
 wire _074_;
 wire _075_;
 wire _076_;
 wire _077_;
 wire _078_;
 wire _079_;
 wire _080_;
 wire _081_;
 wire _082_;
 wire _083_;
 wire _084_;
 wire _085_;
 wire _086_;
 wire _087_;
 wire _088_;
 wire _089_;
 wire _090_;
 wire _091_;
 wire _092_;
 wire _093_;
 wire _094_;
 wire _095_;
 wire _096_;
 wire _097_;
 wire _098_;
 wire _099_;
 wire _100_;
 wire _101_;
 wire _102_;
 wire _103_;
 wire _104_;
 wire _105_;
 wire _106_;
 wire _107_;
 wire _108_;
 wire _109_;
 wire _110_;
 wire _111_;
 wire _112_;
 wire _113_;
 wire _114_;
 wire _115_;
 wire _116_;
 wire _117_;
 wire _118_;
 wire _119_;
 wire _120_;
 wire _121_;
 wire _122_;
 wire _123_;
 wire _124_;
 wire _125_;
 wire _126_;
 wire _127_;
 wire _128_;
 wire _129_;
 wire _130_;
 wire _131_;
 wire _132_;
 wire _133_;
 wire _134_;
 wire _135_;
 wire _136_;
 wire _137_;
 wire _138_;
 wire _139_;
 wire _140_;
 wire _141_;
 wire _142_;
 wire _143_;
 wire _144_;
 wire _145_;
 wire _146_;
 wire \a_q[0] ;
 wire \a_q[1] ;
 wire \a_q[2] ;
 wire \a_q[3] ;
 wire \a_q[4] ;
 wire \a_q[5] ;
 wire \a_q[6] ;
 wire \a_q[7] ;
 wire \b_q[0] ;
 wire \b_q[1] ;
 wire \b_q[2] ;
 wire \b_q[3] ;
 wire \b_q[4] ;
 wire \b_q[5] ;
 wire \b_q[6] ;
 wire \b_q[7] ;
 wire \op_q[0] ;
 wire \op_q[1] ;
 wire \op_q[2] ;

 sky130_fd_sc_hd__o211a_2 _147_ (.A1(\a_q[2] ),
    .A2(_069_),
    .B1(_068_),
    .C1(_067_),
    .X(_070_));
 sky130_fd_sc_hd__o211a_2 _148_ (.A1(_146_),
    .A2(_051_),
    .B1(_053_),
    .C1(_070_),
    .X(_071_));
 sky130_fd_sc_hd__o21ai_2 _149_ (.A1(_031_),
    .A2(_058_),
    .B1(_071_),
    .Y(_072_));
 sky130_fd_sc_hd__o221a_2 _150_ (.A1(\a_q[3] ),
    .A2(_053_),
    .B1(_066_),
    .B2(_072_),
    .C1(rst_n),
    .X(_003_));
 sky130_fd_sc_hd__a21oi_2 _151_ (.A1(_146_),
    .A2(_039_),
    .B1(_040_),
    .Y(_073_));
 sky130_fd_sc_hd__a31o_2 _152_ (.A1(_146_),
    .A2(_039_),
    .A3(_040_),
    .B1(_126_),
    .X(_074_));
 sky130_fd_sc_hd__nand2_2 _153_ (.A(\a_q[2] ),
    .B(_060_),
    .Y(_075_));
 sky130_fd_sc_hd__o21ai_2 _154_ (.A1(\a_q[3] ),
    .A2(\b_q[3] ),
    .B1(_047_),
    .Y(_076_));
 sky130_fd_sc_hd__o211a_2 _155_ (.A1(\a_q[3] ),
    .A2(_069_),
    .B1(_075_),
    .C1(_076_),
    .X(_077_));
 sky130_fd_sc_hd__o22a_2 _156_ (.A1(_144_),
    .A2(_051_),
    .B1(_058_),
    .B2(_040_),
    .X(_078_));
 sky130_fd_sc_hd__and3_2 _157_ (.A(_053_),
    .B(_077_),
    .C(_078_),
    .X(_079_));
 sky130_fd_sc_hd__o21ai_2 _158_ (.A1(_073_),
    .A2(_074_),
    .B1(_079_),
    .Y(_080_));
 sky130_fd_sc_hd__o211a_2 _159_ (.A1(\a_q[4] ),
    .A2(_053_),
    .B1(_080_),
    .C1(rst_n),
    .X(_004_));
 sky130_fd_sc_hd__nand2_2 _160_ (.A(_141_),
    .B(_041_),
    .Y(_081_));
 sky130_fd_sc_hd__o21ai_2 _161_ (.A1(\a_q[4] ),
    .A2(\b_q[4] ),
    .B1(_047_),
    .Y(_082_));
 sky130_fd_sc_hd__nand2_2 _162_ (.A(\a_q[3] ),
    .B(_060_),
    .Y(_083_));
 sky130_fd_sc_hd__o211a_2 _163_ (.A1(\a_q[4] ),
    .A2(_069_),
    .B1(_082_),
    .C1(_083_),
    .X(_084_));
 sky130_fd_sc_hd__o211a_2 _164_ (.A1(_141_),
    .A2(_058_),
    .B1(_084_),
    .C1(_053_),
    .X(_085_));
 sky130_fd_sc_hd__o21ai_2 _165_ (.A1(_139_),
    .A2(_051_),
    .B1(_085_),
    .Y(_086_));
 sky130_fd_sc_hd__a31o_2 _166_ (.A1(_125_),
    .A2(_042_),
    .A3(_081_),
    .B1(_086_),
    .X(_087_));
 sky130_fd_sc_hd__o211a_2 _167_ (.A1(\a_q[5] ),
    .A2(_053_),
    .B1(_087_),
    .C1(rst_n),
    .X(_005_));
 sky130_fd_sc_hd__and3_2 _168_ (.A(_137_),
    .B(_139_),
    .C(_042_),
    .X(_088_));
 sky130_fd_sc_hd__o21ai_2 _169_ (.A1(\a_q[5] ),
    .A2(\b_q[5] ),
    .B1(_047_),
    .Y(_089_));
 sky130_fd_sc_hd__nand2_2 _170_ (.A(\a_q[4] ),
    .B(_060_),
    .Y(_090_));
 sky130_fd_sc_hd__o2111a_2 _171_ (.A1(\a_q[5] ),
    .A2(_048_),
    .B1(_053_),
    .C1(_089_),
    .D1(_090_),
    .X(_091_));
 sky130_fd_sc_hd__nand2_2 _172_ (.A(_135_),
    .B(_052_),
    .Y(_092_));
 sky130_fd_sc_hd__o211a_2 _173_ (.A1(_137_),
    .A2(_058_),
    .B1(_091_),
    .C1(_092_),
    .X(_093_));
 sky130_fd_sc_hd__o31ai_2 _174_ (.A1(_126_),
    .A2(_043_),
    .A3(_088_),
    .B1(_093_),
    .Y(_094_));
 sky130_fd_sc_hd__o211a_2 _175_ (.A1(\a_q[6] ),
    .A2(_053_),
    .B1(_094_),
    .C1(rst_n),
    .X(_006_));
 sky130_fd_sc_hd__nand2_2 _176_ (.A(_131_),
    .B(_133_),
    .Y(_095_));
 sky130_fd_sc_hd__inv_2 _177_ (.A(_095_),
    .Y(_096_));
 sky130_fd_sc_hd__o21ai_2 _178_ (.A1(_135_),
    .A2(_043_),
    .B1(_096_),
    .Y(_097_));
 sky130_fd_sc_hd__o31a_2 _179_ (.A1(_135_),
    .A2(_043_),
    .A3(_096_),
    .B1(_125_),
    .X(_098_));
 sky130_fd_sc_hd__o21ai_2 _180_ (.A1(\a_q[6] ),
    .A2(\b_q[6] ),
    .B1(_047_),
    .Y(_099_));
 sky130_fd_sc_hd__nand2_2 _181_ (.A(\a_q[5] ),
    .B(_060_),
    .Y(_100_));
 sky130_fd_sc_hd__o211a_2 _182_ (.A1(\a_q[6] ),
    .A2(_069_),
    .B1(_099_),
    .C1(_100_),
    .X(_101_));
 sky130_fd_sc_hd__o22a_2 _183_ (.A1(_131_),
    .A2(_051_),
    .B1(_058_),
    .B2(_095_),
    .X(_102_));
 sky130_fd_sc_hd__and3_2 _184_ (.A(_053_),
    .B(_101_),
    .C(_102_),
    .X(_103_));
 sky130_fd_sc_hd__a21bo_2 _185_ (.A1(_097_),
    .A2(_098_),
    .B1_N(_103_),
    .X(_104_));
 sky130_fd_sc_hd__o211a_2 _186_ (.A1(\a_q[7] ),
    .A2(_053_),
    .B1(_104_),
    .C1(rst_n),
    .X(_007_));
 sky130_fd_sc_hd__o21ba_2 _187_ (.A1(_044_),
    .A2(_045_),
    .B1_N(_129_),
    .X(_105_));
 sky130_fd_sc_hd__and3_2 _188_ (.A(rst_n),
    .B(_125_),
    .C(_105_),
    .X(_008_));
 sky130_fd_sc_hd__nor2_2 _189_ (.A(_129_),
    .B(_045_),
    .Y(_106_));
 sky130_fd_sc_hd__nand2_2 _190_ (.A(_044_),
    .B(_106_),
    .Y(_107_));
 sky130_fd_sc_hd__or2_2 _191_ (.A(_044_),
    .B(_106_),
    .X(_108_));
 sky130_fd_sc_hd__and2b_2 _192_ (.A_N(_058_),
    .B(_106_),
    .X(_109_));
 sky130_fd_sc_hd__nor2_2 _193_ (.A(\a_q[7] ),
    .B(_069_),
    .Y(_110_));
 sky130_fd_sc_hd__or2_2 _194_ (.A(\b_q[7] ),
    .B(\a_q[7] ),
    .X(_111_));
 sky130_fd_sc_hd__a221o_2 _195_ (.A1(\a_q[6] ),
    .A2(_060_),
    .B1(_111_),
    .B2(_047_),
    .C1(_110_),
    .X(_112_));
 sky130_fd_sc_hd__a211o_2 _196_ (.A1(_045_),
    .A2(_052_),
    .B1(_109_),
    .C1(_112_),
    .X(_113_));
 sky130_fd_sc_hd__a31o_2 _197_ (.A1(_125_),
    .A2(_107_),
    .A3(_108_),
    .B1(_113_),
    .X(_114_));
 sky130_fd_sc_hd__and2_2 _198_ (.A(rst_n),
    .B(_114_),
    .X(_010_));
 sky130_fd_sc_hd__or3_2 _199_ (.A(_001_),
    .B(_002_),
    .C(_003_),
    .X(_115_));
 sky130_fd_sc_hd__or4_2 _200_ (.A(_004_),
    .B(_005_),
    .C(_006_),
    .D(_115_),
    .X(_116_));
 sky130_fd_sc_hd__a211oi_2 _201_ (.A1(rst_n),
    .A2(_114_),
    .B1(_116_),
    .C1(_007_),
    .Y(_009_));
 sky130_fd_sc_hd__and2_2 _202_ (.A(rst_n),
    .B(a[0]),
    .X(_011_));
 sky130_fd_sc_hd__and2_2 _203_ (.A(rst_n),
    .B(a[1]),
    .X(_012_));
 sky130_fd_sc_hd__and2_2 _204_ (.A(rst_n),
    .B(a[2]),
    .X(_013_));
 sky130_fd_sc_hd__and2_2 _205_ (.A(rst_n),
    .B(a[3]),
    .X(_014_));
 sky130_fd_sc_hd__and2_2 _206_ (.A(rst_n),
    .B(a[4]),
    .X(_015_));
 sky130_fd_sc_hd__and2_2 _207_ (.A(rst_n),
    .B(a[5]),
    .X(_016_));
 sky130_fd_sc_hd__and2_2 _208_ (.A(rst_n),
    .B(a[6]),
    .X(_017_));
 sky130_fd_sc_hd__and2_2 _209_ (.A(rst_n),
    .B(a[7]),
    .X(_018_));
 sky130_fd_sc_hd__and2_2 _210_ (.A(rst_n),
    .B(b[0]),
    .X(_019_));
 sky130_fd_sc_hd__and2_2 _211_ (.A(rst_n),
    .B(b[1]),
    .X(_020_));
 sky130_fd_sc_hd__and2_2 _212_ (.A(rst_n),
    .B(b[2]),
    .X(_021_));
 sky130_fd_sc_hd__and2_2 _213_ (.A(rst_n),
    .B(b[3]),
    .X(_022_));
 sky130_fd_sc_hd__and2_2 _214_ (.A(rst_n),
    .B(b[4]),
    .X(_023_));
 sky130_fd_sc_hd__and2_2 _215_ (.A(rst_n),
    .B(b[5]),
    .X(_024_));
 sky130_fd_sc_hd__and2_2 _216_ (.A(rst_n),
    .B(b[6]),
    .X(_025_));
 sky130_fd_sc_hd__and2_2 _217_ (.A(rst_n),
    .B(b[7]),
    .X(_026_));
 sky130_fd_sc_hd__and2_2 _218_ (.A(rst_n),
    .B(op[0]),
    .X(_027_));
 sky130_fd_sc_hd__and2_2 _219_ (.A(rst_n),
    .B(op[1]),
    .X(_028_));
 sky130_fd_sc_hd__and2_2 _220_ (.A(rst_n),
    .B(op[2]),
    .X(_029_));
 sky130_fd_sc_hd__inv_2 _221_ (.A(\op_q[1] ),
    .Y(_117_));
 sky130_fd_sc_hd__inv_2 _222_ (.A(\a_q[7] ),
    .Y(_118_));
 sky130_fd_sc_hd__inv_2 _223_ (.A(\a_q[6] ),
    .Y(_119_));
 sky130_fd_sc_hd__inv_2 _224_ (.A(\a_q[5] ),
    .Y(_120_));
 sky130_fd_sc_hd__inv_2 _225_ (.A(\a_q[4] ),
    .Y(_121_));
 sky130_fd_sc_hd__inv_2 _226_ (.A(\a_q[3] ),
    .Y(_122_));
 sky130_fd_sc_hd__inv_2 _227_ (.A(\a_q[2] ),
    .Y(_123_));
 sky130_fd_sc_hd__inv_2 _228_ (.A(\a_q[1] ),
    .Y(_124_));
 sky130_fd_sc_hd__nor2_2 _229_ (.A(\op_q[2] ),
    .B(\op_q[1] ),
    .Y(_125_));
 sky130_fd_sc_hd__or2_2 _230_ (.A(\op_q[2] ),
    .B(\op_q[1] ),
    .X(_126_));
 sky130_fd_sc_hd__or3b_2 _231_ (.A(\op_q[2] ),
    .B(\op_q[1] ),
    .C_N(\op_q[0] ),
    .X(_127_));
 sky130_fd_sc_hd__xor2_2 _232_ (.A(\b_q[7] ),
    .B(_127_),
    .X(_128_));
 sky130_fd_sc_hd__and2_2 _233_ (.A(_118_),
    .B(_128_),
    .X(_129_));
 sky130_fd_sc_hd__xor2_2 _234_ (.A(\b_q[6] ),
    .B(_127_),
    .X(_130_));
 sky130_fd_sc_hd__or2_2 _235_ (.A(_119_),
    .B(_130_),
    .X(_131_));
 sky130_fd_sc_hd__inv_2 _236_ (.A(_131_),
    .Y(_132_));
 sky130_fd_sc_hd__nand2_2 _237_ (.A(_119_),
    .B(_130_),
    .Y(_133_));
 sky130_fd_sc_hd__xor2_2 _238_ (.A(\b_q[5] ),
    .B(_127_),
    .X(_134_));
 sky130_fd_sc_hd__nor2_2 _239_ (.A(_120_),
    .B(_134_),
    .Y(_135_));
 sky130_fd_sc_hd__nand2_2 _240_ (.A(_120_),
    .B(_134_),
    .Y(_136_));
 sky130_fd_sc_hd__nand2b_2 _241_ (.A_N(_135_),
    .B(_136_),
    .Y(_137_));
 sky130_fd_sc_hd__xor2_2 _242_ (.A(\b_q[4] ),
    .B(_127_),
    .X(_138_));
 sky130_fd_sc_hd__or2_2 _243_ (.A(_121_),
    .B(_138_),
    .X(_139_));
 sky130_fd_sc_hd__nand2_2 _244_ (.A(_121_),
    .B(_138_),
    .Y(_140_));
 sky130_fd_sc_hd__nand2_2 _245_ (.A(_139_),
    .B(_140_),
    .Y(_141_));
 sky130_fd_sc_hd__xor2_2 _246_ (.A(\b_q[3] ),
    .B(_127_),
    .X(_142_));
 sky130_fd_sc_hd__and2_2 _247_ (.A(_122_),
    .B(_142_),
    .X(_143_));
 sky130_fd_sc_hd__or2_2 _248_ (.A(_122_),
    .B(_142_),
    .X(_144_));
 sky130_fd_sc_hd__xor2_2 _249_ (.A(\b_q[2] ),
    .B(_127_),
    .X(_145_));
 sky130_fd_sc_hd__or2_2 _250_ (.A(_123_),
    .B(_145_),
    .X(_146_));
 sky130_fd_sc_hd__nand2_2 _251_ (.A(_123_),
    .B(_145_),
    .Y(_030_));
 sky130_fd_sc_hd__nand2_2 _252_ (.A(_146_),
    .B(_030_),
    .Y(_031_));
 sky130_fd_sc_hd__xor2_2 _253_ (.A(\b_q[1] ),
    .B(_127_),
    .X(_032_));
 sky130_fd_sc_hd__or2_2 _254_ (.A(_124_),
    .B(_032_),
    .X(_033_));
 sky130_fd_sc_hd__xnor2_2 _255_ (.A(\a_q[1] ),
    .B(_032_),
    .Y(_034_));
 sky130_fd_sc_hd__inv_2 _256_ (.A(_034_),
    .Y(_035_));
 sky130_fd_sc_hd__nand2_2 _257_ (.A(\b_q[0] ),
    .B(\a_q[0] ),
    .Y(_036_));
 sky130_fd_sc_hd__o21ai_2 _258_ (.A1(\b_q[0] ),
    .A2(_127_),
    .B1(_036_),
    .Y(_037_));
 sky130_fd_sc_hd__nand2_2 _259_ (.A(_034_),
    .B(_037_),
    .Y(_038_));
 sky130_fd_sc_hd__a21o_2 _260_ (.A1(_033_),
    .A2(_038_),
    .B1(_031_),
    .X(_039_));
 sky130_fd_sc_hd__nand2b_2 _261_ (.A_N(_143_),
    .B(_144_),
    .Y(_040_));
 sky130_fd_sc_hd__a31o_2 _262_ (.A1(_144_),
    .A2(_146_),
    .A3(_039_),
    .B1(_143_),
    .X(_041_));
 sky130_fd_sc_hd__a311o_2 _263_ (.A1(_144_),
    .A2(_146_),
    .A3(_039_),
    .B1(_143_),
    .C1(_141_),
    .X(_042_));
 sky130_fd_sc_hd__a21oi_2 _264_ (.A1(_139_),
    .A2(_042_),
    .B1(_137_),
    .Y(_043_));
 sky130_fd_sc_hd__o31a_2 _265_ (.A1(_132_),
    .A2(_135_),
    .A3(_043_),
    .B1(_133_),
    .X(_044_));
 sky130_fd_sc_hd__nor2_2 _266_ (.A(_118_),
    .B(_128_),
    .Y(_045_));
 sky130_fd_sc_hd__mux2_1 _267_ (.A0(_045_),
    .A1(_129_),
    .S(_044_),
    .X(_046_));
 sky130_fd_sc_hd__and3_2 _268_ (.A(rst_n),
    .B(_125_),
    .C(_046_),
    .X(_000_));
 sky130_fd_sc_hd__and3b_2 _269_ (.A_N(\op_q[2] ),
    .B(\op_q[1] ),
    .C(\op_q[0] ),
    .X(_047_));
 sky130_fd_sc_hd__nand2_2 _270_ (.A(\op_q[2] ),
    .B(\op_q[0] ),
    .Y(_048_));
 sky130_fd_sc_hd__a31o_2 _271_ (.A1(_117_),
    .A2(_036_),
    .A3(_048_),
    .B1(_047_),
    .X(_049_));
 sky130_fd_sc_hd__o21ai_2 _272_ (.A1(\b_q[0] ),
    .A2(\a_q[0] ),
    .B1(_049_),
    .Y(_050_));
 sky130_fd_sc_hd__or3_2 _273_ (.A(\op_q[2] ),
    .B(_117_),
    .C(\op_q[0] ),
    .X(_051_));
 sky130_fd_sc_hd__inv_2 _274_ (.A(_051_),
    .Y(_052_));
 sky130_fd_sc_hd__or2_2 _275_ (.A(_117_),
    .B(_048_),
    .X(_053_));
 sky130_fd_sc_hd__o221a_2 _276_ (.A1(\a_q[0] ),
    .A2(_048_),
    .B1(_051_),
    .B2(_036_),
    .C1(_053_),
    .X(_054_));
 sky130_fd_sc_hd__nand2_2 _277_ (.A(_050_),
    .B(_054_),
    .Y(_055_));
 sky130_fd_sc_hd__o211a_2 _278_ (.A1(\a_q[1] ),
    .A2(_053_),
    .B1(_055_),
    .C1(rst_n),
    .X(_001_));
 sky130_fd_sc_hd__or2_2 _279_ (.A(_034_),
    .B(_037_),
    .X(_056_));
 sky130_fd_sc_hd__and3_2 _280_ (.A(_125_),
    .B(_038_),
    .C(_056_),
    .X(_057_));
 sky130_fd_sc_hd__or3b_2 _281_ (.A(\op_q[1] ),
    .B(\op_q[0] ),
    .C_N(\op_q[2] ),
    .X(_058_));
 sky130_fd_sc_hd__o21ai_2 _282_ (.A1(\a_q[1] ),
    .A2(\b_q[1] ),
    .B1(_047_),
    .Y(_059_));
 sky130_fd_sc_hd__and3b_2 _283_ (.A_N(\op_q[0] ),
    .B(\op_q[1] ),
    .C(\op_q[2] ),
    .X(_060_));
 sky130_fd_sc_hd__nand2_2 _284_ (.A(\a_q[0] ),
    .B(_060_),
    .Y(_061_));
 sky130_fd_sc_hd__o211a_2 _285_ (.A1(\a_q[1] ),
    .A2(_048_),
    .B1(_053_),
    .C1(_061_),
    .X(_062_));
 sky130_fd_sc_hd__o211a_2 _286_ (.A1(_033_),
    .A2(_051_),
    .B1(_059_),
    .C1(_062_),
    .X(_063_));
 sky130_fd_sc_hd__o21ai_2 _287_ (.A1(_035_),
    .A2(_058_),
    .B1(_063_),
    .Y(_064_));
 sky130_fd_sc_hd__o221a_2 _288_ (.A1(\a_q[2] ),
    .A2(_053_),
    .B1(_057_),
    .B2(_064_),
    .C1(rst_n),
    .X(_002_));
 sky130_fd_sc_hd__nand3_2 _289_ (.A(_031_),
    .B(_033_),
    .C(_038_),
    .Y(_065_));
 sky130_fd_sc_hd__and3_2 _290_ (.A(_125_),
    .B(_039_),
    .C(_065_),
    .X(_066_));
 sky130_fd_sc_hd__nand2_2 _291_ (.A(\a_q[1] ),
    .B(_060_),
    .Y(_067_));
 sky130_fd_sc_hd__o21ai_2 _292_ (.A1(\a_q[2] ),
    .A2(\b_q[2] ),
    .B1(_047_),
    .Y(_068_));
 sky130_fd_sc_hd__or2_2 _293_ (.A(\op_q[1] ),
    .B(_048_),
    .X(_069_));
 sky130_fd_sc_hd__dfxtp_2 _294_ (.CLK(clk),
    .D(_000_),
    .Q(overflow));
 sky130_fd_sc_hd__dfxtp_2 _295_ (.CLK(clk),
    .D(_001_),
    .Q(y[0]));
 sky130_fd_sc_hd__dfxtp_2 _296_ (.CLK(clk),
    .D(_002_),
    .Q(y[1]));
 sky130_fd_sc_hd__dfxtp_2 _297_ (.CLK(clk),
    .D(_003_),
    .Q(y[2]));
 sky130_fd_sc_hd__dfxtp_2 _298_ (.CLK(clk),
    .D(_004_),
    .Q(y[3]));
 sky130_fd_sc_hd__dfxtp_2 _299_ (.CLK(clk),
    .D(_005_),
    .Q(y[4]));
 sky130_fd_sc_hd__dfxtp_2 _300_ (.CLK(clk),
    .D(_006_),
    .Q(y[5]));
 sky130_fd_sc_hd__dfxtp_2 _301_ (.CLK(clk),
    .D(_007_),
    .Q(y[6]));
 sky130_fd_sc_hd__dfxtp_2 _302_ (.CLK(clk),
    .D(_008_),
    .Q(carry));
 sky130_fd_sc_hd__dfxtp_2 _303_ (.CLK(clk),
    .D(_009_),
    .Q(zero));
 sky130_fd_sc_hd__dfxtp_2 _304_ (.CLK(clk),
    .D(_010_),
    .Q(negative));
 sky130_fd_sc_hd__dfxtp_2 _305_ (.CLK(clk),
    .D(_011_),
    .Q(\a_q[0] ));
 sky130_fd_sc_hd__dfxtp_2 _306_ (.CLK(clk),
    .D(_012_),
    .Q(\a_q[1] ));
 sky130_fd_sc_hd__dfxtp_2 _307_ (.CLK(clk),
    .D(_013_),
    .Q(\a_q[2] ));
 sky130_fd_sc_hd__dfxtp_2 _308_ (.CLK(clk),
    .D(_014_),
    .Q(\a_q[3] ));
 sky130_fd_sc_hd__dfxtp_2 _309_ (.CLK(clk),
    .D(_015_),
    .Q(\a_q[4] ));
 sky130_fd_sc_hd__dfxtp_2 _310_ (.CLK(clk),
    .D(_016_),
    .Q(\a_q[5] ));
 sky130_fd_sc_hd__dfxtp_2 _311_ (.CLK(clk),
    .D(_017_),
    .Q(\a_q[6] ));
 sky130_fd_sc_hd__dfxtp_2 _312_ (.CLK(clk),
    .D(_018_),
    .Q(\a_q[7] ));
 sky130_fd_sc_hd__dfxtp_2 _313_ (.CLK(clk),
    .D(_019_),
    .Q(\b_q[0] ));
 sky130_fd_sc_hd__dfxtp_2 _314_ (.CLK(clk),
    .D(_020_),
    .Q(\b_q[1] ));
 sky130_fd_sc_hd__dfxtp_2 _315_ (.CLK(clk),
    .D(_021_),
    .Q(\b_q[2] ));
 sky130_fd_sc_hd__dfxtp_2 _316_ (.CLK(clk),
    .D(_022_),
    .Q(\b_q[3] ));
 sky130_fd_sc_hd__dfxtp_2 _317_ (.CLK(clk),
    .D(_023_),
    .Q(\b_q[4] ));
 sky130_fd_sc_hd__dfxtp_2 _318_ (.CLK(clk),
    .D(_024_),
    .Q(\b_q[5] ));
 sky130_fd_sc_hd__dfxtp_2 _319_ (.CLK(clk),
    .D(_025_),
    .Q(\b_q[6] ));
 sky130_fd_sc_hd__dfxtp_2 _320_ (.CLK(clk),
    .D(_026_),
    .Q(\b_q[7] ));
 sky130_fd_sc_hd__dfxtp_2 _321_ (.CLK(clk),
    .D(_027_),
    .Q(\op_q[0] ));
 sky130_fd_sc_hd__dfxtp_2 _322_ (.CLK(clk),
    .D(_028_),
    .Q(\op_q[1] ));
 sky130_fd_sc_hd__dfxtp_2 _323_ (.CLK(clk),
    .D(_029_),
    .Q(\op_q[2] ));
 sky130_fd_sc_hd__buf_2 _324_ (.A(negative),
    .X(y[7]));
endmodule
