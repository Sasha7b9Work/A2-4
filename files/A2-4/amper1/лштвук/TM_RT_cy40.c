// Touch memory DS1994 + время   for CYGNAL кварц=22118400

#include "tm_rt_cy40.h"
//#include  "MyDef40.h"

sfr WDTCN=0xFF;
sfr PSW  =  0xD0;
sbit F0  =  PSW ^ 5;  
sfr IE   =  0xA8;      // INTERRUPT ENABLE 
sbit EA  =  IE ^ 7;    // GLOBAL INTERRUPT ENABLE
sfr P0   =  0x80;      // PORT 0

//////////
//sfr SFRPAGE  = 0x84;    /* SFR PAGE SELECT     */
//sfr P4       = 0xC8;    /* PORT 4                                       */

sbit TMbit = P0^2;     // TM

//   перезапуск WDT !!!  (в TM_reset() )
//#define WDTreset {WDTCN=0x07;WDTCN=0xA5;}
#define WDTreset {  }

#define TM_memrd_on   0
#define TM_memwr_on   0
#define TM_rdsern_on  0
#define RT_sec_rd_on  0
#define RT_sec_wr_on  0
#define TM_Rd_Temp_on 0
#define byte unsigned char


typedef union
   {                       /*  для 51 процессора */ /*  для IBM PC        */
//+     float F;              /*   ст      -  мл    */ /*   мл      -  ст    */
     unsigned long  L;     /*   H0    -     L0   */ /*   L0    -     H0   */
     unsigned int I[2];    /*   H0    -     L0   */ /*   L0    -     H0   */
     byte C[4];   /*   H0  L0  H1  L1   */ /*   L0  H0  L1  H1   */
   } FLIC ;                /*   0   1   2   3    */ /*   0   1   2   3    */

/****************************/
byte TM_BUF_MEM BBB_1,BBB_2,BBB_3,
  TM_pr,
  TM_ta1,TM_ta2,  /* адресный регистр буфера               */
  TM_es;         /* регистр E/S:
         0-4 бит - след адрес в буфере
         5 (PF)  - =1 если число обработанных бит не кратно 8
         6 (OF)  - =1 при попытке записать больше буфера
         7 (АА)  - =1 признак факта копиров.буфера в память    */


byte TM_BUF_MEM
        TM_1994_time[5], 
             TM_sern[8],    /* 0 - код серии,
                            1-6 серийный номер (мл - ст)
                     	    7 - SRC байт         */
             TM_scr[32];    /* сам буфер            */

byte TM_reset(void)
                     /* _               ____        _____       */
  {                  /* |\_____________/|  |\_____/|     |      */
                     /* |             | |  |       |     |      */
                     /* |  t0         |1|t2|  t3   |  t4 |      */
                     /*                                        */
                     /*  480<=t0<=0-0                          */
                     /*   15<=t2<=60                           */
                     /*   60<=t3<=240                          */
byte data pr,t;
byte data c,d;
 
WDTreset;
//SFRPAGE=0xf;             //  c40
TMbit = 0;

// d=11 c=255 tt=510
 {  for(d=11;d!=0;d--)for(c=255;c!=0;c--);}

EA=0;
pr=1;
TMbit=1;

// c=255 t=81.2
 {
//?unsigned  char data c ;  
for(c=255;c!=0;c--)if ( TMbit == 1 )goto zzzz1;}
 
pr=2;goto end_reset;

zzzz1:
 {
//? unsigned  char data c ;  

for(c=255;c!=0;c--)if ( TMbit == 0 )goto zzzz2;}

pr=3;goto end_reset;

zzzz2:
 {
//? unsigned  char data c ;  
for(d=4;d!=0;d--)
 for(c=255;c!=0;c--)
  {
  t=c;
  if ( TMbit == 1 )goto zzzz3;
//?if ( TMbit == 1 )goto zzzz3;
//?if ( TMbit == 1 )goto zzzz3;
//?if ( TMbit == 1 )goto zzzz3;
  }
 }

pr=4;goto end_reset;

zzzz3:
end_reset:
			EA=1;
// d=6  c=220 tt=240
{ char data c,d;  for(d=6;d!=0;d--)for(c=220;c!=0;c--);}
/* pr=1 - норма , 2-4 - сбой  */
//SFRPAGE =0;
return pr;
  }
/********************************************************/
byte TM_wrbit (byte a)
{
F0=a;
EA=0;     /* запрет прерывания */
//SFRPAGE=0xf;
TMbit = 0;       // замеры в микросек от этой точки t=0

{ char data c ;  for(c=2;c!=0;c--);}   //длительность L=1.99misec

TMbit = F0;       // t=2.26

{ char data c ;  for(c=18;c!=0;c--);} // L=13.2

F0 = TMbit;      // t=15.55
 
{ char data c ;  for(c=62;c!=0;c--);} // L=45

TMbit = 1;       // t=60.58

EA=1;
a=F0;
//SFRPAGE=0;
return a;
}
/**********************************/
byte TM_wrbyte(byte a)
{
byte q,i;

  for (q=i=0;i<8;i++)
  {
    q = (q>>1);
    if ( TM_wrbit(a & 0x01) != 0 ) q|=0x80;
    a = a>>1;
  }

return q;
}
/***********************************************/
/***********************************************/

# if (TM_rdsern_on==1)
byte TM_rdsern(void)  /* чтение серийного номера */
{
byte i,j,crc,a;

crc=0;

//  if(TM_reset()!=1) return 0; /* нет отклика */

  TM_wrbyte(0x33);

  for (i=0;i<8;i++)
  {
    TM_sern[i] = TM_wrbyte(0xff);
  }

  /* вычисление CRC */

  for (i=0;i<8;i++)
  {
  a=TM_sern[i];
    for (j=0;j<8;j++)
    {
    if (((a & 0x01) ^ (crc & 0x01)) == 0x01)
          {
          crc = (crc >> 1) ^ 0x8c;
          }
    else
          {
          crc >>= 1;
          }
    a>>=1;
    }
  }

if (crc == 0) return 1;
return 2;
}
# endif
/**********************************/

# if (TM_memrd_on == 1)

byte TM_memrd(unsigned  int addr)
            /* addr - адрес буфера_32  */
{
byte i;

  for(i=0;i<32;i++)
    {
    TM_scr[i]=0;
    }

  if(TM_reset()!=1) return 0; /* нет отклика */
  TM_wrbyte(0xcc);            /* skip rom command */
  TM_ta1 = (addr << 5) ;
  TM_ta2 = (addr >> 3) ;

  TM_wrbyte(0xF0       );           /* read memory       */
  TM_wrbyte(TM_ta1      );           /* wr                */
  TM_wrbyte(TM_ta2      );           /* wr                */
  for (i=0;i<32;i++)
  {
    TM_scr[i] = TM_wrbyte(0xff);       /* rd buffer      */
  }
return 1;
}
# endif
/******************************************************/
# if (TM_memwr_on ==1)
byte TM_memwr(unsigned  int addr)
{
byte i,c;


   BBB_1=BBB_2=BBB_3=0;


  if(TM_reset()!=1) return 0; /* нет отклика */

  TM_wrbyte(0xcc);            /* skip rom command */
  TM_ta1 =(byte) ((addr << 5) & 0xff) ;
  TM_ta2 =(byte)( (addr >> 3) & 0xff) ;

  TM_wrbyte(0x0F       );           /* write memory    */
  TM_wrbyte(TM_ta1      );           /* wr              */
  TM_wrbyte(TM_ta2      );           /* wr              */
  for (i=0;i<32;i++)
  {
    TM_wrbyte(TM_scr[i]);           /* wr buffer       */
  }


  if(TM_reset()==0) return 0; /* нет отклика */
  TM_wrbyte(0xcc);            /* skip rom command */

  TM_wrbyte(0xaa       );           /* read buffer       */
  BBB_1 = TM_wrbyte(0xff);           /* rd   ta1          */
  BBB_2 = TM_wrbyte(0xff);           /* rd   ta2          */
  BBB_3 = TM_wrbyte(0xff);           /*      e/s          */
  TM_pr = 0 ;

  for (i=0;i<32;i++)
  {
    c = TM_wrbyte(0xff);   /* rd buffer         */
    if ( c != TM_scr[i] )
             {
             TM_pr++;
             }
  }

  if( TM_pr != 0) return 2;
    /* нет совпадения при повторном чтении */

  if(TM_reset()!=1) return 0; /* нет отклика */
  TM_wrbyte(0xcc);            /* skip rom command */
  TM_wrbyte(0x55);            /* copy buffer      */
  TM_wrbyte(BBB_1);            /* wr ta1           */
  TM_wrbyte(BBB_2);            /* wr ta2           */
  TM_wrbyte(BBB_3);            /* wr e/s           */


/**/
  for (i=0;i<132;i++);


  if(TM_reset()!=1) return 0; /* нет отклика */
  TM_wrbyte(0xcc);            /* skip rom command */

  TM_wrbyte(0xaa       );           /* read buffer       */
  BBB_1 = TM_wrbyte(0xff);           /* rd   ta1          */
  BBB_2 = TM_wrbyte(0xff);           /* rd   ta2          */
  BBB_3 = TM_wrbyte(0xff);           /*      e/s          */

  TM_reset();

  if((BBB_3 & 0x80 ) == 0x80) return 1;  else
return 3;
}
# endif
/************************************/
/************************************/

# if (RT_sec_rd_on==1)

byte RT_sec_rd(unsigned long *tt)
{
FLIC t;

  if((TM_reset())!=1)
      return 0; /* нет отклика */
  TM_wrbyte(0xcc);            /* skip rom command */

  TM_wrbyte(0xF0      );           /* read memory       */
  TM_wrbyte(0x02      );           /* wr                */
  TM_wrbyte(0x02      );           /* wr                */

          TM_1994_time[0] = TM_wrbyte(0xff);
t.C[3] =  TM_1994_time[1] = TM_wrbyte(0xff);
t.C[2] =  TM_1994_time[2] = TM_wrbyte(0xff);
t.C[1] =  TM_1994_time[3] = TM_wrbyte(0xff);
t.C[0] =  TM_1994_time[4] = TM_wrbyte(0xff);

*tt = t.L;
return 1;

}
# endif
/**********************/

# if (RT_sec_wr_on ==1)
byte RT_sec_wr(unsigned long tt)
{
byte i;
FLIC t;

t.L = tt;
TM_scr[0] = 0x38;
TM_scr[1] = 0x58;
TM_scr[2] = 0x00;
TM_scr[6]=t.C[0] ;
TM_scr[5]=t.C[1] ;
TM_scr[4]=t.C[2] ;
TM_scr[3]=t.C[3] ;
for(i=7;i<32;i++) TM_scr[i]=0;
i=TM_memwr(16);
return i;
}
#endif
/**********************************/
# if (TM_Rd_Temp_on == 1)

int TM_Rd_Temp(void)
{
int TMP;
byte t0,t1,a;

TMP=0;

/* чтение температуры */
//FLAG_TM=1;

/* задержка */

  a=TM_reset();

if(a==1)
{ 
  a=TM_wrbyte(0xCC);
  a=TM_wrbyte(0xBE);

  t0=TM_wrbyte(0xff);
  t1=TM_wrbyte(0xff);

/**********/
  TMP =  t0 | (((int)t1)<<8);   /* t=TMP/2 */
//  проверить правильность при отрицательном значении температуры!!!!!!
/*********/
}
  a=TM_reset();
  a=TM_wrbyte(0xCC); /* skip */
  a=TM_wrbyte(0x44); /* преобразование температуры */
/*****************/
//FLAG_TM=0;

return TMP ;

}
#endif
/////////////////////////////////////
/////////////////////////////////////
byte ttt[9];
int TMP;//float TMP;
byte Temper(void)	//+float  Temper(void)
{

byte a,crc=0,i,j;
//? int f;// float f;

TMP=0;

/* чтение температуры */

/*
  a=TM_reset();
  a=TM_wrbyte(0xCC); // skip 
  a=TM_wrbyte(0x44); // преобразование температуры 
*/
/* задержка */

  a=TM_reset();
 if(a==1)
 { 
/*  a=TM_wrbyte(0x55);
  a=TM_wrbyte(SR[n][0]);
  a=TM_wrbyte(SR[n][1]);
  a=TM_wrbyte(SR[n][2]);
  a=TM_wrbyte(SR[n][3]);
  a=TM_wrbyte(SR[n][4]);
  a=TM_wrbyte(SR[n][5]);
  a=TM_wrbyte(SR[n][6]);
  a=TM_wrbyte(SR[n][7]);

*/
  a=TM_wrbyte(0xCC);
  a=TM_wrbyte(0xBE);

for(a=0;a<9;a++)
	  ttt[a]=TM_wrbyte(0xff);
/*
  ttt[0]=TM_wrbyte(0xff);
  ttt[1]=TM_wrbyte(0xff);
  ttt[2]=TM_wrbyte(0xff);
  ttt[3]=TM_wrbyte(0xff);
  ttt[4]=TM_wrbyte(0xff);
  ttt[5]=TM_wrbyte(0xff);
  ttt[6]=TM_wrbyte(0xff);
  ttt[7]=TM_wrbyte(0xff);
  ttt[8]=TM_wrbyte(0xff);
*/
     for (i=0;i<9;i++)      // 
  {
  a=ttt[i];
    for (j=0;j<8;j++)
    {
    if (((a & 0x01) ^ (crc & 0x01)) == 0x01)
          {
          crc = (crc >> 1) ^ 0x8c;
          }
    else
          {
          crc >>= 1;
          }
    a>>=1;
    }
  }
  a=crc;
  if(crc!=0) return -200;

  //f=
 	TMP = (int)ttt[0] | ((int)ttt[1]<<8);  

  a=TM_reset();

//?  a=TM_reset();
  a=TM_wrbyte(0xCC); // skip 
  a=TM_wrbyte(0x44); // преобразование температуры 

 return TMP<<4;//?was /16;
 }
/*****************/
return -200. ;
//return TMP ;

} 
/////////////




//# endif

