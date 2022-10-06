#include "c8051f000.h"
#include "MyDef005.h"

/****************************************************************/
/* ∆ » дисплей 4bita                                                  */
/****************************************************************/

/*************************************************************************/
/*          макрокоманды  управлени€ дисплеем                            */
/*************************************************************************/
/* индикатор       E       A8
                   RS      A0
                  R/W     A1

             E    -  синхро : 0 - нет операции
                     дл€ чтени€/записи  ≈=1(0),
                     при записи - переход из 1 в 0ю   (0-1)
             R\W  -  0 - запись в LCD  ; 1 - чтение
             RS   -  0 - команды ; 1 данные
*/
sbit  LCD_E =  P1^4;
sbit  LCD_RW = P2^0;
sbit  LCD_RS = P1^5;
char bdata DB;
sbit DB0 = DB^0;
sbit DB1 = DB^1;
sbit DB2 = DB^2;
sbit DB3 = DB^3;
sbit DB4 = DB^4;
sbit DB5 = DB^5;
sbit DB6 = DB^6;
sbit DB7 = DB^7;
/*
unsigned char LCD_rr()   //чтение данных диспле€
{
//DB0=P12;
//DB1=P11;
//DB2=P10;
//DB3=P06;
DB4=P12;
DB5=P13;
DB6=P10;
DB7=P11;
return DB;
}
*/
void LCD_ww(unsigned char dd)   //запись данных диспле€
{
DB=dd<<4;
//P12=DB0;
//P11=DB1;
//P10=DB2;
//P06=DB3;
P12=DB4;
P13=DB5;
P11=DB7;
P10=DB6;
}

//sbit  LCD_E =  0xb3;  /*P3.3*/
//sbit  LCD_RW = 0xb4;  /*P3.4*/
//sbit  LCD_RS = 0xb5;  /*P3.5*/

// DATA - Port1
// DB7  P1.3
// DB6  P1.2
// DB5  P1.1
// DB4  P1.0

//sbit  LCD_E =  0xa7;  /*P2.7*/
//sbit  LCD_RW = 0xa6;  /*P2.6*/ 
//sbit  LCD_RS = 0xa5;  /*P2.5*/

/***********************************************************************/
/*   функции управлени€ дисплеем                                       */
/***********************************************************************/
void DELY( unsigned int i);
/**/
#if 0
unsigned char LCD_ir(void)  /*   чтение готовности и адреса из диспле€ */
{
unsigned char a;
/*
F0 = EA;
EA=0;

LCD_ww(0xff);	//P1=0xff;
LCD_E=0;LCD_RS=0;LCD_RW=1;
LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;
LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;

LCD_E=1;
a=LCD_rr();	//a=P1;
LCD_E=0;

EA = F0;

return a;
*/
return 0x80;
}

#endif
/**/
unsigned char idata LCD_WITE;

unsigned char LCD_w(void) /* ожидание готовности диспле€ */
{                         /* 1 - готов */
unsigned char i,g;


g=0;

WDTreset;       /********/
LCD_WITE=0;
//for(i=0;i<160;i++)
//{
//if( (LCD_ir() & 0x80) == 0) { LCD_WITE = i; g=1;break;}
//}
DELY(8000);
//DELY(15000);
g=1;
return g;
}
/**/
void LCD_dw(char a)  /* запись данных в дисплей */
{

if(LCD_w() == 0)  /*      return*/;

F0 = EA;
EA=0;

LCD_ww(a>>4);		///P1=a>>4;    // hi-4bit
LCD_E=0;LCD_RS=1;LCD_RW=0;LCD_RW=0;LCD_RW=0;LCD_RW=0;
LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;
LCD_E=1;LCD_E=1;
LCD_E=0;

LCD_ww(a);	///P1=a;    // lo-4bit
LCD_E=0;LCD_RS=1;LCD_RW=0;LCD_RW=0;LCD_RW=0;LCD_RW=0;
LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;
LCD_E=1;LCD_E=1;
LCD_E=0;


EA = F0;

}
/**/
void LCD_iw(unsigned char a) /*   запись команды в дисплей */
{

if(LCD_w() == 0) /*return*/;

F0 = EA;
EA=0;

LCD_ww(a>>4);	///P1=a>>4;    // hi-4bit
LCD_E=0;LCD_RS=0;LCD_RW=0;LCD_RW=0;LCD_RW=0;LCD_RW=0;
LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;
LCD_E=1;LCD_E=1;
LCD_E=0;

LCD_ww(a);	///P1=a;   // lo-4bit
LCD_E=0;LCD_RS=0;LCD_RW=0;LCD_RW=0;LCD_RW=0;LCD_RW=0;
LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;
LCD_E=1;LCD_E=1;
LCD_E=0;

EA = F0;

}

void LCD_iw4bit(unsigned char a) /*   запись 4 bit команды в дисплей дл€ init */
{

if(LCD_w() == 0) /*return*/;

F0 = EA;
EA=0;

LCD_ww(a);	///P1=a;    // hi-4bit
LCD_E=0;LCD_RS=0;LCD_RW=0;LCD_RW=0;LCD_RW=0;LCD_RW=0;
LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;LCD_E=1;
LCD_E=1;LCD_E=1;
LCD_E=0;

EA = F0;

}

# if 0
/*
unsigned char LCD_dr(void)   // чтение данных из диспле€
{
unsigned char a;

if(LCD_w() == 0) //return

F0 = EA;
EA=0;

P0 = 0xff;
LCD_E=0;LCD_RS=1;LCD_RW=1;
LCD_E=1;
a=P0;
LCD_E=0;

EA = F0;

return a;

}
*/
#endif
void DELY( unsigned int i)    /* программна€ задержка */
{
unsigned char j;

//   for(i;i>0;i--)
	for (j=0;j<150;j++) 
   for(;i!=0;i--)i=i;

}
/*****/
/********************************************************/
/* процедура инициализации диспле€                      */
void LCD_init(void)
{
unsigned char q;
     /* начальна€ инициализаци€ */

LCD_E=0;LCD_E=0;LCD_E=0;LCD_E=0;
WDTreset;
DELY(15000);
LCD_iw4bit(0x3);
WDTreset;
DELY(15000);
LCD_iw4bit(0x3);
WDTreset;
DELY(11000);
LCD_iw4bit(0x3);
WDTreset;
DELY(1200);
LCD_iw4bit(0x2);    // длина 4 бита
WDTreset;
LCD_iw(0x28);       /* две строки по  5х7 */
WDTreset;
q=LCD_w();
LCD_iw(0x08);       /* disply=off,cursor=off,blink=off*/
WDTreset;
q=LCD_w();
LCD_iw(0x01);       /* clear disply */
WDTreset;
q=LCD_w();
LCD_iw(0x06);       /* I/D=1 курсор движетс€ S=0 диспл - нет */

q=LCD_w();

q=LCD_w();
DELY(100);          /* установлено опытным путем !!!!!!*/
//LCD_iw(0x0e);       /* D=1-disply on,c=1 cursor on,B=0 blink off */
LCD_iw(0x0c);       /* D=1-disply on,c=1 cursor off,B=0 blink off */
q=LCD_w();
/*    спец символы  **************/

{
unsigned char q,qq;
const unsigned char code CD[8]={1,2,4,8,0x10,8,4,2};
for(q=0;q<8;q++)
 {
   for(qq=0;qq<8;qq++)
   {
   LCD_iw(0x40 + q*8+qq);
   if(q==qq)
       {
       LCD_dw(0xff);
       }
   else
      LCD_dw(CD[q]);
   }

 }
LCD_iw(0x80);
}
# if 0
LCD_iw(0x40 +   0);
LCD_dw(0x1f);
LCD_iw(0x40 +   1);
LCD_dw(0x15);
LCD_iw(0x40 +   2);
LCD_dw(0x04);
LCD_iw(0x40 +   3);
LCD_dw(0x04);
LCD_iw(0x40 +   4);
LCD_dw(0x00);
LCD_iw(0x40 +   5);
LCD_dw(0x00);
LCD_iw(0x40 +   6);
LCD_dw(0x00);
LCD_iw(0x40 +   7);
LCD_dw(0x00);
LCD_iw(0x40 +   8);
LCD_dw(0x00);
LCD_iw(0x40 +   9);
LCD_dw(0x00);
LCD_iw(0x40 +  10);
LCD_dw(0x00);
LCD_iw(0x40 +  11);
LCD_dw(0x11);
LCD_iw(0x40 +  12);
LCD_dw(0x11);
LCD_iw(0x40 +  13);
LCD_dw(0x1f);
LCD_iw(0x40 +  14);
LCD_dw(0x1f);
LCD_iw(0x40 +  15);
LCD_dw(0x00);
LCD_iw(0x40 +  16);
LCD_dw(0x1f);
LCD_iw(0x40 +  17);
LCD_dw(0x13);
LCD_iw(0x40 +  18);
LCD_dw(0x04);
LCD_iw(0x40 +  19);
LCD_dw(0x15);
LCD_iw(0x40 +  20);
LCD_dw(0x11);
LCD_iw(0x40 +  21);
LCD_dw(0x1f);
LCD_iw(0x40 +  22);
LCD_dw(0x1f);
LCD_iw(0x40 +  23);
LCD_dw(0x00);
LCD_iw(0x40 +  24);
LCD_dw(0x00);
# endif

}
/*****************************************************/
/* выдача строки в дисплей с текущей позиции курсора */
/*****************************************************/
void LCD_string(unsigned char *s)
{
while(*s != 0)
  {
  LCD_dw(*s);
  s++;
  }
}
/******************************************************/
/* поместить курсор x-позици€ в строке, y-номер строки*/
/* x,y от 0                             */
/******************************************************/
void  LCD_xy(char x,char y)
{
if (x<=0x4f)
   {
   if (y==0)   LCD_iw(0x80 + x);
   if (y==1)   LCD_iw(0xc0 + x);
   }
}
/*******************************************************/
/* вывод с текущей позиции экрана 5 дес€тичных символов*/
/* беззнакового целого параметра "а"                   */
/*******************************************************/
#include <stdio.h>
# if 0
/*void LCD_Dint(unsigned int a)
{
                                             
unsigned char c[7];

  sprintf(c,"%5u",a);
  LCD_string(c);
}
void LCD_Dint4(unsigned int a)
{
unsigned char c[7];

  sprintf(c,"%4u",a);
  LCD_string(c);

}
*/
# endif
/*******************************************************/
/* вывод с текущей позиции экрана 4 шестнадцатеричных  */
/* символов                                            */
/* беззнакового целого параметра "а"                   */
/*******************************************************/
const
unsigned char code H_sim[17]={"0123456789ABCDEF"};
# if 0
void  LCD_Hint(unsigned int a)
{
unsigned char c[7];

  sprintf(c,"%4x",a);
  LCD_string(c);
}
/*******************************************************/
/* вывод с текущей позиции экрана 3 дес€тичных         */
/* символа   char   "а"                                */
/*******************************************************/
/*
void LCD_Dchar(unsigned char a)
{

unsigned char c[7];

  sprintf(c,"%3bd",a);
  LCD_string(c);
}*/

/*******************************************************/
/* вывод с текущей позиции экрана 2 шестнадцатеричных  */
/* символа   char   "а"                                */
/*******************************************************/
void  LCD_Hchar(unsigned char a)
{
LCD_dw(H_sim[a>>4]);
LCD_dw(H_sim[a&0x0f]);
}

#endif
/*
void LCD_Dchar2(unsigned char a)
{
  LCD_dw((a / 10) | 0x30);
  LCD_dw((a % 10) | 0x30);
}
*/



# include "lcd_tRUW.c"
#if 0
unsigned char LCD_rus_char(unsigned char c)
{
  if(c>=128)
   {
   c=RUS_tab[(unsigned char)(c-(unsigned char)128)];
   }
return c;
}
#endif
/**/
void LCD_rus_string(unsigned char *s)
{
unsigned char c;

while(*s != 0)
  {
  c=*s;

  if(c>=128)
   {
   c=RUS_tab[(unsigned char)(c-(unsigned char)128)];
   }

  LCD_dw(c);
  s++;
  }
}


/**********************************************/
void  LCD_clear(void)
    {
     unsigned char s[17]="                ";

        LCD_xy(0,0);
        LCD_string(s);

        LCD_xy(0,1);
        LCD_string(s);
     }
//////////////////////////////////

#if 0
void  LCD_xy_rus_str(char x,char y,unsigned char *s)
    {
        LCD_xy(x,y);
        LCD_rus_string(s);
    }



void  LCD_xy_str(char x,char y,unsigned char *s)
    {
        LCD_xy(x,y);
        LCD_string(s);
    }

#endif
