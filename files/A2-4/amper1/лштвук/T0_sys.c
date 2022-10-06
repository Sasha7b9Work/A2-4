//*********************************************
//   T0_SYS.c
// -------------------------------------------
//   v 1.10 8.03.2004         
//*********************************************

# include "T0_sys.h"
  
/*    

unsigned char s=0;
sbit  LED = (0x90)^6;

int rrr=0;
*/


/////   SFR //////////
sfr SFRPAGE = 0x84;

sfr TMOD  = 0x89;

sfr TL0   = 0x8A;
sfr TH0   = 0x8C;

//  IEN0  
sbit EA    = 0xAF;   
sbit ET0   = 0xA9;   

//  TCON  
sbit TR0   = 0x8C; 


sfr P0       =  0x80;	// PORT 0
/************************/

/// НАСТРОЙКИ 
# define Dtic 1            // для 52 
//# define Dtic 9           // для 520 dallas Q/4
//#define freq 100           //  Частота  оборотов  T0 в секунду

#define freq 100.           //  Частота  оборотов  T0 в секунду
#define time2sec 200      // freq*2
#define time1sec 100      // freq*1
// кварц 
# define QQ (11059200/2)
/////////////////////////////////////////////////////////////////////////

unsigned int data T0_LOAD ;   // ((unsigned int)(0x1f00+Dtic))
unsigned int data Time_100,Time1_100;   // цикл счетчик общего назначения 1/100 sec
bit    T0_flag,fl_2sek,fl_4sek;
unsigned int  Time_1000,Time_datchik;   // цикл счетчик общего назначения 1/100 sec


extern  unsigned int cnt_lampy1,cnt_lampy2,cnt_L1;
extern  unsigned char stat_lampy1,stat_lampy2,stat_12;	// состояние лампы 0-вкл, 1-выкл, 2-авария

//-------------------------------------

// 
void To_load_calc(unsigned int f)
{
/*   f=           //количество тиков таймера за 1 период заданной частоты
     (1./f)     // период заданой частоты
     /
    (12./QQ);   // период тика
*/
	f=QQ/f/12;//??
   T0_LOAD=Dtic-f;
}

//--------------------------------

void T0_init(void)
{
//   SFRPAGE =0;        // добавлено для C8051F040x
 
   TR0 = 0;          /* таймер off         */
 
   Time_100=0; Time1_100=0;
   Time_1000=0; Time_datchik=0;

   cnt_lampy1=cnt_lampy2=0;

   To_load_calc(freq);
   T0_flag=0;
   // Time_n=0;
 
   TMOD = TMOD & 0xf0 | 0x01;
   TR0 = 0;          /* таймер отключен         */
   TH0 = T0_LOAD>>8;
   TL0 = T0_LOAD;    /* T0 = 0                  */
   ET0 = 1;          /* Т0 прерывания разрешены */
   TR0 = 1;          /* таймер включен          */
   EA  = 1;          /* прерывания разрешены    */
}

//sfr P0       =  0x80;	
//sbit TMbit = P0^2;

bit L1,L2;

void T0_int(void) interrupt 1 //Обработчик прерываний от T0
{
   //перезагрузка таймера величиной freq0
   unsigned int data q;
 
   EA=0;    // перезагрузка таймера
   TR0=0;
   *(((unsigned char *)&q)+1)=TL0;
   *(((unsigned char *)&q)+0)=TH0;
   //q=q+(0xDC00+9+6); // 0.01 sec timer    9-530 15-52
   q=q+T0_LOAD;
   TL0=*(((unsigned char *)&q)+1);
   TH0=*(((unsigned char *)&q)+0);
   TR0=1;
   EA=1;                                   


// проверка работы ламп

if ((P0&0x08) != 0)
  { if (L1==0) cnt_lampy1++; L1=1; }
else {if (L1==1) cnt_lampy1++; L1=0; }

if ((P0&0x10) != 0) 
  { if (L2==0) cnt_lampy2++; L2=1; }
else {if (L2==1) cnt_lampy2++; L2=0; }

  Time_100++;

   if (Time_100==time1sec)	// !!!1 cek
	 {  
	 cnt_L1=cnt_lampy1;
	   Time_100=0;
	   stat_lampy1=0;
	   if (cnt_lampy1>30)stat_lampy1=2;
	   else if (L1==1) stat_lampy1=1;


	   stat_lampy2=0;
	   if (cnt_lampy2>30)stat_lampy2=2;
	   else if (L2==1) stat_lampy2=1;

	   stat_12 = (stat_lampy1<<4)|stat_lampy2;

	   cnt_lampy1=cnt_lampy2=0;
	 }

 Time_datchik++;
 Time_1000++;

}
