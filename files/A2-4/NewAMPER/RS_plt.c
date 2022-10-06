#include <c8051f200.h>                    // SFR declarations

sfr16 RCAP2 = 0xca;	// Timer2 capture/reload
sfr16 T2 = 0xcc;		// Timer2

#define byte	unsigned char
#define BAUDRATE	9600		// Baud rate of UART in bps
#define SYSCLK	12000000	// SYSCLK frequency in Hz
sbit  LED = P0^4; 
sbit  LED2 = P0^5; 

void PORT_Init (void);
void UART0_Init (char);
void Timer2_Init (int);
void Timer2_ISR (void);
void Bytes1(void);
void Bytes2(void);
 void Bytes2pulse(byte,byte,byte,int *out,long *rest);
void tran(char);
char recv(void);
void sleep(int);

long sum1=0L,sum2=0L;
byte is_s,is_loop='\0';//,*no_2;//is second
byte inv_w=(char)100;//inverse weight
byte rest1='\0',rest2='\0';
 int i,j,exp1=0,exp2=0;
int cn1,cn2,cns=0;//counters~leakage <10000
char b1,b2,kk,r1,r2,r3,r4;
char c1,c2,c3;//exp[6];
byte	w[14];
union {
	byte cc[4];
	long ll;
	} un;
union {
	char c[2];
	int it;
	} u2;
union {
	long ll;
	int ti[2];
	} u3;

void main (void) 
{
  WDTCN = 0xde;// disable watchdog timer
  WDTCN = 0xad;//WDTCN=0xA5l;//WDT reset

 PORT_Init ();
	kk=(char)(SYSCLK/BAUDRATE/16);
 UART0_Init (kk);

	j=SYSCLK/2000/12;//1 kHz meandr
 Timer2_Init (j);//?10kHz,(25000);

//-if( *no_2 == '\4' ) goto mloop;//no DU 
//EX1=1;//int1 enable
//ET2=1;//timer2 en
	EA = 1;// enable global interrupts=timer->watchdog

beg:		//ROM-DU:
 SBUF=(char)29;
 while( !TI);
  TI=0;

 sleep(65);//1 sek

 SBUF=(char)28;
 while( !TI);
  TI=0;
 sleep(65);

 SBUF=(char)0x30;//for any device ID
 while( !TI);
  TI=0;
 SBUF=(char)0x30;
 while( !TI);
  TI=0;
 SBUF=(char)0x30;
 while( !TI);
  TI=0;
 SBUF=(char)0x30;
 while( !TI);
  TI=0;
//? sleep(1);
 while( !RI);
 RI=0;
 r1=SBUF;
 if( r1 != 26) goto beg;//isn't device

 SBUF=(char)20;
 while( !TI);
  TI=0;
 SBUF=(char)3;//ReadROM
 while( !TI);
  TI=0;
// sleep(1);
m3:
	while( !RI);
	RI=0;
	r2=SBUF;
 if( r2 != 26) goto m3;//beg;

	SBUF=(char)0x38;//RCONFIG=(81)
	while( !TI);
	 TI=0;
	SBUF=(char)0x31;
	while( !TI);
	 TI=0;
	while( !RI);
	 RI=0;
	b1=SBUF&((char)0xF);
	while( !RI);
	 RI=0;
	b2=SBUF&((char)0xF);
	c3=((b1<<4)|b2);
m4:
	while( !RI);
	 RI=0;
	r3=SBUF;	//wait 26
// if( r3 != 26) goto m4;//beg;

	if( ( c3 & (char)7 )== '\0' ) inv_w=(char)200;//DU=15, 0.01
else	if( ( c3 & (char)7 )== (char)1 ) inv_w=(char)100;//DU=25, 0.02
else	if( ( c3 & (char)7 )== (char)5 ) inv_w=(char)50;//DU=32, 0.02
else	if( ( c3 & (char)7 )== (char)2 ) inv_w=(char)20;//DU=50, 0.05
else	if( ( c3 & (char)7 )== (char)3 ) inv_w=(char)10;//DU=80, 0.05
else	 inv_w=(char)5;//DU=100, 0.1
	SBUF=(char)20;//?27  tran(0x20);
	while( !TI);
	 TI=0;
 SBUF='\0';//end 'Prog'
 while( !TI);
  TI=0;
//?read 
	sleep(1);
//-*no_2 = '\4';//?watchdog pass DU read

mloop:
	is_s='\0';
//?	cn1=2*exp1; cn2=2*exp2;//output

 SBUF=(char)27;
 while( !TI);
  TI=0;

 SBUF=(char)0x30;//  tran('0');u2.c[0]);// for any device ID
 while( !TI);
  TI=0;
 SBUF=(char)0x30;
 while( !TI);
  TI=0;
 SBUF=(char)0x30;
 while( !TI);
  TI=0;
 SBUF=(char)0x30;
 while( !TI);
  TI=0;
m2:
	while( !RI);
	RI=0;
	r4=SBUF;
//if( !((r4 ==(char)7)||(r4 ==(char)26))) goto m2;
if( !(r4 ==(char)7)) goto m2;

for(i=0;i<14;i++)
	{
	while( !RI);
	RI=0;
	b1=SBUF&((char)0xF);
	while( !RI);
	 RI=0;
	b2=SBUF&((char)0xF);
	w[i]=((b1<<4)+b2);
	}
for(i;i<74;i++)
	{
	while( !RI);
	RI=0;
	kk=SBUF;
	while( !RI);
	RI=0;
	kk=SBUF;
	}

 SBUF=(char)28;
 while( !TI);
  TI=0;
 SBUF=(char)0x30;//  tran('0');u2.c[0]);// for any device ID
 while( !TI);
  TI=0;
 SBUF=(char)0x30;
 while( !TI);
  TI=0;
 SBUF=(char)0x30;
 while( !TI);
  TI=0;
 SBUF=(char)0x30;
 while( !TI);
  TI=0;
for(i=0;i<14;i++) ;// sleep(1);

Bytes1();//Bytes2pulse(exp[0],exp[1],exp[2],&exp1,&rest1);
Bytes2();//Bytes2pulse(exp[3],exp[4],exp[5],&exp2,&rest2);

//exp2=1000; //exp1=2000;//+

is_loop='\0';//no deadloop
 while( !is_s) ;//1 s wait

 cn1=exp1<<1; cn2=exp2<<1;//?

// while( !RI);
// RI=0;
 c1=SBUF;// if( c1 != 0x6) ?

 goto mloop;

 i=0xCC00;

}



void UART0_Init (char k)
{

   SCON    = 0x50;                     // SCON: mode 1, 8-bit UART, enable RX
   TMOD    = 0x20;                     // TMOD: timer 1, mode 2, 8-bit reload
   TH1    = (char)0xB2;//B2;-k;//(SYSCLK/BAUDRATE/16);     // set Timer1 reload value for baudrate
   TR1    = 1;                         // start Timer1
   CKCON |= 0x10;                      // Timer1 uses SYSCLK as time base
   PCON  |= 0x80;                      // SMOD = 1
//   TI     = 1;                         // Indicate TX ready

}

void sleep(int k)
{
  LED2 = ~LED2;
 for(i=0;i<k;i++)
 for(j=0;j<0x3FFF;j++);
}

void Timer2_Init (int counts)
{
   T2CON  = 0x00;		// Stop Timer2; configure for auto-reload
   CKCON &= ~0x20;	// T2M=0 (use SYSCLK/12 as timebase)
   RCAP2  = -counts;	// Init reload value
   T2     = 0xffff;	// set to reload immediately
   ET2    = 1;		// enable Timer2 interrupts
   TR2    = 1;		// start Timer2
}


void PORT_Init (void)
{
 OSCXCN = 0x67; //external quartz
 OSCICN = 0x8;

 PRT0CF |= 0x31;	//10 was, enable P0.4 (LED) as push-pull output
// PRT0CF |= 0x01;	// enable TX0 as a push-pull output
// PRT0CF |= 0x20;	// enable P0.5 (LED) as push-pull output

 PRT0MX |= 1; //UART enable
//? P0MODE=0x2;//?33 digital inputs

 IT1=0;//int1 dinamically back edge

/* high model
 XBR0 = 0x04;		// Enable UART0
 XBR1 = 0x00;
 XBR2 = 0x40;		// Enable crossbar and weak pull-ups
*/
}

void Timer2_ISR (void) interrupt 5
{
   TF2 = 0;	// clear Timer2 overflow interrupt flag
if(cn1>0) { cn1--; LED = ~LED; sum1++; }
	else LED=1;
//+ LED2 =~LED2 ;
if(cn2>0) { cn2--; LED2 = ~LED2; sum2++; }
	else LED2=1;
	cns++;
 if(cns>=2000)
	{
	if(is_loop<'\5') is_loop++;
	 else WDTCN=(char)0xA5;//enable
	is_s++;
	cns=0;
//?	cn1=exp1<<1; cn2=exp2<<1;
//?	exp1=0; exp2=0;
	}
}

void Int1_ISR (void) interrupt 2
{
	if(is_loop<'\5') is_loop++;
	 else WDTCN=(char)0xA5;//enable
	is_s++;
	cns=0;
	cn1=exp1<<1;
	cn2=exp2<<1;
}


byte lv;
int m,n;
long lw,w2;

void Bytes1(void)
{

	un.cc[2]=w[9]; un.cc[3]=w[10]; un.cc[0]='\0'; un.cc[1]='\0';
	lw=un.ll;
//	lw+=(long)rest1;//3 high bit rejected by shift
	w2=lw*inv_w*125;
	w[8]&=(char)0x7F;
	lv=(char)0x44-w[8];//lv=(char)0x4A-w[8];//lv=exp[0]-(char)0x20;
//?  rnd=7L;rnd<<=(lv-3);
//?  rest1=(lw&rnd);
	lw=(w2>>lv);
 lw++;
 lw=(lw>>1);
	lw+=(long)rest1;
 rest1=(char)(lw);//&'\377';
 lw=(lw>>8);//was 3
//u3.ll=lw; exp1=u3.ti[1];
 exp1=(int)lw;
}

void Bytes2(void)
{
	un.cc[2]=w[12]; un.cc[3]=w[13]; un.cc[0]='\0'; un.cc[1]='\0';
	lw=un.ll;
	w2=lw*inv_w*125;
	w[11]&=(char)0x7F;
	lv=(char)0x44-w[11];
	lw=(w2>>lv);
 lw++;
 lw=(lw>>1);
	lw+=(long)rest2;//2 high bit rejected by shift
	rest2=(char)(lw);//&'\7'+'\1';
 lw=(lw>>8);
//	u3.ll=lw; exp2=u3.ti[1];
 exp2=(int)lw;
}

