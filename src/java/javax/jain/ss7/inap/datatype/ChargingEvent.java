/*
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *
 *  Copyrights:
 *
 *  Copyright - 1999 Sun Microsystems, Inc. All rights reserved.
 *  901 San Antonio Road, Palo Alto, California 94043, U.S.A.
 *
 *  This product and related documentation are protected by copyright and
 *  distributed under licenses restricting its use, copying, distribution, and
 *  decompilation. No part of this product or related documentation may be
 *  reproduced in any form by any means without prior written authorization of
 *  Sun and its licensors, if any.
 *
 *  RESTRICTED RIGHTS LEGEND: Use, duplication, or disclosure by the United
 *  States Government is subject to the restrictions set forth in DFARS
 *  252.227-7013 (c)(1)(ii) and FAR 52.227-19.
 *
 *  The product described in this manual may be protected by one or more U.S.
 *  patents, foreign patents, or pending applications.
 *
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 *
 *  Author:
 *
 *  Mahindra British Telecom
 *  155 , Bombay - Pune Road 
 *  Pimpri ,
 *  Pune - 411 018.
 *
 *  Module Name   : JAIN INAP API
 *  File Name     : ChargingEvent.java
 *  Approver      : Jain Inap Edit Group
 *  Version       : 1.0
 *
 *~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 */
package javax.jain.ss7.inap.datatype;


import java.io.*;
import java.util.*;
import java.lang.*;
import javax.jain.ss7.inap.constants.*;
import javax.jain.*;

/**
This class defines the ChargingEvent datatype
*/

public class ChargingEvent implements Serializable
{

    private String eventTypeCharging;
    
    private MonitorMode monitorMode;
    
    private LegID legID;
    private boolean isLegID =false ;

/**
Constructor For ChargingEvent
*/
	public ChargingEvent(String eventTypeCharging, MonitorMode monitorMode) 
	{
		setEventTypeCharging(eventTypeCharging);
		setMonitorMode(monitorMode);
	}

//---------------------------------------    

/**
Gets  Event Type Charging
*/
    public String getEventTypeCharging()
    {
        return eventTypeCharging;
    }

/**
Sets  Event Type Charging
*/
 public void  setEventTypeCharging(String eventTypeCharging)
    {
        this.eventTypeCharging = eventTypeCharging;
    }

//------------------------

/**<P>
Gets Monitor Mode
<DT> This parameter gets the information of an event being relayed and/or 
processed by the SSP. In the context of charging events, the following explanantions hold good.
<LI>INTERRUPTED - Means that the SSF has notified the SCF of the charging event; 
does not process the event but discards it.
<LI>NOTIFY_AND_CONTINUE	- Means that the SSF has notified the SCF of the charging event 
and continues processing the event without waiting for SCF instructions.
<LI>TRANSPARENT - Means that the SSF does not notify the SCF of the event. Monitoring the charging 
of a previously requested charging event is ended.
<P>
*/

    public MonitorMode getMonitorMode()
    {
        return monitorMode ;
    }

/**
Sets  Monitor Mode
*/

    public void  setMonitorMode(MonitorMode monitorMode)
    {
     	this.monitorMode = monitorMode;

    }

    
//--------------------------------

/**
Gets  Leg ID
*/

    public LegID  getLegID() throws ParameterNotSetException
    {
       if(isLegIDPresent())
	   {
       		return legID ;
       }
	   else
	   {
            throw new ParameterNotSetException();
       } 
    }

/**
Sets  Leg ID
*/

    public void  setLegID(LegID legID)
    {
        this.legID= legID;
        isLegID=true;  
    }

/**
Indicates if the Leg ID optional parameter is present .
Returns:TRUE if present , FALSE otherwise.
*/
    public boolean isLegIDPresent()
    {
        return isLegID;

    }


} 