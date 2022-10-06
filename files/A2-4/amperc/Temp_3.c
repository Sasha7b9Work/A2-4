//-----------------------------------------------------------------------------
// Temp_3.c
//-----------------------------------------------------------------------------
// Copyright 2001 Cygnal Integrated Products, Inc.
//
// AUTH: BW
// DATE: 19 JUL 01
//
// This program prints the C8051F020 die temperature out the hardware 
// UART at 9600bps. Assumes an 22.1184MHz crystal is attached between 
// XTAL1 and XTAL2.
//
// The ADC is configured to look at the on-chip temp sensor.  The sampling
// rate of the ADC is determined by the constant <SAMPLE_RATE>, which is given
// in Hz.
// 
// The ADC0 End of Conversion Interrupt Handler retrieves the sample
// from the ADC and adds it to a running accumulator.  Every <INT_DEC> 
// samples, the ADC updates and stores its result in the global variable
// <temperature>, which holds the current temperature in hundredths of a
// degree.  The sampling technique of adding a set of values and
// decimating them (posting results every (n)th sample) is called 'integrate
// and dump.'  It is easy to implement and requires very few resources.
//
// For each power of 4 of <INT_DEC>, you gain 1 bit of effective resolution.
// For example, <INT_DEC> = 256 gain you 4 bits of resolution: 4^4 = 256.
//
// Also note that the ADC0 is configured for 'LEFT' justified mode.  In this
// mode, the MSB of the ADC word is located in the MSB position of the ADC0
// high byte.  Using the data in this way makes the magnitude of the resulting
// code independent of the number of bits in the ADC (12- and 10-bits behave
// the same).
//
// Target: C8051F02x
// Tool chain: KEIL C51 6.03 / KEIL EVAL C51
//

//-----------------------------------------------------------------------------
// Includes
//-----------------------------------------------------------------------------

#include <c8051f020.h>                 // SFR declarations
#include <stdio.h>

//-----------------------------------------------------------------------------
// 16-bit SFR Definitions for 'F02x
//-----------------------------------------------------------------------------

sfr16 DP       = 0x82;                 // data pointer
sfr16 TMR3RL   = 0x92;                 // Timer3 reload value
sfr16 TMR3     = 0x94;                 // Timer3 counter
sfr16 ADC0     = 0xbe;                 // ADC0 data
sfr16 ADC0GT   = 0xc4;                 // ADC0 greater than window
sfr16 ADC0LT   = 0xc6;                 // ADC0 less than window
sfr16 RCAP2    = 0xca;                 // Timer2 capture/reload
sfr16 T2       = 0xcc;                 // Timer2
sfr16 RCAP4    = 0xe4;                 // Timer4 capture/reload
sfr16 T4       = 0xf4;                 // Timer4
sfr16 DAC0     = 0xd2;                 // DAC0 data
sfr16 DAC1     = 0xd5;                 // DAC1 data

//-----------------------------------------------------------------------------
// Global CONSTANTS
//-----------------------------------------------------------------------------

#define BAUDRATE     115200            // Baud rate of UART in bps
#define SYSCLK       22118400          // SYSCLK frequency in Hz
#define SAMPLE_RATE  50000             // Sample frequency in Hz
#define INT_DEC      256               // integrate and decimate ratio

sbit LED = P1^6;                       // LED='1' means ON
sbit SW1 = P3^7;                       // SW1='0' means switch pressed

//-----------------------------------------------------------------------------
// Function PROTOTYPES
//-----------------------------------------------------------------------------

void SYSCLK_Init (void);
void PORT_Init (void);
void UART0_Init (void);
void ADC0_Init (void);
void Timer3_Init (int counts);
void ADC0_ISR (void);

//-----------------------------------------------------------------------------
// Global VARIABLES
//-----------------------------------------------------------------------------

long result;                           // ADC0 decimated value

//-----------------------------------------------------------------------------
// MAIN Routine
//-----------------------------------------------------------------------------

void main (void) {
   long temperature;                   // temperature in hundredths of a
                                       // degree C
   int temp_int, temp_frac;            // integer and fractional portions of
                                       // temperature

   WDTCN = 0xde;                       // disable watchdog timer
   WDTCN = 0xad;

   SYSCLK_Init ();                     // initialize oscillator
   PORT_Init ();                       // initialize crossbar and GPIO
   UART0_Init ();                      // initialize UART0
   Timer3_Init (SYSCLK/SAMPLE_RATE);   // initialize Timer3 to overflow at
                                       // sample rate

   ADC0_Init ();                       // init ADC

	AD0EN = 1;                          // enable ADC

   EA = 1;                             // Enable global interrupts

	while (1) {
      EA = 0;                          // disable interrupts
      temperature = result;
      EA = 1;                          // re-enable interrupts

      // calculate temperature in hundredths of a degree
      temperature = temperature - 42380;
      temperature = (temperature * 100L) / 156;
      temp_int = temperature / 100;
      temp_frac = temperature - (temp_int * 100);
	   printf ("Temperature is %+02d.%02d\n", temp_int, temp_frac);

      LED = ~SW1;                      // LED reflects state of switch
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

//-----------------------------------------------------------------------------
// PORT_Init
//-----------------------------------------------------------------------------
//
// Configure the Crossbar and GPIO ports
//
void PORT_Init (void)
{
   XBR0    = 0x04;                     // Enable UART0
   XBR1    = 0x00;
   XBR2    = 0x40;                     // Enable crossbar and weak pull-ups
   P0MDOUT |= 0x01;                    // enable TX0 as a push-pull output
   P1MDOUT |= 0x40;                    // enable P1.6 (LED) as push-pull output
}

//-----------------------------------------------------------------------------
// UART0_Init
//-----------------------------------------------------------------------------
//
// Configure the UART0 using Timer1, for <baudrate> and 8-N-1.
//
void UART0_Init (void)
{
   SCON0   = 0x50;                     // SCON0: mode 1, 8-bit UART, enable RX
   TMOD    = 0x20;                     // TMOD: timer 1, mode 2, 8-bit reload
   TH1    = -(SYSCLK/BAUDRATE/16);     // set Timer1 reload value for baudrate
   TR1    = 1;                         // start Timer1
   CKCON |= 0x10;                      // Timer1 uses SYSCLK as time base
   PCON  |= 0x80;                      // SMOD00 = 1
   TI0    = 1;                         // Indicate TX0 ready
}

//-----------------------------------------------------------------------------
// ADC0_Init
//-----------------------------------------------------------------------------
//
// Configure ADC0 to use Timer3 overflows as conversion source, to
// generate an interrupt on conversion complete, and to use left-justified
// output mode.  Enables ADC end of conversion interrupt. Leaves ADC disabled.
//
void ADC0_Init (void)
{
   ADC0CN = 0x05;                      // ADC0 disabled; normal tracking
                                       // mode; ADC0 conversions are initiated 
                                       // on overflow of Timer3; ADC0 data is
                                       // left-justified
   REF0CN = 0x07;                      // enable temp sensor, on-chip VREF,
                                       // and VREF output buffer
   AMX0SL = 0x0f;                      // Select TEMP sens as ADC mux output
   ADC0CF = (SYSCLK/2500000) << 3;     // ADC conversion clock = 2.5MHz
   ADC0CF |= 0x01;                     // PGA gain = 2

   EIE2 |= 0x02;                       // enable ADC interrupts
}

//-----------------------------------------------------------------------------
// Timer3_Init
//-----------------------------------------------------------------------------
//
// Configure Timer3 to auto-reload at interval specified by <counts> (no 
// interrupt generated) using SYSCLK as its time base.
//
void Timer3_Init (int counts)
{
   TMR3CN = 0x02;                      // Stop Timer3; Clear TF3;
                                       // use SYSCLK as timebase
   TMR3RL  = -counts;                  // Init reload values
   TMR3    = 0xffff;                   // set to reload immediately
   EIE2   &= ~0x01;                    // disable Timer3 interrupts
   TMR3CN |= 0x04;                     // start Timer3
}

//-----------------------------------------------------------------------------
// Interrupt Service Routines
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// ADC0_ISR
//-----------------------------------------------------------------------------
//
// ADC0 end-of-conversion ISR 
// Here we take the ADC0 sample, add it to a running total <accumulator>, and
// decrement our local decimation counter <int_dec>.  When <int_dec> reaches
// zero, we post the decimated result in the global variable <result>.
//
void ADC0_ISR (void) interrupt 15
{
   static unsigned int_dec=INT_DEC;    // integrate/decimate counter
                                       // we post a new result when
                                       // int_dec = 0
   static long accumulator=0L;         // here's where we integrate the
                                       // ADC samples             

   AD0INT = 0;									// clear ADC conversion complete
                                       // indicator

	accumulator += ADC0;                // read ADC value and add to running
                                       // total
   int_dec--;                          // update decimation counter

   if (int_dec == 0) {                 // if zero, then post result
      int_dec = INT_DEC;               // reset counter
      result = accumulator >> 8;
      accumulator = 0L;                // reset accumulator
   }
}
