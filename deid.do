global data "C:\Users\wb596077\OneDrive - WBG\Gender\"

global country "Haiti" // options - Rwanda, Haiti, Kenya, El Salvador
global round "hf" // options - baseline, midline, endline, hf (only for Haiti)

import delimited "$data\$country\\${round}_deid.csv", clear

***************************************************************************
** Baseline data
***************************************************************************
if "${round}" == "baseline" {
	
	* Common variables across all datasets
	drop a_enum_name* /// names
		c_birthdate_* /// date of births 
		county district subdistrict village /// geographic identifiers
		treat /// treatment variables
		comment_final*
		*g2_registry_date g13_wfp_survey_date_* // dates
	
	* Loops for specific countries
	if "${country}" == "Rwanda" {
		* Dropping variables that contain PII data
		drop site /// geographic identifiers
		treatment /// treatment variables
		scope_id
	}

	if "${country}" == "Haiti" {
		* Dropping variables that contain PII data
		drop ht_female_resp_name ht_male_resp_name // names
	}

	if "${country}" == "Kenya" {
		* Dropping variables that contain PII data
		drop m_decision_visits_label m_cons_attitude_3_label /// names
		a_level* site /// geographic identifiers 
		a_hhid_mc
	}

	if "${country}" == "El Salvador" {
		* Dropping variables that contain PII data
		drop m_decision_visits_label m_cons_attitude_3_label /// names
		a_level* /// geographic identifiers
		scope_id*
	}

	save "$data\$country\baseline_deid.dta", replace

}

***************************************************************************
** Midline data
***************************************************************************
if "${round}" == "midline" {
	
	* Common variables across all datasets
	drop a_enum_name* /// names
		c_birthdate_* /// date of births 
		a_level* county district subdistrict village /// geographic identifiers
		treat /// treatment variables
		comment_final*
		*g2_registry_date g13_wfp_survey_date_* g17_bis_wfp_transfer_date_* // dates
	
	* Loops for specific countries
	if "${country}" == "Rwanda" {
		* Dropping variables that contain PII data
		drop site /// geographic identifiers 
		treatment /// treatment variables
		scope_id*
		*g213_2_wfp_mob_date g222_wfp_work_date // dates
	}
	
	* No extra variables to drop for Haiti so loop skipped

	if "${country}" == "Kenya" {
		* Dropping variables that contain PII data
		drop m_decision_visits_label m_cons_attitude_3_label /// names
		site // geographic identifiers
	}

	if "${country}" == "El Salvador" {
		* Dropping variables that contain PII data
		drop m_decision_visits_label m_cons_attitude_3_label /// names
		scope_id* 
	}

	save "$data\$country\midline_deid.dta", replace

}

if "${country}" == "Rwanda" & "${round}" == "midline" {
	import delimited "$data\$country\hh_${round}_waves_deid.csv", clear
	drop county district subdistrict village household treatment wfp_id
	save "$data\$country\hh_${round}_waves_deid.dta", replace
}

***************************************************************************
** Endline data
***************************************************************************
if "${round}" == "endline" {
	
	* Common variables across all datasets
	drop a_enum_name* /// names
		c_birthdate_* /// date of births 
		a_level* county district subdistrict village /// geographic identifiers
		treat /// treatment variables
		comment_final*
		*g2_registry_date g13_wfp_survey_date_* g17_bis_wfp_transfer_date_* // dates
	
	* Loops for specific countries
	if "${country}" == "Rwanda" {
		* Dropping variables that contain PII data
		drop a2_enumerator /// names
		site /// geographic identifiers 
		treatment /// treatment variables
		scope_id*
		*g213_2_wfp_mob_date g222_wfp_work_date // dates
	}
	
	* No extra variables to drop for Haiti so loop skipped

	if "${country}" == "Kenya" {
		* Dropping variables that contain PII data
		drop m_decision_visits_label m_cons_attitude_3_label /// names
		site // geographic identifiers
	}

	if "${country}" == "El Salvador" {
		* Dropping variables that contain PII data
		drop m_decision_visits_label m_cons_attitude_3_label /// names
		scope_id* 
	}

	save "$data\$country\endline_deid.dta", replace

}

if "${round}" == "hf" & "${country}" == "Haiti" {
	drop a_enum_name*  /// names
	a3_level1 a4_level2 a5_level3 a6_level4 county district subdistrict village /// geographic identifiers
	treat /// treatment variables
	comment_final*
	*g17_bis_wfp_transfer_date_* // dates
	
	save "$data\$country\hf_deid.dta", replace
}
 