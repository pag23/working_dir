USE [nhs_cds]
GO

/****** Object:  StoredProcedure [dbo].[sd_cds_exclude_v2]    Script Date: 05/10/2016 10:15:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER  procedure [dbo].[sd_cds_exclude_v2] 
(
    @database_name varchar(100)
    -- 1.2 ,@test_or_live char(1)
    ,@cds varchar(5)
    ,@start_date datetime
    ,@end_date datetime
)
as
--SET NOCOUNT ON exec [sd_cds_exclude_v2] 'cds_audit','020','20150401','20160501'
--IF @cds = '010' 
--		BEGIN
--		-- Queries for 010 exclusions ---------------------------------------------------
--		-- exclude 1 query:
--		PRINT ' HALLOOOO! '+ @cds
--		update nhs_data_warehouse.dbo.tbl_ae
--						   set exclude_cds=1
--		PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows excluded for cds '+ @cds						   
--		-- exclude 2 query: 
		 
--		-- include 1 query:
--		update ae
--					  set ae.exclude_cds=0
--					  from nhs_data_warehouse.dbo.tbl_ae ae
--					  inner join nhs_data_warehouse.dbo.tbl_patient p
--					  on ae.fk_patient=p.pk_patient
--					  where p.fk_pct <> 1
--					  AND ae.delete_flag='N'
--					  and p.pasid NOT IN  ('A712073','A1081042') 
--					  and isnull(p.nhs_number,'') <> '9990030464' 
--					  and p.pasid not like '%A00_00%'
--					  and p.pasid is not null 
--					  and p.pasid <> '' 
--							 and arrival_date_dt  >=@start_date
--							 and arrival_date_dt <@end_date
							 
--		PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows included for cds '+ @cds								 
--		-- include 2 query: 
		 
--		-- insert 1 query: 

--		  insert into cds_audit.dbo.cds_010_exclude
--		select case when p.pasid in ('A712073','A1081042')
--		or p.pasid like '%A00_00%'
--		OR P.pasid is null
--		or p.pasid=''
--		or isnull(p.nhs_number,'')='9990030464'
--		then 'PASID or NHS_NUMBER'
--		WHEN ae.delete_flag <> 'N'
--		then 'DELETE_FLAG'
--		when p.fk_pct=1
--		then 'PCT_OF_RESIDENCE'   
--		ELSE 'ERROR NOT KNOWN'
--		END AS exclude_reason, 
--		p.pasid,p.fk_pct,p.postcode,p.nhs_number,ae.arrival_date_dt,ae.attendance_number,ae.delete_flag 
--		,getdate() as exclude_date
--		from nhs_data_warehouse.dbo.tbl_ae ae
--		inner join nhs_data_warehouse.dbo.tbl_patient p
--		on ae.fk_patient=p.pk_patient
--		where ae.exclude_cds=1
--		and ae.delete_flag='N'
--							 and arrival_date_dt  >=@start_date
--							 and arrival_date_dt <@end_date
							 
--        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows exclusions for cds '+ @cds								 
--        END							 
		-- END Queries for 010 exclusions ---------------------------------------------------
---------------------020 ------------DISSENT ADDED------------------------------------------------------------		
IF @cds = '020' 
		BEGIN
		PRINT ' HALLOOOO! '+ @cds
		-- Queries for 020 exclusions ---------------------------------------------------
		-- exclude 1 query:
		update nhs_data_warehouse.dbo.tbl_outpatient_act
						   set exclude_cds=1
									 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows excludes for cds '+ @cds					   
		-- exclude 2 query: 
		 
		-- include 1 query:
		           
		update oa		
		set oa.exclude_cds=0
		--SELECT *		
		from  nhs_data_warehouse.dbo.tbl_outpatient_act oa
		inner join nhs_data_warehouse.dbo.tbl_patient p
		on oa.fk_patient=p.pk_patient
		inner join nhs_data_warehouse.dbo.tbl_consultant c
		on oa.fk_consultant=c.pk_consultant
		inner join nhs_data_warehouse.dbo.tbl_specialty s
		on c.fk_specialty=s.pk_specialty
		inner join nhs_data_warehouse.dbo.tbl_attend_notattend att
		on oa.fk_attend_or_did_not_attend=att.pk_attend_notattend
		inner join nhs_data_warehouse.dbo.tbl_specialty tr
		on tr.pk_specialty=oa.fk_specialty
		inner join nhs_data_warehouse.dbo.tbl_clinic cl
		on oa.fk_clinic=cl.pk_clinic
		inner join nhs_data_warehouse.dbo.tbl_pct pct
		on p.fk_pct=pct.pk_pct
		where (
			tr.spec_code not in ('960','653','007')
		 or s.spec_code not in ('960','653','007')
		 )
			--ADDED to exclude dissent extract delete records>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		 and p.pasid not in --
		  (
		 SELECT DISTINCT [patient_number]
		   FROM SDHIS2.[CORPORATE_DATA].[Information].[patient_dissent_list]
		 )
		 and p.pasid NOT IN  ('A712073','A1081042') 
		 and isnull(p.nhs_number,'') <> '9990030464' 
		 and p.pasid not like '%A00_00%' 
		 and p.pasid is not null 
		 and p.pasid <> ''
		 and cl.clinic_code NOT like 'CAMDT%'
		 and cl.clinic_code NOT Like 'BPAS%'
		 and cl.clinic_code NOT Like 'TOPAS%'
		  and  fk_pct <> 1
		 and   att.national_code  in (3,5) 
		 and oa.delete_flag='N' 
							 and attendance_date_dt  >=@start_date
							 and attendance_date_dt <@end_date
							 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows includes for cds '+ @cds	
        							 
		-- include 2 query: 

		update oa
		set oa.exclude_cds=0
		--SELECT *
		from  nhs_data_warehouse.dbo.tbl_outpatient_act oa
		inner join nhs_data_warehouse.dbo.tbl_first_attendance firsts
		on firsts.pk_first_attend=oa.fk_first_attendance
		where 
		 firsts.national_code=5 --administrative_events rtt
		 and oa.delete_flag='N' 
							 and attendance_date_dt  >=@start_date
							 and attendance_date_dt <@end_date
		-- insert 1 query: 
		--SELECT TOP 1000 * FROM cds_audit.dbo.cds_020_exclude  order by  attendance_date_dt desc
		insert into cds_audit.dbo.cds_020_exclude  
		select case when tr.spec_code  in ('960','653','007')
		then 'TREATMENT_FUNCTION'
		WHEN s.spec_code  in ('960','653','007')
		then 'CONSULTANT_SPECIALTY'
		WHEN (p.pasid  IN  ('A712073','A1081042')
		or p.pasid  like '%A00_00%' 
		or p.pasid is  null 
		or p.pasid = '')
		then 'PASID' 
		WHEN isnull(p.nhs_number,'') = '9990030464' 
		then 'NHS_NUMBER'
		WHEN cl.clinic_code  like 'CAMDT%' OR 
			 cl.clinic_code like 'BPAS%'  OR 
			 cl.clinic_code like 'TOPAS%'
		then 'CLINIC_CODE'
		when p.fk_pct =1 
		then 'PCT_OF_RESIDENCE'
		ELSE 'ERROR_NOT_KNOWN'
		end as exclude_reason,    
		p.pasid,p.fk_pct,p.postcode,tr.spec_code as treatment_function
		,s.spec_code as consultant_specialty,p.nhs_number,cl.clinic_code
		,att.national_code as attend_or_not_attend,oa.appointment_serial,
		oa.attendance_date_dt,getdate() as exclude_date
		from  nhs_data_warehouse.dbo.tbl_outpatient_act oa
		inner join nhs_data_warehouse.dbo.tbl_patient p
		on oa.fk_patient=p.pk_patient
		inner join nhs_data_warehouse.dbo.tbl_consultant c
		on oa.fk_consultant=c.pk_consultant
		inner join nhs_data_warehouse.dbo.tbl_specialty s
		on c.fk_specialty=s.pk_specialty
		inner join nhs_data_warehouse.dbo.tbl_attend_notattend att
		on oa.fk_attend_or_did_not_attend=att.pk_attend_notattend
		inner join nhs_data_warehouse.dbo.tbl_specialty tr
		on tr.pk_specialty=oa.fk_specialty
		inner join nhs_data_warehouse.dbo.tbl_clinic cl
		on oa.fk_clinic=cl.pk_clinic
		where oa.exclude_cds=1
		and oa.delete_flag='N'
		and att.national_code  in (3,5)
		--PATIENT DISSENT EXCLUDE >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		--and p.pasid in --
		--  (
		-- SELECT DISTINCT [patient_number]
		--   FROM SDHIS2.[CORPORATE_DATA].[Information].[patient_dissent_list]
		-- )

							 and attendance_date_dt  >=@start_date
							 and attendance_date_dt <@end_date
							 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows exclusions for cds '+ @cds								 
	END
		-- END Queries for 020 exclusions ---------------------------------------------------
	--ELSE
	--	BEGIN
	--		PRINT ' NONE OF THAT!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
	--	END
---------------------------120 --------------------------------------------------------------
IF @cds = '120' 
		BEGIN
				PRINT ' HALLOOOO! '+ @cds		
		-- Queries for 120 exclusions ---------------------------------------------------
		-- exclude 1 query:
		update nhs_data_warehouse.dbo.tbl_obstetrics  
										 set exclude_cds=1
										 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows excluded for cds '+ @cds											 
		-- exclude 2 query: 
		 
		-- include 1 query:
						update c
						set exclude_cds=0
						--select *
						from nhs_data_warehouse.dbo.tbl_consultant_episode c
						where delete_flag='N' 							  
						and end_date_cons_episode_dt  >=@start_date
						and end_date_cons_episode_dt <@end_date
							 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows included for cds '+ @cds	
        							 
		-- include 2 query: 
		UPDATE nhs_data_warehouse.dbo.tbl_obstetrics
		SET    exclude_cds = 0
		--SELECT *  FROM nhs_data_warehouse.dbo.tbl_obstetrics
		WHERE  delete_flag = 'N'
			   AND fk_consultant_episode_birth <> 1 --include having linked pas records only                        
			   and baby_hospital_number not in ('A1189962','A1179020','A1201519','A1201518') 
							 and delivery_dttm  >=@start_date
							 and delivery_dttm <@end_date
							 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows included for cds '+ @cds								 
		-- insert 1 query: 
		 insert into cds_audit.dbo.cds_120_exclude
		 select 
				case when fk_consultant_episode_birth=1 then 'NO_PAS_RECORd'
					 ELSE 'UNKNOWN_ERROR' end as exclude_reason,
					 internal_id,delivery_dttm,delete_flag,
					 baby_hospital_number,actual_place_del,
					 baby_birth_order,getdate() as exclude_date 
		 from nhs_data_warehouse.dbo.tbl_obstetrics 
				where exclude_cds=1
				and actual_place_del <> '3'
				and delete_flag='N' 
							 and delivery_dttm  >=@start_date
							 and delivery_dttm <@end_date
							 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows exclusions for cds '+ @cds	
   END							 
   ---------------------130 -------------------------------------------------------------
IF @cds = '130' 
		BEGIN
				PRINT ' HALLOOOO! '+ @cds
		-- Queries for 130 exclusions ---------------------------------------------------
		-- exclude 1 query:
		update nhs_data_warehouse..tbl_consultant_episode
					  set exclude_cds=1
										 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows excluded 1 for cds '+ @cds						  
		-- exclude 2 query: 
		update nhs_data_warehouse..tbl_obstetrics
					  set exclude_cds=1
										 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows excluded 2 for cds '+ @cds						  
		-- include 1 query:

		  update c                
		  set exclude_cds = 0   
		  --SELECT *              
		  from  -- Consultant Episode                
		  nhs_data_warehouse.dbo.tbl_consultant_episode c                
		  inner join -- Provider Spell (Patient link)                
		  nhs_data_warehouse.dbo.tbl_provider_spell s                
		  on  c.fk_provider_spell = s.pk_provider_spell                
		  inner join -- Patient                
		  nhs_data_warehouse.dbo.tbl_patient p                
		  on  p.pk_patient = s.fk_patient
		  inner join --provider
		  nhs_data_warehouse.dbo.tbl_provider pr
		  on s.fk_provider=pr.pk_provider                
		  where                 
		  c.delete_flag = 'N'                
		  and  s.delete_flag = 'N'  
		  and p.delete_flag='N'--TEST PATIENTS ARE MARKED AS DELETED IN WAREHOUSE              
		  and p.fk_pct <> 1                
		  and pasid is NOT null                 
		  and pasid <> ''  
			--ADDED to exclude dissent extract delete records >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
			and pasid not in --
			(
			SELECT DISTINCT [patient_number]
			FROM SDHIS2.[CORPORATE_DATA].[Information].[patient_dissent_list]
			)			                
		  and p.pasid NOT IN  ('A712073','A1081042')                
		  and isnull(nhs_number,'') <> '9990030464'                 
		  and pasid NOT like '%A00_00%'
		  and provider_code <> 'RWV00' 
							 and end_date_cons_episode_dt  >=@start_date
							 and end_date_cons_episode_dt <@end_date
										 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows included for cds '+ @cds								 
		-- include 2 query: 
		 
		-- insert 1 query: 
		insert into cds_audit.dbo.cds_130_exclude  
			  select case 
			  WHEN (p.pasid  IN  ('A712073','A1081042')  or p.pasid  like '%A00_00%'   or p.pasid is  null   or p.pasid = '')  
			  then 'PASID'  
			  WHEN isnull(p.nhs_number,'') = '9990030464'   
			  then 'NHS_NUMBER'  
			  when p.fk_pct =1   
			  then 'PCT_OF_RESIDENCE' 
			  when provider_code='RWV00'
			  THEN 'PROVIDER' 
			  ELSE 'ERROR_NOT_KNOWN'  
			  end as exclude_reason,  
			  p.pasid,
			  p.fk_pct,
			  p.postcode,
			  p.nhs_number,
			  c.hospital_provider_spell_number  ,
			  c.episode_number,
			  c.end_date_cons_episode_dt   ,
			  getdate() as exclude_date  
			  from nhs_data_warehouse.dbo.tbl_provider_spell pr  
			  inner join nhs_data_warehouse.dbo.tbl_patient p  
			  on pr.fk_patient=p.pk_patient  
			  inner join nhs_data_warehouse.dbo.tbl_consultant_episode c  
			  on c.fk_provider_spell=pr.pk_provider_spell 
			  inner join nhs_data_warehouse.dbo.tbl_provider provider
			  on provider.pk_provider=pr.fk_provider 
			  where c.exclude_cds=1  
			  and pr.delete_flag='N'  
			  and c.delete_flag='N'
							 and end_date_cons_episode_dt  >=@start_date
							 and end_date_cons_episode_dt <@end_date
										 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows exclusions for cds '+ @cds	
  END							 
		--  Queries for 130 exclusions ---------------------------------------------------
IF @cds = '140' 
		BEGIN
				PRINT ' HALLOOOO! '+ @cds
		-- Queries for 140 exclusions ---------------------------------------------------
		-- exclude 1 query:
		update nhs_data_warehouse.dbo.tbl_obstetrics  
										 set exclude_cds=1
										 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows excluded for cds '+ @cds											 
		-- exclude 2 query: 
		 
		-- include 1 query:
		update c
									  set exclude_cds=0
									  from nhs_data_warehouse.dbo.tbl_consultant_episode c
									  where delete_flag='N' 
							 and end_date_cons_episode_dt  >=@start_date
							 and end_date_cons_episode_dt <@end_date
										 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows included 1 for cds '+ @cds								 
		-- include 2 query: 
		update nhs_data_warehouse.dbo.tbl_obstetrics
							  set exclude_cds=0
							  where delete_flag='N'
							  and fk_consultant_episode <> 1 --include having linked pas records only 
							 and delivery_dttm  >=@start_date
							 and delivery_dttm <@end_date
										 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows include 2 for cds '+ @cds								 							 
		-- insert 1 query: 
		 insert into cds_audit.dbo.cds_140_exclude
		 select 
				case when fk_consultant_episode_birth=1 then 'NO_PAS_RECORd'
					 ELSE 'UNKNOWN_ERROR' end as exclude_reason,
					 internal_id,delivery_dttm,delete_flag,
					 baby_hospital_number,actual_place_del,
					 baby_birth_order,getdate() as exclude_date 
		 from nhs_data_warehouse.dbo.tbl_obstetrics 
				where exclude_cds=1
				and actual_place_del <> '3'
				and delete_flag='N' 
							 and delivery_dttm  >=@start_date
							 and delivery_dttm <@end_date
										 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows exclusions for cds '+ @cds	
 END
        							 
		--  Queries for 140 exclusions ---------------------------------------------------
IF @cds = '150' 
		BEGIN
				PRINT ' HALLOOOO! '+ @cds
		-- Queries for 150 exclusions ---------------------------------------------------
		-- exclude 1 query:
		update nhs_data_warehouse.dbo.tbl_obstetrics  
										 set exclude_cds=1
										 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows excluded for cds '+ @cds											 
		-- exclude 2 query: 
		 
		-- include 1 query:
		update nhs_data_warehouse.dbo.tbl_obstetrics
							  set exclude_cds=0
							  where delete_flag='N'
							  and actual_place_del=3 
							 and delivery_dttm  >=@start_date
							 and delivery_dttm <@end_date
										 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows included for cds '+ @cds								 
		-- include 2 query: 
		 
		-- insert 1 query: 
		insert into cds_audit.dbo.cds_150_exclude
						 select internal_id,delivery_dttm,delete_flag,actual_place_del
						 baby_hospital_number,baby_birth_order,getdate() as exclude_date
						 from nhs_data_warehouse.dbo.tbl_obstetrics 
						 where exclude_cds=1
						 and actual_place_del=3
						 and delete_flag='N'
							 and delivery_dttm  >=@start_date
							 and delivery_dttm <@end_date
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows exclusions for cds '+ @cds	
END							 
		--  Queries for 150 exclusions ---------------------------------------------------
IF @cds = '160' 
		BEGIN
				PRINT ' HALLOOOO! '+ @cds
		-- Queries for 160 exclusions ---------------------------------------------------
		-- exclude 1 query:
		update nhs_data_warehouse.dbo.tbl_obstetrics  
										 set exclude_cds=1
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows excluded for cds '+ @cds											 
		-- exclude 2 query: 
		 
		-- include 1 query:
		update nhs_data_warehouse.dbo.tbl_obstetrics
							  set exclude_cds=0
							  where delete_flag='N'
							  and actual_place_del=3
		                       
							 and delivery_dttm  >=@start_date
							 and delivery_dttm <@end_date
							 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows included for cds '+ @cds								 
		-- include 2 query: 
		 
		-- insert 1 query: 
		insert into cds_audit.dbo.cds_160_exclude
						 select internal_id,delivery_dttm,delete_flag,actual_place_del
						 baby_hospital_number,baby_birth_order,getdate() as exclude_date
						 from nhs_data_warehouse.dbo.tbl_obstetrics 
						 where exclude_cds=1
						 and actual_place_del=3
						 and delete_flag='N'
							 and delivery_dttm  >=@start_date
							 and delivery_dttm <@end_date
							 
        PRINT CAST(@@rowcount AS VARCHAR(10)) + ' rows exclusions for cds '+ @cds	
END							 
		--  Queries for 160 exclusions ---------------------------------------------------


GO


