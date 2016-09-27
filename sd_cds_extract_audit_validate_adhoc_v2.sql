USE [nhs_cds]
GO

/****** Object:  StoredProcedure [dbo].[sd_cds_extract_audit_validate_adhoc_v2]    Script Date: 05/11/2016 09:43:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO













ALTER procedure [dbo].[sd_cds_extract_audit_validate_adhoc_v2] 
(
      @test_or_live char(1),
      @cds varchar(200),
      @type varchar(25),
      @net_start varchar(100),
      @net_end varchar(100)
)
as
begin
----------------------------------------------------------------------------------
------------------------------------------------------------------------------------
/*
created by: shah   
dated:                                      03/01/2010  Initial Version
amended: auditing added                     13/05/2010  Shah
amended: auditing changed for temperory run 27/07/2010  Shah
Changed name to 'cds_extract_audit_validate_adhoc' from	'cds_run_2' 6/12/2010 PAG
amended: added system_user in cds_file_sent table 24/05/2012 Shah

	DESCRIPTION
---------------------------------------
this procedure extract data between 2 dates provided . This should be activity dates
parameters : 
1ST parameter T or L for running either Test Extract Or Live Extract
2ND Parameter is CDS Type i.e (020 for outpatient,010 for A&E, 130 for General Inpatient
                               120 for hospital birth,140 for hospital deliveries
                               150 for home births and 160 for home deliveries)
3RD Parameter is Activity Start date
4th Parameter is Activity End date
note: start is the start of the month and end should be the start of the next month.
example: exec sd_cds_extract_audit_validate_adhoc_v2 'L','130','NET','20130401','20160511'
example: exec sd_cds_extract_audit_validate_adhoc_v2 'L','020','NET','20130401','20160511'
--------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------*/
declare @database_name varchar(100)
set @database_name='cds_audit'
set @database_name=case when @test_or_live='T' then @database_name+'_T' 
                        when @test_or_live='L' then @database_name
                   END


PRINT 'exec dbo.sd_cds_exclude - '+ @database_name +' '+ CAST(@net_start AS varchar(20)) +' '+ CAST(@net_end AS varchar(20))
exec dbo.sd_cds_exclude_v2 @database_name,@cds,@net_start,@net_end


declare @min_dw_modif_date datetime
declare @max_dw_modif_date datetime
declare @table_name varchar(100)
declare @view varchar(200)
set @table_name=(
                 select case 
                      when @cds in ('130') then 'nhs_data_warehouse.dbo.tbl_consultant_episode'--netchange uses the consultant episode start and end date 
                      when @cds='010' then  'nhs_data_warehouse.dbo.tbl_ae'
                      when @cds='020' then  'nhs_data_warehouse.dbo.tbl_outpatient_act'
                      when @cds in ('150','160') then 'nhs_data_warehouse.dbo.tbl_obstetrics' 
                  end)
 set      @view=(
                  select case     
                      when @cds='130' then 'CDS V6.1 TYPE 130 - ADMITTED PATIENT CARE - FINISHED GENERAL EPISODE CDS'
                      when @cds='010' then 'CDS V6.1 TYPE 010 - ACCIDENT AND EMERGENCY CDS' 
                      when @cds='020' then 'CDS V6.1 TYPE 020 - OUTPATIENT CDS'
                      when @cds='120' then 'CDS V6.1 TYPE 120 - ADMITTED PATIENT CARE - FINISHED BIRTH EPISODE CDS'
                      when @cds='140' then 'CDS V6.1 TYPE 140 - ADMITTED PATIENT CARE - FINISHED DELIVERY EPISODE CDS'
                      when @cds='150' then 'CDS V6.1 TYPE 150 - ADMITTED PATIENT CARE - OTHER BIRTH EVENT CDS'
                      when @cds='160' then 'CDS V6.1 TYPE 160 - ADMITTED PATIENT CARE - OTHER DELIVERY EVENT CDS'
                 end)
                 
 PRINT   @table_name  
 PRINT   @view        

create table #min_max_dates
(
min_date datetime not null,
max_date datetime not null
)  
declare @start_date datetime
declare @end_date datetime
declare @imp_date datetime               
declare @sql1 varchar(500)
if @cds in ('130','010','020','150','160')
begin
set @sql1='
            select 
                min(dw_modif_date_dt)
                ,max(dw_modif_date_dt) 
            from 
                '+@table_name+'
            where 
                  exclude_cds=0
            '
            
            
  insert into #min_max_dates exec (@sql1)

  PRINT (@sql1)
         
 end           
 
            
  else if @cds ='120'
	begin
		insert into #min_max_dates(min_date,max_date)
		select min(c.dw_modif_date_dt),max(o.dw_modif_date_dt)
		from nhs_data_warehouse..tbl_obstetrics o
						inner join nhs_data_warehouse..tbl_consultant_episode c
						on o.fk_consultant_episode_birth=c.pk_consultant_episode
						
						where o.delete_flag='N'
						and c.delete_flag='N'
						and o.exclude_cds=0
						and c.exclude_cds=0
						and delivery_dttm >=@net_start
						and delivery_dttm < @net_end
 
	end
	 else if @cds ='140'
	begin
		insert into #min_max_dates(min_date,max_date)
		select min(c.dw_modif_date_dt),max(o.dw_modif_date_dt)
		from nhs_data_warehouse..tbl_obstetrics o
						inner join nhs_data_warehouse..tbl_consultant_episode c
						on o.fk_consultant_episode=c.pk_consultant_episode
						where o.delete_flag='N'
						and c.delete_flag='N'
						and o.exclude_cds=0
						and c.exclude_cds=0
						and delivery_dttm >=@net_start
						and delivery_dttm < @net_end
 
	end

--select count(*) from #min_max_dates

set @start_date=(select CONVERT(datetime, min_date,103) from #min_max_dates)
PRINT @start_date
set @end_date=(select CONVERT(datetime, max_date,103) from #min_max_dates)
PRINT @end_date
set @imp_date=(select CONVERT(datetime, max_date,103) from #min_max_dates) 
PRINT @imp_date


if @type='NET'
    begin
          
          --producing the xml file
         PRINT   'producing the xml file - exec usp_cds_process_view '+ ' - ' + @view +' - '+ @type + ' - ' + cast (@start_date as varchar(20))+ ' - ' + cast (@end_date as varchar(20)) + ' - 9 - ' + cast (@imp_date as varchar(20)) + ' -0 ' --' - 1 '  
         --exec usp_cds_process_view @view,@type,@start_date,@end_date,9 ,@imp_date,1
         exec usp_cds_process_view @view,@type,@start_date,@end_date,9 ,@imp_date,1
         
          declare @reject_view varchar(200)
          set @reject_view =(select TABLE_NAME 
                             from information_schema.tables 
                             where table_name like '%V6-1_net_reject'
                             and table_name like 'vw_%'
                             and substring(table_name,8,3)=@cds
                             )
          set @reject_view='['+@reject_view+']'
         declare @source_table varchar(200)
         declare @file_name varchar(200)
         set @source_table= (select TABLE_NAME 
                             from information_schema.tables 
                             where table_name like '%V6-1_net_report'
                             and substring(table_name,8,3)=@cds
                             )
                       
          set @file_name=replace(replace(@source_table,'vw_',''),'_report','')+'_'+ convert(varchar(20),getdate(),120)+'.xml'  
         
       -- set @file_name='CDS_020_redmine_issue_#1481_2nd_Investigate_TAL_data_on_SUS_FY_2012_13_'+ convert(varchar(20),getdate(),120)+'.xml'
         
         set @source_table='['+@source_table+']' 
          declare @reject_query varchar(1000)
          set @reject_query='select distinct 
                            [ns:CDSTransactionHeader_NetChange!7!ns:CDSUniqueIdentifier!element] 
                            from '+@reject_view
          create table #temp_rejects(identifier varchar(100)) 
          insert into #temp_rejects exec (@reject_query)
          PRINT (@reject_query)
          declare @reject_count int
          set @reject_count=(select count(distinct identifier) from #temp_rejects)
						
          
          
          
         declare @records_query varchar(1000)
         declare @record int 
         set @records_query='
          select distinct [ns:CDSTransactionHeader_NetChange!7!ns:CDSUniqueIdentifier!element]
          from nhs_cds.dbo.'+@source_table+' 
          where [ns:CDSTransactionHeader_NetChange!7!ns:CDSUniqueIdentifier!element] is not null'
          create table #temp(identifier varchar(100))  
          insert into #temp exec (@records_query)
          PRINT (@records_query)
         set @record=(select count(distinct identifier) from #temp  ) 
    declare @file_sent_audit_query varchar(8000)
    set @file_sent_audit_query='
    insert into '+@database_name+'.dbo.cds_file_sent
         (
         extracted_by,
         extract_date,
         net_start,
         net_end,
         cds_xml_file_name,
         records_in_file,
         records_rejected,
         anglia_xml_file_name,
         submission_date,
         interchange_id,
         records_on_sus,
         comments
         )
        
         
         select
         system_user,
         getdate(),
         cast('''+@net_start+''' as varchar(100)),
         dateadd(dd,-1,cast('''+@net_end+''' as varchar(100))),
         '''+@file_name+''',
         '+cast(@record as varchar(10))+',
         '+cast(@reject_count as varchar(10))+',
         null,
         null,
         null,
         null,
         ''Adhoc'''
         
         PRINT @file_sent_audit_query
        exec (@file_sent_audit_query)
     end  
         
          --displaying the number of rejects
        exec sd_cds_rejects @cds,@type,@reject_view
        ----------------------------------------------------------------
        --auditing rejects
        --exec nhs_cds.dbo.reject_audit @test_or_live,@cds,@reject_view,@file_name 
        PRINT   'auditing rejects - exec    nhs_cds.dbo.reject_audit '+ ' ' + @test_or_live +' '+ @cds + ' ' + @reject_view  + ' ' + @file_name
        exec nhs_cds.dbo.sd_reject_audit @test_or_live,@cds,@reject_view,@file_name 
        
       
         ----checking unlinked records
         --PRINT   'checking unlinked records - exec    nhs_cds.dbo.unlinked_maternity_records '+ ' ' + @cds +' '+ cast(@net_start as varchar(20)) + ' ' + cast(@net_end as varchar(20)) 
         --exec nhs_cds.dbo.sd_unlinked_maternity_records @cds,@net_start,@net_end
            
         
         ----checking the unique cds identifier 
         --exec cds_identifier_to_be_replace @cds
         
         --checking the difference of datawarehouse and xml file 
         --exec dbo.cds_xml_file_and_warehouse_difference  @cds,@net_start,@net_end
         
         print 'auditing begins'
         
        -- --auditing cds
        --PRINT   'auditing cds - exec    nhs_cds.dbo.cds_audit '+ ' ' + @test_or_live +' '+ @cds + ' ' + @source_table + ' ' + @file_name
        --exec    nhs_cds.dbo.sd_cds_audit @test_or_live,@cds,@source_table,@file_name
      
         --removing record from reject if found in the new file to be sent and is not rejected again
       declare @query varchar(100)
       -- set @query =@database_name+'.dbo.remove_rejects '''+@cds+''''
       -- print @query
       --exec (@query)
       -- ----removing excludes if sent again
        
         set @query=@database_name+'.dbo.remove_exclude '''+@cds+''''
          print @query
         exec (@query)
         
       -- validating the temporary cds extract with live
       --if @test_or_live='T'
       --begin
       --set @query=@database_name+'.dbo.validate_cds_extract '''+@cds+''''
       -- exec (@query) 
       --  end
         
       -- --SUS pre submission validation on this file
        --set @query=@database_name+'.dbo.sus_validation'''+@cds+''','''+@net_start+''','''+@net_end+''''
        --print (@query)
        --exec (@query)
 end
    
























GO


