/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/BuccelliLab/Documents/GitHub/intan-dac-debug/HPF_tests/DAC_tb.v";
static int ng1[] = {0, 0};
static int ng2[] = {1, 0};
static int ng3[] = {10, 0};
static int ng4[] = {150, 0};
static int ng5[] = {2, 0};
static int ng6[] = {30, 0};
static const char *ng7 = "ampl_data_bin.txt";
static const char *ng8 = "output.txt";
static const char *ng9 = "w";
static const char *ng10 = "%b\n";
static const char *ng11 = "Current value of DAC_register is %d";



static void Initial_81_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;

LAB0:    t1 = (t0 + 5864U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(81, ng0);

LAB4:    xsi_set_current_line(83, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2224);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(84, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2384);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(85, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2544);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);
    xsi_set_current_line(86, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 2704);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 6);
    xsi_set_current_line(87, ng0);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 2864);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(88, ng0);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 3024);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(89, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3184);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(90, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3344);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(91, ng0);
    t2 = ((char*)((ng5)));
    t3 = (t0 + 3504);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 3);
    xsi_set_current_line(92, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3664);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 7);
    xsi_set_current_line(93, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 3824);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(94, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 3984);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(95, ng0);
    t2 = ((char*)((ng6)));
    t3 = (t0 + 4144);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(96, ng0);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 4304);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(97, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4464);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(98, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 4624);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 16);
    xsi_set_current_line(101, ng0);
    t2 = (t0 + 5672);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    goto LAB1;

}

static void Initial_107_1(char *t0)
{
    char t2[8];
    char *t1;
    char *t3;

LAB0:    xsi_set_current_line(107, ng0);

LAB2:    xsi_set_current_line(108, ng0);
    t1 = (t0 + 4944);
    xsi_vlogfile_readmemb(ng7, 0, t1, 0, 0, 0, 0);
    xsi_set_current_line(109, ng0);
    *((int *)t2) = xsi_vlogfile_file_open_of_cname_ctype(ng8, ng9);
    t1 = (t2 + 4);
    *((int *)t1) = 0;
    t3 = (t0 + 4784);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 32);

LAB1:    return;
}

static void Always_114_2(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;

LAB0:    t1 = (t0 + 6360U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(115, ng0);
    t2 = (t0 + 6168);
    xsi_process_wait(t2, 5000LL);
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(115, ng0);
    t4 = (t0 + 2384);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memset(t3, 0, 8);
    t7 = (t6 + 4);
    t8 = *((unsigned int *)t7);
    t9 = (~(t8));
    t10 = *((unsigned int *)t6);
    t11 = (t10 & t9);
    t12 = (t11 & 1U);
    if (t12 != 0)
        goto LAB8;

LAB6:    if (*((unsigned int *)t7) == 0)
        goto LAB5;

LAB7:    t13 = (t3 + 4);
    *((unsigned int *)t3) = 1;
    *((unsigned int *)t13) = 1;

LAB8:    t14 = (t0 + 2384);
    xsi_vlogvar_assign_value(t14, t3, 0, 0, 1);
    goto LAB2;

LAB5:    *((unsigned int *)t3) = 1;
    goto LAB8;

}

static void Always_116_3(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;

LAB0:    t1 = (t0 + 6608U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(116, ng0);
    t2 = (t0 + 6928);
    *((int *)t2) = 1;
    t3 = (t0 + 6640);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(116, ng0);

LAB5:    xsi_set_current_line(119, ng0);
    t4 = (t0 + 4784);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    t7 = (t0 + 2864);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    xsi_vlogfile_fwrite(*((unsigned int *)t6), 0, 0, 1, ng10, 2, t0, (char)118, t9, 16);
    xsi_set_current_line(121, ng0);
    t2 = (t0 + 6416);
    xsi_process_wait(t2, 3000LL);
    *((char **)t1) = &&LAB6;
    goto LAB1;

LAB6:    xsi_set_current_line(121, ng0);
    t3 = (t0 + 1824U);
    t4 = *((char **)t3);
    xsi_vlogfile_write(1, 0, 0, ng11, 2, t0, (char)118, t4, 16);
    goto LAB2;

}


extern void work_m_00000000003684201241_0565049414_init()
{
	static char *pe[] = {(void *)Initial_81_0,(void *)Initial_107_1,(void *)Always_114_2,(void *)Always_116_3};
	xsi_register_didat("work_m_00000000003684201241_0565049414", "isim/DAC_tb_isim_beh.exe.sim/work/m_00000000003684201241_0565049414.didat");
	xsi_register_executes(pe);
}
