/*************************************************************************
based for NwayPBX
Copyright (C) 2015-, Li hao <lihao@nway.com.cn>
License： GPL
author: Li hao
email: lihao@nway.com.cn
The Initial Developer of the Original Code is
Li hao<lihao@nway.com.cn>
Portions created by the Initial Developer are Copyright (C)
the Initial Developer. All Rights Reserved.
Contributor(s):
**************************************************************************/
#ifndef ___NWAY_DB_LOAD_H__
#define ___NWAY_DB_LOAD_H__
#include <esl.h>
#include "../database/dbimp/CDBOperator.h"
//originate {return_ring_ready=true}sofia/gateway/liangping/18621575908 &bridge(user/8001)同时振铃

#define SYSTEM_V_CALL 9999                //4个9代表是一个具体的虚拟号，用于外呼的时候，呼进来后先挂起，然后再按相应的逻辑进行处理

int get_uuid(char* uuid);
bool InitDatabase();
bool LoadConfigFromDb(list<base_config>& lstBaseConfig, list<NwayExtensionGroup>& lstExtensionGroup, list<NwayExtension>& lstExtension, \
	list<NwayGateway>& lstGateway, list<NwayDialplanDetail>& lstDialplanDetail, list<NwayDialplan>& lstDialplan, \
	list<NwayIVRDetail>& lstIvrDeatail, list<NwayIVR>& lstIvr, list<NwayRing>& lstRings, list<Outside_line>& lstOutsides,\
	list<In_Out_Mapping>& lstInOutMapping, list<NwayCalloutGateway>& lstCalloutGateways);
#endif