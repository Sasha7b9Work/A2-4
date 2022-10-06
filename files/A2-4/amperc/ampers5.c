#include <stdio.h>
#include <math.h>
#include <c8051f310.h>
#include<stdlib.h>

//------------------------------------------------------------------------------------
// 16-bit SFR Definitions for 'F02x
//------------------------------------------------------------------------------------


//sfr P2MDIN   = 0xF3;    // PORT 2 INPUT MODE REGISTER   
//sfr TMR2CN   = 0xC8;    // TIMER 2 CONTROL               
//sfr P0MDIN   = 0xF1;    // PORT 0 INPUT MODE REGISTER  
//sfr P3MDIN   = 0xF4;    // PORT 3 INPUT MODE REGISTER  
//sfr P0SKIP   = 0xD4;    // PORT 0 CROSSBAR SKIP
//sfr P1SKIP   = 0xD5;    // PORT 1 CROSSBAR SKIP                                     */
//sfr IT01CF   = 0xE4;    // INT0/INT1 CONFIGURATION                                         */
//sfr AMX0N    = 0xBA;    // ADC0 MUX NEGATIVE CHANNEL SELECTION                      */
//sfr AMX0P    = 0xBB;    // ADC0 MUX POSITIVE CHANNEL SELECTION
//sfr TMR2RLL  = 0xCA;    // TIMER 2 RELOAD LOW                                       */
//sfr TMR2RLH  = 0xCB;    // TIMER 2 RELOAD HIGH                                      */
//sfr TMR2L    = 0xCC;    // TIMER 2 LOW BYTE                                         */
//sfr TMR2H    = 0xCD;    // TIMER 2 HIGH BYTE 
//sfr SMB0CF   = 0xC1;    // SMBUS CONFIGURATION        
//sfr CLKSEL   = 0xA9;    // CLOCK SOURCE SELECT 
  
//sbit TF2L    = TMR2CN ^ 6; // TIMER 2 LOW BYTE OVERFLOW FLAG                        */
//sbit TF2H    = TMR2CN ^ 7; // TIMER 2 HIGH BYTE OVERFLOW FLAG        
 sfr VDM0CN   = 0xFF;    // VDD MONITOR CONTROL                   
/////////////
 sbit  BIT6p1=P1^6;
 sbit  BIT7p1=P1^7;
 sbit  BITacp=P1^6	;//��� acp
 sbit  BIT5p1=P1^5;



bit  BITzn;		//��� �����	
//-----------------------------------------------------------------------------
// Global CONSTANTS
//-----------------------------------------------------------------------------
#define TIMER2_RATE     1000           // Timer 2 overflow rate in Hz

#define SOAK_TIME          15          // Soak Time in Seconds

//sbit	P3.1=P3^1;

//void main (void)
//{
	int		j;
	int		a;

	char data dj;
	char  data dk;
	int	 data tdelay;
	int	 data acc;
	char data PP;
	char data 	marbuf;
	char data	address;
	
	char data 	marbuf;

	char data  bufind [32]_at_ 0x2e;
	unsigned data	wriacp;
	unsigned data	rezacp;
	char data R3R4R5[3];//3�����
	unsigned  long ccc;//3�����
	int ddd;
//	char ccc;
//	char buffer[10];
//	long lll=0xee;

//	char str [6];
 char buffer [10];
  int n, a=0xfe, b=3;
  unsigned long  k;


//-----------------------------------------------------------------------------
// Function PROTOTYPES
//-----------------------------------------------------------------------------
void wait_one_second (void);
//void del_second(void);	
void del_second (int tdelay);
void wait_soak_time (unsigned char soak_time);
void write ();
void read ();
void loop ();
void ind();
void wwind();
void d100mk_second();
void d15ms_second();
void del_2mks_second();
void del_34mks_second();
void tim2();
void tim();
void  chtadc();	
void  zapadc();
void real();
void zreal();



main ()
{
 	SP=0x0e0;
	PCA0L=0x00;
	PCA0MD= 0x00;//00000000;
	P0MDOUT=0x00;//00000000;
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
	IT01CF=0x00;//00000000;
 
	SMB0CF=0xc2;//11000010; 
	SCON0=0x10;                                   
	TMOD=0x22;//00100010;	//������� �������
	CKCON=0x30;//00110000;    //���� �������/12                 ; ��������� �������
	TH0=0x0f9;
	TL0=0x0f9; 
	EIE1=0x80;//10000000;

	AMX0P=0x13;//00010011;
	AMX0N=0x1f;//00011111;
	ADC0CF=0xf8;//11111000;
	ADC0CN=0x80;//10000000;
	OSCXCN=0xe7;//11100111;

//gener:     mov a, oscxcn
//           cjne a,#11100111b,gener

	marbuf=OSCXCN;
	if    (OSCXCN!=0xe7){
			;
}
   CLKSEL=0x01;//00000001;                    
  OSCICN=0x43;//01000011; 
   TMR2RLL=0;
   TMR2RLH=0xd1;
   TMR2CN=0x0c;//00001100;
	TMR2CN=TMR2CN&0xbf;  //tmr2cn.6=0
	TMR3L=0xcc;
	TMR3H=0x0f8;
	TMR3RLL=0xcc;
	TMR3RLH=0xf8;
	TMR3CN=0x04;//00000100;
    TCON=TCON|0x40;  //TCON.6=1 ������� ����������
	TCON=TCON|0x10;//	 tcon.4=1

	VDM0CN=0x80;//��� ��������� �������
	RSTSRC=02	;//��������� ������ 

	//IE=0x80;//10000000	;//������ ���������� ���� ����������
     
	 SP=  0xe0;    
    IP=IP|0x10;//00010000;//IP.4=1
	TL1=0;//��������� ��������� � ������� ���� ������� 1
    TH1=0xd0;//��������� ��������� � ������� ���� ������� 1
	PCA0CPH2=0x80;
	PCA0CPL2=0x80;
    PCA0MD=0x05;//00000101;
	PCA0CPM0=0x20;//00100000;
	PCA0CPM1=0x20;//00100000;
	PCA0CPM2=0x03;//00000011;
	CPT1CN=0x80;//10000000;
	CPT0CN=0x80;//10000000;
	REF0CN=0x02;//00000010;
	ADC0H=0;
	ADC0L=0;

;;;;;;;;;;;;;;;;;
//start: 
     
	//////////////////////
//������������� ����������

//start:
	P3=P3&0xef;//	  clr P3.4
	
	d100mk_second();	//		call z_100         ;�����
	P3=P3|0x10;//	setb P3.4

	P3=P3&0xF3;//   clr P3.3,p3.2

	 d15ms_second();//  call z_15         ;�������� 15 ��
//          clr c          ;��������� �������� ������
    acc=0x30;//     mov A,#30h     ;������������� ����������� ����
	write();//		call x1              ;������� � ������
	d15ms_second();//	call z_15         ;�������� 15 ��
	write();//		call x1               ;������� � ������
	d100mk_second();//	call z_100        ;�������� 100 ���
         
	write();//		call x1               ;������
     //////////////
	// goto start ;   
	loop();//		call loop            ;�������� ����� BF
	//goto start
    acc=0x38;//      mov A,#38h     ;������������� ����� ��������� ����������� � ��� ������
     write();//   	call x1               ;������
     loop();//   	call loop                     ;�������� ����� BF

     acc=0x06;//   	mov A,#06h     ;������������� ����� ��������������� ����������� ������� �����-������� ����� ������ ������� ������� 
     write();//    	call x1               ;������
	 loop();//		call loop                     ;�������� ����� BF 

     acc=0x02;//     mov A,#02h     ;������ ������ ���������� � ������ DDRAM
	write();//				call x1               ;������
	loop();//				call loop                     ;�������� ����� BF

      acc=0x0c;//    mov A,#0Ch     ;�������� ���������� �� ������ ���-������, ��� ����������� ��������
	write();//				call x1               ;������
	loop();//				call loop                     ;�������� ����� BF
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
	for (j=0;j<4;j++){
		bufind[j]=0x2a;//2d;		
	}	
	for (j=4;j<12;j++){
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
//������������� ACP
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

	wriacp=0x64;//������ INSR
	zreal();
	tim();
	wriacp=0x60;
	zreal();	//������� ���� ��
	wriacp=0x20;
	zreal();	//������ ���� ��
	wriacp=0x03;//00;
	zreal();	//������ ���� ��
	wriacp=0x0c;//4d;
	zreal();	//������� ���� ��

//////////////////////////////////
//��������� ACP

hhh:
	while	(BIT5p1!=1){
	;
	}

	while	(BIT5p1!=0){
	;
	}
	tim();
	wriacp=0xc0;//������ INSR
	zreal();
	tim();
	real();//������ acp
	R3R4R5[0]=rezacp;
	real();//������ acp
	R3R4R5[1]=rezacp;
	real();//������ acp
	R3R4R5[2]=rezacp;
///////////////////////////////////
	dj=R3R4R5[0];//&0x80;
	dj=dj&0x80;
	if (dj!=0x00){
		R3R4R5[0]=R3R4R5[0]&0x7f;//bit7=1 ���� "+"
		bufind[4]=0x2b;	
	}
	else
		{
		
		R3R4R5[0]=~R3R4R5[0];//bit7=0 ���� "-"
		R3R4R5[1]=~R3R4R5[1];
		R3R4R5[2]=~R3R4R5[2];
		R3R4R5[0]=R3R4R5[0]&0x7f;
		bufind[4]=0x2d;
	}
///////////////////////////////////
//�������������� � ������ �� ���������

 
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

//������ ��� ACP � ���� ����������
	n=sprintf(buffer,"%ld",k);

//� ������ ������ ������ ������ � ����� 0
	a=0;
	while (buffer[a]!=0){
		a++;
		//ddd=buffer[a];
	}
	a--;
	for (j=12;j>4;j--){
		bufind[j]=buffer[a];
		a--;
	}


	ind();
goto hhh;
////////

	goto eee;
	
	
	
	
	
	
	
	
		

}

//-----------------------------------------------------------------------------
// Support Subroutines
//-----------------------------------------------------------------------------
//�� ������
void write ()	//������ ������ (X1)
{
    P3= P3&0xfd; //p3.1=0   mov P3.1,c        
    P2=acc;
	P3=P3|0x08;	  //P3.3=1
				
	del_34mks_second();// ��������   call z_5
					
	P3=P3&0xf7;//  P3.3=0
	P2=0xFF;
}

//�� ������ ������ 
void writeD ()	//������(X1)
{
    P3= P3|0x02; //p3.1=1   mov P3.1,c        
    P2=acc;
	P3=P3|0x08;	  //P3.3=1
				
	del_34mks_second();// ��������   call z_5
					
	P3=P3&0xf7;//  P3.3=0
	P2=0xFF;
}




// �� ������     x2  
void read ()
{
          P3= P3&0xfd; //p3.1=0  mov P3.1,c        
          P3=P3|0x0c;	//setb P3.2,	  setb P3.3
		  del_2mks_second();//			call z_2
		  acc=P2;    //  mov A,P2
		  P3=P3&0xf3; // clr P3.3  clr P3.2
		  
		  
}
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
//�������� 2 ���
void del_2mks_second (void)
{
	unsigned int count;
	for (count = 4; count != 0; count--) {
	;
	}
}

//�������� 34 ���(z_5)!!!!!!!!!!!!!
void del_34mks_second (void)
{
	unsigned int count;
	for (count = 0x2e; count != 0; count--) {
	;
	}
}

//�������� 15 ��(z_15)!!!!!!!!!!!!!1
void d15ms_second (void)
{
	 int count;
	int hcount;

	for (count = 0xed; count != 0; count--) 
		for (hcount=0x50;hcount!=0;hcount--)
			;
}

//�������� 100mkc !!!!!!!!!!!!!!!!!
void d100mk_second (void)
{
	 int chee;
	int cheet;

	for (chee = 0x24; chee != 0; chee--) 
		for (cheet=0x02;cheet!=0;cheet--)
			;
}




//�������� ����� BF
void loop(void)
{     read();	//call x2       ;�������� ����� ����������
	   // jb ACC.7,loop     ;������� �� ������, ���� ��� �(7)=1
			     //        ;�������, ���� ��� �(7)<>1
		
while	 (acc!=0){
		read();	//call x2       ;�������� ����� ����������
		acc=acc &0x80;
		 }				 
}

//�������� 100 ���
void del_second (unsigned int tdelay)
{
	unsigned int count;
	for (count = tdelay; count != 0; count--) {
	;
	}
}

//�� ������ �� ��������� ������ 2e..4e
void ind()
{	
	int		i;

	loop();//call	loop
	acc=0x80;//��������� ������
    write();

	for (i=0;i<17;i++){
		loop();
		acc=bufind[i];//	mov A,@R0      ;���������� ���������� R0 � �����������
		writeD();//          call x1               ;������

	}
     
	loop();//		  	  call loop                     ;�������� ����� BF
	acc=0xc0;//    mov A,#0C0h 
	write();//        	call x1               ;������
			    	

	for (i=17;i<33;i++){
		   
//          clr c          ;��������� �������� ������
		loop();//			call loop                     ;�������� ����� BF

		acc=bufind[i];// 	mov A,@R0     ;���������� ���������� R0 � �����������
		writeD();//         	call x1               ;������


	}		
}


//������ ACP
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
	portwri=portwri&0x40;//�������� ��� p1.6
	P1=P1&0xbf;
	P1=P1|portwri;//P1=portwri;//7� ��� �����
	tim2();
	BIT7p1=0;
	tim2();
//d6
	portwri=0;
	BIT7p1=1;
	portwri=portwri|wriacp;
	portwri=portwri&0x40;//�������� ��� p1.6
	P1=P1&0xbf;
	P1=P1|portwri;//P1=portwri;//6� ��� �����
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
		save=save&0x40;//portwri=portwri&0x40;//�������� ��� p1.6
		P1=P1&0xbf;
		P1=P1|save;//dk=portwri;//P1=portwri;
		tim2();
		BIT7p1=0;

		tim2();
	}
	BITacp=1;//p1.6=1

}



//������ ACP
//wriacp->p1.6
void zreal1()
{
	int	i;
	int portwri,save;

	dk=0;
//d7
	portwri=0;
	BIT7p1=1;
	portwri=portwri|wriacp;
	portwri=portwri>>1;
	portwri=portwri&0x40;//�������� ��� p1.6
	dk=dk&0xbf;
	dk=dk|portwri;//P1=portwri;//7� ��� �����
	tim2();
	BIT7p1=0;
	tim2();
//d6
	portwri=0;
	BIT7p1=1;
	portwri=portwri|wriacp;
	portwri=portwri&0x40;//�������� ��� p1.6
	dk=dk&0xbf;
	dk=dk|portwri;//P1=portwri;//6� ��� �����
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
		save=save&0x40;//portwri=portwri&0x40;//�������� ��� p1.6
		dk=dk&0xbf;
		dk=dk|save;//dk=portwri;//P1=portwri;
		tim2();
		BIT7p1=0;

		tim2();
	}
	BITacp=1;//p1.6=1

}



//������ ACP
//wriacp->p1.6
void zapadc()
{
//	int	i;
//	int portwri;
//	dk=0;
//d7
//	portwri=0;
//	BIT7p1=1;
//	portwri=portwri|wriacp;
	//portwri=portwri>>1;
//	portwri=portwri&0x40;//�������� ��� p1.6
//	dk=portwri;//P1=portwri;//7� ��� �����
//	tim2();
//	BIT7p1=0;
//	tim2();
//d6
//	portwri=0;
//	BIT7p1=1;
//	portwri=portwri|wriacp;
//	portwri=portwri&0x40;//�������� ��� p1.6
//	dk=portwri;//P1=portwri;//6� ��� �����
//	tim2();
//	BIT7p1=0;
//	tim2();
//d5..d0
//	portwri=0;
//	BIT7p1=1;
//	portwri=portwri|wriacp;
//	for (i=0;i<6;i++){
//		BIT7p1=1;
//		portwri=portwri|wriacp;
//		portwri=portwri<<1;
//		portwri=portwri&0x40;//�������� ��� p1.6
//		dk=portwri;//P1=portwri;
//		tim2();
//		BIT7p1=0;

//		tim2();
//	}
//	BITacp=1;//p1.6=1

}

//������ ACP
//��������� � rezacp
void chtadc()
{
//	int	i;
//	int portread;

//	rezacp=0;
//	for (i=0;i<7;i++){
//		BIT7p1=1;
//		tim2();
//		BIT7p1=0;

//		portread=P1;
//		portread=portread&0x40;//�������� ��� p1.6
//		portread=portread<<1;
	
//		rezacp=rezacp|portread;//+
//		rezacp=rezacp>>1;

//		tim2();
//	}
//	rezacp=rezacp|portread;
}

//������ ACP
//��������� � rezacp
void real1()
{
	int	i;
	int portread;

	rezacp=0;
	for (i=0;i<7;i++){
		BIT7p1=1;
		tim2();
		BIT7p1=0;

		portread=dk;//P1;
		portread=portread&0x40;//�������� ��� p1.6
		portread=portread<<1;
	
		rezacp=rezacp|portread;//+
		rezacp=rezacp>>1;

		tim2();
	}
		BIT7p1=1;
		tim2();
		BIT7p1=0;

		portread=dk;//P1;
		portread=portread&0x40;//�������� ��� p1.6
		portread=portread<<1;
	rezacp=rezacp|portread;
		tim2();
}

//������ ACP
//��������� � rezacp
void real()
{
	int	i;
	int portread;

	rezacp=0;
	for (i=0;i<7;i++){
		BIT7p1=1;
		tim2();
		BIT7p1=0;

		portread=P1;
		portread=portread&0x40;//�������� ��� p1.6
		portread=portread<<1;
	
		rezacp=rezacp|portread;//+
		rezacp=rezacp>>1;

		tim2();
	}
		BIT7p1=1;
		tim2();
		BIT7p1=0;

		portread=P1;
		portread=portread&0x40;//�������� ��� p1.6
		portread=portread<<1;
		rezacp=rezacp|portread;
		tim2();
}


//

//
void tim2()
{
	unsigned int count;
	for (count = 0x05; count != 0; count--) {
	;
	}
}

//
void tim()
{
	unsigned int count;
	for (count = 0x0e; count != 0; count--) {
	;
	}
}


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

