//===========================
//  редакция 24.06.2005 
//---------------------------



//============================
//         Утилиты
//============================
#define SetBit(A,B)  A=A|(1<<B)   // установить бит в переменной
#define ClrBit(A,B)  A=A&~(1<<B)  // сбросить бит в переменной
#define IsBit(A,B)   (A&(1<<B))>0 // проверка бита в переменной

// объединение двух char в int
//#define CH_TO_INT(ml,st,_int) {*((unsigned char*)(&_int))=st;*(((unsigned //char*)(&_int))+1)=ml;}



typedef union
{
   unsigned int I;
   unsigned char C[2];    // 0 - старшая 1 - младшая часть int
} IC;


typedef union
{                          /*  для 51 процессора */ /*  для IBM PC        */
//+     float F;              /*   ст      -  мл    */ /*   мл      -  ст    */
     unsigned long  L;     /*   H0    -     L0   */ /*   L0    -     H0   */
     unsigned int I[2];    /*   H0    -     L0   */ /*   L0    -     H0   */
     unsigned char C[4];   /*   H0  L0  H1  L1   */ /*   L0  H0  L1  H1   */
} FLIC ;                   /*   0   1   2   3    */ /*   0   1   2   3    */








//дополнительный регистр разрешения прерываний EIE1
#define CP2IE	6
#define CP1IE 	5
#define CP0IE	4
#define EPCA0 	3
#define EWADC0 	2
#define ESMB0 	1
#define ESPIO	0

//дополнительный регистр разрешения прерываний EIE2
#define ES1	6
#define ECAN0 	5
#define EADC2	4
#define EWADC2 	3
#define ET4 	2
#define EADC0 	1
#define ET3	0

//доплнительный регистр приоритетов EIP1
#define PCP2	6
#define PCP1 	5
#define PCP0	4
#define PPCA0 	3
#define PWADC0 	2
#define PSMB0 	1
#define PSPI0	0

//доплнительный регистр приоритетов EIP2
#define EP1	6
#define PCAN0 	5
#define PADC2	4
#define PWADC2 	3
#define PT4 	2
#define PADC0 	1
#define PT3	0


//распределение бит в TMOD
#define GATE1 	7
#define C_T1 	6
#define T1M1 	5
#define T1M0 	4
#define GATE0 	3
#define C_T0 	2
#define T0M1	1
#define T0M0	0


//TMRnCF - регистр конфигурации таймеров 2,3,4
#define TnM1	4	//флаг выбора источника входной частоты
#define TnM0	3	//флаг выбора источника входной частоты
#define TOGn	2	//режим выхода
#define TnOE	1	//разрешение выхода
#define DCEn	0	//направление счета








///////////////////////////
// НЕ ПРОВЕРЕНО!!!!!!! НИЧЕГО!!!!!!!!

//======================================
//PCA0MD: регистр режимов для PCA0 (0xD9)
//--------------------------------------
#define ECF	0		//бит маскирования флага переполнения счетчика PCA0
				//0 - запретить прерывания от CF
				//1 - разрешить прерывания от CF
//======================================
//PCA0CPMn: регистр режимов для защелок (для каждого канала)
//--------------------------------------
#define PWM16	7		//разрешить 16-bit Pulse Width Modulation
#define ECOM	6		//разрешить функцию сравнения
#define CAPP	5		//разрешить захват по положительному фронту
#define CAPN	4		//разрешить захват по отрицательному фронту
#define MAT	3		//разрешить функцию Match 
#define TOG	2		//Toggle Function Enable.
#define PWM	1		//Pulse Width Modulation Mode Enable.
#define ECCF	0		//разрешить прерывания от соответствующего модуля
//======================================
//CPT0CN: регистр управления компаратором 0 (0x9E)
//--------------------------------------
#define CP0EN	7		//разрешить компаратор 0
#define CP0OUT	6		//состояние выхода компаратора 0
				//0:Voltage on CP0+<CP0-
				//1:Voltage on CP0+>C 0-
#define CP0RIF	5		//флаг прерываний по нарастающему фронту
#define CP0FIF	4		//флаг прерываний по падающему фронту
#define CP0HYP1	3		//биты управления положительным гистерезисом
#define CP0HYP0	2		//
				//00:positive Hysteresis Disabled.
				//01:positive Hysteresis =2 mV.
				//10:positive Hysteresis =4 mV.
				//11:positive Hysteresis =10 mV.
#define CP0HYN1	1		//биты управления отрицательным гистерезисом
#define CP0HYN0	0		//
				//00:Negative Hysteresis Disabled.
				//01:Negative Hysteresis =2 mV.
				//10:Negative Hysteresis =4 mV.
				//11:Negative Hysteresis =10 mV.



//===========================
//порт 0
sbit P07	=	P0^7;	
sbit P06	=	P0^6;	
sbit P05	=	P0^5;	
sbit P04	=	P0^4;	
sbit P03	=	P0^3;	
sbit P02	=	P0^2;	
sbit P01	=	P0^1;	
sbit P00	=	P0^0;	

//===========================
//порт 1
sbit P17	=	P1^7;	
sbit P16	=	P1^6;	
sbit P15	=	P1^5;	
sbit P14	=	P1^4;	
sbit P13	=	P1^3;	
sbit P12	=	P1^2;	
sbit P11	=	P1^1;	
sbit P10	=	P1^0;	

//==========================
//порт 2
sbit P27	=	P2^7;	
sbit P26	=       P2^6;	
sbit P25	=	P2^5;	
sbit P24	=	P2^4;	
sbit P23	=	P2^3;	
sbit P22	=	P2^2;	
sbit P21	=	P2^1;	
sbit P20	=	P2^0;	

//===========================
//порт 3
sbit P37	=	P3^7;	
sbit P36	=       P3^6;	
sbit P35	=	P3^5;	
sbit P34	=	P3^4;	
sbit P33	=	P3^3;	
sbit P32	=	P3^2;	
sbit P31	=	P3^1;	
sbit P30	=	P3^0;	

//===========================
//порт 4
//sbit P47	=	P4^7;	
//sbit P46	=       P4^6;	
//sbit P45	=	P4^5;	
//sbit P44	=	P4^4;	
//sbit P43	=	P4^3;	
//sbit P42	=	P4^2;	
//sbit P41	=	P4^1;	
//sbit P40	=	P4^0;	


//===========================
// некоторые регистровые пары 
//  С младшего байта....видимо
//---------------------------
sfr16 RCAP2   = 	0xCA;                 // Timer2 reload value
sfr16 TMR2    =		0xCC;                 // Timer2 counter

sfr16 RCAP3   = 	0xCA;                 // Timer3 reload value
sfr16 TMR3    =		0xCC;                 // Timer3 counter

sfr16 RCAP4   = 	0xCA;                 // Timer4 reload value
sfr16 TMR4    =		0xCC;                 // Timer4 counter


sfr16 PCA0    =         0xF9;

sfr16 PCA0CP  =         0xFB;
sfr16 PCA1CP  =         0xFD;
sfr16 PCA2CP  =         0xE9;
sfr16 PCA3CP  =         0xEB;
sfr16 PCA4CP  =         0xED;
sfr16 PCA5CP  =         0xE1;



sfr16 ADC0     =	0xbe;
sfr16 ADC0G    =	0xc4;
sfr16 ADC0LL   =	0xc6;

/////////////////////////////////////////////////////////////////////////////////////
//   ПРОВЕРЕНО!!!

/*==============================*/
/* Interrupt Vector Definitions */
/*==============================*/
#define EXT0_interrupt         void EXT0_int  (void)  interrupt 0
//[0x03] Внешнее прерывание 0 

#define T0_interrupt           void T0_int    (void)  interrupt 1
//[0x0B] Переполнение таймера 0 

#define EXT1_interrupt         void EXT1_int  (void)  interrupt 2
//[0x13] Внешнее прерывание 1 

#define T1_interrupt           void T1_int    (void)  interrupt 3
//[0x1B] Переполнение таймера 1

#define UART0_interrupt        void UART1_int (void)  interrupt 4
//[0x23] Serial Port 0 

#define T2_interrupt           void T2_int    (void)  interrupt 5
//[0x2B] Переполнение таймера 2

#define SPI_interrupt          void SPI_int   (void)  interrupt 6
//[0x33] Интерфейс SPI              

#define SMBus_interrupt        void SMBus_int (void)  interrupt 7
//[0x3B] Интерфейс SMBus              

#define ADC0W_interrupt        void ADC0W_int (void)  interrupt 8
//[0x43] Компаратор "окна" ADC0              

#define PCA_interrupt          void PCA_int   (void)  interrupt 9
//[0x4B] Программируемый счетчик/массив PCA              

//////////////////////////////////////////
//////// УДАЛЕНЫ КОМПАРАТОРЫ!!!!
//////////////////////////////////////////

#define T3_interrupt           void T3_int    (void)  interrupt 14
//[0x73] Переполнение таймера 3  

#define ADС0_interrupt         void ADС0_int  (void)  interrupt 15
//[0x7B] Завершение преобразования ADC0              

#define T4_interrupt           void T4_int    (void)  interrupt 16
//[0x83] Переполнение таймера 4              

#define ADС2W_interrupt        void ADС2W_int (void)  interrupt 17
//[0x93] Компаратор "окна" ADC2W             

#define ADС2_interrupt         void ADС2_int  (void)  interrupt 18
//[0x8B] Завершение преобразования ADC2              
 
#define CAN_interrupt          void CAN_int   (void)  interrupt 19
//[0x9B] прерывание CAN            

//////////////////////////////////////////////////////////////////
/////////   СТРАННО . ВТОРОЕ ПРЕРЫВАНИЕ . НЕТ УПОМИНАНИЯ В pdf.
//////////////////////////////////////////////////////////////////



//#define EXT7_interrupt         void EXT7_int  (void)  interrupt 19
//[0x9B] Внешнее прерывание 7    

#define UART1_interrupt        void UART1_int (void)  interrupt 20
//[0xA3] Serial Port 1              


/***********  WDT **************************************************/
// ГДЕ ON/OFF, SET, RESET 
//# define WDToff   { WDTCN = 0xDE;    WDTCN = 0xAD; }
//#define WDTreset { WDTCN = 0x07;    WDTCN = 0xA5; } // разрешает и сбрасывает 
# define WDTreset {  }


