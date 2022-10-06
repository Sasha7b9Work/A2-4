//---------------------------------------
// Main-программа модуля управления "Детский стол" 
// V 6    05.11.2007
//  C Cygnal c8051f005  кварц=22118400
//---------------------------------------
#include "c8051f000.h"
#include "MyDef005.h"
# include "T0_sys.h" 
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
//#include  "tm_rt_cy40.h"
# include "lcd_moda.h"

#define T0 300	//0x12A	//5C3	//127
#define Tgr 64	//+,last=90

	// кнопки
#define Key_rabota (P1&0x20)
#define Key_datchik (P1&0x40)
#define Key_razogrew (P1&0x80)

// звуковой сигнал 1-вкл сигнал аварии, 0-выкл
#define Zwuk P06 
#define byte unsigned char


//---------------------------------------
// Объявление ОЗУ
//---------------------------------------

  unsigned char idata sss[20]; //?120 буфер индикации
  unsigned int idata ttt_key;      // счетчик времени опроса кнопок
  unsigned char idata regim1;   // режим работы 1-подготовка, 2-разогрев, 
                               // 3-работа
  unsigned int idata T_opory;
  //unsigned
   int idata T_lampy1,T_lampy2; // заданная температура
  unsigned int idata Pred_lampy1,Pred_lampy2, cnt_izm_lampy1, cnt_izm_lampy2;
  unsigned int idata Pred_wozd, cnt_izm_wozd;
  unsigned char rez;

  bit fl_key, fl_sboy, fl_lampy1, fl_lampy2,fl_gotow;
  bit fl_Zwuk1,fl_Zwuk2,fl_Zwuk3,fl_wykl_zwuk;
  unsigned int cnt_mig,cnt_lampy1,cnt_lampy2,cnt_L1;
  unsigned char idata regim2;   // // режим работы (для контроля WDT)
  unsigned char stat_lampy1,stat_lampy2,stat_12,stat_12_pred;//состояние лампы 0-вкл, 1-выкл, 2-авария
  unsigned int Time_3min;

void msprintf(void);	//int Temperatur);

//////////////////////////////////////

void SYSCLK_Crystal_Init_F005(void)
{
int i; 

OSCXCN = 0x77; // start external oscillator with
				// 22.1184MHz crystal
for (i=0; i < 256; i++) ; // XTLVLD blanking interval (>1ms)
while (!(OSCXCN & 0x80)) ; // Wait for crystal osc. to settle
OSCICN = 0x88; 			// select external oscillator as SYSCLK
						// source and enable missing clock detector
}

int Temper(void);//+float  Temper(void);
int Temperatur,Temperatur_n, Mas_Temperatur[16], Sum_usr;//Temperatur_new float
int Min_T, Max_T;//byte;float Min_T, Max_T;
unsigned char ind_Mas;


void izm_Temper_datchika (void)
    {
	  unsigned char i;

	if (Time_datchik>=10)	//?100
	  {
        Temperatur = Temper();
		 
//		Mas_Temperatur[ind_Mas] = Temperatur-T0;

//	Sum_usr+= Temperatur-T0;
	Sum_usr+= Temperatur;//+ADC

		if (ind_Mas < Tgr)
		{
		ind_Mas++;
		}
		else
		{
		ind_Mas=0;
//		Sum_usr = 0;
	
//	    for (i=0;i<16;i++)	//8
//           {  Sum_usr += (Mas_Temperatur[i]); }

	    Temperatur_n =Sum_usr;//?(( Sum_usr+8)>>4);//&0x7F;//was 4 3???
		Sum_usr = 0;
		}
/*		Sum_usr = 0;
	    for (i=0;i<16;i++)	//8
           {  Sum_usr += (Mas_Temperatur[i]); }

	    Temperatur_n =Sum_usr;//?(( Sum_usr+8)>>4);//&0x7F;//was 4 3???
*/		Time_datchik=0;
      }

    }
/*
void init_izm_Temper_datchika (void)
	{
	  unsigned char i;

	  	ind_Mas=0;

		Temperatur = Temper();
		for (i=0;i<16;i++)
   		   {  Mas_Temperatur[i]=Temperatur; }
	
	}
*/
// опрос кнопок
// 0 - нет нажатия
// 1 - кн1 нагрев
// 2 - кн2 датчик
// 3 - кн3 работа
// 4 - кн1+кн2 - выход в режим подготовки
// 5 - кн1+кн2+кн3 выход в тестовый режим

unsigned char Scan_Key (void)
    {

        P36=1; P37=1; P26=1;
// ??        if ((P1&0xe0) == 0) return 6;
        if (((P3&0xc0) == 0)&&((P2&0x40) == 0)) return 5;
        if ((P3&0xc0) == 0) return 4;
        if ((P3&0x40) == 0) return 1;
        if ((P3&0x80) == 0) return 2;
        if ((P2&0x40) == 0) return 3;

        return 0;
    }


void Wywod_stat_lampy(void)
	{
		fl_lampy1=fl_lampy2=0;
		LCD_xy(15,0);
		 if (stat_lampy1==0) LCD_dw(0x2a);  // вкл
	else if (stat_lampy1==1) LCD_dw('o');  // выкл
	else if (stat_lampy1==2) { LCD_dw(0x41); fl_lampy1=1; } // авария
		LCD_xy(14,0);
		 if (stat_lampy2==0) { LCD_dw(0x2a); } // вкл
	else if (stat_lampy2==1) { LCD_dw('o'); } // выкл
	else if (stat_lampy2==2) { LCD_dw(0x41); fl_lampy2=1; } // авария

	}

void Pisk_awar_lamp (void)
    {
unsigned int i;

		if (fl_lampy1||fl_lampy2)
		  {
      		Zwuk = 1;
        	for (i=0;i<20000;i++) {WDTreset;}//delay_1();//
      		Zwuk = 0;
		  }
		fl_lampy1=0; fl_lampy2=0;
	}

//code unsigned char S_det_stol[17]=
//{0x20,0xe0,0x65,0xbf,0x63,0xba,0xb8,0xb9,0x20,0x63,0xbf,0xef,0xbb,0x20,0x20,0x20,0x00};
code unsigned char T_s[]="T=";

code unsigned char S_podgot[17]=
{0x20,0x20,0x20,0xa8,0xef,0xe3,0xb4,0xef,0xbf,0xef,0xb3,0xba,0x61,0x20,0x20,0x20,0x00};

// "Нагрев  Стол=   "
code unsigned char S_nagrew[17]=
{0x48,0x61,0xb4,0x70,0x65,0xb3,0x20,0x20,0x43,0xbf,0xef,0xbb,0x20,0x20,0x20,0x20,0x00};

// "Датчик на стол "
code unsigned char S_dat[17]=
{0xe0,0x61,0xbf,0xc0,0xb8,0xba,0x20,0xbd,0x61,0x20,0x43,0xbf,0xef,0xbb,0x20,0x20,0x00};

// "     Готов      "
code unsigned char S_gotow[17]=
{0x20,0x20,0x20,0x20,0x20,0xa1,0xef,0xbf,0xef,0xb3,0x20,0x20,0x20,0x20,0x20,0x20,0x00};

// "Работа"
code unsigned char S_rabota[7]=
{0x50,0x61,0xb2,0xef,0xbf,0x61,0x00};

//" Авария секции 1 "
code unsigned char S_awar1[17]=
{0x41,0xb3,0x61,0x70,0xb8,0xc7,0x20,0x63,0x65,0xba,0xe5,0xb8,0xb8,0x31,0x20,0x20,0x00};

//" Авария секции 2 "
code unsigned char S_awar2[17]=
{0x41,0xb3,0x61,0x70,0xb8,0xc7,0x20,0x63,0x65,0xba,0xe5,0xb8,0xb8,0x32,0x20,0x20,0x00};

//" Авария секции 12 "
code unsigned char S_awar12[17]=
{0x41,0xb3,0x61,0x70,0xb8,0xc7,0x20,0x63,0x65,0xba,0xe5,0xb8,0xb9,0x31,0x32,0x20,0x00};

//" Выкл. секции 1 "
code unsigned char S_wykl1[17]=
{0x42,0xc3,0xba,0xbb,0x2e,0x20,0x20,0x63,0x65,0xba,0xe5,0xb8,0xb8,0x31,0x20,0x20,0x00};

//" Выкл. секции 2 "
code unsigned char S_wykl2[17]=
{0x42,0xc3,0xba,0xbb,0x2e,0x20,0x20,0x63,0x65,0xba,0xe5,0xb8,0xb8,0x32,0x20,0x20,0x00};

//" Выкл. секции 12 "
code unsigned char S_wykl12[17]=
{0x42,0xc3,0xba,0xbb,0x2e,0x20,0x20,0x63,0x65,0xba,0xe5,0xb8,0xb9,0x31,0x32,0x20,0x00};

// перегрев
code unsigned char S_peregrew[17]=
{0x20,0x20,0x20,0x20,0xa8,0x45,0x50,0x45,0xa1,0x50,0x45,0x42,0x20,0x20,0x20,0x20,0x00};

code unsigned char S_clr[]={"                "};
sbit TMbit = P0^2;

 void main(void)
	{
unsigned int i;


	Zwuk = 0;	// выключить звук
   WDTCN = 0xde;
   WDTCN = 0xad;
  SYSCLK_Crystal_Init_F005 ();   
   // Инициализация кроссбара
   XBR2 = 0xc0;
fl_sboy = 0; 
	T0_init();
	LCD_init();     //инициализация LCD
	LCD_clear();
	WDTreset;

// инициализация ОЗУ
//init_izm_Temper_datchika ();

 Time_1000=0;

fl_key = 0; 

stat_lampy1=0; stat_lampy2=2;

//void ADC_Init (void)
{
   ADC0CN = 0x00;	// ADC disabled; normal tracking mode
   REF0CN = 0x03;//7;	// enable temp sensor, on-chip VREF, VREF output buffer
   AMX0CF = 0x60;	// dual 4&5;0-separate pins
   AMX0SL = 0x04;	// AIN4
   ADC0CF = 0x86;	// ADC conversion clock = sysclk/16
}

/////////////////////////

while (1)
 {

     WDTreset;

L_podgot: ;
// режим подготовка
regim1 = regim2 = 1;


//for (i=0; i < 16; i++)	Mas_Temperatur[i] = 0;
Temperatur_n=T0*16;

	LCD_xy(0,0); LCD_string(S_podgot);
	LCD_xy(0,1); LCD_string(S_clr);
    // ожидаем нажатия кнопки "Разогрев"
    cnt_mig = 0;
  
    while ((Scan_Key ()) != 1)
         {
            izm_Temper_datchika ();
			msprintf();	//sss,"   T=%4.1f      ",Temperatur); 
//			sss[9]=0xdf; sss[10]=0;//??
	//for(i=8;i>1;i--) sss[i]=sss[i-2];
	//sss[0]='T'; sss[1]='=';
			LCD_xy(0,1); LCD_string(T_s);	LCD_string(sss);
			Wywod_stat_lampy();
            Pisk_awar_lamp ();
            if (cnt_mig == 4)	            // мигаем номером кнопки, которую нужно нажать
              {  cnt_mig = 0;
                 if (fl_key == 0) { LCD_xy(15,1); LCD_dw(0x31); fl_key = 1; }
                   else { LCD_xy(15,1); LCD_dw(0x20); fl_key = 0; }
              }
              cnt_mig++;
         }
////////////////////////////////////////////////
L_nagrew: 		// режим Разогрев
		regim1 = regim2 = 2;

    LCD_xy(0,0); LCD_rus_string("Нагрев          ");
    LCD_xy(0,1); LCD_string(S_dat); // "Датчик на стол "
          izm_Temper_datchika ();
 			Wywod_stat_lampy();
			Pisk_awar_lamp ();
    // ожидаем нажатия кнопки "Датчик"
    cnt_mig = 0;
    while ((Scan_Key ()) != 2) 
         {
            izm_Temper_datchika ();
			msprintf();	//sss,"%4.1f",Temperatur);
//?			 sss[4]=0xdf; sss[5]=0;
			LCD_xy(7,0); LCD_string(sss);

 			Wywod_stat_lampy();
			Pisk_awar_lamp ();

            // мигаем номером кнопки, которую нужно нажать
            if (cnt_mig == 4)
              {  cnt_mig = 0;
                 if (fl_key == 0) { LCD_xy(15,1); LCD_dw(0x32); fl_key = 1; }
                   else { LCD_xy(15,1); LCD_dw(0x20); fl_key = 0; }
              }
              cnt_mig++;

         }
    // убрать сообщение "Датчик на стол "

    LCD_xy(0,1); LCD_string(S_clr);

    // отслеживаем достижение заданной температуры нагрева
Min_T=Max_T=Temperatur/10;
 Time_1000=0;
Time_3min=0;
stat_12_pred=stat_12;

fl_wykl_zwuk=0;
fl_gotow =0;

while (fl_gotow==0) 
         {
            izm_Temper_datchika ();
			msprintf();	//sss,"%3.1f",Temperatur);
//?			 sss[4]=0xdf; sss[5]=0;
			LCD_xy(8,0); LCD_string(sss);

 			Wywod_stat_lampy();
			Pisk_awar_lamp ();

            // проверка на перегрев
            if (fl_wykl_zwuk==0)
              {
                if (Temperatur/10 >= 40)
                  { Zwuk = 1;  LCD_xy(0,1); LCD_string(S_peregrew);  }
                else 
                  { Zwuk = 0; LCD_xy(0,1); LCD_string(S_clr); }
              }
            else
              { Zwuk = 0;
                if (Temperatur/10 >= 40)
                  {   LCD_xy(0,1); LCD_string(S_peregrew);  }
                else 
                  {  LCD_xy(0,1); LCD_string(S_clr); }
              }

           // проверка нагрева воздуха через 10 cek
            if (Time_1000 >= 1000)
              {
                if (Temperatur/10 < Min_T) Min_T=Temperatur/10;
                if (Temperatur/10 > Max_T) Max_T=Temperatur/10;

				if ((Max_T-Min_T)< 1 ) //0.5)
				  if (stat_12_pred==stat_12) Time_3min++;
				    else { Time_3min = 0; stat_12_pred=stat_12; }
				else 
				   { Time_3min=0; Min_T=Max_T=Temperatur/10; }

                Time_1000=0;

              }
            // если в течении 5 минут T воздуха не растет, то готов
            if (Time_3min >= 30) fl_gotow=1;	// !!!!!!!!!! 18


            if ((Scan_Key ()) == 3) break;

            // выключить звуковой сигнал по нажатию кнопки 1	
            if ((Scan_Key ()) == 1) { Zwuk = 0; fl_wykl_zwuk=1; }

         }



    // выдать звуковой сигнал и сообщение "Готов"

		if (fl_gotow==1) Zwuk = 1;
		Time_1000=0;

        LCD_xy(0,1); LCD_string(S_gotow); // "     Готов      "

    // ожидаем нажатия кнопки "Работа"
    cnt_mig = 0;
 
    while ((Scan_Key ()) != 3) 
         {
           WDTreset;
            // мигаем номером кнопки, которую нужно нажать
            if (cnt_mig == 20000)
              {  cnt_mig = 0;
                 if (fl_key == 0) { LCD_xy(15,1); LCD_dw(0x33); fl_key = 1; }
                   else { LCD_xy(15,1); LCD_dw(0x20); fl_key = 0; }
              }
              cnt_mig++;

            // выключить звук через 10 сек
            if (Time_1000 >= 1000) Zwuk = 0;
         }

////////////////////////////////////////////////
L_rabota: ;
// режим Работа
regim1 = regim2 = 3;
    // выключить звуковой сигнал
    Zwuk = 0;
stat_12_pred=stat_12;

//    memcpy(sss,S_rabota,6);
//    memcpy(sss,"       ",7);//memcpy(sss+6,"          ",10);
    LCD_xy(0,0); LCD_string(S_rabota);

    // убрать сообщение "Готов "
    LCD_xy(0,1); LCD_string(S_clr);


    for (i=0;i<20000;i++) {WDTreset;}

    // ожидаем нажатия кнопки "Работа"
    cnt_mig = 0;
 
    fl_Zwuk1=fl_Zwuk2=fl_Zwuk3=fl_wykl_zwuk=0;

 while ((Scan_Key ()) != 3) 
 {
            izm_Temper_datchika ();
 			msprintf();	//sss,"%3.1f",Temperatur);
//?			 sss[4]=0xdf; sss[5]=0;
			LCD_xy(8,0); LCD_string(sss);

 			Wywod_stat_lampy();

// слежение за состоянием ламп
   if (fl_wykl_zwuk==0)
   {
     // проверка на перегрев
     if (Temperatur/10 >= 40)
      {
         	 Zwuk = 1; fl_Zwuk3=1; 
			 LCD_xy(0,1); LCD_string(S_peregrew); /* " перегрев Т > 40 "*/ 

      }
    else 
      {
          if ((fl_Zwuk1==0)&&(fl_Zwuk2==0))
             { Zwuk = 0; LCD_xy(0,1); LCD_string(S_clr); }

      }
     
  	 // проверка на аварии
	 if (stat_12== 0x22)
	  { 
         	 Zwuk = 1; fl_Zwuk1=1; fl_Zwuk2=1;
			 LCD_xy(0,1); LCD_string(S_awar12); /* " Авария секции 12 "*/ 
			 goto l_endif;
	  }
     if ((stat_12&0xf0)== 0x20)
	  { 
	   		Zwuk = 1; fl_Zwuk1=1;
	   		LCD_xy(0,1); LCD_string(S_awar1); /* " Авария секции 1 "*/ 
			 goto l_endif;
	  }
     if ((stat_12&0x0f)== 0x02)
      { 
	   		Zwuk = 1; fl_Zwuk2=1;
	   		LCD_xy(0,1); LCD_string(S_awar2); /* " Авария секции 2 " */
			 goto l_endif;
	  }
	 
	 // изменилось состояние секции  	 
	 if ((stat_12_pred!=stat_12)&&(stat_12== 0x11))
	  { 
		   	 // выдать звуковой сигнал
         	 Zwuk = 1; fl_Zwuk1=1; fl_Zwuk2=1;
			 LCD_xy(0,1); LCD_string(S_wykl12); /* " Выкл. секции 12 "*/
			 goto l_endif; 
	  }	 

	 if ((stat_12_pred&0xf0) != (stat_12&0xf0)) 
	  {	// изменилось состояние секции1
	     // выдать звуковой сигнал
		 Zwuk = 1; fl_Zwuk1=1;
	    if ((stat_12&0xf0)== 0x10)
		   { LCD_xy(0,1); LCD_string(S_wykl1); /* " Выключена секция 1 "*/ }
	  } 
     else 
      {
	    fl_Zwuk1=0;
       if ((fl_Zwuk2==0)&&(fl_Zwuk3==0))
              { Zwuk = 0; LCD_xy(0,1); LCD_string(S_clr); }
      }
	 if ((stat_12_pred&0x0f) != (stat_12&0x0f)) 
	  {	// изменилось состояние секции2
	     // выдать звуковой сигнал
         Zwuk = 1; fl_Zwuk2=1;
	   if ((stat_12&0x0f)== 0x01)
 			{ LCD_xy(0,1); LCD_string(S_wykl2); /* " Выключена секция 1 "*/ }
      }
     else 
      {  fl_Zwuk2=0;
        if ((fl_Zwuk1==0)&&(fl_Zwuk3==0))
             { Zwuk = 0; LCD_xy(0,1); LCD_string(S_clr); }
      }
   } // if слежение
 else
   { 
    if (Temperatur/10 >= 40)
         {   LCD_xy(0,1); LCD_string(S_peregrew);  }
    else 
         {  LCD_xy(0,1); LCD_string(S_clr); }
   }

l_endif: ;
           // мигаем номером кнопки, которую нужно нажать
      if (cnt_mig == 1)
       {  cnt_mig = 0;
         if (fl_key == 0)
		 	 { LCD_xy(15,1); LCD_dw(0x33); fl_key = 1; }
         else 
		 	 { LCD_xy(15,1); LCD_dw(0x20); fl_key = 0; }
       }
      cnt_mig++;
	// выключить звуковой сигнал по нажатию кнопки 1	
     if ((Scan_Key ()) == 1) { Zwuk = 0; fl_wykl_zwuk=1; }

 } // while

    // выключить звуковой сигнал
    Zwuk = 0;

// переход в режим подготовки

WDTreset;

////////////////////////////////

  }  // end while(1)



}  	// end main()



int Temper(void)
{
//int i,j;

	ADCEN = 1;//ADC0CN=0x10;		// Enable ADC0
	ADBUSY = 1;	// Initiate conversion
	while (!ADCINT);// Wait for conversion to complete
	ADCINT = 0;	// Clear end-of-conversion indicator
	T_lampy2=ADC0;
	return(T_lampy2);

}
void msprintf(void)	//int ur)
{
//unsigned int si;

//ADC 
		Temperatur=(Temperatur_n+32)>>6;
/*old
	T_lampy2=(Temperatur_n-4770-854);//?4770 T0*16+2;3
	T_lampy1=T_lampy2*32;
	T_lampy2=(T_lampy1+27)/55+487;//500; 0x197-12A=109
*/
/*last
	T_lampy2=(Temperatur_n+5)/10-10;//500; 0x197-12A=109
if(T_lampy2 < 0 )
	{
	sss[0]='-';
	Temperatur=-T_lampy2;
	}
	else
	{
	sss[0]=' ';
	Temperatur=T_lampy2;
	}
*/
sss[1]=Temperatur/1000;
 T_lampy1=Temperatur-sss[1]*1000;//tail
sss[2]=T_lampy1/100;
 T_lampy2=T_lampy1-sss[2]*100;//tail
sss[3]=T_lampy2/10;
sss[5]=T_lampy2-sss[3]*10;//tail
if(sss[1] == 0) sss[1]=' '; else sss[1]|=0x30;
if((sss[2] == 0) && (sss[1] == ' ')) sss[2]=' '; else sss[2]|=0x30;
sss[3]|=0x30;
sss[4]=',';
sss[5]|=0x30;
sss[6]='\0';
}

/*
int Temper(void)
{
//int i,j;

	ADCEN = 1;//ADC0CN=0x10;		// Enable ADC0
	ADBUSY = 1;	// Initiate conversion
	while (!ADCINT);// Wait for conversion to complete
	ADCINT = 0;	// Clear end-of-conversion indicator
	T_lampy2=(ADC0-T0);//?-1
	T_lampy1=T_lampy2*105;
	T_lampy2=(T_lampy1+5)/11-5;//-55; 0x193-T0=127
//if( j < 0 ) j=0;
	return(T_lampy2);

}
void msprintf(void)	//int ur)
{
//int i;

sss[0]=' ';
if(Temperatur_n < 0 )
	{
	sss[0]='-';
	Temperatur=-Temperatur_n;
	}
	else
	{
	sss[0]=' ';
	Temperatur=Temperatur_n;
	}

sss[1]=Temperatur/1000;
 T_lampy1=Temperatur-sss[1]*1000;//tail
sss[2]=T_lampy1/100;
 T_lampy2=T_lampy1-sss[2]*100;//tail
sss[3]=T_lampy2/10;
sss[5]=T_lampy2-sss[3]*10;//tail
if(sss[1] == 0) sss[1]=' '; else sss[1]|=0x30;
if((sss[2] == 0) && (sss[1] == ' ')) sss[2]=' '; else sss[2]|=0x30;
sss[3]|=0x30;
sss[4]=',';
sss[5]|=0x30;
sss[6]='\0';
}
*/