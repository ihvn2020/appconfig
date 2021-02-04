
/*
   This query will use the HEI Enrollment of the
   baby as the encounter_datetime of the Child Birth Registration Form
*/
update encounter JOIN patient_program on(patient_program.patient_id=encounter.patient_id and encounter.voided=0 and patient_program.voided=0)
set encounter.encounter_datetime=patient_program.date_enrolled
where encounter.form_id=19 and patient_program.program_id=3;
/*
   This query will use the PMTCT Enrollment Date of the
   woman as the encounter_datetime of the General ANC Form
*/
update encounter JOIN patient_program on(patient_program.patient_id=encounter.patient_id and encounter.voided=0 and patient_program.voided=0)
set encounter.encounter_datetime=patient_program.date_enrolled
where encounter.form_id=16 and patient_program.program_id=2;
/*
   This script ensures all visit.date_started is the same
   as visit.date_stopped
*/
update visit set visit.date_stopped=visit.date_started;
/*
   Script below will generate visit_ids for encounters without visit_ids
*/

update encounter
INNER JOIN visit on(DATE(visit.date_started)=DATE(encounter.encounter_datetime) AND visit.patient_id=encounter.patient_id AND visit.voided=0)
set encounter.visit_id=visit.visit_id
where 
encounter.voided=0 and visit.voided=0;
insert into visit
(
patient_id,
visit_type_id,
date_started,
date_stopped,
location_id,
creator,
date_created,
uuid
)
select
encounter.patient_id,
1,
DATE(encounter.encounter_datetime),
DATE(encounter.encounter_datetime),
encounter.location_id,
encounter.creator,
encounter.date_created,
uuid()
from encounter 
where 
encounter.visit_id is null
and 
voided=0;

update encounter
INNER JOIN visit on(DATE(visit.date_started)=DATE(encounter.encounter_datetime) AND visit.patient_id=encounter.patient_id AND visit.voided=0)
set encounter.visit_id=visit.visit_id
where 
encounter.visit_id is null 
and encounter.voided=0 and visit.voided=0;

/*
   This script ensures all visit.date_started is the same
   as visit.date_stopped
*/
update visit set visit.date_stopped=visit.date_started;


