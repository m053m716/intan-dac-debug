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
static const char *ng0 = "C:/Users/BuccelliLab/Documents/GitHub/intan-dac-debug/HPF_tests/mult_tb.v";
static int ng1[] = {0, 0};
static int ng2[] = {40, 0};
static int ng3[] = {20, 0};



static void Initial_46_0(char *t0)
{
    char *t1;
    char *t2;
    char *t3;

LAB0:    t1 = (t0 + 3168U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(46, ng0);

LAB4:    xsi_set_current_line(48, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 1448);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(49, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 1608);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 18);
    xsi_set_current_line(50, ng0);
    t2 = ((char*)((ng1)));
    t3 = (t0 + 1768);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 18);
    xsi_set_current_line(53, ng0);
    t2 = (t0 + 2976);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    goto LAB1;

}

static void Always_59_1(char *t0)
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

LAB0:    t1 = (t0 + 3416U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(60, ng0);
    t2 = (t0 + 3224);
    xsi_process_wait(t2, 5000LL);
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(60, ng0);
    t4 = (t0 + 1448);
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

LAB8:    t14 = (t0 + 1448);
    xsi_vlogvar_assign_value(t14, t3, 0, 0, 1);
    goto LAB2;

LAB5:    *((unsigned int *)t3) = 1;
    goto LAB8;

}

static void Always_62_2(char *t0)
{
    char t6[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    char *t14;
    unsigned int t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;

LAB0:    t1 = (t0 + 3664U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(62, ng0);
    t2 = (t0 + 3984);
    *((int *)t2) = 1;
    t3 = (t0 + 3696);
    *((char **)t3) = t2;
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(62, ng0);

LAB5:    xsi_set_current_line(63, ng0);
    t4 = ((char*)((ng2)));
    t5 = (t0 + 1608);
    xsi_vlogvar_assign_value(t5, t4, 0, 0, 18);
    xsi_set_current_line(64, ng0);
    t2 = ((char*)((ng3)));
    memset(t6, 0, 8);
    xsi_vlog_signed_unary_minus(t6, 32, t2, 32);
    t3 = (t0 + 1768);
    xsi_vlogvar_assign_value(t3, t6, 0, 0, 18);
    xsi_set_current_line(65, ng0);
    t2 = (t0 + 1608);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t6, 0, 8);
    t5 = (t6 + 4);
    t7 = (t4 + 4);
    t8 = *((unsigned int *)t4);
    t9 = (t8 >> 2);
    *((unsigned int *)t6) = t9;
    t10 = *((unsigned int *)t7);
    t11 = (t10 >> 2);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t12 & 65535U);
    t13 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t13 & 65535U);
    t14 = (t0 + 1928);
    xsi_vlogvar_assign_value(t14, t6, 0, 0, 16);
    xsi_set_current_line(66, ng0);
    t2 = (t0 + 1768);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    memset(t6, 0, 8);
    t5 = (t6 + 4);
    t7 = (t4 + 4);
    t8 = *((unsigned int *)t4);
    t9 = (t8 >> 1);
    *((unsigned int *)t6) = t9;
    t10 = *((unsigned int *)t7);
    t11 = (t10 >> 1);
    *((unsigned int *)t5) = t11;
    t12 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t12 & 65535U);
    t13 = *((unsigned int *)t5);
    *((unsigned int *)t5) = (t13 & 65535U);
    t14 = (t0 + 2088);
    xsi_vlogvar_assign_value(t14, t6, 0, 0, 16);
    xsi_set_current_line(67, ng0);
    t2 = (t0 + 1048U);
    t3 = *((char **)t2);
    memset(t6, 0, 8);
    t2 = (t6 + 4);
    t4 = (t3 + 4);
    t8 = *((unsigned int *)t3);
    t9 = (t8 >> 3);
    *((unsigned int *)t6) = t9;
    t10 = *((unsigned int *)t4);
    t11 = (t10 >> 3);
    *((unsigned int *)t2) = t11;
    t5 = (t3 + 8);
    t7 = (t3 + 12);
    t12 = *((unsigned int *)t5);
    t13 = (t12 << 29);
    t15 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t15 | t13);
    t16 = *((unsigned int *)t7);
    t17 = (t16 << 29);
    t18 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t18 | t17);
    t19 = *((unsigned int *)t6);
    *((unsigned int *)t6) = (t19 & 4294967295U);
    t20 = *((unsigned int *)t2);
    *((unsigned int *)t2) = (t20 & 4294967295U);
    t14 = (t0 + 2248);
    xsi_vlogvar_assign_value(t14, t6, 0, 0, 32);
    goto LAB2;

}


extern void work_m_00000000000213800029_1136260949_init()
{
	static char *pe[] = {(void *)Initial_46_0,(void *)Always_59_1,(void *)Always_62_2};
	xsi_register_didat("work_m_00000000000213800029_1136260949", "isim/mult_tb_isim_beh.exe.sim/work/m_00000000000213800029_1136260949.didat");
	xsi_register_executes(pe);
}
