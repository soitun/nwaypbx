PGDMP     0    4                r            nwaycc    9.3.5    9.3.5 H   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           1262    16384    nwaycc    DATABASE     v   CREATE DATABASE nwaycc WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'zh_CN.utf8' LC_CTYPE = 'zh_CN.utf8';
    DROP DATABASE nwaycc;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    5            �           0    0    public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    5            �            3079    12670    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    241            �            1255    17229    count_time(bigint)    FUNCTION     �  CREATE FUNCTION count_time(cdrid bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$  
 
    Declare ret integer;
    Begin  
        ret := 0;
	update call_cdr set duration=ceil(abs(extract(epoch from a_answer_stamp - a_end_stamp))) where id=cdrid and a_leg_called=True;
	update call_cdr set mduration=ceil(abs(extract(epoch from b_answer_stamp - b_end_stamp))) where id=cdrid and b_leg_called=True;
		
        return ret;
    END;
    $$;
 /   DROP FUNCTION public.count_time(cdrid bigint);
       public       postgres    false    5    241                        1255    17243 W   insertnewcall(character varying, character varying, character varying, integer, bigint)    FUNCTION     �  CREATE FUNCTION insertnewcall(v_caller_name character varying, v_caller_number character varying, v_called_number character varying, v_is_callout integer, INOUT cdrid bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$  
 
    Declare cid bigint;
            ret integer;
    Begin  
        cdrid := 0;
	select nextval('call_cdr_id_seq') into cid;
	if v_is_callout = 0 then
		INSERT INTO call_cdr(id, caller_id_name, caller_id_number,  
		    star_epoch, start_stamp, called_number, a_end_epoch, a_end_stamp)
		VALUES (cid, v_caller_name, v_caller_number, 0, current_timestamp, v_called_number, 0, current_timestamp);
	else
		INSERT INTO call_cdr(id, caller_id_name, caller_id_number,  
		    star_epoch, start_stamp, called_number, a_end_epoch, a_end_stamp,auto_callout)
		VALUES (cid, v_caller_name, v_caller_number, 0, current_timestamp, v_called_number, 0, current_timestamp,True);
	end if;
	cdrid := cid;
        --正常返回
        return ;
    END;
    $$;
 �   DROP FUNCTION public.insertnewcall(v_caller_name character varying, v_caller_number character varying, v_called_number character varying, v_is_callout integer, INOUT cdrid bigint);
       public       postgres    false    5    241            �            1255    17232 5   query_callouts(refcursor, integer, character varying)    FUNCTION     �  CREATE FUNCTION query_callouts(INOUT io_cursor_ref refcursor, INOUT opstatus integer, INOUT errtext character varying) RETURNS record
    LANGUAGE plpgsql
    AS $$
DECLARE

 --IO_CURSOR_REF,结果集
 --opstatus,操作结果，0为成功
 --errText,如果出错，则这是出错的文本信息
 --2013-5-2
 --李浩
BEGIN
  SELECT id, callout_name, number_group_id, number_group_uploadfile, run_position, 
       time_rule_id, start_time, stop_time, ring_id, after_ring_play, 
       ring_timeout, group_id, call_project_id, concurr_type_id, concurr_number, 
       callout_state_id, total_number, wait_number, success_number, 
       failed_number, cancel_number, has_parse_from_file, callout_gateway_id, 
       max_concurr_number, second_ring_id, second_after_ring_opt, after_ring_key, 
       after_key_opt_id
  FROM call_group_callout  t where t.start_time < now() and t.stop_time >now() and (callout_state_id=1 or callout_state_id=2) ;
  OPEN IO_CURSOR_REF FOR
    SELECT * from call_out_numbers;

  RETURN;
   Exception
	When Others Then
		GET STACKED DIAGNOSTICS opstatus = RETURNED_SQLSTATE,
                               errText = MESSAGE_TEXT;
END;

$$;
 }   DROP FUNCTION public.query_callouts(INOUT io_cursor_ref refcursor, INOUT opstatus integer, INOUT errtext character varying);
       public       postgres    false    241    5            �            1259    16805 
   auth_group    TABLE     ^   CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);
    DROP TABLE public.auth_group;
       public         postgres    false    5            �            1259    16803    auth_group_id_seq    SEQUENCE     s   CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.auth_group_id_seq;
       public       postgres    false    5    215            �           0    0    auth_group_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;
            public       postgres    false    214            �            1259    16790    auth_group_permissions    TABLE     �   CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);
 *   DROP TABLE public.auth_group_permissions;
       public         postgres    false    5            �            1259    16788    auth_group_permissions_id_seq    SEQUENCE        CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.auth_group_permissions_id_seq;
       public       postgres    false    213    5            �           0    0    auth_group_permissions_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;
            public       postgres    false    212            �            1259    16780    auth_permission    TABLE     �   CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);
 #   DROP TABLE public.auth_permission;
       public         postgres    false    5            �            1259    16778    auth_permission_id_seq    SEQUENCE     x   CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.auth_permission_id_seq;
       public       postgres    false    211    5                        0    0    auth_permission_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;
            public       postgres    false    210            �            1259    16850 	   auth_user    TABLE     �  CREATE TABLE auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone NOT NULL,
    is_superuser boolean NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(75) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);
    DROP TABLE public.auth_user;
       public         postgres    false    5            �            1259    16820    auth_user_groups    TABLE     x   CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);
 $   DROP TABLE public.auth_user_groups;
       public         postgres    false    5            �            1259    16818    auth_user_groups_id_seq    SEQUENCE     y   CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.auth_user_groups_id_seq;
       public       postgres    false    5    217                       0    0    auth_user_groups_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;
            public       postgres    false    216            �            1259    16848    auth_user_id_seq    SEQUENCE     r   CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.auth_user_id_seq;
       public       postgres    false    5    221                       0    0    auth_user_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;
            public       postgres    false    220            �            1259    16835    auth_user_user_permissions    TABLE     �   CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);
 .   DROP TABLE public.auth_user_user_permissions;
       public         postgres    false    5            �            1259    16833 !   auth_user_user_permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.auth_user_user_permissions_id_seq;
       public       postgres    false    5    219                       0    0 !   auth_user_user_permissions_id_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;
            public       postgres    false    218            �            1259    17053    call_after_opt    TABLE     b   CREATE TABLE call_after_opt (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
 "   DROP TABLE public.call_after_opt;
       public         postgres    false    5                       0    0    TABLE call_after_opt    COMMENT     K   COMMENT ON TABLE call_after_opt IS '在外呼时，播放铃声后操作';
            public       postgres    false    228            �            1259    17160    call_afteropt_id_seq    SEQUENCE     v   CREATE SEQUENCE call_afteropt_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.call_afteropt_id_seq;
       public       postgres    false    5            �            1259    17005    call_base_config    TABLE     �   CREATE TABLE call_base_config (
    id integer NOT NULL,
    config_name character varying(255) NOT NULL,
    config_param character varying(255) NOT NULL
);
 $   DROP TABLE public.call_base_config;
       public         postgres    false    5            �            1259    16469    call_cdr    TABLE     X  CREATE TABLE call_cdr (
    id bigint NOT NULL,
    accountcode text,
    xml_cdr text,
    caller_id_name character varying(50),
    caller_id_number character varying(50),
    destination_number character varying(50),
    star_epoch numeric,
    start_stamp timestamp without time zone,
    a_answer_stamp timestamp without time zone,
    a_answer_epoch numeric,
    a_end_epoch numeric,
    a_end_stamp timestamp without time zone,
    duration numeric,
    mduration numeric,
    billsec numeric,
    recording_file character varying(255),
    conference_name character varying(50),
    conference_id bigint,
    digites_dialed character varying(50),
    hangup_cause character varying(200),
    hangup_cause_id bigint,
    waitsec integer,
    call_gateway_id bigint,
    b_answer_stamp timestamp without time zone,
    b_answer_epoch numeric,
    b_end_stamp timestamp without time zone,
    b_end_epoch numeric,
    hangup_direction integer,
    a_leg_called boolean DEFAULT false,
    b_leg_called boolean DEFAULT false,
    called_number character varying(50),
    auto_callout boolean DEFAULT false
);
    DROP TABLE public.call_cdr;
       public         postgres    false    5                       0    0     COLUMN call_cdr.hangup_direction    COMMENT     U   COMMENT ON COLUMN call_cdr.hangup_direction IS '挂机方向，和c部分的对应';
            public       postgres    false    181                       0    0    COLUMN call_cdr.a_leg_called    COMMENT     :   COMMENT ON COLUMN call_cdr.a_leg_called IS 'a leg接通';
            public       postgres    false    181            �            1259    16467    call_cdr_id_seq    SEQUENCE     q   CREATE SEQUENCE call_cdr_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.call_cdr_id_seq;
       public       postgres    false    5    181                       0    0    call_cdr_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE call_cdr_id_seq OWNED BY call_cdr.id;
            public       postgres    false    180            �            1259    18454    call_click_dial    TABLE     J  CREATE TABLE call_click_dial (
    id bigint NOT NULL,
    caller_number character(50),
    is_agent boolean DEFAULT false,
    is_immediately boolean DEFAULT false,
    trans_number character varying(50),
    time_plan timestamp without time zone,
    account_number character varying(50),
    is_called boolean DEFAULT false
);
 #   DROP TABLE public.call_click_dial;
       public         postgres    false    5                       0    0 $   COLUMN call_click_dial.caller_number    COMMENT     f   COMMENT ON COLUMN call_click_dial.caller_number IS '客户电话，如手机号，不管3721都加0';
            public       postgres    false    237            	           0    0    COLUMN call_click_dial.is_agent    COMMENT     H   COMMENT ON COLUMN call_click_dial.is_agent IS '是否属于voip内线';
            public       postgres    false    237            
           0    0 %   COLUMN call_click_dial.is_immediately    COMMENT     J   COMMENT ON COLUMN call_click_dial.is_immediately IS '是否立即执行';
            public       postgres    false    237                       0    0 #   COLUMN call_click_dial.trans_number    COMMENT     B   COMMENT ON COLUMN call_click_dial.trans_number IS '转接号码';
            public       postgres    false    237                       0    0     COLUMN call_click_dial.time_plan    COMMENT     d   COMMENT ON COLUMN call_click_dial.time_plan IS '当is_immediately为FALSE时生效，定时呼叫';
            public       postgres    false    237                       0    0 %   COLUMN call_click_dial.account_number    COMMENT     D   COMMENT ON COLUMN call_click_dial.account_number IS '计费帐户';
            public       postgres    false    237                       0    0     COLUMN call_click_dial.is_called    COMMENT     ?   COMMENT ON COLUMN call_click_dial.is_called IS '是否呼叫';
            public       postgres    false    237            �            1259    18452    call_click_dial_id_seq    SEQUENCE     x   CREATE SEQUENCE call_click_dial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.call_click_dial_id_seq;
       public       postgres    false    5    237                       0    0    call_click_dial_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE call_click_dial_id_seq OWNED BY call_click_dial.id;
            public       postgres    false    236            �            1259    16667    call_concurr_type    TABLE     r   CREATE TABLE call_concurr_type (
    id bigint NOT NULL,
    concurr_type_name character varying(255) NOT NULL
);
 %   DROP TABLE public.call_concurr_type;
       public         postgres    false    5                       0    0    TABLE call_concurr_type    COMMENT     6   COMMENT ON TABLE call_concurr_type IS '并发类型';
            public       postgres    false    206            �            1259    17156    call_concurr_type_id_seq    SEQUENCE     z   CREATE SEQUENCE call_concurr_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.call_concurr_type_id_seq;
       public       postgres    false    5            �            1259    16562    call_dialplan_details    TABLE     u  CREATE TABLE call_dialplan_details (
    id bigint NOT NULL,
    dialplan_id bigint,
    dialplan_detail_tag character varying(255),
    dialplan_detail_data text,
    dialplan_detail_inline text,
    dialplan_detail_group_id bigint,
    dialplan_detail_order integer,
    dialplan_detail_break boolean,
    dialplan_detail_type_id integer,
    ring_id bigint DEFAULT 0
);
 )   DROP TABLE public.call_dialplan_details;
       public         postgres    false    5                       0    0 $   COLUMN call_dialplan_details.ring_id    COMMENT     `   COMMENT ON COLUMN call_dialplan_details.ring_id IS '如果是播放彩铃，则需要彩铃id';
            public       postgres    false    198            �            1259    16560    call_dialplan_details_id_seq    SEQUENCE     ~   CREATE SEQUENCE call_dialplan_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.call_dialplan_details_id_seq;
       public       postgres    false    198    5                       0    0    call_dialplan_details_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE call_dialplan_details_id_seq OWNED BY call_dialplan_details.id;
            public       postgres    false    197            �            1259    16552    call_dialplans    TABLE     3  CREATE TABLE call_dialplans (
    id bigint NOT NULL,
    dialplan_name character varying(255),
    dialplan_context character varying(255),
    dialplan_number character varying(255),
    dialplan_order numeric,
    dialplan_description text,
    dialplan_enabled boolean,
    dialplan_continue boolean
);
 "   DROP TABLE public.call_dialplans;
       public         postgres    false    5                       0    0 #   COLUMN call_dialplans.dialplan_name    COMMENT     <   COMMENT ON COLUMN call_dialplans.dialplan_name IS '名称';
            public       postgres    false    196                       0    0 &   COLUMN call_dialplans.dialplan_context    COMMENT     W   COMMENT ON COLUMN call_dialplans.dialplan_context IS '一般destination_number即可';
            public       postgres    false    196                       0    0 %   COLUMN call_dialplans.dialplan_number    COMMENT     Y   COMMENT ON COLUMN call_dialplans.dialplan_number IS '号码，可按正则表达式来';
            public       postgres    false    196            �            1259    16550    call_dialplans_id_seq    SEQUENCE     w   CREATE SEQUENCE call_dialplans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.call_dialplans_id_seq;
       public       postgres    false    5    196                       0    0    call_dialplans_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE call_dialplans_id_seq OWNED BY call_dialplans.id;
            public       postgres    false    195            �            1259    16395    call_extension    TABLE     �  CREATE TABLE call_extension (
    id bigint NOT NULL,
    extension_name character varying(50) NOT NULL,
    extension_number character varying(50) NOT NULL,
    callout_number character varying(50),
    extension_type bigint,
    group_id bigint,
    extension_pswd character varying(130),
    extension_login_state character varying(50) DEFAULT 'success'::character varying,
    extension_reg_state character varying(50),
    callout_gateway bigint,
    is_allow_callout boolean,
    call_state integer
);
 "   DROP TABLE public.call_extension;
       public         postgres    false    5                       0    0 $   COLUMN call_extension.extension_name    COMMENT     C   COMMENT ON COLUMN call_extension.extension_name IS '分机名称';
            public       postgres    false    173                       0    0 &   COLUMN call_extension.extension_number    COMMENT     E   COMMENT ON COLUMN call_extension.extension_number IS '分机号码';
            public       postgres    false    173                       0    0 $   COLUMN call_extension.callout_number    COMMENT     I   COMMENT ON COLUMN call_extension.callout_number IS '外呼时的号码';
            public       postgres    false    173                       0    0 $   COLUMN call_extension.extension_type    COMMENT     C   COMMENT ON COLUMN call_extension.extension_type IS '分机类型';
            public       postgres    false    173                       0    0 )   COLUMN call_extension.extension_reg_state    COMMENT     H   COMMENT ON COLUMN call_extension.extension_reg_state IS '注册状态';
            public       postgres    false    173                       0    0     COLUMN call_extension.call_state    COMMENT     k   COMMENT ON COLUMN call_extension.call_state IS '该分机的通话状态，空闲为0，正在通话中1';
            public       postgres    false    173            �            1259    16596    call_extension_groups    TABLE     �   CREATE TABLE call_extension_groups (
    id bigint NOT NULL,
    group_name character varying(255) NOT NULL,
    group_description character varying(500)
);
 )   DROP TABLE public.call_extension_groups;
       public         postgres    false    5                       0    0 '   COLUMN call_extension_groups.group_name    COMMENT     I   COMMENT ON COLUMN call_extension_groups.group_name IS '分机组名称';
            public       postgres    false    202            �            1259    16594    call_extension_groups_id_seq    SEQUENCE     ~   CREATE SEQUENCE call_extension_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.call_extension_groups_id_seq;
       public       postgres    false    202    5                       0    0    call_extension_groups_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE call_extension_groups_id_seq OWNED BY call_extension_groups.id;
            public       postgres    false    201            �            1259    16393    call_extension_id_seq    SEQUENCE     w   CREATE SEQUENCE call_extension_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.call_extension_id_seq;
       public       postgres    false    5    173                       0    0    call_extension_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE call_extension_id_seq OWNED BY call_extension.id;
            public       postgres    false    172            �            1259    16403    call_extension_type    TABLE     b   CREATE TABLE call_extension_type (
    id bigint NOT NULL,
    type_name character varying(50)
);
 '   DROP TABLE public.call_extension_type;
       public         postgres    false    5            �            1259    16401    call_extension_type_id_seq    SEQUENCE     |   CREATE SEQUENCE call_extension_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.call_extension_type_id_seq;
       public       postgres    false    5    175                        0    0    call_extension_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE call_extension_type_id_seq OWNED BY call_extension_type.id;
            public       postgres    false    174            �            1259    16529    call_functions    TABLE     �   CREATE TABLE call_functions (
    id bigint NOT NULL,
    function_name character varying(255),
    function_description text
);
 "   DROP TABLE public.call_functions;
       public         postgres    false    5            !           0    0 #   COLUMN call_functions.function_name    COMMENT     B   COMMENT ON COLUMN call_functions.function_name IS '功能名称';
            public       postgres    false    191            �            1259    17154    call_functions_id_seq    SEQUENCE     w   CREATE SEQUENCE call_functions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.call_functions_id_seq;
       public       postgres    false    5            �            1259    16424    call_gateway    TABLE     �   CREATE TABLE call_gateway (
    id bigint NOT NULL,
    gateway_name character varying(255),
    gateway_url character varying(255),
    call_prefix character varying(50),
    max_call integer
);
     DROP TABLE public.call_gateway;
       public         postgres    false    5            "           0    0     COLUMN call_gateway.gateway_name    COMMENT     ?   COMMENT ON COLUMN call_gateway.gateway_name IS '网关名称';
            public       postgres    false    179            #           0    0    COLUMN call_gateway.call_prefix    COMMENT     >   COMMENT ON COLUMN call_gateway.call_prefix IS '出局冠字';
            public       postgres    false    179            $           0    0    COLUMN call_gateway.max_call    COMMENT     M   COMMENT ON COLUMN call_gateway.max_call IS '网关最大的并发线路数';
            public       postgres    false    179            �            1259    16422    call_gateway_id_seq    SEQUENCE     u   CREATE SEQUENCE call_gateway_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.call_gateway_id_seq;
       public       postgres    false    179    5            %           0    0    call_gateway_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE call_gateway_id_seq OWNED BY call_gateway.id;
            public       postgres    false    178            �            1259    16387 
   call_group    TABLE     c   CREATE TABLE call_group (
    id bigint NOT NULL,
    group_name character varying(50) NOT NULL
);
    DROP TABLE public.call_group;
       public         postgres    false    5            &           0    0    COLUMN call_group.group_name    COMMENT     A   COMMENT ON COLUMN call_group.group_name IS '外呼组的组名';
            public       postgres    false    171            �            1259    16537    call_group_callout    TABLE     �  CREATE TABLE call_group_callout (
    id bigint NOT NULL,
    callout_name character varying(255),
    number_group_id bigint,
    number_group_uploadfile character varying(255),
    run_position bigint,
    time_rule_id bigint,
    start_time timestamp without time zone,
    stop_time timestamp without time zone,
    ring_id bigint,
    after_ring_play integer,
    ring_timeout integer,
    group_id bigint,
    call_project_id bigint,
    concurr_type_id bigint,
    concurr_number numeric,
    callout_state_id bigint,
    total_number integer DEFAULT 0,
    wait_number integer DEFAULT 0,
    success_number integer DEFAULT 0,
    failed_number integer DEFAULT 0,
    cancel_number integer DEFAULT 0,
    has_parse_from_file boolean DEFAULT false,
    callout_gateway_id bigint,
    max_concurr_number integer,
    second_ring_id bigint,
    second_after_ring_opt integer DEFAULT 0,
    after_ring_key character varying(40),
    after_key_opt_id integer,
    outside_line_number character varying(20)
);
 &   DROP TABLE public.call_group_callout;
       public         postgres    false    5            '           0    0 )   COLUMN call_group_callout.number_group_id    COMMENT     K   COMMENT ON COLUMN call_group_callout.number_group_id IS '呼叫号码组';
            public       postgres    false    193            (           0    0 )   COLUMN call_group_callout.after_ring_play    COMMENT     �   COMMENT ON COLUMN call_group_callout.after_ring_play IS '彩铃后的操作，和call_after_opt对应，主要是继续彩铃，挂机，转座席';
            public       postgres    false    193            )           0    0 &   COLUMN call_group_callout.ring_timeout    COMMENT     a   COMMENT ON COLUMN call_group_callout.ring_timeout IS '振铃时长,当到时未接听则挂机';
            public       postgres    false    193            *           0    0 "   COLUMN call_group_callout.group_id    COMMENT     G   COMMENT ON COLUMN call_group_callout.group_id IS '呼叫的座席组';
            public       postgres    false    193            +           0    0 )   COLUMN call_group_callout.concurr_type_id    COMMENT     }   COMMENT ON COLUMN call_group_callout.concurr_type_id IS '并发类型，0为按在线坐席数量的比例，1为指定值';
            public       postgres    false    193            ,           0    0 (   COLUMN call_group_callout.concurr_number    COMMENT     h   COMMENT ON COLUMN call_group_callout.concurr_number IS '并发倍数，按并发类型处理并发数';
            public       postgres    false    193            -           0    0 %   COLUMN call_group_callout.wait_number    COMMENT     D   COMMENT ON COLUMN call_group_callout.wait_number IS '等待数量';
            public       postgres    false    193            .           0    0 (   COLUMN call_group_callout.success_number    COMMENT     G   COMMENT ON COLUMN call_group_callout.success_number IS '接通数量';
            public       postgres    false    193            /           0    0 '   COLUMN call_group_callout.failed_number    COMMENT     L   COMMENT ON COLUMN call_group_callout.failed_number IS '接通失败数量';
            public       postgres    false    193            0           0    0 '   COLUMN call_group_callout.cancel_number    COMMENT     I   COMMENT ON COLUMN call_group_callout.cancel_number IS '取消的数量';
            public       postgres    false    193            1           0    0 -   COLUMN call_group_callout.has_parse_from_file    COMMENT     �   COMMENT ON COLUMN call_group_callout.has_parse_from_file IS '当上传了文件后，是否从文件中解析了内容插到数据表中，解析结束后置为true';
            public       postgres    false    193            2           0    0 ,   COLUMN call_group_callout.max_concurr_number    COMMENT     w   COMMENT ON COLUMN call_group_callout.max_concurr_number IS '最大并发数，前一个concurr_number为并发倍数';
            public       postgres    false    193            3           0    0 (   COLUMN call_group_callout.second_ring_id    COMMENT     e   COMMENT ON COLUMN call_group_callout.second_ring_id IS '由after_ring_play定为播放彩铃生效';
            public       postgres    false    193            4           0    0 /   COLUMN call_group_callout.second_after_ring_opt    COMMENT     z   COMMENT ON COLUMN call_group_callout.second_after_ring_opt IS '第二次再播放后的操作，和call_after_opt对应';
            public       postgres    false    193            5           0    0 (   COLUMN call_group_callout.after_ring_key    COMMENT     \   COMMENT ON COLUMN call_group_callout.after_ring_key IS '播放语音时按键中止播放';
            public       postgres    false    193            6           0    0 *   COLUMN call_group_callout.after_key_opt_id    COMMENT     i   COMMENT ON COLUMN call_group_callout.after_key_opt_id IS '按键后的操作，和call_after_opt对应';
            public       postgres    false    193            7           0    0 -   COLUMN call_group_callout.outside_line_number    COMMENT     �   COMMENT ON COLUMN call_group_callout.outside_line_number IS '外呼时，如手机上显示的来电号码，需运营商许可通过';
            public       postgres    false    193            �            1259    16535    call_group_callout_id_seq    SEQUENCE     {   CREATE SEQUENCE call_group_callout_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.call_group_callout_id_seq;
       public       postgres    false    193    5            8           0    0    call_group_callout_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE call_group_callout_id_seq OWNED BY call_group_callout.id;
            public       postgres    false    192            �            1259    16943    call_group_callout_state    TABLE     s   CREATE TABLE call_group_callout_state (
    id integer NOT NULL,
    state_name character varying(255) NOT NULL
);
 ,   DROP TABLE public.call_group_callout_state;
       public         postgres    false    5            �            1259    16385    call_group_id_seq    SEQUENCE     s   CREATE SEQUENCE call_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.call_group_id_seq;
       public       postgres    false    5    171            9           0    0    call_group_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE call_group_id_seq OWNED BY call_group.id;
            public       postgres    false    170            �            1259    16478    call_hangup_cause    TABLE     �   CREATE TABLE call_hangup_cause (
    id bigint NOT NULL,
    hangup_cause character varying(200),
    hangup_cause_desc text
);
 %   DROP TABLE public.call_hangup_cause;
       public         postgres    false    5            �            1259    18466    call_in_out_event    TABLE       CREATE TABLE call_in_out_event (
    id bigint NOT NULL,
    aleg_number character(50),
    bleg_number character(50),
    router_number character varying(50),
    event_id integer DEFAULT 1,
    event_time timestamp without time zone,
    is_read boolean,
    extension_id bigint
);
 %   DROP TABLE public.call_in_out_event;
       public         postgres    false    5            :           0    0 $   COLUMN call_in_out_event.aleg_number    COMMENT     C   COMMENT ON COLUMN call_in_out_event.aleg_number IS 'a leg number';
            public       postgres    false    239            ;           0    0 $   COLUMN call_in_out_event.bleg_number    COMMENT     B   COMMENT ON COLUMN call_in_out_event.bleg_number IS 'bleg number';
            public       postgres    false    239            <           0    0 &   COLUMN call_in_out_event.router_number    COMMENT     �   COMMENT ON COLUMN call_in_out_event.router_number IS '路由号码，如外线89999999经过8888888进来后，转给了内线8008,88888888就是路由号码';
            public       postgres    false    239            =           0    0 !   COLUMN call_in_out_event.event_id    COMMENT     <   COMMENT ON COLUMN call_in_out_event.event_id IS '事件id';
            public       postgres    false    239            >           0    0 #   COLUMN call_in_out_event.event_time    COMMENT     H   COMMENT ON COLUMN call_in_out_event.event_time IS '事件触发时间';
            public       postgres    false    239            ?           0    0     COLUMN call_in_out_event.is_read    COMMENT     �   COMMENT ON COLUMN call_in_out_event.is_read IS '是否已读取到客户端，当读取结束并有返回消息时，删除掉它';
            public       postgres    false    239            �            1259    18464    call_in_out_event_id_seq    SEQUENCE     z   CREATE SEQUENCE call_in_out_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.call_in_out_event_id_seq;
       public       postgres    false    239    5            @           0    0    call_in_out_event_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE call_in_out_event_id_seq OWNED BY call_in_out_event.id;
            public       postgres    false    238            �            1259    18473    call_in_out_event_type    TABLE     |   CREATE TABLE call_in_out_event_type (
    id integer NOT NULL,
    event_name character varying(50),
    event_desc text
);
 *   DROP TABLE public.call_in_out_event_type;
       public         postgres    false    5            A           0    0 (   COLUMN call_in_out_event_type.event_name    COMMENT     G   COMMENT ON COLUMN call_in_out_event_type.event_name IS '事件名称';
            public       postgres    false    240            �            1259    16511    call_ivr_menu_options    TABLE     J  CREATE TABLE call_ivr_menu_options (
    id bigint NOT NULL,
    ivr_menu_id bigint,
    ivr_menu_option_digits character varying(50),
    ivr_menu_option_param character varying(1000),
    ivr_menu_option_order integer,
    ivr_menu_option_description text,
    ivr_menu_option_action_id integer,
    ring_id bigint DEFAULT 0
);
 )   DROP TABLE public.call_ivr_menu_options;
       public         postgres    false    5            �            1259    16509    call_ivr_menu_options_id_seq    SEQUENCE     ~   CREATE SEQUENCE call_ivr_menu_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.call_ivr_menu_options_id_seq;
       public       postgres    false    5    188            B           0    0    call_ivr_menu_options_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE call_ivr_menu_options_id_seq OWNED BY call_ivr_menu_options.id;
            public       postgres    false    187            �            1259    16500    call_ivr_menus    TABLE     �  CREATE TABLE call_ivr_menus (
    id bigint NOT NULL,
    ivr_menu_name character varying(200),
    ivr_menu_extension text,
    ivr_menu_confirm_macro character varying(200),
    ivr_menu_confirm_key character varying(200),
    ivr_menu_confirm_attempts integer,
    ivr_menu_timeout integer,
    ivr_menu_exit_data text,
    ivr_menu_inter_digit_timeout integer,
    ivr_menu_max_failures integer,
    ivr_menu_max_timeouts integer,
    ivr_menu_digit_len integer,
    ivr_menu_direct_dial character varying(200),
    ivr_menu_cid_prefix character varying(200),
    ivr_menu_description text,
    ivr_menu_call_crycle_order integer,
    ivr_menu_enabled boolean,
    ivr_menu_call_order_id bigint,
    ivr_menu_greet_long_id bigint,
    ivr_menu_greet_short_id bigint,
    ivr_menu_invalid_sound_id bigint,
    ivr_menu_exit_sound_id bigint,
    ivr_menu_ringback_id bigint,
    ivr_menu_exit_app_id integer
);
 "   DROP TABLE public.call_ivr_menus;
       public         postgres    false    5            C           0    0 /   COLUMN call_ivr_menus.ivr_menu_confirm_attempts    COMMENT     N   COMMENT ON COLUMN call_ivr_menus.ivr_menu_confirm_attempts IS '尝试次数';
            public       postgres    false    186            D           0    0 &   COLUMN call_ivr_menus.ivr_menu_timeout    COMMENT     E   COMMENT ON COLUMN call_ivr_menus.ivr_menu_timeout IS '超时秒数';
            public       postgres    false    186            E           0    0 2   COLUMN call_ivr_menus.ivr_menu_inter_digit_timeout    COMMENT     f   COMMENT ON COLUMN call_ivr_menus.ivr_menu_inter_digit_timeout IS '中间不按键时的超时时间';
            public       postgres    false    186            F           0    0 +   COLUMN call_ivr_menus.ivr_menu_max_failures    COMMENT     V   COMMENT ON COLUMN call_ivr_menus.ivr_menu_max_failures IS '输错ivr的最大次数';
            public       postgres    false    186            G           0    0 +   COLUMN call_ivr_menus.ivr_menu_max_timeouts    COMMENT     S   COMMENT ON COLUMN call_ivr_menus.ivr_menu_max_timeouts IS 'ivr最大超时次数';
            public       postgres    false    186            H           0    0 (   COLUMN call_ivr_menus.ivr_menu_digit_len    COMMENT     S   COMMENT ON COLUMN call_ivr_menus.ivr_menu_digit_len IS '数字按键最大长度';
            public       postgres    false    186            I           0    0 *   COLUMN call_ivr_menus.ivr_menu_description    COMMENT     C   COMMENT ON COLUMN call_ivr_menus.ivr_menu_description IS '说明';
            public       postgres    false    186            J           0    0 0   COLUMN call_ivr_menus.ivr_menu_call_crycle_order    COMMENT     �   COMMENT ON COLUMN call_ivr_menus.ivr_menu_call_crycle_order IS '针对属于循环呼叫的，实时记录当前呼叫的子节点的order';
            public       postgres    false    186            �            1259    16498    call_ivr_menus_id_seq    SEQUENCE     w   CREATE SEQUENCE call_ivr_menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.call_ivr_menus_id_seq;
       public       postgres    false    186    5            K           0    0    call_ivr_menus_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE call_ivr_menus_id_seq OWNED BY call_ivr_menus.id;
            public       postgres    false    185            �            1259    17131    call_operation    TABLE     �   CREATE TABLE call_operation (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255)
);
 "   DROP TABLE public.call_operation;
       public         postgres    false    5            �            1259    17158    call_operation_id_seq    SEQUENCE     w   CREATE SEQUENCE call_operation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.call_operation_id_seq;
       public       postgres    false    5            �            1259    16544 
   call_order    TABLE     w   CREATE TABLE call_order (
    id bigint NOT NULL,
    order_name character varying(255),
    order_description text
);
    DROP TABLE public.call_order;
       public         postgres    false    5            L           0    0    TABLE call_order    COMMENT     2   COMMENT ON TABLE call_order IS '呼叫类型表';
            public       postgres    false    194            M           0    0 #   COLUMN call_order.order_description    COMMENT     H   COMMENT ON COLUMN call_order.order_description IS '呼叫类型说明';
            public       postgres    false    194            �            1259    16607    call_out_numbers    TABLE     �  CREATE TABLE call_out_numbers (
    id bigint NOT NULL,
    group_id bigint,
    number character varying(50),
    is_called integer DEFAULT 0,
    call_state integer DEFAULT 0,
    start_time timestamp without time zone,
    answer_time timestamp without time zone,
    hangup_time timestamp without time zone,
    hangup_reason_id bigint,
    answer_extension_id bigint,
    record_file character varying(255),
    wait_sec integer,
    cdr_id bigint
);
 $   DROP TABLE public.call_out_numbers;
       public         postgres    false    5            N           0    0 !   COLUMN call_out_numbers.is_called    COMMENT     F   COMMENT ON COLUMN call_out_numbers.is_called IS '是否呼叫过了';
            public       postgres    false    204            O           0    0 "   COLUMN call_out_numbers.call_state    COMMENT     A   COMMENT ON COLUMN call_out_numbers.call_state IS '呼叫状态';
            public       postgres    false    204            P           0    0 #   COLUMN call_out_numbers.record_file    COMMENT     B   COMMENT ON COLUMN call_out_numbers.record_file IS '录音文件';
            public       postgres    false    204            Q           0    0     COLUMN call_out_numbers.wait_sec    COMMENT     ?   COMMENT ON COLUMN call_out_numbers.wait_sec IS '等待时长';
            public       postgres    false    204            R           0    0    COLUMN call_out_numbers.cdr_id    COMMENT     N   COMMENT ON COLUMN call_out_numbers.cdr_id IS '记录这个呼叫的cdr的id';
            public       postgres    false    204            �            1259    16605    call_out_numbers_id_seq    SEQUENCE     y   CREATE SEQUENCE call_out_numbers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.call_out_numbers_id_seq;
       public       postgres    false    204    5            S           0    0    call_out_numbers_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE call_out_numbers_id_seq OWNED BY call_out_numbers.id;
            public       postgres    false    203            �            1259    16416    call_outside_config    TABLE     �  CREATE TABLE call_outside_config (
    id bigint NOT NULL,
    outside_line_name character varying(50),
    outside_line_number character varying(50),
    inside_line_number character varying(50) DEFAULT NULL::character varying,
    call_order_id bigint DEFAULT 0,
    call_crycle_order bigint DEFAULT 0,
    is_record boolean DEFAULT false,
    is_voice_mail boolean DEFAULT false
);
 '   DROP TABLE public.call_outside_config;
       public         postgres    false    5            T           0    0 ,   COLUMN call_outside_config.outside_line_name    COMMENT     K   COMMENT ON COLUMN call_outside_config.outside_line_name IS '外线名称';
            public       postgres    false    177            U           0    0 .   COLUMN call_outside_config.outside_line_number    COMMENT     M   COMMENT ON COLUMN call_outside_config.outside_line_number IS '外线号码';
            public       postgres    false    177            V           0    0 -   COLUMN call_outside_config.inside_line_number    COMMENT     L   COMMENT ON COLUMN call_outside_config.inside_line_number IS '内线号码';
            public       postgres    false    177            W           0    0 (   COLUMN call_outside_config.call_order_id    COMMENT     �   COMMENT ON COLUMN call_outside_config.call_order_id IS '呼叫顺序，外线可以直转内线号码，而不用配置多余的ivr';
            public       postgres    false    177            X           0    0 ,   COLUMN call_outside_config.call_crycle_order    COMMENT     c   COMMENT ON COLUMN call_outside_config.call_crycle_order IS '循环呼叫的当前呼叫到的值';
            public       postgres    false    177            �            1259    16414    call_outside_config_id_seq    SEQUENCE     |   CREATE SEQUENCE call_outside_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.call_outside_config_id_seq;
       public       postgres    false    177    5            Y           0    0    call_outside_config_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE call_outside_config_id_seq OWNED BY call_outside_config.id;
            public       postgres    false    176            �            1259    16520 
   call_rings    TABLE     �   CREATE TABLE call_rings (
    id bigint NOT NULL,
    ring_name character varying(200),
    ring_path character varying(255),
    ring_description text,
    ring_category bigint
);
    DROP TABLE public.call_rings;
       public         postgres    false    5            Z           0    0    COLUMN call_rings.ring_category    COMMENT     \   COMMENT ON COLUMN call_rings.ring_category IS '彩铃的类型，如ivr,voicemail,等等
';
            public       postgres    false    190            �            1259    16518    call_rings_id_seq    SEQUENCE     s   CREATE SEQUENCE call_rings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.call_rings_id_seq;
       public       postgres    false    190    5            [           0    0    call_rings_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE call_rings_id_seq OWNED BY call_rings.id;
            public       postgres    false    189            �            1259    16684    call_time_plan    TABLE       CREATE TABLE call_time_plan (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    plan_timing boolean DEFAULT false,
    plan_date date,
    per_hour boolean DEFAULT false,
    per_day boolean DEFAULT false,
    per_month boolean DEFAULT false,
    is_monday boolean DEFAULT false,
    is_tuesday boolean DEFAULT false,
    is_wednesday boolean DEFAULT false,
    is_thursday boolean DEFAULT false,
    is_friday boolean DEFAULT false,
    is_saturday boolean DEFAULT false,
    is_sunday boolean DEFAULT false
);
 "   DROP TABLE public.call_time_plan;
       public         postgres    false    5            \           0    0 !   COLUMN call_time_plan.plan_timing    COMMENT     @   COMMENT ON COLUMN call_time_plan.plan_timing IS '定时执行';
            public       postgres    false    207            �            1259    17162    call_time_plan_id_seq    SEQUENCE     w   CREATE SEQUENCE call_time_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.call_time_plan_id_seq;
       public       postgres    false    5            �            1259    16489    call_voicemail    TABLE     }  CREATE TABLE call_voicemail (
    id bigint NOT NULL,
    extension_id bigint NOT NULL,
    voicemail_password character varying(50),
    greeting_id bigint,
    voicemail_mail_to character varying(50),
    voicemail_attach_file character varying(255),
    voicemail_local_after_email character varying(255),
    voicemail_enabled character varying(50),
    voicemail_desc text
);
 "   DROP TABLE public.call_voicemail;
       public         postgres    false    5            �            1259    16487    call_voicemail_id_seq    SEQUENCE     w   CREATE SEQUENCE call_voicemail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.call_voicemail_id_seq;
       public       postgres    false    184    5            ]           0    0    call_voicemail_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE call_voicemail_id_seq OWNED BY call_voicemail.id;
            public       postgres    false    183            �            1259    17013    callout_gateways    TABLE     |   CREATE TABLE callout_gateways (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    gateway_id bigint
);
 $   DROP TABLE public.callout_gateways;
       public         postgres    false    5            �            1259    16768    django_admin_log    TABLE     �  CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    user_id integer NOT NULL,
    content_type_id integer,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);
 $   DROP TABLE public.django_admin_log;
       public         postgres    false    5            �            1259    16766    django_admin_log_id_seq    SEQUENCE     y   CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.django_admin_log_id_seq;
       public       postgres    false    5    209            ^           0    0    django_admin_log_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;
            public       postgres    false    208            �            1259    16875    django_content_type    TABLE     �   CREATE TABLE django_content_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);
 '   DROP TABLE public.django_content_type;
       public         postgres    false    5            �            1259    16873    django_content_type_id_seq    SEQUENCE     |   CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.django_content_type_id_seq;
       public       postgres    false    5    223            _           0    0    django_content_type_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;
            public       postgres    false    222            �            1259    16893    django_session    TABLE     �   CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);
 "   DROP TABLE public.django_session;
       public         postgres    false    5            �            1259    16587    in_out_mapping    TABLE     �   CREATE TABLE in_out_mapping (
    id bigint NOT NULL,
    outside_line_id bigint DEFAULT 0,
    inside_line_id bigint DEFAULT 0,
    order_number integer DEFAULT 0
);
 "   DROP TABLE public.in_out_mapping;
       public         postgres    false    5            `           0    0 "   COLUMN in_out_mapping.order_number    COMMENT     N   COMMENT ON COLUMN in_out_mapping.order_number IS '排序的序列从1开始';
            public       postgres    false    200            �            1259    16585    in_out_mapping_id_seq    SEQUENCE     w   CREATE SEQUENCE in_out_mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.in_out_mapping_id_seq;
       public       postgres    false    200    5            a           0    0    in_out_mapping_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE in_out_mapping_id_seq OWNED BY in_out_mapping.id;
            public       postgres    false    199            �            1259    16615    number_paragraph    TABLE     W   CREATE TABLE number_paragraph (
    number_paragraph character varying(50) NOT NULL
);
 $   DROP TABLE public.number_paragraph;
       public         postgres    false    5            �            1259    17222    test    TABLE     '   CREATE TABLE test (
    id smallint
);
    DROP TABLE public.test;
       public         postgres    false    5            �           2604    16808    id    DEFAULT     `   ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);
 <   ALTER TABLE public.auth_group ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    215    214    215            �           2604    16793    id    DEFAULT     x   ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);
 H   ALTER TABLE public.auth_group_permissions ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    213    212    213            �           2604    16783    id    DEFAULT     j   ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);
 A   ALTER TABLE public.auth_permission ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    211    210    211            �           2604    16853    id    DEFAULT     ^   ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);
 ;   ALTER TABLE public.auth_user ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    221    220    221            �           2604    16823    id    DEFAULT     l   ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);
 B   ALTER TABLE public.auth_user_groups ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    216    217    217            �           2604    16838    id    DEFAULT     �   ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);
 L   ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    219    218    219            �           2604    16472    id    DEFAULT     \   ALTER TABLE ONLY call_cdr ALTER COLUMN id SET DEFAULT nextval('call_cdr_id_seq'::regclass);
 :   ALTER TABLE public.call_cdr ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    181    180    181            �           2604    18457    id    DEFAULT     j   ALTER TABLE ONLY call_click_dial ALTER COLUMN id SET DEFAULT nextval('call_click_dial_id_seq'::regclass);
 A   ALTER TABLE public.call_click_dial ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    236    237    237            �           2604    16565    id    DEFAULT     v   ALTER TABLE ONLY call_dialplan_details ALTER COLUMN id SET DEFAULT nextval('call_dialplan_details_id_seq'::regclass);
 G   ALTER TABLE public.call_dialplan_details ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    198    197    198            �           2604    16555    id    DEFAULT     h   ALTER TABLE ONLY call_dialplans ALTER COLUMN id SET DEFAULT nextval('call_dialplans_id_seq'::regclass);
 @   ALTER TABLE public.call_dialplans ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    196    195    196            �           2604    16398    id    DEFAULT     h   ALTER TABLE ONLY call_extension ALTER COLUMN id SET DEFAULT nextval('call_extension_id_seq'::regclass);
 @   ALTER TABLE public.call_extension ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    172    173    173            �           2604    16599    id    DEFAULT     v   ALTER TABLE ONLY call_extension_groups ALTER COLUMN id SET DEFAULT nextval('call_extension_groups_id_seq'::regclass);
 G   ALTER TABLE public.call_extension_groups ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    201    202    202            �           2604    16406    id    DEFAULT     r   ALTER TABLE ONLY call_extension_type ALTER COLUMN id SET DEFAULT nextval('call_extension_type_id_seq'::regclass);
 E   ALTER TABLE public.call_extension_type ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    174    175    175            �           2604    16427    id    DEFAULT     d   ALTER TABLE ONLY call_gateway ALTER COLUMN id SET DEFAULT nextval('call_gateway_id_seq'::regclass);
 >   ALTER TABLE public.call_gateway ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    178    179    179            �           2604    16390    id    DEFAULT     `   ALTER TABLE ONLY call_group ALTER COLUMN id SET DEFAULT nextval('call_group_id_seq'::regclass);
 <   ALTER TABLE public.call_group ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    170    171    171            �           2604    16540    id    DEFAULT     p   ALTER TABLE ONLY call_group_callout ALTER COLUMN id SET DEFAULT nextval('call_group_callout_id_seq'::regclass);
 D   ALTER TABLE public.call_group_callout ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    193    192    193            �           2604    18469    id    DEFAULT     n   ALTER TABLE ONLY call_in_out_event ALTER COLUMN id SET DEFAULT nextval('call_in_out_event_id_seq'::regclass);
 C   ALTER TABLE public.call_in_out_event ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    238    239    239            �           2604    16514    id    DEFAULT     v   ALTER TABLE ONLY call_ivr_menu_options ALTER COLUMN id SET DEFAULT nextval('call_ivr_menu_options_id_seq'::regclass);
 G   ALTER TABLE public.call_ivr_menu_options ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    188    187    188            �           2604    16503    id    DEFAULT     h   ALTER TABLE ONLY call_ivr_menus ALTER COLUMN id SET DEFAULT nextval('call_ivr_menus_id_seq'::regclass);
 @   ALTER TABLE public.call_ivr_menus ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    185    186    186            �           2604    16610    id    DEFAULT     l   ALTER TABLE ONLY call_out_numbers ALTER COLUMN id SET DEFAULT nextval('call_out_numbers_id_seq'::regclass);
 B   ALTER TABLE public.call_out_numbers ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    204    203    204            �           2604    16419    id    DEFAULT     r   ALTER TABLE ONLY call_outside_config ALTER COLUMN id SET DEFAULT nextval('call_outside_config_id_seq'::regclass);
 E   ALTER TABLE public.call_outside_config ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    177    176    177            �           2604    16523    id    DEFAULT     `   ALTER TABLE ONLY call_rings ALTER COLUMN id SET DEFAULT nextval('call_rings_id_seq'::regclass);
 <   ALTER TABLE public.call_rings ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    189    190    190            �           2604    16492    id    DEFAULT     h   ALTER TABLE ONLY call_voicemail ALTER COLUMN id SET DEFAULT nextval('call_voicemail_id_seq'::regclass);
 @   ALTER TABLE public.call_voicemail ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    184    183    184            �           2604    16771    id    DEFAULT     l   ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);
 B   ALTER TABLE public.django_admin_log ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    209    208    209            �           2604    16878    id    DEFAULT     r   ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);
 E   ALTER TABLE public.django_content_type ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    222    223    223            �           2604    16590    id    DEFAULT     h   ALTER TABLE ONLY in_out_mapping ALTER COLUMN id SET DEFAULT nextval('in_out_mapping_id_seq'::regclass);
 @   ALTER TABLE public.in_out_mapping ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    199    200    200            �           2606    16477    PK_CALL_CDR_ID 
   CONSTRAINT     P   ALTER TABLE ONLY call_cdr
    ADD CONSTRAINT "PK_CALL_CDR_ID" PRIMARY KEY (id);
 C   ALTER TABLE ONLY public.call_cdr DROP CONSTRAINT "PK_CALL_CDR_ID";
       public         postgres    false    181    181            �           2606    16466    PK_CALL_GATEWAY_ID 
   CONSTRAINT     X   ALTER TABLE ONLY call_gateway
    ADD CONSTRAINT "PK_CALL_GATEWAY_ID" PRIMARY KEY (id);
 K   ALTER TABLE ONLY public.call_gateway DROP CONSTRAINT "PK_CALL_GATEWAY_ID";
       public         postgres    false    179    179            �           2606    16392    PK_CALL_GROUP_ID 
   CONSTRAINT     T   ALTER TABLE ONLY call_group
    ADD CONSTRAINT "PK_CALL_GROUP_ID" PRIMARY KEY (id);
 G   ALTER TABLE ONLY public.call_group DROP CONSTRAINT "PK_CALL_GROUP_ID";
       public         postgres    false    171    171            �           2606    16485    PK_CALL_HANGUP_CAUSE 
   CONSTRAINT     _   ALTER TABLE ONLY call_hangup_cause
    ADD CONSTRAINT "PK_CALL_HANGUP_CAUSE" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.call_hangup_cause DROP CONSTRAINT "PK_CALL_HANGUP_CAUSE";
       public         postgres    false    182    182            X           2606    18472    PK_CALL_IN_OUT_EVENT 
   CONSTRAINT     _   ALTER TABLE ONLY call_in_out_event
    ADD CONSTRAINT "PK_CALL_IN_OUT_EVENT" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.call_in_out_event DROP CONSTRAINT "PK_CALL_IN_OUT_EVENT";
       public         postgres    false    239    239            Z           2606    18490    PK_CALL_IN_OUT_EVENT_TYPE 
   CONSTRAINT     i   ALTER TABLE ONLY call_in_out_event_type
    ADD CONSTRAINT "PK_CALL_IN_OUT_EVENT_TYPE" PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.call_in_out_event_type DROP CONSTRAINT "PK_CALL_IN_OUT_EVENT_TYPE";
       public         postgres    false    240    240            �           2606    16508    PK_CALL_IVR_MENU_KEY 
   CONSTRAINT     \   ALTER TABLE ONLY call_ivr_menus
    ADD CONSTRAINT "PK_CALL_IVR_MENU_KEY" PRIMARY KEY (id);
 O   ALTER TABLE ONLY public.call_ivr_menus DROP CONSTRAINT "PK_CALL_IVR_MENU_KEY";
       public         postgres    false    186    186            �           2606    16528    PK_CALL_RING_ID 
   CONSTRAINT     S   ALTER TABLE ONLY call_rings
    ADD CONSTRAINT "PK_CALL_RING_ID" PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.call_rings DROP CONSTRAINT "PK_CALL_RING_ID";
       public         postgres    false    190    190            �           2606    16497    PK_CALL_VOICEMAIL_ID 
   CONSTRAINT     \   ALTER TABLE ONLY call_voicemail
    ADD CONSTRAINT "PK_CALL_VOICEMAIL_ID" PRIMARY KEY (id);
 O   ALTER TABLE ONLY public.call_voicemail DROP CONSTRAINT "PK_CALL_VOICEMAIL_ID";
       public         postgres    false    184    184            �           2606    16719    PK_EXTENSION_ID 
   CONSTRAINT     W   ALTER TABLE ONLY call_extension
    ADD CONSTRAINT "PK_EXTENSION_ID" PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.call_extension DROP CONSTRAINT "PK_EXTENSION_ID";
       public         postgres    false    173    173            �           2606    16408    PK_EXTENSION_TYPE_ID 
   CONSTRAINT     a   ALTER TABLE ONLY call_extension_type
    ADD CONSTRAINT "PK_EXTENSION_TYPE_ID" PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.call_extension_type DROP CONSTRAINT "PK_EXTENSION_TYPE_ID";
       public         postgres    false    175    175            �           2606    16421    PK_OUTSIDE_LINE_ID 
   CONSTRAINT     _   ALTER TABLE ONLY call_outside_config
    ADD CONSTRAINT "PK_OUTSIDE_LINE_ID" PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.call_outside_config DROP CONSTRAINT "PK_OUTSIDE_LINE_ID";
       public         postgres    false    177    177            -           2606    16812    auth_group_name_key 
   CONSTRAINT     R   ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);
 H   ALTER TABLE ONLY public.auth_group DROP CONSTRAINT auth_group_name_key;
       public         postgres    false    215    215            (           2606    16797 1   auth_group_permissions_group_id_permission_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);
 r   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_group_id_permission_id_key;
       public         postgres    false    213    213    213            +           2606    16795    auth_group_permissions_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_pkey;
       public         postgres    false    213    213            0           2606    16810    auth_group_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.auth_group DROP CONSTRAINT auth_group_pkey;
       public         postgres    false    215    215            #           2606    16787 ,   auth_permission_content_type_id_codename_key 
   CONSTRAINT     �   ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);
 f   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT auth_permission_content_type_id_codename_key;
       public         postgres    false    211    211    211            %           2606    16785    auth_permission_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT auth_permission_pkey;
       public         postgres    false    211    211            3           2606    16825    auth_user_groups_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_pkey;
       public         postgres    false    217    217            6           2606    16827 %   auth_user_groups_user_id_group_id_key 
   CONSTRAINT     w   ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);
 `   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_user_id_group_id_key;
       public         postgres    false    217    217    217            >           2606    16855    auth_user_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_pkey;
       public         postgres    false    221    221            9           2606    16840    auth_user_user_permissions_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_pkey;
       public         postgres    false    219    219            <           2606    16842 4   auth_user_user_permissions_user_id_permission_id_key 
   CONSTRAINT     �   ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_key UNIQUE (user_id, permission_id);
 y   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_user_id_permission_id_key;
       public         postgres    false    219    219    219            @           2606    16857    auth_user_username_key 
   CONSTRAINT     X   ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);
 J   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_username_key;
       public         postgres    false    221    221            Q           2606    17057    call_after_opt_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY call_after_opt
    ADD CONSTRAINT call_after_opt_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.call_after_opt DROP CONSTRAINT call_after_opt_pkey;
       public         postgres    false    228    228            M           2606    17012    call_base_config_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY call_base_config
    ADD CONSTRAINT call_base_config_pkey PRIMARY KEY (id, config_name);
 P   ALTER TABLE ONLY public.call_base_config DROP CONSTRAINT call_base_config_pkey;
       public         postgres    false    226    226    226            V           2606    18462    call_click_dial_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY call_click_dial
    ADD CONSTRAINT call_click_dial_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.call_click_dial DROP CONSTRAINT call_click_dial_pkey;
       public         postgres    false    237    237                       2606    16673    call_concurr_type_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY call_concurr_type
    ADD CONSTRAINT call_concurr_type_pkey PRIMARY KEY (id, concurr_type_name);
 R   ALTER TABLE ONLY public.call_concurr_type DROP CONSTRAINT call_concurr_type_pkey;
       public         postgres    false    206    206    206                       2606    16632    call_dialplan_details_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY call_dialplan_details
    ADD CONSTRAINT call_dialplan_details_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.call_dialplan_details DROP CONSTRAINT call_dialplan_details_pkey;
       public         postgres    false    198    198                       2606    16634    call_dialplans_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY call_dialplans
    ADD CONSTRAINT call_dialplans_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.call_dialplans DROP CONSTRAINT call_dialplans_pkey;
       public         postgres    false    196    196                       2606    16604    call_extension_groups_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY call_extension_groups
    ADD CONSTRAINT call_extension_groups_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.call_extension_groups DROP CONSTRAINT call_extension_groups_pkey;
       public         postgres    false    202    202                       2606    16636    call_functions_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY call_functions
    ADD CONSTRAINT call_functions_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.call_functions DROP CONSTRAINT call_functions_pkey;
       public         postgres    false    191    191                       2606    16638    call_group_callout_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY call_group_callout
    ADD CONSTRAINT call_group_callout_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.call_group_callout DROP CONSTRAINT call_group_callout_pkey;
       public         postgres    false    193    193            K           2606    16947    call_group_callout_state_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY call_group_callout_state
    ADD CONSTRAINT call_group_callout_state_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.call_group_callout_state DROP CONSTRAINT call_group_callout_state_pkey;
       public         postgres    false    225    225            �           2606    16640    call_ivr_menu_options_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY call_ivr_menu_options
    ADD CONSTRAINT call_ivr_menu_options_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.call_ivr_menu_options DROP CONSTRAINT call_ivr_menu_options_pkey;
       public         postgres    false    188    188            S           2606    17138    call_operation_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY call_operation
    ADD CONSTRAINT call_operation_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.call_operation DROP CONSTRAINT call_operation_pkey;
       public         postgres    false    229    229                       2606    16642    call_order_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY call_order
    ADD CONSTRAINT call_order_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.call_order DROP CONSTRAINT call_order_pkey;
       public         postgres    false    194    194                       2606    16614    call_out_numbers_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY call_out_numbers
    ADD CONSTRAINT call_out_numbers_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.call_out_numbers DROP CONSTRAINT call_out_numbers_pkey;
       public         postgres    false    204    204                       2606    16692    call_time_plan_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY call_time_plan
    ADD CONSTRAINT call_time_plan_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.call_time_plan DROP CONSTRAINT call_time_plan_pkey;
       public         postgres    false    207    207            O           2606    17017    callout_gateways_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY callout_gateways
    ADD CONSTRAINT callout_gateways_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.callout_gateways DROP CONSTRAINT callout_gateways_pkey;
       public         postgres    false    227    227                       2606    16777    django_admin_log_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT django_admin_log_pkey;
       public         postgres    false    209    209            C           2606    16882 '   django_content_type_app_label_model_key 
   CONSTRAINT     {   ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_key UNIQUE (app_label, model);
 e   ALTER TABLE ONLY public.django_content_type DROP CONSTRAINT django_content_type_app_label_model_key;
       public         postgres    false    223    223    223            E           2606    16880    django_content_type_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.django_content_type DROP CONSTRAINT django_content_type_pkey;
       public         postgres    false    223    223            H           2606    16900    django_session_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);
 L   ALTER TABLE ONLY public.django_session DROP CONSTRAINT django_session_pkey;
       public         postgres    false    224    224                       2606    16593    in_out_mapping_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY in_out_mapping
    ADD CONSTRAINT in_out_mapping_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.in_out_mapping DROP CONSTRAINT in_out_mapping_pkey;
       public         postgres    false    200    200                       2606    16619    number_paragraph_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY number_paragraph
    ADD CONSTRAINT number_paragraph_pkey PRIMARY KEY (number_paragraph);
 P   ALTER TABLE ONLY public.number_paragraph DROP CONSTRAINT number_paragraph_pkey;
       public         postgres    false    205    205            	           1259    16653    IDX_CALL_DIALPLAN_DETAILS_MAIN    INDEX     f   CREATE INDEX "IDX_CALL_DIALPLAN_DETAILS_MAIN" ON call_dialplan_details USING btree (id, dialplan_id);
 4   DROP INDEX public."IDX_CALL_DIALPLAN_DETAILS_MAIN";
       public         postgres    false    198    198                       1259    16665    IDX_CALL_EXTENSION_GROUPS_MAIN    INDEX     e   CREATE INDEX "IDX_CALL_EXTENSION_GROUPS_MAIN" ON call_extension_groups USING btree (id, group_name);
 4   DROP INDEX public."IDX_CALL_EXTENSION_GROUPS_MAIN";
       public         postgres    false    202    202                       1259    16666    IDX_CALL_GROUP_CALLOUT_MAIN    INDEX     �   CREATE INDEX "IDX_CALL_GROUP_CALLOUT_MAIN" ON call_group_callout USING btree (id, callout_name, number_group_id, start_time, stop_time, ring_id, group_id, concurr_type_id, concurr_number);
 1   DROP INDEX public."IDX_CALL_GROUP_CALLOUT_MAIN";
       public         postgres    false    193    193    193    193    193    193    193    193    193            �           1259    16706    IDX_CALL_IVR_MENU_OPTIONS_MAIN    INDEX     f   CREATE INDEX "IDX_CALL_IVR_MENU_OPTIONS_MAIN" ON call_ivr_menu_options USING btree (id, ivr_menu_id);
 4   DROP INDEX public."IDX_CALL_IVR_MENU_OPTIONS_MAIN";
       public         postgres    false    188    188            �           1259    16725    IDX_CALL_OUTSIDE_CONFIG_MAIN    INDEX     �   CREATE INDEX "IDX_CALL_OUTSIDE_CONFIG_MAIN" ON call_outside_config USING btree (id, outside_line_name, outside_line_number, inside_line_number);
 2   DROP INDEX public."IDX_CALL_OUTSIDE_CONFIG_MAIN";
       public         postgres    false    177    177    177    177                       1259    16712    IDX_CALL_OUT_NUMBERS_MAIN    INDEX     �   CREATE INDEX "IDX_CALL_OUT_NUMBERS_MAIN" ON call_out_numbers USING btree (id, group_id, number, is_called, call_state, start_time, answer_time, hangup_time, hangup_reason_id);
 /   DROP INDEX public."IDX_CALL_OUT_NUMBERS_MAIN";
       public         postgres    false    204    204    204    204    204    204    204    204    204            �           1259    16731    IDX_CALL_RINGS_MAIN    INDEX     Y   CREATE INDEX "IDX_CALL_RINGS_MAIN" ON call_rings USING btree (id, ring_name, ring_path);
 )   DROP INDEX public."IDX_CALL_RINGS_MAIN";
       public         postgres    false    190    190    190                       1259    16736    IDX_CALL_TIME_PLAN_MAIN    INDEX     �   CREATE INDEX "IDX_CALL_TIME_PLAN_MAIN" ON call_time_plan USING btree (id, name, plan_timing, plan_date, per_hour, per_day, per_month, is_monday, is_tuesday, is_wednesday, is_thursday, is_friday, is_saturday);
 -   DROP INDEX public."IDX_CALL_TIME_PLAN_MAIN";
       public         postgres    false    207    207    207    207    207    207    207    207    207    207    207    207    207            �           1259    16745    IDX_CALL_VOICEMAIL_MAIN    INDEX     �   CREATE INDEX "IDX_CALL_VOICEMAIL_MAIN" ON call_voicemail USING btree (id, extension_id, voicemail_attach_file, voicemail_local_after_email, voicemail_enabled);
 -   DROP INDEX public."IDX_CALL_VOICEMAIL_MAIN";
       public         postgres    false    184    184    184    184    184            �           1259    16630    IDX_CDR_MAIN    INDEX     �   CREATE INDEX "IDX_CDR_MAIN" ON call_cdr USING btree (id, caller_id_name, caller_id_number, destination_number, start_stamp, a_answer_stamp, a_end_stamp, hangup_cause_id, call_gateway_id);
 "   DROP INDEX public."IDX_CDR_MAIN";
       public         postgres    false    181    181    181    181    181    181    181    181    181            T           1259    18463    IDX_CLICK_DIAL    INDEX     �   CREATE INDEX "IDX_CLICK_DIAL" ON call_click_dial USING btree (id, caller_number, is_agent, is_immediately, account_number, is_called, trans_number);
 $   DROP INDEX public."IDX_CLICK_DIAL";
       public         postgres    false    237    237    237    237    237    237    237                       1259    16753    IDX_IN_OUT_MAPPING_MAIN    INDEX     z   CREATE INDEX "IDX_IN_OUT_MAPPING_MAIN" ON in_out_mapping USING btree (id, outside_line_id, inside_line_id, order_number);
 -   DROP INDEX public."IDX_IN_OUT_MAPPING_MAIN";
       public         postgres    false    200    200    200    200                       1259    16765    IDX_NUMBER_PARAGRAPH_MAIN    INDEX     ]   CREATE INDEX "IDX_NUMBER_PARAGRAPH_MAIN" ON number_paragraph USING btree (number_paragraph);
 /   DROP INDEX public."IDX_NUMBER_PARAGRAPH_MAIN";
       public         postgres    false    205            .           1259    16907    auth_group_name_like    INDEX     X   CREATE INDEX auth_group_name_like ON auth_group USING btree (name varchar_pattern_ops);
 (   DROP INDEX public.auth_group_name_like;
       public         postgres    false    215            &           1259    16905    auth_group_permissions_group_id    INDEX     _   CREATE INDEX auth_group_permissions_group_id ON auth_group_permissions USING btree (group_id);
 3   DROP INDEX public.auth_group_permissions_group_id;
       public         postgres    false    213            )           1259    16906 $   auth_group_permissions_permission_id    INDEX     i   CREATE INDEX auth_group_permissions_permission_id ON auth_group_permissions USING btree (permission_id);
 8   DROP INDEX public.auth_group_permissions_permission_id;
       public         postgres    false    213            !           1259    16904    auth_permission_content_type_id    INDEX     _   CREATE INDEX auth_permission_content_type_id ON auth_permission USING btree (content_type_id);
 3   DROP INDEX public.auth_permission_content_type_id;
       public         postgres    false    211            1           1259    16909    auth_user_groups_group_id    INDEX     S   CREATE INDEX auth_user_groups_group_id ON auth_user_groups USING btree (group_id);
 -   DROP INDEX public.auth_user_groups_group_id;
       public         postgres    false    217            4           1259    16908    auth_user_groups_user_id    INDEX     Q   CREATE INDEX auth_user_groups_user_id ON auth_user_groups USING btree (user_id);
 ,   DROP INDEX public.auth_user_groups_user_id;
       public         postgres    false    217            7           1259    16911 (   auth_user_user_permissions_permission_id    INDEX     q   CREATE INDEX auth_user_user_permissions_permission_id ON auth_user_user_permissions USING btree (permission_id);
 <   DROP INDEX public.auth_user_user_permissions_permission_id;
       public         postgres    false    219            :           1259    16910 "   auth_user_user_permissions_user_id    INDEX     e   CREATE INDEX auth_user_user_permissions_user_id ON auth_user_user_permissions USING btree (user_id);
 6   DROP INDEX public.auth_user_user_permissions_user_id;
       public         postgres    false    219            A           1259    16912    auth_user_username_like    INDEX     ^   CREATE INDEX auth_user_username_like ON auth_user USING btree (username varchar_pattern_ops);
 +   DROP INDEX public.auth_user_username_like;
       public         postgres    false    221                       1259    16903     django_admin_log_content_type_id    INDEX     a   CREATE INDEX django_admin_log_content_type_id ON django_admin_log USING btree (content_type_id);
 4   DROP INDEX public.django_admin_log_content_type_id;
       public         postgres    false    209                        1259    16902    django_admin_log_user_id    INDEX     Q   CREATE INDEX django_admin_log_user_id ON django_admin_log USING btree (user_id);
 ,   DROP INDEX public.django_admin_log_user_id;
       public         postgres    false    209            F           1259    16914    django_session_expire_date    INDEX     U   CREATE INDEX django_session_expire_date ON django_session USING btree (expire_date);
 .   DROP INDEX public.django_session_expire_date;
       public         postgres    false    224            I           1259    16913    django_session_session_key_like    INDEX     n   CREATE INDEX django_session_session_key_like ON django_session USING btree (session_key varchar_pattern_ops);
 3   DROP INDEX public.django_session_session_key_like;
       public         postgres    false    224            u           2606    17126    FK_CALLOUT_AFTER_KEY_OPT    FK CONSTRAINT     �   ALTER TABLE ONLY call_group_callout
    ADD CONSTRAINT "FK_CALLOUT_AFTER_KEY_OPT" FOREIGN KEY (after_key_opt_id) REFERENCES call_after_opt(id);
 W   ALTER TABLE ONLY public.call_group_callout DROP CONSTRAINT "FK_CALLOUT_AFTER_KEY_OPT";
       public       postgres    false    193    228    3153            �           2606    17018    FK_CALLOUT_GATEWAY_GATEWAY_ID    FK CONSTRAINT     �   ALTER TABLE ONLY callout_gateways
    ADD CONSTRAINT "FK_CALLOUT_GATEWAY_GATEWAY_ID" FOREIGN KEY (gateway_id) REFERENCES call_gateway(id);
 Z   ALTER TABLE ONLY public.callout_gateways DROP CONSTRAINT "FK_CALLOUT_GATEWAY_GATEWAY_ID";
       public       postgres    false    179    227    3055            s           2606    17116    FK_CALLOUT_SECOND_RING_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_group_callout
    ADD CONSTRAINT "FK_CALLOUT_SECOND_RING_ID" FOREIGN KEY (second_ring_id) REFERENCES call_rings(id);
 X   ALTER TABLE ONLY public.call_group_callout DROP CONSTRAINT "FK_CALLOUT_SECOND_RING_ID";
       public       postgres    false    3071    193    190            t           2606    17121    FK_CALLOUT_SECOND_RING_PLAY_OPT    FK CONSTRAINT     �   ALTER TABLE ONLY call_group_callout
    ADD CONSTRAINT "FK_CALLOUT_SECOND_RING_PLAY_OPT" FOREIGN KEY (second_after_ring_opt) REFERENCES call_after_opt(id);
 ^   ALTER TABLE ONLY public.call_group_callout DROP CONSTRAINT "FK_CALLOUT_SECOND_RING_PLAY_OPT";
       public       postgres    false    228    3153    193            r           2606    17058    FK_CALL_CALLOUT_AFTER_OPT_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_group_callout
    ADD CONSTRAINT "FK_CALL_CALLOUT_AFTER_OPT_ID" FOREIGN KEY (after_ring_play) REFERENCES call_after_opt(id);
 [   ALTER TABLE ONLY public.call_group_callout DROP CONSTRAINT "FK_CALL_CALLOUT_AFTER_OPT_ID";
       public       postgres    false    193    228    3153            q           2606    17023    FK_CALL_CALLOUT_GATEWAY_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_group_callout
    ADD CONSTRAINT "FK_CALL_CALLOUT_GATEWAY_ID" FOREIGN KEY (callout_gateway_id) REFERENCES callout_gateways(id);
 Y   ALTER TABLE ONLY public.call_group_callout DROP CONSTRAINT "FK_CALL_CALLOUT_GATEWAY_ID";
       public       postgres    false    227    193    3151            `           2606    16625    FK_CALL_CDR_GATEWAY_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_cdr
    ADD CONSTRAINT "FK_CALL_CDR_GATEWAY_ID" FOREIGN KEY (call_gateway_id) REFERENCES call_gateway(id);
 K   ALTER TABLE ONLY public.call_cdr DROP CONSTRAINT "FK_CALL_CDR_GATEWAY_ID";
       public       postgres    false    181    179    3055            _           2606    16620    FK_CALL_CDR_HANGUP_CAUSE_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_cdr
    ADD CONSTRAINT "FK_CALL_CDR_HANGUP_CAUSE_ID" FOREIGN KEY (hangup_cause_id) REFERENCES call_hangup_cause(id);
 P   ALTER TABLE ONLY public.call_cdr DROP CONSTRAINT "FK_CALL_CDR_HANGUP_CAUSE_ID";
       public       postgres    false    181    3060    182            m           2606    16679    FK_CALL_GROUP_CALLOUT_GROUP_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_group_callout
    ADD CONSTRAINT "FK_CALL_GROUP_CALLOUT_GROUP_ID" FOREIGN KEY (number_group_id) REFERENCES call_group(id);
 ]   ALTER TABLE ONLY public.call_group_callout DROP CONSTRAINT "FK_CALL_GROUP_CALLOUT_GROUP_ID";
       public       postgres    false    193    171    3046            o           2606    16938     FK_CALL_GROUP_CALLOUT_GROUP_ID_E    FK CONSTRAINT     �   ALTER TABLE ONLY call_group_callout
    ADD CONSTRAINT "FK_CALL_GROUP_CALLOUT_GROUP_ID_E" FOREIGN KEY (group_id) REFERENCES call_extension_groups(id);
 _   ALTER TABLE ONLY public.call_group_callout DROP CONSTRAINT "FK_CALL_GROUP_CALLOUT_GROUP_ID_E";
       public       postgres    false    3089    202    193            l           2606    16674    FK_CALL_GROUP_CALLOUT_RING_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_group_callout
    ADD CONSTRAINT "FK_CALL_GROUP_CALLOUT_RING_ID" FOREIGN KEY (ring_id) REFERENCES call_rings(id);
 \   ALTER TABLE ONLY public.call_group_callout DROP CONSTRAINT "FK_CALL_GROUP_CALLOUT_RING_ID";
       public       postgres    false    3071    190    193            p           2606    16952    FK_CALL_GROUP_CALLOUT_STATE_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_group_callout
    ADD CONSTRAINT "FK_CALL_GROUP_CALLOUT_STATE_ID" FOREIGN KEY (callout_state_id) REFERENCES call_group_callout_state(id);
 ]   ALTER TABLE ONLY public.call_group_callout DROP CONSTRAINT "FK_CALL_GROUP_CALLOUT_STATE_ID";
       public       postgres    false    193    3147    225            n           2606    16693    FK_CALL_GROUP_CALLOUT_TIME_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_group_callout
    ADD CONSTRAINT "FK_CALL_GROUP_CALLOUT_TIME_ID" FOREIGN KEY (time_rule_id) REFERENCES call_time_plan(id);
 \   ALTER TABLE ONLY public.call_group_callout DROP CONSTRAINT "FK_CALL_GROUP_CALLOUT_TIME_ID";
       public       postgres    false    193    3100    207            �           2606    18484    FK_CALL_IN_OUT_EVENT_EXT_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_in_out_event
    ADD CONSTRAINT "FK_CALL_IN_OUT_EVENT_EXT_ID" FOREIGN KEY (extension_id) REFERENCES call_extension(id);
 Y   ALTER TABLE ONLY public.call_in_out_event DROP CONSTRAINT "FK_CALL_IN_OUT_EVENT_EXT_ID";
       public       postgres    false    239    3048    173            �           2606    18491    FK_CALL_IN_OUT_EVENT_TYPE    FK CONSTRAINT     �   ALTER TABLE ONLY call_in_out_event
    ADD CONSTRAINT "FK_CALL_IN_OUT_EVENT_TYPE" FOREIGN KEY (event_id) REFERENCES call_in_out_event_type(id);
 W   ALTER TABLE ONLY public.call_in_out_event DROP CONSTRAINT "FK_CALL_IN_OUT_EVENT_TYPE";
       public       postgres    false    239    240    3162            f           2606    17043    FK_CALL_IVR_MENUS_EXIT_RING_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_ivr_menus
    ADD CONSTRAINT "FK_CALL_IVR_MENUS_EXIT_RING_ID" FOREIGN KEY (ivr_menu_exit_sound_id) REFERENCES call_rings(id);
 Y   ALTER TABLE ONLY public.call_ivr_menus DROP CONSTRAINT "FK_CALL_IVR_MENUS_EXIT_RING_ID";
       public       postgres    false    186    3071    190            e           2606    17038 !   FK_CALL_IVR_MENUS_INVALID_RING_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_ivr_menus
    ADD CONSTRAINT "FK_CALL_IVR_MENUS_INVALID_RING_ID" FOREIGN KEY (ivr_menu_invalid_sound_id) REFERENCES call_rings(id);
 \   ALTER TABLE ONLY public.call_ivr_menus DROP CONSTRAINT "FK_CALL_IVR_MENUS_INVALID_RING_ID";
       public       postgres    false    3071    186    190            c           2606    17028    FK_CALL_IVR_MENUS_LONG_RING_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_ivr_menus
    ADD CONSTRAINT "FK_CALL_IVR_MENUS_LONG_RING_ID" FOREIGN KEY (ivr_menu_greet_long_id) REFERENCES call_rings(id);
 Y   ALTER TABLE ONLY public.call_ivr_menus DROP CONSTRAINT "FK_CALL_IVR_MENUS_LONG_RING_ID";
       public       postgres    false    186    190    3071            h           2606    17149    FK_CALL_IVR_MENUS_OPERATION_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_ivr_menus
    ADD CONSTRAINT "FK_CALL_IVR_MENUS_OPERATION_ID" FOREIGN KEY (ivr_menu_exit_app_id) REFERENCES call_operation(id);
 Y   ALTER TABLE ONLY public.call_ivr_menus DROP CONSTRAINT "FK_CALL_IVR_MENUS_OPERATION_ID";
       public       postgres    false    186    3155    229            b           2606    16966    FK_CALL_IVR_MENUS_ORDER_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_ivr_menus
    ADD CONSTRAINT "FK_CALL_IVR_MENUS_ORDER_ID" FOREIGN KEY (ivr_menu_call_order_id) REFERENCES call_order(id);
 U   ALTER TABLE ONLY public.call_ivr_menus DROP CONSTRAINT "FK_CALL_IVR_MENUS_ORDER_ID";
       public       postgres    false    3078    194    186            g           2606    17048 "   FK_CALL_IVR_MENUS_RINGBACK_RING_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_ivr_menus
    ADD CONSTRAINT "FK_CALL_IVR_MENUS_RINGBACK_RING_ID" FOREIGN KEY (ivr_menu_ringback_id) REFERENCES call_rings(id);
 ]   ALTER TABLE ONLY public.call_ivr_menus DROP CONSTRAINT "FK_CALL_IVR_MENUS_RINGBACK_RING_ID";
       public       postgres    false    190    3071    186            d           2606    17033    FK_CALL_IVR_MENUS_SHORT_RING_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_ivr_menus
    ADD CONSTRAINT "FK_CALL_IVR_MENUS_SHORT_RING_ID" FOREIGN KEY (ivr_menu_greet_short_id) REFERENCES call_rings(id);
 Z   ALTER TABLE ONLY public.call_ivr_menus DROP CONSTRAINT "FK_CALL_IVR_MENUS_SHORT_RING_ID";
       public       postgres    false    186    190    3071            }           2606    16720     FK_CALL_OUT_NUMBERS_EXTENSION_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_out_numbers
    ADD CONSTRAINT "FK_CALL_OUT_NUMBERS_EXTENSION_ID" FOREIGN KEY (answer_extension_id) REFERENCES call_extension(id);
 ]   ALTER TABLE ONLY public.call_out_numbers DROP CONSTRAINT "FK_CALL_OUT_NUMBERS_EXTENSION_ID";
       public       postgres    false    3048    204    173            |           2606    16713    FK_CALL_OUT_NUMBERS_GROUP_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_out_numbers
    ADD CONSTRAINT "FK_CALL_OUT_NUMBERS_GROUP_ID" FOREIGN KEY (group_id) REFERENCES call_group(id);
 Y   ALTER TABLE ONLY public.call_out_numbers DROP CONSTRAINT "FK_CALL_OUT_NUMBERS_GROUP_ID";
       public       postgres    false    171    204    3046            ~           2606    16933 #   FK_CALL_OUT_NUMBERS_HANGUP_RESON_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_out_numbers
    ADD CONSTRAINT "FK_CALL_OUT_NUMBERS_HANGUP_RESON_ID" FOREIGN KEY (hangup_reason_id) REFERENCES call_hangup_cause(id);
 `   ALTER TABLE ONLY public.call_out_numbers DROP CONSTRAINT "FK_CALL_OUT_NUMBERS_HANGUP_RESON_ID";
       public       postgres    false    204    3060    182            a           2606    16746    FK_CALL_VOICEMAIL_EXTENSION_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_voicemail
    ADD CONSTRAINT "FK_CALL_VOICEMAIL_EXTENSION_ID" FOREIGN KEY (extension_id) REFERENCES call_extension(id);
 Y   ALTER TABLE ONLY public.call_voicemail DROP CONSTRAINT "FK_CALL_VOICEMAIL_EXTENSION_ID";
       public       postgres    false    3048    173    184            v           2606    16648    FK_DIALPLAN_DETAILS_DIALPLAN_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_dialplan_details
    ADD CONSTRAINT "FK_DIALPLAN_DETAILS_DIALPLAN_ID" FOREIGN KEY (dialplan_id) REFERENCES call_dialplans(id);
 a   ALTER TABLE ONLY public.call_dialplan_details DROP CONSTRAINT "FK_DIALPLAN_DETAILS_DIALPLAN_ID";
       public       postgres    false    196    3080    198            w           2606    16654    FK_DIALPLAN_DETAILS_GROUP_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_dialplan_details
    ADD CONSTRAINT "FK_DIALPLAN_DETAILS_GROUP_ID" FOREIGN KEY (dialplan_detail_group_id) REFERENCES call_extension_groups(id);
 ^   ALTER TABLE ONLY public.call_dialplan_details DROP CONSTRAINT "FK_DIALPLAN_DETAILS_GROUP_ID";
       public       postgres    false    202    198    3089            x           2606    17139     FK_DIALPLAN_DETAILS_OPERATION_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_dialplan_details
    ADD CONSTRAINT "FK_DIALPLAN_DETAILS_OPERATION_ID" FOREIGN KEY (dialplan_detail_type_id) REFERENCES call_operation(id);
 b   ALTER TABLE ONLY public.call_dialplan_details DROP CONSTRAINT "FK_DIALPLAN_DETAILS_OPERATION_ID";
       public       postgres    false    198    229    3155            y           2606    17203    FK_DIALPLAN_DETAILS_RING_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_dialplan_details
    ADD CONSTRAINT "FK_DIALPLAN_DETAILS_RING_ID" FOREIGN KEY (ring_id) REFERENCES call_rings(id);
 ]   ALTER TABLE ONLY public.call_dialplan_details DROP CONSTRAINT "FK_DIALPLAN_DETAILS_RING_ID";
       public       postgres    false    3071    190    198            ]           2606    16915    FK_EXTENSION_GATEWAY_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_extension
    ADD CONSTRAINT "FK_EXTENSION_GATEWAY_ID" FOREIGN KEY (callout_gateway) REFERENCES call_gateway(id);
 R   ALTER TABLE ONLY public.call_extension DROP CONSTRAINT "FK_EXTENSION_GATEWAY_ID";
       public       postgres    false    3055    179    173            \           2606    16460    FK_EXTENSION_GROUP_ID    FK CONSTRAINT     }   ALTER TABLE ONLY call_extension
    ADD CONSTRAINT "FK_EXTENSION_GROUP_ID" FOREIGN KEY (group_id) REFERENCES call_group(id);
 P   ALTER TABLE ONLY public.call_extension DROP CONSTRAINT "FK_EXTENSION_GROUP_ID";
       public       postgres    false    173    171    3046            [           2606    16409    FK_EXTENSION_TYPE_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_extension
    ADD CONSTRAINT "FK_EXTENSION_TYPE_ID" FOREIGN KEY (extension_type) REFERENCES call_extension_type(id);
 O   ALTER TABLE ONLY public.call_extension DROP CONSTRAINT "FK_EXTENSION_TYPE_ID";
       public       postgres    false    173    175    3050            z           2606    16754    FK_IN_OUT_MAPPING_IN_LINE_ID    FK CONSTRAINT     �   ALTER TABLE ONLY in_out_mapping
    ADD CONSTRAINT "FK_IN_OUT_MAPPING_IN_LINE_ID" FOREIGN KEY (inside_line_id) REFERENCES call_extension(id);
 W   ALTER TABLE ONLY public.in_out_mapping DROP CONSTRAINT "FK_IN_OUT_MAPPING_IN_LINE_ID";
       public       postgres    false    173    3048    200            {           2606    16759    FK_IN_OUT_MAPPING_OUT_LINE_ID    FK CONSTRAINT     �   ALTER TABLE ONLY in_out_mapping
    ADD CONSTRAINT "FK_IN_OUT_MAPPING_OUT_LINE_ID" FOREIGN KEY (outside_line_id) REFERENCES call_outside_config(id);
 X   ALTER TABLE ONLY public.in_out_mapping DROP CONSTRAINT "FK_IN_OUT_MAPPING_OUT_LINE_ID";
       public       postgres    false    200    177    3053            i           2606    16707    FK_IVR_MENU_OPTIONS_MENU_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_ivr_menu_options
    ADD CONSTRAINT "FK_IVR_MENU_OPTIONS_MENU_ID" FOREIGN KEY (ivr_menu_id) REFERENCES call_ivr_menus(id);
 ]   ALTER TABLE ONLY public.call_ivr_menu_options DROP CONSTRAINT "FK_IVR_MENU_OPTIONS_MENU_ID";
       public       postgres    false    3065    188    186            j           2606    17144     FK_IVR_MENU_OPTIONS_OPERATION_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_ivr_menu_options
    ADD CONSTRAINT "FK_IVR_MENU_OPTIONS_OPERATION_ID" FOREIGN KEY (ivr_menu_option_action_id) REFERENCES call_operation(id);
 b   ALTER TABLE ONLY public.call_ivr_menu_options DROP CONSTRAINT "FK_IVR_MENU_OPTIONS_OPERATION_ID";
       public       postgres    false    3155    188    229            k           2606    17217    FK_IVR_MENU_OPTIONS_RING_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_ivr_menu_options
    ADD CONSTRAINT "FK_IVR_MENU_OPTIONS_RING_ID" FOREIGN KEY (ring_id) REFERENCES call_rings(id);
 ]   ALTER TABLE ONLY public.call_ivr_menu_options DROP CONSTRAINT "FK_IVR_MENU_OPTIONS_RING_ID";
       public       postgres    false    3071    190    188            ^           2606    16726    FK_OUTSIDE_CONFIG_ORDER_ID    FK CONSTRAINT     �   ALTER TABLE ONLY call_outside_config
    ADD CONSTRAINT "FK_OUTSIDE_CONFIG_ORDER_ID" FOREIGN KEY (call_order_id) REFERENCES call_order(id);
 Z   ALTER TABLE ONLY public.call_outside_config DROP CONSTRAINT "FK_OUTSIDE_CONFIG_ORDER_ID";
       public       postgres    false    194    3078    177            �           2606    16798 )   auth_group_permissions_permission_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;
 j   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_permission_id_fkey;
       public       postgres    false    213    3109    211            �           2606    16828    auth_user_groups_group_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;
 Y   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_group_id_fkey;
       public       postgres    false    3120    215    217            �           2606    16843 -   auth_user_user_permissions_permission_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;
 r   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_permission_id_fkey;
       public       postgres    false    211    3109    219            �           2606    16883     content_type_id_refs_id_93d2d1f8    FK CONSTRAINT     �   ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT content_type_id_refs_id_93d2d1f8 FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;
 [   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT content_type_id_refs_id_93d2d1f8;
       public       postgres    false    223    3141    209            �           2606    16888     content_type_id_refs_id_d043b34a    FK CONSTRAINT     �   ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT content_type_id_refs_id_d043b34a FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;
 Z   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT content_type_id_refs_id_d043b34a;
       public       postgres    false    211    3141    223            �           2606    16813    group_id_refs_id_f4b32aac    FK CONSTRAINT     �   ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT group_id_refs_id_f4b32aac FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;
 Z   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT group_id_refs_id_f4b32aac;
       public       postgres    false    3120    213    215            �           2606    16863    user_id_refs_id_40c41112    FK CONSTRAINT     �   ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT user_id_refs_id_40c41112 FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 S   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT user_id_refs_id_40c41112;
       public       postgres    false    3134    217    221            �           2606    16868    user_id_refs_id_4dc23c39    FK CONSTRAINT     �   ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT user_id_refs_id_4dc23c39 FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 ]   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT user_id_refs_id_4dc23c39;
       public       postgres    false    3134    221    219                       2606    16858    user_id_refs_id_c0d12874    FK CONSTRAINT     �   ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT user_id_refs_id_c0d12874 FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 S   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT user_id_refs_id_c0d12874;
       public       postgres    false    3134    221    209           