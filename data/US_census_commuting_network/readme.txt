Record Layout for Census 2000 County-to-County Worker Flow Files


Position    Name       Description
--------    --------   -----------

   1-2      Res_ST     FIPS State Code of Residence

   4-6      Res_CO     FIPS County Code of Residence

  8-11      Res_MSA    FIPS Metropolitan Statistical Area (MSA) or
                       Consolidated Metropolitan Statistical Area (CMSA)
                       Code of Residence

                       This field contains the 4-digit code for the MSAs
                       and CMSAs designated June 30, 1999.

                       9999 Appears for nonmetropolitan areas

                          * Appears for counties in the six New England
                            states for which more than one code is  
                            applicable.

 13-16      Res_PMSA   FIPS Primary Metropolitan Statistical Area (PMSA)
                       Code of Residence

                       This field contains the 4-digit code for the PMSAs
                       designated June 30, 1999.

                       9999 Not in a PMSA

                          * Appears for counties in the six New England
                            states for which more than one code is  
                            applicable.

 18-57      Res_Name   Residence County name and State abbreviation

 59-61      Wrk_ST     Modified FIPS State Code or Foreign Country/Area
                       Code of Workplace

                       FIPS State codes have been extended to three 
                       characters by adding a leading zero.

 63-65      Wrk_CO     FIPS County Code of Workplace

                       000  Appears in conjunction with codes for workplaces
                              in Puerto Rico or a Foreign Country/Area.

 67-70      Wrk_MSA    FIPS Metropolitan Statistical Area (MSA) or
                       Consolidated Metropolitan Statistical Area (CMSA)
                       Code of Workplace

                       This field contains the 4-digit code for the MSAs and
                       CMSAs designated June 30, 1999.

                       9999 Appears for nonmetropolitan areas

                          * Appears for counties in the six New England
                            states for which more than one code is  
                            applicable.

                       bbbb This field is blank for workplaces outside
                            the U.S. such as Puerto Rico or a foreign country.

 72-75      Wrk_PMSA   FIPS Primary Metropolitan Statistical Area (PMSA)
                       Code of Workplace

                       This field contains the 4-digit code for the PMSAs
                       designated June 30, 1999.

                       9999 Not in a PMSA

                          * Appears for counties in the six New England
                            states for which more than one code is  
                            applicable.

                       bbbb This field is blank for workplaces outside
                            the U.S. such as Puerto Rico or a foreign country.

 77-116     Wrk_Name   Workplace area name and State abbreviation

 118-124    Count      Number of Workers 16 years old and over in the commuter
                       flow (Right justified; blank filled)
