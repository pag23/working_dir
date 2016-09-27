SELECT TOP 1000
'020'  AS [CDS_Type],
'010' AS [CDS_Protocol_ID],
'BRA900' + [attendance_number] AS [CDS_Unique_ID],
 '' AS [CDS_BULK_Replacement_Group],
 '9' AS [CDS_Update_Type],
 '' AS [CDS_Extract_Date],
 '' AS [CDS_Extract_Time],
 CAST(GetDate() AS DATE) AS [CDS_Applicable_Date],
 CAST(GetDate() AS TIME(0)) AS [CDS_Applicable_Time],
 '' AS [CDS_Report_Period_Start_Date],
 '' AS [CDS_Report_Period_End_Date],
 CAST([attendance_date] AS DATE) AS [CDS_Activity_Date],
 'RA900' AS [CDS_Sender_Identity],
 '?' AS [CDS_Prime_Recip],--todo
 '' AS [CDS_Copy_Recip1],
 '' AS [CDS_Copy_Recip2],
 '' AS [CDS_Copy_Recip3],
 '' AS [CDS_Copy_Recip4],
 '' AS [CDS_Copy_Recip5],
 '' AS [CDS_Copy_Recip6],
 '' AS [CDS_Copy_Recip7],
 '' AS [UBRN],
 [pathway_id] AS [Patient_Pathway_ID],
 [patient_pathway_id_issuer] AS [Org_Code_Pathway_ID], --redo
 '' AS [RTT_Status],
 '' AS [RTT_WaitingTimeMeasurement],
 '' AS [RTT_Start_Date],
 '' AS [RTT_End_Date],
 '?' AS [Withheld_Identitiy_Reason], --todo
 [patient_number] AS [PATID],
 'RA900' AS [Org_Code_PATID],
 [nhs_number] AS [NHS_Number],
 '?' AS [NHS_Number_Status],
 '' AS [Unstructured Patient_Name],
 '?' AS [Structured PersonTitle],
 '?' AS [Structured PersonGivenName],
 '?' AS [Structured PersonFamilyName],
 '?' AS [Structured PersonNameSuffix],
 '?' AS [Structured PersonInititials],
 '' AS [Unstructured Address],
 '?' AS [Structured Address Line 1],
 '?' AS [Structured Address Line 2],
 '?' AS [Structured Address Line 3],
 '?' AS [Structured Address Line 4],
 '?' AS [Structured Address Line 5],
 [postcode] AS [Postcode],
 '?' AS [Org_Code_Residence_Responsibility],
 '?' AS [DOB],
 '?' AS [Gender],
 '?' AS [Carer_Support_Indicator],
 '?' AS [Ethnic_Cat],
 [consultant] AS [Cons_Code],  --todo
 [consultant_specialty] AS [Main_Spec],
 [treatment_function] AS [Treat_Func],
 '?' AS [Local_Sub_Speciality],
 '' AS [ICD_Diag_Scheme],
 '' AS [ICD_Prim_Diag],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_1],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_2],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_3],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_4],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_5],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_6],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_7],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_8],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_9],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_10],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_11],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_12],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_13],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_14],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_15],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_16],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_17],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_18],
 '' AS [Present_On_Admission_Indicator],
 '' AS [ICD_Sec_Diag_19],
 '' AS [Present_On_Admission_Indicator],
 '' AS [Read_Diag_Scheme],
 '' AS [Read_Prim_Diag],
 '' AS [Read_Sec_Diag_1],
 '' AS [Read_Sec_Diag_2],
 [appointment_serial] AS [Att_Identifier],
 '?' AS [Admin_Cat],
 [attended_didnot_attend] AS [Att_Status],
 [first_attendance] AS [First_Att],
 [medical_staff_type] AS [Med_Staff_Type],
 CASE
	WHEN [procedure_1] IS NOT NULL THEN 1
	ELSE 8
 END AS [Op_Status],
 [attendance_outcome] AS [Outcome_Att],
 [attendance_date] AS [Appt_Date],
 [attendance_date_time] AS [Appt_Time],
 '?' AS [Expected_Duration_Appt],
 [start_age]AS [Age_At_CDS_Act_Date],
 '?' AS [Overseas_Visitor_Class_At_Activity_Date],
 '?' AS [Earliest_Reasonable_Offer_Date],
 '?' AS [Earliest_Clinically_Appropriate_Date],
 '?' AS [Consultation_Medium_Used],
 '?' AS [MultiProfOrDiscIndCode],
 '' AS [Rehab_Assmt_Team_Type],
 'XXXXXX' AS [Comm_Serial_No], --???????
 '' AS [SLA_No],
 '' AS [Prov_Ref_No],
 [contract_serial] AS [Comm_Ref_No],
 [provider] AS [Org_Code_Prov],
 '?' AS [Org_Code_Comm],
 '02' AS [OPCS_Scheme],
 [procedure_1] AS [Prim_Proc],
 CAST([attendance_date] AS DATE) AS [Prim_Proc_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 [procedure_2] AS [Sec_Proc_1],
 CAST([attendance_date] AS DATE) AS [Sec_Proc_1_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 [procedure_3] AS [Sec_Proc_2],
 CAST([attendance_date] AS DATE) AS [Sec_Proc_2_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 [procedure_4] AS [Sec_Proc_3],
 CAST([attendance_date] AS DATE) AS [Sec_Proc_3_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 [procedure_5] AS [Sec_Proc_4],
 CAST([attendance_date] AS DATE) AS [Sec_Proc_4_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 [procedure_6] AS [Sec_Proc_5],
 CAST([attendance_date] AS DATE) AS [Sec_Proc_5_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 [procedure_7] AS [Sec_Proc_6],
 CAST([attendance_date] AS DATE) AS [Sec_Proc_6_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 [procedure_8] AS [Sec_Proc_7],
 CAST([attendance_date] AS DATE) AS [Sec_Proc_7_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 [procedure_9] AS [Sec_Proc_8],
 CAST([attendance_date] AS DATE) AS [Sec_Proc_8_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 [procedure_10] AS [Sec_Proc_9],
 CAST([attendance_date] AS DATE) AS [Sec_Proc_9_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 [procedure_11] AS [Sec_Proc_10],
 CAST([attendance_date] AS DATE) AS [Sec_Proc_10_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 [procedure_12] AS [Sec_Proc_11],
 CAST([attendance_date] AS DATE) AS [Sec_Proc_11_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 '' AS [Sec_Proc_12],
 '' AS [Sec_Proc_12_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 '' AS [Sec_Proc_13],
 '' AS [Sec_Proc_13_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 '' AS [Sec_Proc_14],
 '' AS [Sec_Proc_14_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 '' AS [Sec_Proc_15],
 '' AS [Sec_Proc_15_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 '' AS [Sec_Proc_16],
 '' AS [Sec_Proc_16_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 '' AS [Sec_Proc_17],
 '' AS [Sec_Proc_17_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 '' AS [Sec_Proc_18],
 '' AS [Sec_Proc_18_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 '' AS [Sec_Proc_19],
 '' AS [Sec_Proc_19_Date],
 '' AS [HCP_Prof_Reg_Issuer],
 '' AS [HCP_Prof_Reg_Entry_Identifier],
 '' AS [Anaesthetist_Prof_Reg_Issuer],
 '' AS [Anaesthetist_Prof_Reg_Identifier],
 '' AS [Read_Proc_Scheme],
 '' AS [Read_Prim_Proc],
 '' AS [Read_Prim_Proc_Date],
 '' AS [Read_Sec_Proc_1],
 '' AS [Read_Sec_Proc_1_Date],
 '' AS [Read_Sec_Proc_2],
 '' AS [Read_Sec_Proc_2_Date],
 '' AS [Read_Sec_Proc_3],
 '' AS [Read_Sec_Proc_3_Date],
 '' AS [Read_Sec_Proc_4],
 '' AS [Read_Sec_Proc_4_Date],
 '' AS [Read_Sec_Proc_5],
 '' AS [Read_Sec_Proc_5_Date],
 '' AS [Read_Sec_Proc_6],
 '' AS [Read_Sec_Proc_6_Date],
 '' AS [Read_Sec_Proc_7],
 '' AS [Read_Sec_Proc_7_Date],
 '' AS [Read_Sec_Proc_8],
 '' AS [Read_Sec_Proc_8_Date],
 '' AS [Read_Sec_Proc_9],
 '' AS [Read_Sec_Proc_9_Date],
 '' AS [Read_Sec_Proc_10],
 '' AS [Read_Sec_Proc_10_Date],
 '' AS [Read_Sec_Proc_11],
 '' AS [Read_Sec_Proc_11_Date],
 '' AS [Read_Sec_Proc_12],
 '' AS [Read_Sec_Proc_12_Date],
 '' AS [Read_Sec_Proc_13],
 '' AS [Read_Sec_Proc_13_Date],
 '' AS [Read_Sec_Proc_14],
 '' AS [Read_Sec_Proc_14_Date],
 '' AS [Read_Sec_Proc_15],
 '' AS [Read_Sec_Proc_15_Date],
 '' AS [Read_Sec_Proc_16],
 '' AS [Read_Sec_Proc_16_Date],
 '' AS [Read_Sec_Proc_17],
 '' AS [Read_Sec_Proc_17_Date],
 '' AS [Read_Sec_Proc_18],
 '' AS [Read_Sec_Proc_18_Date],
 '' AS [Read_Sec_Proc_19],
 '' AS [Read_Sec_Proc_19_Date],
 '?' AS [Location_Class],
 [site] AS [Site_Code],
 '?' AS [Location_Type],
 [clinic] AS [Clinic_Code],
 '?' AS [Code_Reg_GP],
 [practice]AS [Code_Reg_GP_Practice],
 '' AS [Priority_Type],
 '' AS [Service_Type],
 [source_of_referral] AS [Source_Ref],
 [referral_request_received_date] AS [Ref_Request_Rec_Date],
 '' AS [Direct_Access_Ref_Ind],
 '' AS [Ref_Code],
 '' AS [Ref_Org_Code],
 '' AS [Last_DNA_Canc_Date],
'' AS [Filler],
'' AS [Filler],
'' AS [Filler],
'' AS [Filler],
'' AS [Filler],
'' AS [Filler],
'' AS [Filler],
'' AS [Filler],
'' AS [Filler],
'' AS [Filler]
FROM SDHIS2.[CORPORATE_DATA].[activity].[outpatient_inview]