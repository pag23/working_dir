/****** 

 ******/
 WITH max_records AS
   (
  select Pathway_id,
  pathway_identifier,
  MAX(file_last_modified_date) dd  
from stage_pathway sp1
group by Pathway_id,pathway_identifier  
),
All_records AS
 (
SELECT [Activity_Type]
      ,[Activity_Keys]
      ,[Pathway_Identifier]
      ,[Pathway_id]
      ,[rtt_start]
      ,[rtt_end]
      ,[rtt_national_status_code]
      ,[unique_booking_refno]
      ,[ero_date]
      ,[rtt_outcome_code_1]
      ,[rtt_outcome_date_1]
      ,[rtt_outcome_code_2]
      ,[rtt_outcome_date_2]
      ,[file_name]
      ,[file_last_modified_date]
      ,[record_load_date]
      ,[admin_date]
      ,[pathway_sequence]
      ,[current_record]
      ,[rownum]
      , [UK]
      ,[stage_calculated_sequence_number]
      ,[stage_calculated_clock_no]
  FROM [nhs_inview_stage].[dbo].[stage_pathway] sp
)
--TRUNCATE TABLE [nhs_inview_stage].[dbo].[stage_pathway_last]
INSERT INTO [nhs_inview_stage].[dbo].[stage_pathway_last]
(
 [Activity_Type]
      ,[Activity_Keys]
      ,[Pathway_Identifier]
      ,[Pathway_id]
      ,[rtt_start]
      ,[rtt_end]
      ,[rtt_national_status_code]
      ,[unique_booking_refno]
      ,[ero_date]
      ,[rtt_outcome_code_1]
      ,[rtt_outcome_date_1]
      ,[rtt_outcome_code_2]
      ,[rtt_outcome_date_2]
      ,[file_name]
      ,[file_last_modified_date]
      ,[record_load_date]
      ,[admin_date]
      ,[pathway_sequence]
      ,[current_record]
      ,[rownum]
      --, [UK]
      ,[stage_calculated_sequence_number]
      ,[stage_calculated_clock_no]
)
SELECT All_records.[Activity_Type]
      ,All_records.[Activity_Keys]
      ,All_records.[Pathway_Identifier]
      ,All_records.[Pathway_id]
      ,All_records.[rtt_start]
      ,All_records.[rtt_end]
      ,All_records.[rtt_national_status_code]
      ,All_records.[unique_booking_refno]
      ,All_records.[ero_date]
      ,All_records.[rtt_outcome_code_1]
      ,All_records.[rtt_outcome_date_1]
      ,All_records.[rtt_outcome_code_2]
      ,All_records.[rtt_outcome_date_2]
      ,All_records.[file_name]
      ,All_records.[file_last_modified_date]
      ,All_records.[record_load_date]
      ,All_records.[admin_date]
      ,All_records.[pathway_sequence]
      ,All_records.[current_record]
      ,All_records.[rownum]
      --, [UK]
      ,All_records.[stage_calculated_sequence_number]
      ,All_records.[stage_calculated_clock_no] 
FROM All_records 
INNER JOIN
max_records 
ON
max_records.dd =All_records.file_last_modified_date
AND
max_records.Pathway_id =All_records.[Pathway_id]

--WHERE max_records.Pathway_id = 'XO9000103095140'
--  --ORDER BY [record_load_date] desc
--  ORDER BY [pathway_sequence]