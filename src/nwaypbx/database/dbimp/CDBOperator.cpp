#include <stdio.h>
#include <stdlib.h>
#include "CDBOperator.h"
#include "../../log/log.h"
#include "../../common/NwayStr.h"
//#include <cstdlib>
#include <string.h>
int LoadBaseConfig( list<base_config>& lstBaseConfig )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("select id,config_name,config_param from call_base_config;");
		 
		cmd.Execute();
		while(cmd.FetchNext())
		{
			base_config bc;
			bc.id= cmd.Field("id").asNumeric();
			bc.config_name = cmd.Field("config_name").asString();
			bc.config_param = cmd.Field("config_param").asString();
			lstBaseConfig.push_back(bc);
			printf("LoadBaseConfig any \n");
		}
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load base config error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int LoadExtensionGroup( list<NwayExtensionGroup>& lstExtensionGroup )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("select id,group_name  from call_extension_groups;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			NwayExtensionGroup eg;
			eg.id= cmd.Field("id").asNumeric();
			eg.group_name = cmd.Field("group_name").asString();
			 
			lstExtensionGroup.push_back(eg);
		}
		cmd.Close();
	}
	catch (SAException &x)
	{
		 
		string s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load extension group error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int LoadGateway( list<NwayGateway>& lstGateway )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("select id,gateway_name,gateway_url,call_prefix,max_call  from call_gateway;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			NwayGateway eg;
			eg.id= cmd.Field("id").asNumeric();
			eg.gateway_name = cmd.Field("gateway_name").asString();
			eg.call_prefix = cmd.Field("call_prefix").asString();
			eg.gateway_url = cmd.Field("gateway_url").asString();
			eg.max_call = cmd.Field("max_call").asShort();

			lstGateway.push_back(eg);
		}
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load gateway error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int LoadDialplanDetails( list<NwayDialplanDetail>& lstDialplanDetail )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("select dialplan_id ,id,dialplan_detail_tag, dialplan_detail_data  , \
			dialplan_detail_inline  ,dialplan_detail_group_id  ,dialplan_detail_order  , \
			dialplan_detail_break  ,dialplan_detail_type_id,ring_id    from call_dialplan_details group by dialplan_id,id order by dialplan_detail_order;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			NwayDialplanDetail eg;
			eg.id= cmd.Field("id").asNumeric();
			eg.dialplan_detail_break = cmd.Field("dialplan_detail_break").asBool();
			eg.dialplan_detail_data = cmd.Field("dialplan_detail_data").asString();
			eg.dialplan_detail_group_id = cmd.Field("dialplan_detail_group_id").asNumeric();
			eg.dialplan_detail_inline = cmd.Field("dialplan_detail_inline").asString();
			eg.dialplan_detail_order = cmd.Field("dialplan_detail_order").asShort();
			eg.dialplan_detail_tag = cmd.Field("dialplan_detail_tag").asString();
			eg.dialplan_detail_type_id = cmd.Field("dialplan_detail_type_id").asShort();
			eg.ring_id = cmd.Field("ring_id").asNumeric();
			eg.dialplan_id = cmd.Field("dialplan_id").asNumeric();


			lstDialplanDetail.push_back(eg);
		}
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load dialplan detail error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int LoadDialplan( list<NwayDialplan>& lstDialplan )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();
	printf("begin load dialplan\n");
	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("SELECT id, dialplan_name, dialplan_context, dialplan_number, dialplan_order, \
			dialplan_description, dialplan_enabled, dialplan_continue \
			FROM call_dialplans where dialplan_enabled=True;");

		cmd.Execute();
		printf("execute dialplan sql \n");
		while(cmd.FetchNext())
		{
			NwayDialplan myobj;
			myobj.id= cmd.Field("id").asNumeric();
			myobj.dialplan_context = cmd.Field("dialplan_context").asString();
			myobj.dialplan_continue = cmd.Field("dialplan_continue").asBool();
			myobj.dialplan_name = cmd.Field("dialplan_name").asString();
			myobj.dialplan_number = cmd.Field("dialplan_number").asString();
			myobj.dialplan_order = cmd.Field("dialplan_order").asShort();
			//myobj.re = pcre_compile(myobj.dialplan_number.c_str(), 0, &myobj.error, &myobj.erroffset, NULL);//每个dialplan一个正则的处理，预配好，以便快速处理正则校验
			printf("LoadDialplan any\n");
			lstDialplan.push_back(myobj);
		}
		cmd.Close();
	}
	catch (SAException &x)
	{
       		 string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
    
		printf("the dialplan load error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int LoadIvrDetails( list<NwayIVRDetail>& lstIvrDeatail )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("SELECT id, ivr_menu_id, ivr_menu_option_digits, ivr_menu_option_param,  \
			ivr_menu_option_order,  ivr_menu_option_action_id \
			FROM call_ivr_menu_options order by ivr_menu_option_order;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			NwayIVRDetail myobj;
			myobj.id= cmd.Field("id").asNumeric();
			myobj.ivr_menu_id = cmd.Field("ivr_menu_id").asNumeric();
			myobj.ivr_menu_option_action_id = cmd.Field("ivr_menu_option_action_id").asShort();
			myobj.ivr_menu_option_digits = cmd.Field("ivr_menu_option_digits").asString();
			myobj.ivr_menu_option_order = cmd.Field("ivr_menu_option_order").asShort();
			myobj.ivr_menu_option_param = cmd.Field("ivr_menu_option_param").asString();
			
			lstIvrDeatail.push_back(myobj);
		}
		cmd.Close();
	} 
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("Load ivr details error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int LoadIvrs( list<NwayIVR>& lstIvr )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("SELECT id, ivr_menu_name, ivr_menu_extension, ivr_menu_confirm_macro,  \
			ivr_menu_confirm_key, ivr_menu_confirm_attempts, ivr_menu_timeout,  \
			ivr_menu_exit_data, ivr_menu_inter_digit_timeout, ivr_menu_max_failures, \
			ivr_menu_max_timeouts, ivr_menu_digit_len, ivr_menu_direct_dial, \
			ivr_menu_cid_prefix, ivr_menu_description, ivr_menu_call_crycle_order, \
			ivr_menu_enabled, ivr_menu_call_order_id, ivr_menu_greet_long_id, \
			ivr_menu_greet_short_id, ivr_menu_invalid_sound_id, ivr_menu_exit_sound_id, \
			ivr_menu_ringback_id, ivr_menu_exit_app_id \
			FROM call_ivr_menus where ivr_menu_enabled=True;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			NwayIVR myobj;
			myobj.id= cmd.Field("id").asNumeric();
			myobj.ivr_menu_call_crycle_order = cmd.Field("ivr_menu_call_crycle_order").asShort();
			myobj.ivr_menu_call_order_id = cmd.Field("ivr_menu_call_order_id").asNumeric();
			myobj.ivr_menu_cid_prefix = cmd.Field("ivr_menu_cid_prefix").asString();
			myobj.ivr_menu_confirm_attempts = cmd.Field("ivr_menu_confirm_attempts").asShort();
			myobj.ivr_menu_confirm_key = cmd.Field("ivr_menu_confirm_key").asString();
			myobj.ivr_menu_confirm_macro = cmd.Field("ivr_menu_confirm_macro").asString();
			myobj.ivr_menu_digit_len = cmd.Field("ivr_menu_digit_len").asShort();
			myobj.ivr_menu_direct_dial = cmd.Field("ivr_menu_direct_dial").asString();
			myobj.ivr_menu_exit_app_id = cmd.Field("ivr_menu_exit_app_id").asShort();
			myobj.ivr_menu_exit_data = cmd.Field("ivr_menu_exit_data").asString();
			myobj.ivr_menu_exit_sound_id = cmd.Field("ivr_menu_exit_sound_id").asNumeric();
			myobj.ivr_menu_extension =cmd.Field("ivr_menu_extension").asString();
			myobj.ivr_menu_greet_long_id = cmd.Field("ivr_menu_greet_long_id").asNumeric();
			myobj.ivr_menu_greet_short_id =cmd.Field("ivr_menu_greet_short_id").asNumeric();
			myobj.ivr_menu_inter_digit_timeout = cmd.Field("ivr_menu_inter_digit_timeout").asShort();
			myobj.ivr_menu_invalid_sound_id = cmd.Field("ivr_menu_invalid_sound_id").asNumeric();
			myobj.ivr_menu_max_failures = cmd.Field("ivr_menu_max_failures").asShort();
			myobj.ivr_menu_max_timeouts = cmd.Field("ivr_menu_max_timeouts").asShort();
			myobj.ivr_menu_name = cmd.Field("ivr_menu_name").asString();
			myobj.ivr_menu_ringback_id = cmd.Field("ivr_menu_ringback_id").asNumeric();
			myobj.ivr_menu_timeout = cmd.Field("ivr_menu_timeout").asShort();

			lstIvr.push_back(myobj);
		}
		cmd.Close();
	} 
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load ivr error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int LoadRings( list<NwayRing>& lstRings )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("SELECT id, ring_path	FROM call_rings;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			NwayRing myobj;
			myobj.id= cmd.Field("id").asNumeric();
			myobj.filename = cmd.Field("ring_path").asString();
			printf("loadring:%s\n",myobj.filename.c_str());
			lstRings.push_back(myobj);
		}
		cmd.Close();
	}
	catch (SAException &x)
	{

		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load rings error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int LoadOutsides( list<Outside_line>& lstOutsides )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("SELECT id, outside_line_name, outside_line_number, inside_line_number, \
			call_order_id, call_crycle_order, is_record, is_voice_mail \
			FROM call_outside_config;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			Outside_line myobj;
			myobj.id= cmd.Field("id").asNumeric();
			myobj.call_crycle_order = cmd.Field("call_crycle_order").asNumeric();
			myobj.call_order_id = cmd.Field("call_order_id").asNumeric();
			myobj.inside_line_number = cmd.Field("inside_line_number").asString();
			myobj.is_record = cmd.Field("is_record").asBool();
			myobj.is_voice_mail = cmd.Field("is_voice_mail").asBool();
			myobj.outside_line_name = cmd.Field("outside_line_name").asString();
			myobj.outside_line_number = cmd.Field("outside_line_number").asString();
			lstOutsides.push_back(myobj);
		}
		cmd.Close();
	}
	catch (SAException &x)
	{

		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load outsides error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int LoadInOutMapping( list<In_Out_Mapping>& lstInOutMapping )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("SELECT id, outside_line_id, inside_line_id, order_number \
			FROM in_out_mapping;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			In_Out_Mapping myobj;
			myobj.inside_line_id = cmd.Field("inside_line_id").asNumeric();
			myobj.outside_line_id = cmd.Field("outside_line_id").asNumeric();
			myobj.order_number = cmd.Field("order_number").asShort();
			
			lstInOutMapping.push_back(myobj);
		}
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load in out mapping error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int LoadCalloutGateway( list<NwayCalloutGateway>& lstCalloutGateways )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("SELECT id, name, gateway_id	FROM callout_gateways;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			NwayCalloutGateway myobj;
			myobj.id= cmd.Field("id").asNumeric();
			myobj.gateway_id = cmd.Field("gateway_id").asNumeric();
			myobj.name = cmd.Field("name").asString();
			 

			lstCalloutGateways.push_back(myobj);
		}
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load gateway error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

CExtension::CExtension()
{

}

CExtension::~CExtension()
{

}


int CExtension::LoadExtension( list<NwayExtension>& lstExtension )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("select id,extension_name,extension_number,callout_number,extension_type, \
						   group_id, extension_login_state, extension_reg_state, callout_gateway, \
						   is_allow_callout,extension_pswd,is_record,is_disable from call_extension order by id;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			NwayExtension ne;
			ne.id= cmd.Field("id").asNumeric();
			ne.callout_gateway = cmd.Field("callout_gateway").asNumeric();
			ne.callout_number = cmd.Field("callout_number").asString();
			ne.extension_name = cmd.Field("extension_name").asString();
			ne.extension_number = cmd.Field("extension_number").asString();
			ne.extension_type = cmd.Field("extension_type").asShort();
			ne.group_id = cmd.Field("group_id").asNumeric();
			ne.is_allow_callout =cmd.Field("is_allow_callout").asShort();
			ne.is_record = cmd.Field("is_record").asBool();
			ne.is_disable = cmd.Field("is_disable").asBool();
			string strTmp;
			strTmp  = cmd.Field("extension_reg_state").asString();
			if (strTmp=="REGED")
			{
				ne.reg_state = AGENT_REG_SUCCESS;
			}
			else
			//暂时不用管注册，认为开了分机就是注册成功的
				ne.reg_state = AGENT_REG_FAILED ;
			//////////////////////////////////////////////////////////////////////////
			strTmp = cmd.Field("extension_login_state").asString();
			if (strTmp == "success")
				ne.login_state = AGENT_LOGIN_SUCCESS;
			else if (strTmp == "busy")
				ne.login_state = AGENT_LOGIN_BUSY;
			else if (strTmp == "leaved")
				ne.login_state = AGENT_LOGIN_LEAVED;
			else
				ne.login_state = AGENT_LOGIN_LOGOUT;
			ne.password  = cmd.Field("extension_pswd").asString();
			ne.call_state = CALLIN_STANDBY; //空闲状态
			printf("load extension:%s\n",ne.extension_number.c_str());
			lstExtension.push_back(ne);
		}
		cmd.Close();
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("update call_extension set extension_login_state=\'success\';");

		cmd.Execute();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load extensions error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CExtension::UpdateLoginState( nway_uint64_t& id,int nLogin )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		string strSQL;
		strSQL = "update call_extension set extension_login_state=\'";
		switch (nLogin)
		{
		case 0:
			{
				strSQL += "success";
			}
			break;
		case 1:
			{
				strSQL += "logout";
			}
			break;
		case 2:
			strSQL += "busy";
			break;
		case 3:
			strSQL += "leaved";
			break;
		default:
			;
		}
		strSQL += "\' where id=";
		char sTmp[200];
		sprintf(sTmp,"%lld\0",id);
		strSQL += sTmp;
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(strSQL.c_str());

		cmd.Execute();
		
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("update extension error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CExtension::UpdateRegState( nway_uint64_t& id, const char* szState )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{		
		char sTmp[200];
		sprintf(sTmp,"update call_extension set extension_reg_state=\'%s\' where id=%lld;\n", szState, id);
		 
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(sTmp);

		cmd.Execute();

		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("update extension error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

CCallDetailRecord::CCallDetailRecord()
{

}

CCallDetailRecord::~CCallDetailRecord()
{

}

int CCallDetailRecord::StartCall( const char* caller_name, const char* caller_number, const char* called_number, nway_uint64_t& id)
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		string strSQL;
		strSQL = "insertnewcall";
		
		 
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(strSQL.c_str());
		cmd.Param("v_caller_name").setAsString() = caller_name;
		cmd.Param("v_caller_number").setAsString() = caller_number;
		cmd.Param("v_called_number").setAsString() = called_number;
		cmd.Param("v_is_callout").setAsShort() = 0;
		cmd.Param("cdrid").setAsNumeric() = id;
		nway_uint64_t task_id = 0;
		cmd.Param("v_task_id").setAsNumeric() = task_id;
		cmd.Execute();
		id = cmd.Param("cdrid").setAsNumeric();
		cmd.Close();
		char szCmd[4000]={0};
		sprintf(szCmd,"INSERT INTO call_in_out_event("
			"aleg_number, bleg_number,  event_id, event_time, "
			"is_read,cdr_id)"
			"VALUES (\'%s\',\'%s\', 1,current_timestamp,False,%lld)\n\0",caller_number,called_number,id);
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(szCmd);
		cmd.Execute();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("start call error:%s\n",s.c_str());
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CCallDetailRecord::StartCall( const char* caller_name, const char* caller_number, const char* called_number, nway_uint64_t& id,bool bAutoCallout, nway_uint64_t& task_id  )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		string strSQL;
		strSQL = "insertnewcall";


		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(strSQL.c_str());
		cmd.Param("v_caller_name").setAsString() = caller_name;
		cmd.Param("v_caller_number").setAsString() = caller_number;
		cmd.Param("v_called_number").setAsString() = called_number;
		if (bAutoCallout)
		{
			cmd.Param("v_is_callout").setAsShort() = 1;
		}
		else
			cmd.Param("v_is_callout").setAsShort() = 0;
		cmd.Param("cdrid").setAsNumeric() = id;
		cmd.Param("v_task_id").setAsNumeric() = task_id;
		cmd.Execute();
		id = cmd.Param("cdrid").setAsNumeric();
		cmd.Close();
		char szCmd[4000]={0};
		sprintf(szCmd,"INSERT INTO call_in_out_event("
			"aleg_number, bleg_number,  event_id, event_time, "
			"is_read,cdr_id)"
			"VALUES (\'%s\',\'%s\', 1,current_timestamp,False,%lld)\n\0",caller_number,called_number,id);
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(szCmd);
		cmd.Execute();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("start call error:%s\n",s.c_str());
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CCallDetailRecord::A_AnswerCall( nway_uint64_t& id )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		string strSQL;
		strSQL = "update call_cdr set a_answer_stamp=current_timestamp,a_leg_called=True where id=";
		char sTmp[200];
		sprintf(sTmp,"%lld \n",id);

		strSQL += sTmp;
		printf(strSQL.c_str());
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(strSQL.c_str());
		
		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
		
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("update call error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CCallDetailRecord::B_AnswerCall( nway_uint64_t& id, const char* dest_number, const char* digites_dail )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		string strSQL;
		strSQL = "update call_cdr set b_leg_called=True, b_answer_stamp=current_timestamp,destination_number=\'" ;
		strSQL += dest_number;
		strSQL += "\' where id=";
		char sTmp[200];
		sprintf(sTmp,"%lld \n",id);
		
		strSQL += sTmp;
		printf(strSQL.c_str());
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(strSQL.c_str());

		cmd.Execute();
		 
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("update call error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CCallDetailRecord::A_EndCall( nway_uint64_t& id, NWAY_HANGUP_CAUSE cause,int gatewayid, NWAY_HANGUP_DIRECTION direction )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		string strSQL;
		char sTmp[200];
		strSQL = "update call_cdr set a_end_stamp=current_timestamp,hangup_cause=\'";//destination_number=\'" + dest_number+"\' " ;
		switch(cause)
		{
		case HANGUP_CAUSE_NORMAL:   //普通挂机
			strcpy(sTmp,"NORMAL");
			break;
		case HANGUP_CAUSE_IVR_NORMAL:  //IVR普通挂机
			strcpy(sTmp,"IVR_NORMAL");
			break;
		case HANGUP_CAUSE_UNANSWER:   //无人应答
			strcpy(sTmp,"UNANSWER");
			break;
		case HANGUP_CAUSE_IVR_UNANSWER:  //ivr无人应答
			strcpy(sTmp,"IVR_UNANSWER");
			break;
		case HANGUP_CAUSE_NO_FEE:   //费用不足
			strcpy(sTmp,"NO_FEE");
			break;
		case HANGUP_CAUSE_BUSY:   //对方忙
			strcpy(sTmp,"BUSY");
			break;
		case HANGUP_CAUSE_VOICEMAIL:  //语音信箱
			strcpy(sTmp,"VOICEMAIL");
			break;
		case HANGUP_CAUSE_UNKNOWN_NUMBER://无此号码
			strcpy(sTmp,"UNKNOWN_NUMBER");
			break;
		case HANGUP_CAUSE_NOT_CALL:       //无法呼出
			strcpy(sTmp,"CAN_NOT_CALL");
			break;
		case HANGUP_CAUSE_NOT_CALLED:      //无法接听
			strcpy(sTmp,"NOT_CALLED");
			break;
		default:
			;
		}
		strSQL += sTmp ;
		strSQL	+= "\'";
		if (gatewayid > 0 )
		{
			sprintf(sTmp,", hangup_cause_id=%d, hangup_direction=%d,call_gateway_id=%d  where id=%lld;\0",cause, direction , gatewayid,id);

		}
		else
			sprintf(sTmp,", hangup_cause_id=%d, hangup_direction=%d  where id=%lld;\0",cause, direction ,id);
		
		strSQL += sTmp;

		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(strSQL.c_str());

		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("update A_EndCall error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CCallDetailRecord::B_EndCall( nway_uint64_t& id, const char* dest_number, NWAY_HANGUP_CAUSE cause )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		string strSQL;
		strSQL = "update call_cdr set b_end_stamp=current_timestamp,destination_number=\'";
		strSQL += dest_number;
		strSQL += "\' ";
		//where id=";
		char sTmp[200];
		sprintf(sTmp," where id=%lld \n\0",id);
		strSQL += sTmp;
		printf(strSQL.c_str());
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(strSQL.c_str());

		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("update B_EndCall error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CCallDetailRecord::SetRecordFile( nway_uint64_t& id,const char* filename )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		string strSQL;
		strSQL = "update call_cdr set recording_file=\'";
		strSQL	+= filename;
		strSQL += "\' ";
		//where id=";
		char sTmp[200];
		sprintf(sTmp," where id=%lld\0",id);
		strSQL += sTmp;

		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(strSQL.c_str());

		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("set record file error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CCallDetailRecord::CountTime( nway_uint64_t& id )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		string strSQL;
		strSQL = "count_time";
		

		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(strSQL.c_str());
		cmd.Param("cdrid").setAsNumeric() = id;
		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("count time error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CCallDetailRecord::SetDtmf( nway_uint64_t& id, const char* dtmf )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{

		char szCmd[4000]={0};
		sprintf(szCmd,"update call_cdr set input_key=\'%s\' where cdr_id=%lld;\n",dtmf, id);
		cmd.setConnection(dbInstance->GetConn());
		printf("%s, %d sql:%s\n",__FILE__,__LINE__,szCmd);
		cmd.setCommandText(szCmd);
		cmd.Execute();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());

		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int InsertCallEvent( nway_uint64_t& cdr_id, nway_uint64_t& ext_id,string& a_leg_number,string& b_leg_number,string& route_number, NWAY_CALL_EVENT iEvent )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		string strSQL;
		/*if (ext_id > 0)
			strSQL += ", extension_id";
		if (route_number.length() > 0 )
		{
			strSQL += ", router_number";
		}*/
		char szCmd[4000]={0};
		if (ext_id >0 && route_number.length() > 0)
		{
			sprintf(szCmd,"INSERT INTO call_in_out_event("
				"aleg_number, bleg_number,  event_id, event_time, "
				"is_read,cdr_id ,extension_id, router_number)"
				"VALUES (\'%s\',\'%s\', %d,current_timestamp,False,%lld,%lld,\'%s\')\n\0",
				a_leg_number.c_str(),b_leg_number.c_str(),iEvent,cdr_id,ext_id,route_number.c_str());
		}
		else
		{
			if (ext_id >0 )
			{
				sprintf(szCmd,"INSERT INTO call_in_out_event("
					"aleg_number, bleg_number,  event_id, event_time, "
					"is_read,cdr_id ,extension_id, router_number)"
					"VALUES (\'%s\',\'%s\', %d,current_timestamp,False,%lld,%lld, \'%s\')\n\0",
					a_leg_number.c_str(),b_leg_number.c_str(),iEvent,cdr_id,ext_id, route_number.c_str());
			}
			else
				if (route_number.length() > 0)
				{
					sprintf(szCmd,"INSERT INTO call_in_out_event("
						"aleg_number, bleg_number,  event_id, event_time, "
						"is_read,cdr_id ,extension_id, router_number)"
						"VALUES (\'%s\',\'%s\', %d,current_timestamp,False,%lld,%lld, \'%s\')\n\0",
						a_leg_number.c_str(),b_leg_number.c_str(),iEvent, cdr_id,ext_id,route_number.c_str());
				}
				else
				{
					sprintf(szCmd,"INSERT INTO call_in_out_event("
						"aleg_number, bleg_number,  event_id, event_time, "
						"is_read,cdr_id)"
						"VALUES (\'%s\',\'%s\', %d,current_timestamp,False,%lld)\n\0",a_leg_number.c_str(),b_leg_number.c_str(),iEvent,cdr_id);
				}
			
		}
		
		cmd.setConnection(dbInstance->GetConn());
		//printf("%s, %d sql:%s\n",__FILE__,__LINE__,szCmd);
		cmd.setCommandText(szCmd);
		cmd.Execute();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int UpdateCallEvent( nway_uint64_t& cdr_id, nway_uint64_t& ext_id )
{
		db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		
		char szCmd[4000]={0};
		sprintf(szCmd,"update call_in_out_event set extension_id=%lld where cdr_id=%lld\n\0",ext_id,cdr_id);
		cmd.setConnection(dbInstance->GetConn());
		printf("%s, %d sql:%s\n",__FILE__,__LINE__,szCmd);
		cmd.setCommandText(szCmd);
		cmd.Execute();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int DBGetClickDials( vector<Click_Dial>& vecClickDials )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("SELECT id, caller_number, is_agent, is_immediately, trans_number, time_plan, \
			account_number, is_called\
			FROM call_click_dial where is_called=False and is_immediately=True;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			Click_Dial cd;
			cd.id = cmd.Field("id").asNumeric();
			cd.account_number = cmd.Field("account_number").asString();
			cd.caller_number = cmd.Field("caller_number").asString();
			cd.trans_number = cmd.Field("trans_number").asString();
			vecClickDials.push_back(cd);
			
		}
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load extensions error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int DBSetClickDialed( nway_uint64_t& id )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{

		char szCmd[4000]={0};
		sprintf(szCmd,"update call_click_dial set is_called=True where id=%lld\n\0",id);
		cmd.setConnection(dbInstance->GetConn());
		printf("%s, %d sql:%s\n",__FILE__,__LINE__,szCmd);
		cmd.setCommandText(szCmd);
		cmd.Execute();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());

		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int DBGetConfigChanged( vector<int>& vecConfigs )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText("SELECT config_order "
						   "FROM call_load_config where is_load=True;");

		cmd.Execute();
		while(cmd.FetchNext())
		{
			int config_id;
			config_id = cmd.Field("config_order").asShort();
			
			vecConfigs.push_back(config_id);
			nSuccess =1;
		}
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load extensions error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int DBSetConfigChanged( int orderid )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		char szCmd[1024]={0};
		sprintf(szCmd,"update call_load_config set is_load=False where config_order=%d;\n", orderid);
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(szCmd);

		cmd.Execute();
		
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("load extensions error:%s\n",s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

CDBCalloutTask::CDBCalloutTask()
{

}

CDBCalloutTask::~CDBCalloutTask()
{

}

int CDBCalloutTask::GetTasks( list<Callout_Task>& lstCalloutTasks , list<NwayGateway>& lstGateways,list<NwayCalloutGateway>& lstCalloutGateways)
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		string strSQL;
		
		//strSQL = "count_time";
		strSQL = "SELECT id, callout_name, number_group_id, number_group_uploadfile, run_position, \
			time_rule_id, start_time, stop_time, ring_id, after_ring_play, \
			ring_timeout, group_id, call_project_id, concurr_type_id, concurr_number, \
			callout_state_id, total_number, wait_number, success_number, \
			failed_number, cancel_number, has_parse_from_file, callout_gateway_id, \
			max_concurr_number, second_ring_id, second_after_ring_opt, after_ring_key, \
			after_key_opt_id,outside_line_number \
			FROM call_group_callout  t where t.start_time < now() and t.stop_time >now() \
			and (callout_state_id=1 or callout_state_id=2 or callout_state_id=4) and has_parse_from_file=True ;";

		//printf("%s,%d    string:%s \n\n", __FILE__, __LINE__, strSQL.c_str());
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(strSQL.c_str());
		 
		cmd.Execute();
		while(cmd.FetchNext())
		{
			//找到相关的定时任务
			//每条记录应先从列表中检索一遍看存在与否
			Callout_Task ct ;
			ct.id = cmd.Field("id").asNumeric();
			ct.callout_name = cmd.Field("callout_name").asString();
			ct.after_key_opt_id = cmd.Field("after_key_opt_id").asShort();
			ct.after_ring_key = cmd.Field("after_ring_key").asString();
			ct.after_ring_play = cmd.Field("after_ring_play").asShort();
			ct.call_project_id = cmd.Field("call_project_id").asNumeric();
			ct.callout_gateway_id = cmd.Field("callout_gateway_id").asNumeric();
			ct.callout_state_id = cmd.Field("callout_state_id").asNumeric();
			ct.cancel_number = cmd.Field("cancel_number").asShort();
			ct.concurr_number = cmd.Field("concurr_number").asShort();
			ct.concurr_type_id = cmd.Field("concurr_type_id").asNumeric();
			ct.failed_number = cmd.Field("failed_number").asShort();
			ct.group_id = cmd.Field("group_id").asNumeric();
			ct.max_concurr_number = cmd.Field("max_concurr_number").asShort();
			ct.number_group_id = cmd.Field("number_group_id").asNumeric();
			ct.ring_id = cmd.Field("ring_id").asNumeric();
			ct.ring_timeout = cmd.Field("ring_timeout").asShort();
			ct.run_position = cmd.Field("run_position").asNumeric(); // 实时更新
			ct.second_after_ring_opt = cmd.Field("second_after_ring_opt").asShort();
			ct.second_ring_id = cmd.Field("second_ring_id").asNumeric();
			ct.success_number = cmd.Field("success_number").asShort();
			ct.time_rule_id = cmd.Field("time_rule_id").asNumeric();
			ct.total_number = cmd.Field("total_number").asShort();
			ct.wait_number = cmd.Field("wait_number").asShort();
			ct.outside_line_number = cmd.Field("outside_line_number").asString();
			printf("%s,%d  get a call out task:%s\n\n",__FILE__,__LINE__,ct.callout_name.c_str());
			//先查找网关，如果没有网关，则不需要对此外呼任务进行处理
			list<NwayCalloutGateway>::iterator coGwit = lstCalloutGateways.begin();
			for(; coGwit != lstCalloutGateways.end(); coGwit++)
			{
				NwayCalloutGateway& nwCalloutGw = *coGwit;
				if (nwCalloutGw.id == ct.callout_gateway_id)
				{
					list<NwayGateway>::iterator gwit = lstGateways.begin();
					for (; gwit != lstGateways.end(); gwit++)
					{
						NwayGateway& nwaygw = *gwit;
						if (nwaygw.id == nwCalloutGw.gateway_id)
						{
							ct.gateway_max_line = nwaygw.max_call;
							ct.gateway_url = nwaygw.gateway_url;
							ct.call_prefix = nwaygw.call_prefix;
							break;
						}
					}
					break;
				}

			}
			//////////////////////////////////////////////////////////////////////////
			
			//处理暂停事宜
			list<Callout_Task>::iterator it = lstCalloutTasks.begin();
			bool bFound = false;
			for (; it != lstCalloutTasks.end(); it ++)
			{
				Callout_Task& nwayCt = *it;
				printf("%s,%d compare the list task:%s and this task:%s \n\n", __FILE__,__LINE__,nwayCt.callout_name.c_str() ,ct.callout_name.c_str());
				if (nwayCt.id == ct.id)
				{
					if (ct.callout_state_id == 4 || trim(ct.gateway_url).length() <3)
					{
						//处理暂停
						nwayCt.callout_state_id = 4;
						//*it = nwayCt;
					}
					//*it = nwayCt;
					bFound = true;
					break;
				}
			}
			//if ()
			//{
			//	printf("%s,%d the call out gateway:%s\n\n" , __FILE__, __LINE__, ct.gateway_url.c_str());
			//	//暂停，否则会让检测线程不停处理这个任务
			//	nwayCt.callout_state_id = 4; 
			//	continue;
			//}
			if (!bFound)
			{
				printf("%s, %d  add a call out task id: %lld ;\n",__FILE__,__LINE__, ct.id);
				lstCalloutTasks.push_back(ct);
			}

		}
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		printf("%s, %d\t GetTasks error:%s\n", __FILE__,__LINE__,s.c_str()); 
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CDBCalloutTask::UpdateTaskStatus( nway_uint64_t& id, nway_uint64_t& run_postion, int total,int success, int failed, int cancled )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		char sTmp[2000] = {0};
		 
		sprintf(sTmp,"update call_group_callout set run_position=%lld,success_number=%d,failed_number=%d,wait_number=%d,cancel_number=%d  where id=%lld \n",run_postion,success,failed,total-success-failed, cancled,id);
		//where id=";
		 
		 

		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(sTmp);

		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CDBCalloutTask::UpdateTaskState( nway_uint64_t&id, int nState )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		char sTmp[2000] = {0};

		sprintf(sTmp,"update call_group_callout set callout_state_id=%d  where id=%lld ;\n",nState , id);
		//where id=";



		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(sTmp);

		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CDBCalloutTask::GetIdleAgentNumber( nway_uint64_t& groupid,int& nNumber )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		char szTmp[1024] = {0};

		//strSQL = "count_time";
		sprintf(szTmp, "SELECT count(id) as idlecount \
			FROM call_extension t where (t.extension_login_state='success' or t.extension_login_state='') and t.group_id =%lld;\n",groupid) ;


		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(szTmp);

		cmd.Execute();
		while(cmd.FetchNext())
		{
			nNumber = cmd.Field("idlecount").asLong();
		}
		//id = cmd.Param('cdrid').setAsNumeric();
		//printf("%s, %d\t Has %d Idle Agent\n",__FILE__, __LINE__, nNumber);
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CDBCalloutTask::GetCalloutNumbers( Callout_Task& nwayct, int nMaxnumber )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();
	nway_uint64_t i64Maxid = nwayct.run_position;
	try
	{
		char szTmp[1024] = {0};

		//strSQL = "count_time";
		sprintf(szTmp, "SELECT id, group_id, \"number\", is_called, call_state, start_time, answer_time, \
			hangup_time, hangup_reason_id, answer_extension_id, record_file, wait_sec \
			FROM call_out_numbers where group_id=%lld and call_out_task_id=%lld and is_called=0  and id >%lld order by id limit %d offset 0;\n", nwayct.number_group_id,  nwayct.id, nwayct.run_position, nMaxnumber) ;
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(szTmp);
		//printf(szTmp);
		cmd.Execute();
		int nCount = 0;
		while(cmd.FetchNext())
		{
			 Callout_info ci;
			 ci.id = cmd.Field("id").asNumeric();
			 ci.group_id = nwayct.id;
			 ci.number = cmd.Field("number").asString();
			 ci.wait_sec = cmd.Field("wait_sec").asShort();
			 ci.callout_state = CALLOUT_INIT;
			 i64Maxid = ci.id;
			 string strNumber;
			 strNumber = trim(ci.number);
			 if (strNumber.length() < 2 || strNumber == "110" || strNumber == "119" || strNumber == "96110"  )
			 {
				 //以后可进一步扩展为可配置
				 continue;
			 }
			 sprintf(szTmp,"%s,%d    get a call out number:%s\n\n",__FILE__,__LINE__,ci.number.c_str());
			 LOG(szTmp);
			 nwayct.lstCalloutInfo.push_back(ci);
			 nCount ++;

		}

		nwayct.run_position = i64Maxid;//更新position,由于order by故而是最大的，除非数据库中随意手工更改过
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
		if (nCount == 0)
		{
			//号码获取不到了，则是可以认为完成这个任务了
			sprintf(szTmp,"Update call_group_callout set callout_state_id=3 where id=%lld ;\n",nwayct.id);
			cmd.setConnection(dbInstance->GetConn());
			cmd.setCommandText(szTmp);

			cmd.Execute();
			cmd.Close();

		}
		else
		{
			sprintf(szTmp,"Update call_group_callout set callout_state_id=2 where id=%lld ;\n",nwayct.id);
			cmd.setConnection(dbInstance->GetConn());
			cmd.setCommandText(szTmp);
			cmd.Close();

			cmd.Execute();
		}

	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CDBCalloutInfo::StartCallout( nway_uint64_t& id,nway_uint64_t& cdrid )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		char sTmp[2000] = {0};

		sprintf(sTmp,"update call_out_numbers set is_called=1,start_time=current_timestamp,cdr_id=%lld  where id=%lld \n\0", id, cdrid);
		//where id=";



		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(sTmp);

		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

CDBCalloutInfo::CDBCalloutInfo()
{

}

CDBCalloutInfo::~CDBCalloutInfo()
{

}

int CDBCalloutInfo::ExtensionAnswer( nway_uint64_t& id,nway_uint64_t& extension_id,const char* record_file )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		char sTmp[2000] = {0};

		sprintf(sTmp,"update call_out_numbers set answer_extension_id=%lld,record_file=\'%s\' where id=%lld \n",extension_id,record_file,id );
		
		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(sTmp);

		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CDBCalloutInfo::SetAlegAnswer( nway_uint64_t& id )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		char sTmp[2000] = {0};

		sprintf(sTmp,"update call_out_numbers set answer_time=current_timestamp   where id=%lld \n",id);

		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(sTmp);

		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CDBCalloutInfo::SetAlegHangup( nway_uint64_t& id, int nHangupid )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		char sTmp[2000] = {0};

		sprintf(sTmp,"update call_out_numbers set hangup_time=current_timestamp, hangup_reason_id=%d   where id=%lld \n",nHangupid,id);

		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(sTmp);

		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}

int CDBCalloutInfo::SetCalled( nway_uint64_t& id )
{
	db_center* dbInstance = db_center::get_instance();
	SACommand cmd;
	int nSuccess=0;
	dbInstance->Lock();

	try
	{
		char sTmp[2000] = {0};

		sprintf(sTmp,"update call_out_numbers set is_called=1 where id=%lld \n", id);

		cmd.setConnection(dbInstance->GetConn());
		cmd.setCommandText(sTmp);

		cmd.Execute();
		//id = cmd.Param('cdrid').setAsNumeric();
		cmd.Close();
	}
	catch (SAException &x)
	{
		string s;
		s = x.ErrText().GetBuffer(x.ErrText().GetLength());
		LOGERREX(__FILE__,__LINE__,s.c_str());
		nSuccess = -1;//执行有错误
	}
	dbInstance->Unlock();
	return nSuccess;
}
