//===========================
//  �������� 24.06.2005 
//---------------------------



//============================
//         �������
//============================
#define SetBit(A,B)  A=A|(1<<B)   // ���������� ��� � ����������
#define ClrBit(A,B)  A=A&~(1<<B)  // �������� ��� � ����������
#define IsBit(A,B)   (A&(1<<B))>0 // �������� ���� � ����������

// ����������� ���� char � int
//#define CH_TO_INT(ml,st,_int) {*((unsigned char*)(&_int))=st;*(((unsigned //char*)(&_int))+1)=ml;}



typedef union
{
   unsigned int I;
   unsigned char C[2];    // 0 - ������� 1 - ������� ����� int
} IC;


typedef union
{                          /*  ��� 51 ���������� */ /*  ��� IBM PC        */
//+     float F;              /*   ��      -  ��    */ /*   ��      -  ��    */
     unsigned long  L;     /*   H0    -     L0   */ /*   L0    -     H0   */
     unsigned int I[2];    /*   H0    -     L0   */ /*   L0    -     H0   */
     unsigned char C[4];   /*   H0  L0  H1  L1   */ /*   L0  H0  L1  H1   */
} FLIC ;                   /*   0   1   2   3    */ /*   0   1   2   3    */








//�������������� ������� ���������� ���������� EIE1
#define CP2IE	6
#define CP1IE 	5
#define CP0IE	4
#define EPCA0 	3
#define EWADC0 	2
#define ESMB0 	1
#define ESPIO	0

//�������������� ������� ���������� ���������� EIE2
#define ES1	6
#define ECAN0 	5
#define EADC2	4
#define EWADC2 	3
#define ET4 	2
#define EADC0 	1
#define ET3	0

//������������� ������� ����������� EIP1
#define PCP2	6
#define PCP1 	5
#define PCP0	4
#define PPCA0 	3
#define PWADC0 	2
#define PSMB0 	1
#define PSPI0	0

//������������� ������� ����������� EIP2
#define EP1	6
#define PCAN0 	5
#define PADC2	4
#define PWADC2 	3
#define PT4 	2
#define PADC0 	1
#define PT3	0


//������������� ��� � TMOD
#define GATE1 	7
#define C_T1 	6
#define T1M1 	5
#define T1M0 	4
#define GATE0 	3
#define C_T0 	2
#define T0M1	1
#define T0M0	0


//TMRnCF - ������� ������������ �������� 2,3,4
#define TnM1	4	//���� ������ ��������� ������� �������
#define TnM0	3	//���� ������ ��������� ������� �������
#define TOGn	2	//����� ������
#define TnOE	1	//���������� ������
#define DCEn	0	//����������� �����








///////////////////////////
// �� ���������!!!!!!! ������!!!!!!!!

//======================================
//PCA0MD: ������� ������� ��� PCA0 (0xD9)
//--------------------------------------
#define ECF	0		//��� ������������ ����� ������������ �������� PCA0
				//0 - ��������� ���������� �� CF
				//1 - ��������� ���������� �� CF
//======================================
//PCA0CPMn: ������� ������� ��� ������� (��� ������� ������)
//--------------------------------------
#define PWM16	7		//��������� 16-bit Pulse Width Modulation
#define ECOM	6		//��������� ������� ���������
#define CAPP	5		//��������� ������ �� �������������� ������
#define CAPN	4		//��������� ������ �� �������������� ������
#define MAT	3		//��������� ������� Match 
#define TOG	2		//Toggle Function Enable.
#define PWM	1		//Pulse Width Modulation Mode Enable.
#define ECCF	0		//��������� ���������� �� ���������������� ������
//======================================
//CPT0CN: ������� ���������� ������������ 0 (0x9E)
//--------------------------------------
#define CP0EN	7		//��������� ���������� 0
#define CP0OUT	6		//��������� ������ ����������� 0
				//0:Voltage on CP0+<CP0-
				//1:Voltage on CP0+>C 0-
#define CP0RIF	5		//���� ���������� �� ������������ ������
#define CP0FIF	4		//���� ���������� �� ��������� ������
#define CP0HYP1	3		//���� ���������� ������������� ������������
#define CP0HYP0	2		//
				//00:positive Hysteresis Disabled.
				//01:positive Hysteresis =2 mV.
				//10:positive Hysteresis =4 mV.
				//11:positive Hysteresis =10 mV.
#define CP0HYN1	1		//���� ���������� ������������� ������������
#define CP0HYN0	0		//
				//00:Negative Hysteresis Disabled.
				//01:Negative Hysteresis =2 mV.
				//10:Negative Hysteresis =4 mV.
				//11:Negative Hysteresis =10 mV.



//===========================
//���� 0
sbit P07	=	P0^7;	
sbit P06	=	P0^6;	
sbit P05	=	P0^5;	
sbit P04	=	P0^4;	
sbit P03	=	P0^3;	
sbit P02	=	P0^2;	
sbit P01	=	P0^1;	
sbit P00	=	P0^0;	

//===========================
//���� 1
sbit P17	=	P1^7;	
sbit P16	=	P1^6;	
sbit P15	=	P1^5;	
sbit P14	=	P1^4;	
sbit P13	=	P1^3;	
sbit P12	=	P1^2;	
sbit P11	=	P1^1;	
sbit P10	=	P1^0;	

//==========================
//���� 2
sbit P27	=	P2^7;	
sbit P26	=       P2^6;	
sbit P25	=	P2^5;	
sbit P24	=	P2^4;	
sbit P23	=	P2^3;	
sbit P22	=	P2^2;	
sbit P21	=	P2^1;	
sbit P20	=	P2^0;	

//===========================
//���� 3
sbit P37	=	P3^7;	
sbit P36	=       P3^6;	
sbit P35	=	P3^5;	
sbit P34	=	P3^4;	
sbit P33	=	P3^3;	
sbit P32	=	P3^2;	
sbit P31	=	P3^1;	
sbit P30	=	P3^0;	

//===========================
//���� 4
//sbit P47	=	P4^7;	
//sbit P46	=       P4^6;	
//sbit P45	=	P4^5;	
//sbit P44	=	P4^4;	
//sbit P43	=	P4^3;	
//sbit P42	=	P4^2;	
//sbit P41	=	P4^1;	
//sbit P40	=	P4^0;	


//===========================
// ��������� ����������� ���� 
//  � �������� �����....������
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
//   ���������!!!

/*==============================*/
/* Interrupt Vector Definitions */
/*==============================*/
#define EXT0_interrupt         void EXT0_int  (void)  interrupt 0
//[0x03] ������� ���������� 0 

#define T0_interrupt           void T0_int    (void)  interrupt 1
//[0x0B] ������������ ������� 0 

#define EXT1_interrupt         void EXT1_int  (void)  interrupt 2
//[0x13] ������� ���������� 1 

#define T1_interrupt           void T1_int    (void)  interrupt 3
//[0x1B] ������������ ������� 1

#define UART0_interrupt        void UART1_int (void)  interrupt 4
//[0x23] Serial Port 0 

#define T2_interrupt           void T2_int    (void)  interrupt 5
//[0x2B] ������������ ������� 2

#define SPI_interrupt          void SPI_int   (void)  interrupt 6
//[0x33] ��������� SPI              

#define SMBus_interrupt        void SMBus_int (void)  interrupt 7
//[0x3B] ��������� SMBus              

#define ADC0W_interrupt        void ADC0W_int (void)  interrupt 8
//[0x43] ���������� "����" ADC0              

#define PCA_interrupt          void PCA_int   (void)  interrupt 9
//[0x4B] ��������������� �������/������ PCA              

//////////////////////////////////////////
//////// ������� �����������!!!!
//////////////////////////////////////////

#define T3_interrupt           void T3_int    (void)  interrupt 14
//[0x73] ������������ ������� 3  

#define AD�0_interrupt         void AD�0_int  (void)  interrupt 15
//[0x7B] ���������� �������������� ADC0              

#define T4_interrupt           void T4_int    (void)  interrupt 16
//[0x83] ������������ ������� 4              

#define AD�2W_interrupt        void AD�2W_int (void)  interrupt 17
//[0x93] ���������� "����" ADC2W             

#define AD�2_interrupt         void AD�2_int  (void)  interrupt 18
//[0x8B] ���������� �������������� ADC2              
 
#define CAN_interrupt          void CAN_int   (void)  interrupt 19
//[0x9B] ���������� CAN            

//////////////////////////////////////////////////////////////////
/////////   ������� . ������ ���������� . ��� ���������� � pdf.
//////////////////////////////////////////////////////////////////



//#define EXT7_interrupt         void EXT7_int  (void)  interrupt 19
//[0x9B] ������� ���������� 7    

#define UART1_interrupt        void UART1_int (void)  interrupt 20
//[0xA3] Serial Port 1              


/***********  WDT **************************************************/
// ��� ON/OFF, SET, RESET 
//# define WDToff   { WDTCN = 0xDE;    WDTCN = 0xAD; }
//#define WDTreset { WDTCN = 0x07;    WDTCN = 0xA5; } // ��������� � ���������� 
# define WDTreset {  }


