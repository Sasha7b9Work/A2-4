#include <stdio.h>
#include <math.h>
#include <c8051f020.h>
#include<stdlib.h>

//------------------------------------------------------------------------------------
// 16-bit SFR Definitions for 'F02x
//------------------------------------------------------------------------------------


sfr P2MDIN   = 0xf3;    // PORT 2 INPUT MODE REGISTER   
sfr TMR2CN   = 0xc8;    // TIMER 2 CONTROL               
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
sfr VDM0CN   = 0xFF;    // VDD MONITOR CONTROL                   
/////////////
 sbit  BIT6p1=P1^6;
 sbit  BIT7p1=P1^7;
 sbit  BITacp=P1^6	;//бит acp
 sbit  BIT5p1=P1^5;
 sbit  Rdat=P1^6;//


//bit  BITzn;		//бит знака	

//-----------------------------------------------------------------------------
// Global CONSTANTS
//-----------------------------------------------------------------------------
#define TIMER2_RATE     1000           // Timer 2 overflow rate in Hz

#define SOAK_TIME          15          // Soak Time in Seconds

	int		j;
	int		a;
	unsigned char     save;
	char portread;
	float rez;//double rez;
	char data dj;
	char  data dk;

	int	 data acc;

	char buffer [10];
 	int n, a=0xfe, b=3;
  	unsigned long  k;
	unsigned data	wriacp;
	unsigned char	rezacp;
	char data R3R4R5[3];//3байта
	unsigned  long ccc;//3байта
	int ddd;

	char data  bufind [32]_at_ 0x2e;



//
//-----------------------------------------------------------------------------
// Function PROTOTYPES
//-----------------------------------------------------------------------------
void wait_one_second (void);
//void del_second(void);	
void del_second (int tdelay);
//void wait_soak_time (unsigned char soak_time);
void write ();
void read ();
void loop ();
void ind();
//void wwind();
void d100mk_second();
void d15ms_second();
void del_2mks_second();
void del_34mks_second();
void tim2();
void tim();
void  chtadc();	
void  zapadc();
//void real();
void zreal();
void rrr();



main ()
{
 	SP=0x0e0;
	PCA0L=0x00;
	PCA0MD= 0x00;
	P0MDOUT=0x1f;
	P1MDOUT=0x8f;
	P2MDOUT=0x00;
	//P2MDIN=0xff;//11111111;
	//P3MDOUT =0xff;
	P74OUT =0xff;
	REF0CN=0x03;
	
	XBR0= 0x14;
	XBR1 =0x00;
	XBR2=0x00;
 
	WDTCN=0xde;	 //запрет работы WDT
	WDTCN=0xad;                                   
	TMOD=0x22;	//регистр режимов
	CKCON=0x30; //сист частота/12     
	TH0=0xf9;//	; Установка таймера
	TL0=0xf9; 
	EIE1=0x80;

	DAC0CN=0x80;
	OSCXCN=0x67;

	if    (OSCXCN!=0xe7){
			;
}
                       
  	OSCICN=0x84;
    TMR2RLL=0;
    TMR2RLH=0xd1;
    TCON=TCON|0x40;  //TCON.6=1 регистр управления
	TCON=TCON|0x10;//	 tcon.4=1

	RSTSRC=00	;//источники сброса 

	//IE=0x00;//10000000	;//Снятие блокировки всех прерываний
     XBR2=0x40;
//обнулить озу	
	 for (j=0;j<=255;j++){
//	 begin=0;
//	 a=&begin;
	 a=a++;
   	 }
	 for(j=0;j<=1;j++){
	 //	SUMM[j]=0;
	 }
;;;;;;;;;;;;;;;;;
//start:
//	MAS0[0]=0; 
//    MAS0[1]=0;
//	SUMM[0]=0;
	//////////////////////
//инициализация индикатора

//start:
	P3=P3&0xef;//	  clr P3.4
	
	d100mk_second();	//		call z_100         ;строб
	P3=P3|0x10;//	setb P3.4

	P3=P3&0xF3;//   clr P3.3,p3.2

	 d15ms_second();//  call z_15         ;задержка 15 мс
//          clr c          ;установка регистра команд
    acc=0x30;//     mov A,#30h     ;устанавливаем разрядность шины
	write();//		call x1              ;переход к записи
	d15ms_second();//	call z_15         ;задержка 15 мс
	write();//		call x1               ;переход к записи
	d100mk_second();//	call z_100        ;задержка 100 мкс
         
	write();//		call x1               ;запись
     //////////////
	// goto start ;   
	loop();//		call loop            ;проверка флага BF
	//goto start
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
	acc=0x01;
	write();//

	for (j=0;j<33;j++){
		bufind[j]=0x21;		
	}

	ind();
	wait_one_second ();
	wait_one_second ();

	/////////////////////////////
eee:
	for (j=0;j<=5;j++){
		bufind[j]=0x2a;//2d;		
	}	
	for (j=6;j<12;j++){
		bufind[j]=0x30;		
	}

	for (j=12;j<33;j++){
		bufind[j]=0x2a;//2d;		
	}
	ind();
	///////////
wriacp=0x67;
for (dj=0;dj<8;dj++){
	wriacp=wriacp>>1;
}
/////////////////////////////////
////////////////////////////////
//инициализация ACP
	for (j=0;j<0xff;j++){
			;		
	}

	while	(BIT5p1!=1){
	;
	}

	while	(BIT5p1!=0){
	;
	}
	tim();

	wriacp=0x64;//запись INSR
	zreal();
	tim();
	wriacp=0x60;
	zreal();	//старший байт УС
	wriacp=0x20;
	zreal();	//второй байт УС
	wriacp=0x0f;//07;//03;//00;
	zreal();	//первый байт УС
	wriacp=0x3c;//a0;//0c;//4d;
	zreal();	//младший байт УС

//////////////////////////////////
//измерение ACP

hhh:
	while	(BIT5p1!=1){
	;
	}

	while	(BIT5p1!=0){
	;
	}
	tim();
	wriacp=0xc0;//запись INSR
	zreal();
	tim();
	
	rrr();//real();//чтение acp
	R3R4R5[0]=rezacp;
	rrr();//чтение acp
	R3R4R5[1]=rezacp;
	rrr();//чтение acp
	R3R4R5[2]=rezacp;
///////////////////////////////////
	dj=R3R4R5[0];//&0x80;
	dj=dj&0x80;
	if (dj!=0x00){
		R3R4R5[0]=R3R4R5[0]&0x7f;//bit7=1 знак "+"
		bufind[6]=0x2b;//bufind[5]=0x2b;//bufind[4]=0x2b;	
	}
	else
		{
		
		R3R4R5[0]=~R3R4R5[0];//bit7=0 знак "-"
		R3R4R5[1]=~R3R4R5[1];
		R3R4R5[2]=~R3R4R5[2];
		R3R4R5[0]=R3R4R5[0]&0x7f;
		bufind[6]=0x2d;//bufind[5]=0x2d;//bufind[4]=0x2d;
	}
///////////////////////////////////
//преобразование и выдача на индикатор

 
	k=0;
	ccc=0x00;
 
 	ccc=R3R4R5[0];
	ccc=ccc&0x0000ff;
 	ccc=ccc<<16;
 	k=ccc;

	ccc=0x00;
 	ccc=ccc+R3R4R5[1];
	ccc=ccc&0x0000ff;
 	ccc=ccc<<8;
	k=k|ccc;

	ccc=0x00;
	ccc=ccc+R3R4R5[2];
	ccc=ccc&0x0000ff;
	k=k|ccc;
	////////////////
	k=k>>4;//убираем 4 мл разряда


	
	n=sprintf(buffer,"%ld",k);	//k->buffer
//	n=sprintf(fbuffer,"%8.2f",k);

	//dj=10;
	
	rez=atof(buffer);


//buffer->bufind
//преобр рез ACP в коды индикатора
//в послед ячейке буфера всегда в конце 0
    	a=0;
	while (buffer[a]!=0){
		a++;
		//ddd=buffer[a];
	}
	a--;
	for (j=12;j>6;j--){//5;j--){//4;j--){
		bufind[j]=buffer[a];
		a--;
	
	}
////////////////
		for (j=7;j<12;j++){//j=6//j=5
			if 	(bufind[j]<0x30)
				bufind[j]=0x30;
				//////////
				if 	(bufind[j]>0x39)
					bufind[j]=0x30;
	}

	ind();
goto hhh;
////////

	goto eee;
	
	
	
	
	
	
	
	
		

}

//-----------------------------------------------------------------------------
// Support Subroutines
//-----------------------------------------------------------------------------
//пп записи
void write ()	//запись команд (X1)
{
    P3= P3&0xfd; //p3.1=0   mov P3.1,c        
    P2=acc;
	P3=P3|0x08;	  //P3.3=1
				
	del_34mks_second();// задержка   call z_5
					
	P3=P3&0xf7;//  P3.3=0
	P2=0xFF;
}

//пп записи данных 
void writeD ()	//запись(X1)
{
    P3= P3|0x02; //p3.1=1   mov P3.1,c        
    P2=acc;
	P3=P3|0x08;	  //P3.3=1
				
	del_34mks_second();// задержка   call z_5
					
	P3=P3&0xf7;//  P3.3=0
	P2=0xFF;
}




// пп чтение     x2  
void read ()
{
          P3= P3&0xfd; //p3.1=0  mov P3.1,c        
          P3=P3|0x0c;	//setb P3.2,	  setb P3.3
		  del_2mks_second();//			call z_2
		  acc=P2;    //  mov A,P2
		  P3=P3&0xf3; // clr P3.3  clr P3.2
		  
		  
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
	;
	}
}

//задержка 34 мкс(z_5)!!!!!!!!!!!!!
void del_34mks_second (void)
{
	unsigned int count;
	for (count = 0x2e; count != 0; count--) {
	;
	}
}

//задержка 15 мс(z_15)!!!!!!!!!!!!!1
void d15ms_second (void)
{
	 int count;
	int hcount;

	for (count = 0xed; count != 0; count--) 
		for (hcount=0x50;hcount!=0;hcount--)
			;
}

//задержка 100mkc !!!!!!!!!!!!!!!!!
void d100mk_second (void)
{
	 int chee;
	int cheet;

	for (chee = 0x24; chee != 0; chee--) 
		for (cheet=0x02;cheet!=0;cheet--)
			;
}




//проверка флага BF
void loop(void)
{     read();	//call x2       ;ожидание флага готовности
	   // jb ACC.7,loop     ;переход на чтение, если бит А(7)=1
			     //        ;возврат, если бит А(7)<>1
		
while	 (acc!=0){
		read();	//call x2       ;ожидание флага готовности
		acc=acc &0x80;
		 }				 
}



//пп выдачи на индикатор буфера 2e..4e
void ind()
{	
	int		i;

	loop();//call	loop
	acc=0x80;//установка адреса
    write();

	for (i=0;i<17;i++){
		loop();
		acc=bufind[i];//	mov A,@R0      ;пересылаем содержимое R0 в аккумулятор
		writeD();//          call x1               ;запись

	}
     
	loop();//		  	  call loop                     ;проверка флага BF
	acc=0xc0;//    mov A,#0C0h 
	write();//        	call x1               ;запись
			    	

	for (i=17;i<33;i++){
		   
//          clr c          ;установка регистра команд
		loop();//			call loop                     ;проверка флага BF

		acc=bufind[i];// 	mov A,@R0     ;пересылаем содержимое R0 в аккумулятор
		writeD();//         	call x1               ;запись


	}		
}


//запись ACP
//wriacp->p1.6
void zreal()
{
	int	i;
	int portwri,save;

	dk=0;
//d7
	portwri=0;
	BIT7p1=1;
	portwri=portwri|wriacp;
	portwri=portwri>>1;
	portwri=portwri&0x40;//выделить бит p1.6
	P1=P1&0xbf;
	P1=P1|portwri;//P1=portwri;//7й бит байта
	tim2();
	BIT7p1=0;
	tim2();
//d6
	portwri=0;
	BIT7p1=1;
	portwri=portwri|wriacp;
	portwri=portwri&0x40;//выделить бит p1.6
	P1=P1&0xbf;
	P1=P1|portwri;//P1=portwri;//6й бит байта
	tim2();
	BIT7p1=0;
	tim2();
//d5..d0
	portwri=0;
	BIT7p1=1;
	portwri=portwri|wriacp;
	for (i=0;i<6;i++){
		BIT7p1=1;
		//portwri=portwri|wriacp;
		portwri=portwri<<1;
		save=portwri;
		save=save&0x40;//portwri=portwri&0x40;//выделить бит p1.6
		P1=P1&0xbf;
		P1=P1|save;//dk=portwri;//P1=portwri;
		tim2();
		BIT7p1=0;

		tim2();
	}
	BITacp=1;//p1.6=1

}


//пп чтения acp в rezacp
void rrr()

{
	
	save=0;
	rezacp=0;
	portread=0;
	
	for	(j=0;j<=6;j++){
		
		BIT7p1=1;
		tim2();
		BIT7p1=0;

			
		portread=portread|Rdat;
		portread=portread<<1;
		tim2();
	}
		rezacp=portread;//+
//d0
		BIT7p1=1;
		tim2();
		BIT7p1=0;
		rezacp=rezacp|Rdat;//d0
		tim2();

}


//~5mks
void tim2()
{
	unsigned int count;
	for (count = 0x05; count != 0; count--) {
	;
	}
}

//~14mks
void tim()
{
	unsigned int count;
	for (count = 0x0e; count != 0; count--) {
	;
	}
}


