/** TM_RC_cy.h     v 1.2      **************************/
#define TM_BUF_MEM  xdata
#define byte unsigned char

/*extern byte TM_BUF_MEM
              TM_1994_time[5], 
                   TM_sern[8],    // 0 - код серии, 1-6 серийный номер (мл - ст), 7 - SRC байт         
                   TM_scr[32];    // буфер для TM_memrd,TM_memwr 
*/
byte TM_reset(void);
//unsigned  char TM_wrbit (unsigned  char a);
//unsigned  char TM_wrbyte(unsigned  char a);
byte TM_rdsern(void);  /* чтение серийного номера */
byte TM_memrd(unsigned  int addr);
            /* addr - адрес буфера_32, т.е. номер page  */
byte TM_memwr(unsigned  int addr);
byte RT_sec_rd(unsigned long *time);
byte RT_sec_wr(unsigned long  time);

//int TM_Rd_Temp(void);    /*чтение температуры * 2 */
byte  Temper(void);//float  Temper(void);
////////////////////////////////////////
/*
DS1994 - = 04H - family code 0-15 page - память, 
16 page- реальное время
-------------------------------------------------------------
Cygnal кварц=22118400  , TM_BUF_MEM  xdata
               тик           микросек
TM_reset      19707             890  
TM_rdsern    121699            5502
TM_memrd     420102           18993
TM_memwr     1021655          46188
RT_sec_rd    119683            5411 
RT_sec_wr   1021665           46190

реальные замеры RESET 
t0           11303    511
t1           20
t2           615      27
t3           2448     110
t4           5326     240  
*/