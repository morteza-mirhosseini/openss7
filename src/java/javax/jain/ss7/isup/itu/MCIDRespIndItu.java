/******************************************************************************
*                                                                             *
*                                                                             *
* Copyright (c) SS8 Networks, Inc.                                            *
* All rights reserved.                                                        *
*                                                                             *
* This document contains confidential and proprietary information in which    *
* any reproduction, disclosure, or use in whole or in part is expressly       *
* prohibited, except as may be specifically authorized by prior written       *
* agreement or permission of SS8 Networks, Inc.                               *
*                                                                             *
*******************************************************************************
* VERSION      : $Revision: 1.1 $
* DATE         : $Date: 2008/05/16 12:23:57 $
* 
* MODULE NAME  : $RCSfile: MCIDRespIndItu.java,v $
* AUTHOR       : Nilgun Baykal [SS8]
* DESCRIPTION  : 
* DATE 1st REL : 
* REV.HIST.    : 
* 
* Date      Owner  Description
* ========  =====  ===========================================================
* 
* 
*******************************************************************************
*                                                                             *
*                     RESTRICTED RIGHTS LEGEND                                *
* Use, duplication, or disclosure by Government Is Subject to restrictions as *
* set forth in subparagraph (c)(1)(ii) of the Rights in Technical Data and    *
* Computer Software clause at DFARS 252.227-7013                              *
*                                                                             *
******************************************************************************/


package javax.jain.ss7.isup.itu;

import javax.jain.*;
import javax.jain.ss7.*;
import javax.jain.ss7.isup.*;

public class MCIDRespIndItu extends java.lang.Object implements java.io.Serializable{

	public MCIDRespIndItu(){

	}

	public MCIDRespIndItu(boolean in_mcidRespInd,
                      boolean in_holdProvidedInd){
		holdProvidedInd = in_holdProvidedInd;
		mcidRespInd     = in_mcidRespInd;

	}

	public boolean getHoldProvidedInd(){
		return holdProvidedInd;
	}

	public void setHoldProvidedInd(boolean in_holdProvidedInd){
		holdProvidedInd = in_holdProvidedInd;
	}

	public boolean getMCIDRespInd(){
		return mcidRespInd;
	}

	public void setMCIDRespInd(boolean in_mcidRespInd){
		mcidRespInd = in_mcidRespInd;
	}

	public void  putMCIDRespIndItu(byte[] arr, int index, byte par_len){
				
		if((byte)((arr[index]) & IsupMacros.L_BIT1_MASK) == 1)
			mcidRespInd = true;
		if((byte)((arr[index] >> 1) & IsupMacros.L_BIT1_MASK) == 1)
			holdProvidedInd = true;

	}

	public byte flatMCIDRespIndItu()
	{

		byte rc = 0;
		byte mcidResp=0, holdInd=0;

		if(mcidRespInd == true)
			mcidResp = 1;
		if(holdProvidedInd == true)
			holdInd = 1;
		
		rc = (byte)((mcidResp & IsupMacros.L_BIT1_MASK) | 
					((holdInd & IsupMacros.L_BIT1_MASK) << 1));
					
		return rc;
	}		

	/**
    * String representation of class MCIDRespIndItu
    *
    * @return    String provides description of class MCIDRespIndItu
    */
        public java.lang.String toString(){
        StringBuffer buffer = new StringBuffer(500);
		        buffer.append(super.toString());
				buffer.append("\nholdProvidedInd = ");
				buffer.append(holdProvidedInd);	
				buffer.append("\nmcidRespInd = ");
				buffer.append(mcidRespInd);
				return buffer.toString();
		
		}

	boolean holdProvidedInd;
	boolean mcidRespInd;

	public static final boolean MRI_MCID_NOT_INCLUDED = false; 
	public static final boolean MRI_MCID_INCLUDED	 = true; 	
	public static final boolean HPI_HOLDING_NOT_RROVIDED = false; 
	public static final boolean HPI_HOLDING_PROVIDED = true; 


}



