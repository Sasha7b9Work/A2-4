#include <stdio.h>
#include <math.h>
#include <c8051f020.h>

//------------------------------------------------------------------------------------
// 16-bit SFR Definitions for 'F02x
//------------------------------------------------------------------------------------


sfr P2MDIN   = 0xF3;    // PORT 2 INPUT MODE REGISTER   
sfr TMR2CN   = 0xC8;    // TIMER 2 CONTROL               
sfr P0MDIN   = 0xF1;    // PORT 0 INPUT MODE REGISTER  
sfr P3MDIN   = 0xF4;    // PORT 3 INPUT MODE REGISTER  
sfr P0SKIP   = 0xD4;    // PORT 0 CROSSBAR SKIP
sfr P1SKIP   = 0xD5;    // PORT 1 CROSSBAR SKIP                                     */
sfr IT01CF   = 0xE4;    // INT0/INT1 CONFIGURATION                                         */
sfr AMX0N    = 0xBA;    // ADC0 MUX NEGATIVE CHANNEL SELECTION                      */
sfr AMX0P    = 0xBB;    // ADC0 MUX POSITIVE CHANNEL SELECTION
sfr TMR2RLL  = 0xCA;    // TIMER 2 RELOAD LOW                                       */
sfr TMR2RLH  = 0xCB;    // TIMER 2 RELOAD HIGH                                      */
sfr TMR2L    = 0xCC;    // TIMER 2 LOW BYTE                                         */
sfr TMR2H    = 0xCD;    // TIMER 2 HIGH BYTE 
sfr SMB0CF   = 0xC1;    // SMBUS CONFIGURATION        
sfr CLKSEL   = 0xA9;    // CLOCK SOURCE SELECT 
  
sbit TF2L    = TMR2CN ^ 6; // TIMER 2 LOW BYTE OVERFLOW FLAG                        */
sbit TF2H    = TMR2CN ^ 7; // TIMER 2 HIGH BYTE OVERFLOW FLAG        
              
/////////////
//-----------------------------------------------------------------------------
// Global CONSTANTS
//-----------------------------------------------------------------------------
#define TIMER2_RATE     1000           // Timer 2 overflow rate in Hz

#define SOAK_TIME          15          // Soak Time in Seconds

//sbit	P3.1=P3^1;

//void main (void)
//{
	char data dj;
	int  data dk;
	int	 data tdelay;
	int	 data acc;

	char data 	marbuf;
	//char data	bufind=0x4e;
	int	 data  bufind [32]=0x2e;
	char data 	marbuf;






//-----------------------------------------------------------------------------
// Function PROTOTYPES
//-----------------------------------------------------------------------------
void wait_one_second (void);
//void del_second(void);	
void del_second (unsigned int tdelay);
void wait_soak_time (unsigned char soak_time);
void write (int acc);
void read (int acc);
void loop ();
void ind();
void wwind();



main ()
{
 	SP=0x0e0;
	PCA0L=0;
	PCA0MD= 00000000;
	P0MDOUT=00000000;
	P1MDOUT=0xbf;//10111111;
	P2MDOUT=0x3f;//00111111;
	P2MDIN=0xff;//11111111;
	P3MDOUT =0x17;//00010111;
	P0MDIN=0xf2;//11110010;
	P3MDIN=0xff;//11111111;
    P0SKIP=0x8d;//10001101;
	/////////////////////
	P1SKIP=0x0f;//00001111;
    P1MDIN=0xf0;//11110000;
	XBR0= 0x05;//00000101;
	XBR1 =0x42;//01000010;
	IT01CF=00000000;
 
	SMB0CF=0xc2;//11000010; 
	SCON0=0x10;                                   
	TMOD=0x42;//00100010;	//регистр режимов
	CKCON=0x30;//00110000;    //сист частота/12                 ; Установка таймера
	TH0=0x0f9;
	TL0=0x0f9; 
	EIE1=0x80;//10000000;

	AMX0P=0x13;//00010011;
	AMX0N=0x1f;//00011111;
	ADC0CF=0xf8;//11111000;
	ADC0CN=0x80;//10000000;
	OSCXCN=0xe7;//11100111;
//





//gener:     mov a, oscxcn
//           cjne a,#11100111b,gener

	marbuf=OSCXCN;
	while    (marbuf!=11100111){
		marbuf=OSCXCN;
}
   //CLKSEL=00000001;                    
   //OSCICN=01000011; 
   TMR2RLL=0;
   TMR2RLH=0xd1;
   TMR2CN=00001100;
	TMR2CN=TMR2CN&0xbf;  //tmr2cn.6=0
	TMR3L=0xcc;
	TMR3H=0x0f8;
	TMR3RLL=0xcc;
	TMR3RLH=0xf8;
	TMR3CN=00000100;
    TCON=TCON|01000000;  //TCON.6=1 регистр управления
	TCON=TCON|00010000;//	 tcon.4=1

//	VDM0CN=0x80;//упр монитором питания
	RSTSRC=02	;//источники сброса 

	IE=10000000	;//Снятие блокировки всех прерываний
     
	 SP=  0xe0;    
    IP=IP|00010000;//IP.4=1
	TL1=0;//Занесение константы в младший байт таймера 1
    TH1=0xd0;//Занесение константы в старший байт таймера 1
	PCA0CPH2=0x80;
	PCA0CPL2=0x80;
    PCA0MD=00000101;
	PCA0CPM0=00100000;
	PCA0CPM1=00100000;
	PCA0CPM2=00000011;
	CPT1CN=10000000;
	CPT0CN=10000000;
	REF0CN=00000010;
	ADC0H=0;
	ADC0L=0;

;;;;;;;;;;;;;;;;;
//start: 
     
	//////////////////////
//инициализация индикатора
	P3=P3&0x10;//	  clr P3.4
	//				call z_100         ;строб
	P3=P3|0x10;//	setb P3.4

	P3=P3&0xF7;//   clr P3.3

	 del_second ();//(unsigned 0x40);//          call z_15         ;задержка 15 мс
//          clr c          ;установка регистра команд
    acc=0x30;//     mov A,#30h     ;устанавливаем разрядность шины
	write();//		call x1              ;переход к записи
//					call z_15         ;задержка 15 мс
	write();//		call x1               ;переход к записи
//					call z_100        ;задержка 100 мкс
         
	write();//		call x1               ;запись
         
	loop();//		call loop            ;проверка флага BF

    acc=0x38;//      mov A,#38h     ;устанавливаем режим развертки изображения в две строки
     write();//   	call x1               ;запись
     loop();//   	call loop                     ;проверка флага BF

     acc=0x06;//   	mov A,#06h     ;устанавливаем режим автоматического перемещения курсора слева-направо после вывода каждого символа 
     write();//    	call x1               ;запись
	 loop();//		call loop                     ;проверка флага BF 

     acc=0x02;//     mov A,#02h     ;начало строки адресуется в начале DDRAM
	write();//				call x1               ;запись
	loop();//				call loop                     ;проверка флага BF

      acc=0x0c;//    mov A,#0Ch     ;включаем отбражение на экране ЖКИ-модуля, без отображения курсоров
	write();//				call x1               ;запись
	loop();//				call loop                     ;проверка флага BF




/////////          
	ind();		
////////////////////////////////	  
  				

/////////
	printf("hello\n");

	P0=0x20;
	tdelay=2;
	del_second();
	acc=0x20;
	write ();
	read();


	bufind[0]=0x66;
	marbuf=0x0a;
//	loop();
}

//-----------------------------------------------------------------------------
// Support Subroutines
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// wait_soak_time
//-----------------------------------------------------------------------------
//
// This routine waits for the number of seconds indicated in the constant
// <SOAK_TIME>.
// 
void wait_soak_time (unsigned char soak_time)
{
   unsigned char i;

   for( i = soak_time; i != 0; i--) {
      wait_one_second();
      printf ("Soaking...%d\n", (int) i);
   }
}
 //-----------------------------------------------------------------------------
// wait_one_second
//-----------------------------------------------------------------------------
//
// This routine uses timer 2 to insert a delay of approximately one second.
// Timer 2 overflows <TIMER2_RATE> times per second
//
void wait_one_second (void)
{
   unsigned int count;
   TF2H = 0;                           // Clear Timer2 overflow flag
   TR2 = 1;                            // Start Timer2
   
   for (count = TIMER2_RATE; count != 0; count--) {
      while (!TF2H);                   // wait for overflow
      TF2H = 0;                        // clear overflow indicator
   }

   TR2 = 0;                            // Stop Timer2
}
//задержка 2 мкс
void del_2mks_second (void)
{
	unsigned int count;
	for (count = 4; count != 0; count--) {
	}
}

//задержка 34 мкс(z_5)
void del_34mks_second (void)
{
	unsigned int count;
	for (count = 0x8b; count != 0; count--) {
	}
}
//пп записи
void write (int acc)	//запись(X1)
{
    P3= P3|0x02; //p3.1=0   mov P3.1,c        
    P2=acc;
	P3=P3|0x08;	  //P3.3=1
				
	del_34mks_second();// задержка   call z_5
					
	P3=P3&0xf7;//  P3.3=0
	P2=0xFF;
}

// пп чтение     x2  
void read (int acc)
{
          P3= P3&0xfd; //p3.1=0  mov P3.1,c        
          P3=P3|0x0c;	//setb P3.2,	  setb P3.3
		  del_2mks_second();//			call z_2
		  acc=P2;    //  mov A,P2
		  P3=P3&0xf3; // clr P3.3  clr P3.2
		  
}

void loop(void)
{     read();	//call x2       ;ожидание флага готовности
	  acc=acc|0x80; // jb ACC.7,loop     ;переход на чтение, если бит А(7)=1
			     //        ;возврат, если бит А(7)<>1
		
while	 (acc=0x80){
		acc=acc|0x80;
		 }				 
}

//задержка 100 мкс
void del_second (unsigned int tdelay)
{
	unsigned int count;
	for (count = tdelay; count != 0; count--) {
	}
}

void ind()
{	
	
				
//      		mov R0,#2Eh       ;загрузка счетчика

//M2:
	    	loop();//call	loop
//					setb c         ;установка регистра данных
          
//					mov A,@R0      ;пересылаем содержимое R0 в аккумулятор
			write();//          call x1               ;запись
//          inc R0          ;инкремент счетчика
		
//				  cjne R0,#3Eh,M2  ;сравнение аккумулятора с константой и переход, если не =0  

         	

//f5:		   
//          clr c          ;установка регистра команд
			loop();//		  	  call loop                     ;проверка флага BF
//  			  mov A,#0C0h 
			write();//        	call x1               ;запись
			loop();//					call loop                     ;проверка флага BF

//  				mov R0,#3Eh      ;загрузка счетчика

//M3:
			loop();//	  	call	loop                    ;проверка флага BF
//        	setb c        ;установка регистра данных
//        	mov A,@R0     ;пересылаем содержимое R0 в аккумулятор
			write();//         	call x1               ;запись
//         	inc R0          ;инкремент счетчика
			
//					cjne R0,#4Eh,M3  ;сравнение аккумулятора с константой и переход, если не =0
			
}//					ret



//-----------------------------------------------------------------------------
// Initialization Subroutines
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// SYSCLK_Init
//-----------------------------------------------------------------------------
//
// This routine initializes the system clock to use an 22.1184MHz crystal
// as its clock source.
//
void SYSCLK_Init (void)
{
   int i;                              // delay counter

   OSCXCN = 0x67;                      // start external oscillator with
                                       // 22.1184MHz crystal

   for (i=0; i < 256; i++) ;           // XTLVLD blanking interval (>1ms)

   while (!(OSCXCN & 0x80)) ;          // Wait for crystal osc. to settle

   OSCICN = 0x88;                      // select external oscillator as SYSCLK
                                       // source and enable missing clock
                                       // detector
}
			 
