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
 wire _147_;
 wire _148_;
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

 sky130_fd_sc_hd__nand2b_2 _149_ (.A_N(_132_),
    .B(_133_),
    .Y(_079_));
 sky130_fd_sc_hd__xnor2_2 _150_ (.A(_143_),
    .B(_079_),
    .Y(_080_));
 sky130_fd_sc_hd__nor2_2 _151_ (.A(_126_),
    .B(_080_),
    .Y(_081_));
 sky130_fd_sc_hd__o31a_2 _152_ (.A1(\op_q[2] ),
    .A2(\b_q[3] ),
    .A3(\a_q[3] ),
    .B1(_061_),
    .X(_082_));
 sky130_fd_sc_hd__nor2_2 _153_ (.A(\a_q[3] ),
    .B(_046_),
    .Y(_083_));
 sky130_fd_sc_hd__a211o_2 _154_ (.A1(\a_q[2] ),
    .A2(_047_),
    .B1(_082_),
    .C1(_083_),
    .X(_084_));
 sky130_fd_sc_hd__o22ai_2 _155_ (.A1(_133_),
    .A2(_067_),
    .B1(_079_),
    .B2(_053_),
    .Y(_085_));
 sky130_fd_sc_hd__o32a_2 _156_ (.A1(_081_),
    .A2(_084_),
    .A3(_085_),
    .B1(_064_),
    .B2(\a_q[4] ),
    .X(_086_));
 sky130_fd_sc_hd__nand2_2 _157_ (.A(_138_),
    .B(_139_),
    .Y(_087_));
 sky130_fd_sc_hd__xor2_2 _158_ (.A(_141_),
    .B(_087_),
    .X(_088_));
 sky130_fd_sc_hd__o31a_2 _159_ (.A1(\op_q[2] ),
    .A2(\a_q[1] ),
    .A3(\b_q[1] ),
    .B1(_061_),
    .X(_089_));
 sky130_fd_sc_hd__nor2_2 _160_ (.A(\a_q[1] ),
    .B(_046_),
    .Y(_090_));
 sky130_fd_sc_hd__a211o_2 _161_ (.A1(\a_q[0] ),
    .A2(_047_),
    .B1(_089_),
    .C1(_090_),
    .X(_091_));
 sky130_fd_sc_hd__o22ai_2 _162_ (.A1(_138_),
    .A2(_067_),
    .B1(_087_),
    .B2(_053_),
    .Y(_092_));
 sky130_fd_sc_hd__a211o_2 _163_ (.A1(_125_),
    .A2(_088_),
    .B1(_091_),
    .C1(_092_),
    .X(_093_));
 sky130_fd_sc_hd__or2_2 _164_ (.A(\a_q[2] ),
    .B(_064_),
    .X(_094_));
 sky130_fd_sc_hd__o221a_2 _165_ (.A1(_120_),
    .A2(\op_q[0] ),
    .B1(\a_q[0] ),
    .B2(\b_q[0] ),
    .C1(_045_),
    .X(_095_));
 sky130_fd_sc_hd__o21a_2 _166_ (.A1(\op_q[1] ),
    .A2(_140_),
    .B1(_095_),
    .X(_096_));
 sky130_fd_sc_hd__o22ai_2 _167_ (.A1(\a_q[0] ),
    .A2(_046_),
    .B1(_067_),
    .B2(_140_),
    .Y(_097_));
 sky130_fd_sc_hd__a311o_2 _168_ (.A1(\op_q[2] ),
    .A2(\a_q[1] ),
    .A3(_061_),
    .B1(_096_),
    .C1(_097_),
    .X(_098_));
 sky130_fd_sc_hd__a21oi_2 _169_ (.A1(_093_),
    .A2(_094_),
    .B1(_098_),
    .Y(_099_));
 sky130_fd_sc_hd__nand2b_2 _170_ (.A_N(_135_),
    .B(_136_),
    .Y(_100_));
 sky130_fd_sc_hd__a21oi_2 _171_ (.A1(_138_),
    .A2(_142_),
    .B1(_100_),
    .Y(_101_));
 sky130_fd_sc_hd__a31o_2 _172_ (.A1(_138_),
    .A2(_142_),
    .A3(_100_),
    .B1(_126_),
    .X(_102_));
 sky130_fd_sc_hd__o31a_2 _173_ (.A1(\op_q[2] ),
    .A2(\a_q[2] ),
    .A3(\b_q[2] ),
    .B1(_061_),
    .X(_103_));
 sky130_fd_sc_hd__a21oi_2 _174_ (.A1(\a_q[1] ),
    .A2(_047_),
    .B1(_103_),
    .Y(_104_));
 sky130_fd_sc_hd__o221a_2 _175_ (.A1(\a_q[2] ),
    .A2(_046_),
    .B1(_067_),
    .B2(_136_),
    .C1(_104_),
    .X(_105_));
 sky130_fd_sc_hd__o22a_2 _176_ (.A1(_053_),
    .A2(_100_),
    .B1(_101_),
    .B2(_102_),
    .X(_106_));
 sky130_fd_sc_hd__a2bb2o_2 _177_ (.A1_N(\a_q[3] ),
    .A2_N(_064_),
    .B1(_105_),
    .B2(_106_),
    .X(_107_));
 sky130_fd_sc_hd__and4bb_2 _178_ (.A_N(_078_),
    .B_N(_086_),
    .C(_099_),
    .D(_107_),
    .X(_108_));
 sky130_fd_sc_hd__and2b_2 _179_ (.A_N(_146_),
    .B(_147_),
    .X(_109_));
 sky130_fd_sc_hd__a31o_2 _180_ (.A1(_133_),
    .A2(_144_),
    .A3(_033_),
    .B1(_031_),
    .X(_110_));
 sky130_fd_sc_hd__xnor2_2 _181_ (.A(_109_),
    .B(_110_),
    .Y(_111_));
 sky130_fd_sc_hd__or3_2 _182_ (.A(_122_),
    .B(_145_),
    .C(_067_),
    .X(_112_));
 sky130_fd_sc_hd__o31a_2 _183_ (.A1(\op_q[2] ),
    .A2(\a_q[5] ),
    .A3(\b_q[5] ),
    .B1(_061_),
    .X(_113_));
 sky130_fd_sc_hd__a21oi_2 _184_ (.A1(\a_q[4] ),
    .A2(_047_),
    .B1(_113_),
    .Y(_114_));
 sky130_fd_sc_hd__o211a_2 _185_ (.A1(\a_q[5] ),
    .A2(_046_),
    .B1(_112_),
    .C1(_114_),
    .X(_115_));
 sky130_fd_sc_hd__and2b_2 _186_ (.A_N(_053_),
    .B(_109_),
    .X(_116_));
 sky130_fd_sc_hd__a21oi_2 _187_ (.A1(_125_),
    .A2(_111_),
    .B1(_116_),
    .Y(_117_));
 sky130_fd_sc_hd__a2bb2o_2 _188_ (.A1_N(\a_q[6] ),
    .A2_N(_064_),
    .B1(_115_),
    .B2(_117_),
    .X(_118_));
 sky130_fd_sc_hd__a41o_2 _189_ (.A1(_056_),
    .A2(_069_),
    .A3(_108_),
    .A4(_118_),
    .B1(_124_),
    .X(_002_));
 sky130_fd_sc_hd__and2_2 _190_ (.A(rst_n),
    .B(a[0]),
    .X(_003_));
 sky130_fd_sc_hd__and2_2 _191_ (.A(rst_n),
    .B(a[1]),
    .X(_004_));
 sky130_fd_sc_hd__and2_2 _192_ (.A(rst_n),
    .B(a[2]),
    .X(_005_));
 sky130_fd_sc_hd__and2_2 _193_ (.A(rst_n),
    .B(a[3]),
    .X(_006_));
 sky130_fd_sc_hd__and2_2 _194_ (.A(rst_n),
    .B(a[4]),
    .X(_007_));
 sky130_fd_sc_hd__and2_2 _195_ (.A(rst_n),
    .B(a[5]),
    .X(_008_));
 sky130_fd_sc_hd__and2_2 _196_ (.A(rst_n),
    .B(a[6]),
    .X(_009_));
 sky130_fd_sc_hd__and2_2 _197_ (.A(rst_n),
    .B(a[7]),
    .X(_010_));
 sky130_fd_sc_hd__and2_2 _198_ (.A(rst_n),
    .B(b[0]),
    .X(_011_));
 sky130_fd_sc_hd__and2_2 _199_ (.A(rst_n),
    .B(b[1]),
    .X(_012_));
 sky130_fd_sc_hd__and2_2 _200_ (.A(rst_n),
    .B(b[2]),
    .X(_013_));
 sky130_fd_sc_hd__and2_2 _201_ (.A(rst_n),
    .B(b[3]),
    .X(_014_));
 sky130_fd_sc_hd__and2_2 _202_ (.A(rst_n),
    .B(b[4]),
    .X(_015_));
 sky130_fd_sc_hd__and2_2 _203_ (.A(rst_n),
    .B(b[5]),
    .X(_016_));
 sky130_fd_sc_hd__and2_2 _204_ (.A(rst_n),
    .B(b[6]),
    .X(_017_));
 sky130_fd_sc_hd__and2_2 _205_ (.A(rst_n),
    .B(b[7]),
    .X(_018_));
 sky130_fd_sc_hd__and2_2 _206_ (.A(rst_n),
    .B(op[0]),
    .X(_019_));
 sky130_fd_sc_hd__and2_2 _207_ (.A(rst_n),
    .B(op[1]),
    .X(_020_));
 sky130_fd_sc_hd__and2_2 _208_ (.A(rst_n),
    .B(op[2]),
    .X(_021_));
 sky130_fd_sc_hd__and2_2 _209_ (.A(rst_n),
    .B(_098_),
    .X(_022_));
 sky130_fd_sc_hd__and3_2 _210_ (.A(rst_n),
    .B(_093_),
    .C(_094_),
    .X(_023_));
 sky130_fd_sc_hd__nor2_2 _211_ (.A(_124_),
    .B(_107_),
    .Y(_024_));
 sky130_fd_sc_hd__and2_2 _212_ (.A(rst_n),
    .B(_086_),
    .X(_025_));
 sky130_fd_sc_hd__and2_2 _213_ (.A(rst_n),
    .B(_078_),
    .X(_026_));
 sky130_fd_sc_hd__nor2_2 _214_ (.A(_124_),
    .B(_118_),
    .Y(_027_));
 sky130_fd_sc_hd__nor2_2 _215_ (.A(_124_),
    .B(_069_),
    .Y(_028_));
 sky130_fd_sc_hd__nor2_2 _216_ (.A(_124_),
    .B(_056_),
    .Y(_029_));
 sky130_fd_sc_hd__inv_2 _217_ (.A(\a_q[7] ),
    .Y(_119_));
 sky130_fd_sc_hd__inv_2 _218_ (.A(\op_q[1] ),
    .Y(_120_));
 sky130_fd_sc_hd__inv_2 _219_ (.A(\a_q[6] ),
    .Y(_121_));
 sky130_fd_sc_hd__inv_2 _220_ (.A(\a_q[5] ),
    .Y(_122_));
 sky130_fd_sc_hd__inv_2 _221_ (.A(\a_q[4] ),
    .Y(_123_));
 sky130_fd_sc_hd__inv_2 _222_ (.A(rst_n),
    .Y(_124_));
 sky130_fd_sc_hd__nor2_2 _223_ (.A(\op_q[1] ),
    .B(\op_q[2] ),
    .Y(_125_));
 sky130_fd_sc_hd__or2_2 _224_ (.A(\op_q[1] ),
    .B(\op_q[2] ),
    .X(_126_));
 sky130_fd_sc_hd__or3b_2 _225_ (.A(\op_q[1] ),
    .B(\op_q[2] ),
    .C_N(\op_q[0] ),
    .X(_127_));
 sky130_fd_sc_hd__xor2_2 _226_ (.A(\b_q[6] ),
    .B(_127_),
    .X(_128_));
 sky130_fd_sc_hd__and2_2 _227_ (.A(_121_),
    .B(_128_),
    .X(_129_));
 sky130_fd_sc_hd__or2_2 _228_ (.A(_121_),
    .B(_128_),
    .X(_130_));
 sky130_fd_sc_hd__xnor2_2 _229_ (.A(\b_q[3] ),
    .B(_127_),
    .Y(_131_));
 sky130_fd_sc_hd__nor2_2 _230_ (.A(\a_q[3] ),
    .B(_131_),
    .Y(_132_));
 sky130_fd_sc_hd__nand2_2 _231_ (.A(\a_q[3] ),
    .B(_131_),
    .Y(_133_));
 sky130_fd_sc_hd__xnor2_2 _232_ (.A(\b_q[2] ),
    .B(_127_),
    .Y(_134_));
 sky130_fd_sc_hd__nor2_2 _233_ (.A(\a_q[2] ),
    .B(_134_),
    .Y(_135_));
 sky130_fd_sc_hd__nand2_2 _234_ (.A(\a_q[2] ),
    .B(_134_),
    .Y(_136_));
 sky130_fd_sc_hd__xnor2_2 _235_ (.A(\b_q[1] ),
    .B(_127_),
    .Y(_137_));
 sky130_fd_sc_hd__nand2_2 _236_ (.A(\a_q[1] ),
    .B(_137_),
    .Y(_138_));
 sky130_fd_sc_hd__or2_2 _237_ (.A(\a_q[1] ),
    .B(_137_),
    .X(_139_));
 sky130_fd_sc_hd__nand2_2 _238_ (.A(\a_q[0] ),
    .B(\b_q[0] ),
    .Y(_140_));
 sky130_fd_sc_hd__o21a_2 _239_ (.A1(\b_q[0] ),
    .A2(_127_),
    .B1(_140_),
    .X(_141_));
 sky130_fd_sc_hd__o21bai_2 _240_ (.A1(\a_q[1] ),
    .A2(_137_),
    .B1_N(_141_),
    .Y(_142_));
 sky130_fd_sc_hd__a31o_2 _241_ (.A1(_136_),
    .A2(_138_),
    .A3(_142_),
    .B1(_135_),
    .X(_143_));
 sky130_fd_sc_hd__a311o_2 _242_ (.A1(_136_),
    .A2(_138_),
    .A3(_142_),
    .B1(_135_),
    .C1(_132_),
    .X(_144_));
 sky130_fd_sc_hd__xor2_2 _243_ (.A(\b_q[5] ),
    .B(_127_),
    .X(_145_));
 sky130_fd_sc_hd__nor2_2 _244_ (.A(_122_),
    .B(_145_),
    .Y(_146_));
 sky130_fd_sc_hd__nand2_2 _245_ (.A(_122_),
    .B(_145_),
    .Y(_147_));
 sky130_fd_sc_hd__xor2_2 _246_ (.A(\b_q[4] ),
    .B(_127_),
    .X(_148_));
 sky130_fd_sc_hd__nand2_2 _247_ (.A(_123_),
    .B(_148_),
    .Y(_030_));
 sky130_fd_sc_hd__inv_2 _248_ (.A(_030_),
    .Y(_031_));
 sky130_fd_sc_hd__a21oi_2 _249_ (.A1(_147_),
    .A2(_030_),
    .B1(_146_),
    .Y(_032_));
 sky130_fd_sc_hd__or2_2 _250_ (.A(_123_),
    .B(_148_),
    .X(_033_));
 sky130_fd_sc_hd__and2b_2 _251_ (.A_N(_033_),
    .B(_147_),
    .X(_034_));
 sky130_fd_sc_hd__a21o_2 _252_ (.A1(_133_),
    .A2(_144_),
    .B1(_032_),
    .X(_035_));
 sky130_fd_sc_hd__o211ai_2 _253_ (.A1(_146_),
    .A2(_034_),
    .B1(_133_),
    .C1(_144_),
    .Y(_036_));
 sky130_fd_sc_hd__a31o_2 _254_ (.A1(_130_),
    .A2(_035_),
    .A3(_036_),
    .B1(_129_),
    .X(_037_));
 sky130_fd_sc_hd__xor2_2 _255_ (.A(\b_q[7] ),
    .B(_127_),
    .X(_038_));
 sky130_fd_sc_hd__nand2_2 _256_ (.A(_119_),
    .B(_038_),
    .Y(_039_));
 sky130_fd_sc_hd__or2_2 _257_ (.A(_119_),
    .B(_038_),
    .X(_040_));
 sky130_fd_sc_hd__nand2_2 _258_ (.A(_037_),
    .B(_040_),
    .Y(_041_));
 sky130_fd_sc_hd__mux2_1 _259_ (.A0(_039_),
    .A1(_040_),
    .S(_037_),
    .X(_042_));
 sky130_fd_sc_hd__nor3_2 _260_ (.A(_124_),
    .B(_126_),
    .C(_042_),
    .Y(_000_));
 sky130_fd_sc_hd__and4_2 _261_ (.A(rst_n),
    .B(_125_),
    .C(_039_),
    .D(_041_),
    .X(_001_));
 sky130_fd_sc_hd__nand2_2 _262_ (.A(_039_),
    .B(_040_),
    .Y(_043_));
 sky130_fd_sc_hd__xnor2_2 _263_ (.A(_037_),
    .B(_043_),
    .Y(_044_));
 sky130_fd_sc_hd__nand2_2 _264_ (.A(\op_q[0] ),
    .B(\op_q[2] ),
    .Y(_045_));
 sky130_fd_sc_hd__or2_2 _265_ (.A(\op_q[1] ),
    .B(_045_),
    .X(_046_));
 sky130_fd_sc_hd__and3b_2 _266_ (.A_N(\op_q[0] ),
    .B(\op_q[2] ),
    .C(\op_q[1] ),
    .X(_047_));
 sky130_fd_sc_hd__nand2_2 _267_ (.A(\a_q[6] ),
    .B(_047_),
    .Y(_048_));
 sky130_fd_sc_hd__nor2_2 _268_ (.A(\b_q[7] ),
    .B(\a_q[7] ),
    .Y(_049_));
 sky130_fd_sc_hd__and2_2 _269_ (.A(\b_q[7] ),
    .B(\a_q[7] ),
    .X(_050_));
 sky130_fd_sc_hd__nor2_2 _270_ (.A(\op_q[0] ),
    .B(_050_),
    .Y(_051_));
 sky130_fd_sc_hd__or4_2 _271_ (.A(_120_),
    .B(\op_q[2] ),
    .C(_049_),
    .D(_051_),
    .X(_052_));
 sky130_fd_sc_hd__or3b_2 _272_ (.A(\op_q[1] ),
    .B(\op_q[0] ),
    .C_N(\op_q[2] ),
    .X(_053_));
 sky130_fd_sc_hd__o31a_2 _273_ (.A1(_049_),
    .A2(_050_),
    .A3(_053_),
    .B1(_048_),
    .X(_054_));
 sky130_fd_sc_hd__o211a_2 _274_ (.A1(\a_q[7] ),
    .A2(_046_),
    .B1(_052_),
    .C1(_054_),
    .X(_055_));
 sky130_fd_sc_hd__o21a_2 _275_ (.A1(_126_),
    .A2(_044_),
    .B1(_055_),
    .X(_056_));
 sky130_fd_sc_hd__nand2b_2 _276_ (.A_N(_129_),
    .B(_130_),
    .Y(_057_));
 sky130_fd_sc_hd__a21oi_2 _277_ (.A1(_035_),
    .A2(_036_),
    .B1(_057_),
    .Y(_058_));
 sky130_fd_sc_hd__and3_2 _278_ (.A(_035_),
    .B(_036_),
    .C(_057_),
    .X(_059_));
 sky130_fd_sc_hd__or3_2 _279_ (.A(_126_),
    .B(_058_),
    .C(_059_),
    .X(_060_));
 sky130_fd_sc_hd__and2_2 _280_ (.A(\op_q[1] ),
    .B(\op_q[0] ),
    .X(_061_));
 sky130_fd_sc_hd__nand2_2 _281_ (.A(\op_q[1] ),
    .B(\op_q[0] ),
    .Y(_062_));
 sky130_fd_sc_hd__or3_2 _282_ (.A(\op_q[2] ),
    .B(\a_q[6] ),
    .C(\b_q[6] ),
    .X(_063_));
 sky130_fd_sc_hd__nand2_2 _283_ (.A(\op_q[2] ),
    .B(_061_),
    .Y(_064_));
 sky130_fd_sc_hd__a22o_2 _284_ (.A1(\a_q[5] ),
    .A2(_047_),
    .B1(_061_),
    .B2(_063_),
    .X(_065_));
 sky130_fd_sc_hd__o21ba_2 _285_ (.A1(\a_q[6] ),
    .A2(_046_),
    .B1_N(_065_),
    .X(_066_));
 sky130_fd_sc_hd__or3_2 _286_ (.A(_120_),
    .B(\op_q[0] ),
    .C(\op_q[2] ),
    .X(_067_));
 sky130_fd_sc_hd__o221a_2 _287_ (.A1(_053_),
    .A2(_057_),
    .B1(_067_),
    .B2(_130_),
    .C1(_066_),
    .X(_068_));
 sky130_fd_sc_hd__a2bb2o_2 _288_ (.A1_N(\a_q[7] ),
    .A2_N(_064_),
    .B1(_068_),
    .B2(_060_),
    .X(_069_));
 sky130_fd_sc_hd__nand2_2 _289_ (.A(_030_),
    .B(_033_),
    .Y(_070_));
 sky130_fd_sc_hd__and3_2 _290_ (.A(_133_),
    .B(_144_),
    .C(_070_),
    .X(_071_));
 sky130_fd_sc_hd__a21oi_2 _291_ (.A1(_133_),
    .A2(_144_),
    .B1(_070_),
    .Y(_072_));
 sky130_fd_sc_hd__or3_2 _292_ (.A(_126_),
    .B(_071_),
    .C(_072_),
    .X(_073_));
 sky130_fd_sc_hd__nand2_2 _293_ (.A(\a_q[3] ),
    .B(_047_),
    .Y(_074_));
 sky130_fd_sc_hd__o211a_2 _294_ (.A1(\a_q[4] ),
    .A2(_046_),
    .B1(_064_),
    .C1(_074_),
    .X(_075_));
 sky130_fd_sc_hd__o21a_2 _295_ (.A1(_033_),
    .A2(_067_),
    .B1(_075_),
    .X(_076_));
 sky130_fd_sc_hd__o221a_2 _296_ (.A1(_031_),
    .A2(_062_),
    .B1(_070_),
    .B2(_053_),
    .C1(_076_),
    .X(_077_));
 sky130_fd_sc_hd__o2bb2a_2 _297_ (.A1_N(_077_),
    .A2_N(_073_),
    .B1(_064_),
    .B2(\a_q[5] ),
    .X(_078_));
 sky130_fd_sc_hd__dfxtp_2 _298_ (.CLK(clk),
    .D(_000_),
    .Q(overflow));
 sky130_fd_sc_hd__dfxtp_2 _299_ (.CLK(clk),
    .D(_001_),
    .Q(carry));
 sky130_fd_sc_hd__dfxtp_2 _300_ (.CLK(clk),
    .D(_002_),
    .Q(zero));
 sky130_fd_sc_hd__dfxtp_2 _301_ (.CLK(clk),
    .D(_003_),
    .Q(\a_q[0] ));
 sky130_fd_sc_hd__dfxtp_2 _302_ (.CLK(clk),
    .D(_004_),
    .Q(\a_q[1] ));
 sky130_fd_sc_hd__dfxtp_2 _303_ (.CLK(clk),
    .D(_005_),
    .Q(\a_q[2] ));
 sky130_fd_sc_hd__dfxtp_2 _304_ (.CLK(clk),
    .D(_006_),
    .Q(\a_q[3] ));
 sky130_fd_sc_hd__dfxtp_2 _305_ (.CLK(clk),
    .D(_007_),
    .Q(\a_q[4] ));
 sky130_fd_sc_hd__dfxtp_2 _306_ (.CLK(clk),
    .D(_008_),
    .Q(\a_q[5] ));
 sky130_fd_sc_hd__dfxtp_2 _307_ (.CLK(clk),
    .D(_009_),
    .Q(\a_q[6] ));
 sky130_fd_sc_hd__dfxtp_2 _308_ (.CLK(clk),
    .D(_010_),
    .Q(\a_q[7] ));
 sky130_fd_sc_hd__dfxtp_2 _309_ (.CLK(clk),
    .D(_011_),
    .Q(\b_q[0] ));
 sky130_fd_sc_hd__dfxtp_2 _310_ (.CLK(clk),
    .D(_012_),
    .Q(\b_q[1] ));
 sky130_fd_sc_hd__dfxtp_2 _311_ (.CLK(clk),
    .D(_013_),
    .Q(\b_q[2] ));
 sky130_fd_sc_hd__dfxtp_2 _312_ (.CLK(clk),
    .D(_014_),
    .Q(\b_q[3] ));
 sky130_fd_sc_hd__dfxtp_2 _313_ (.CLK(clk),
    .D(_015_),
    .Q(\b_q[4] ));
 sky130_fd_sc_hd__dfxtp_2 _314_ (.CLK(clk),
    .D(_016_),
    .Q(\b_q[5] ));
 sky130_fd_sc_hd__dfxtp_2 _315_ (.CLK(clk),
    .D(_017_),
    .Q(\b_q[6] ));
 sky130_fd_sc_hd__dfxtp_2 _316_ (.CLK(clk),
    .D(_018_),
    .Q(\b_q[7] ));
 sky130_fd_sc_hd__dfxtp_2 _317_ (.CLK(clk),
    .D(_019_),
    .Q(\op_q[0] ));
 sky130_fd_sc_hd__dfxtp_2 _318_ (.CLK(clk),
    .D(_020_),
    .Q(\op_q[1] ));
 sky130_fd_sc_hd__dfxtp_2 _319_ (.CLK(clk),
    .D(_021_),
    .Q(\op_q[2] ));
 sky130_fd_sc_hd__dfxtp_2 _320_ (.CLK(clk),
    .D(_022_),
    .Q(y[0]));
 sky130_fd_sc_hd__dfxtp_2 _321_ (.CLK(clk),
    .D(_023_),
    .Q(y[1]));
 sky130_fd_sc_hd__dfxtp_2 _322_ (.CLK(clk),
    .D(_024_),
    .Q(y[2]));
 sky130_fd_sc_hd__dfxtp_2 _323_ (.CLK(clk),
    .D(_025_),
    .Q(y[3]));
 sky130_fd_sc_hd__dfxtp_2 _324_ (.CLK(clk),
    .D(_026_),
    .Q(y[4]));
 sky130_fd_sc_hd__dfxtp_2 _325_ (.CLK(clk),
    .D(_027_),
    .Q(y[5]));
 sky130_fd_sc_hd__dfxtp_2 _326_ (.CLK(clk),
    .D(_028_),
    .Q(y[6]));
 sky130_fd_sc_hd__dfxtp_2 _327_ (.CLK(clk),
    .D(_029_),
    .Q(negative));
 sky130_fd_sc_hd__buf_2 _328_ (.A(negative),
    .X(y[7]));
endmodule
