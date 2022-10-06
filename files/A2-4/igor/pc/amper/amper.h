// amper.h : main header file for the AMPER application
//

#if !defined(AFX_AMPER_H__3A434845_EF7D_11DB_B7E8_00C0DFF158A1__INCLUDED_)
#define AFX_AMPER_H__3A434845_EF7D_11DB_B7E8_00C0DFF158A1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CAmperApp:
// See amper.cpp for the implementation of this class
//

class CAmperApp : public CWinApp
{
public:
	CAmperApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CAmperApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CAmperApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_AMPER_H__3A434845_EF7D_11DB_B7E8_00C0DFF158A1__INCLUDED_)
